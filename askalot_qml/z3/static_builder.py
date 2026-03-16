"""
StaticBuilder - Z3-Driven Static Analysis for QML Questionnaires

This module provides Static Single Assignment (SSA) versioning and Z3 constraint
generation for questionnaire analysis. It builds formal models from preconditions,
postconditions, and code blocks to enable dependency discovery and verification.

Moved from processor/ to z3/ as it belongs with other Z3 constraint solving utilities.
"""

import logging
from typing import Dict, Any, List, Set, Optional, Tuple
from z3 import (
    Context, ExprRef, BoolRef,
    Int, IntVal, BoolVal,
    And, Or, Not, Implies, If,
)
import ast

from askalot_qml.models.qml_state import QMLState

# Import profiling - graceful fallback if not available
try:
    from askalot_common import profile_block
except ImportError:
    from contextlib import contextmanager
    @contextmanager
    def profile_block(name, tags=None):
        yield


class StaticBuilder:
    """
    Manages Static Single Assignment versioning and Z3 constraint generation.

    This class provides the foundation for Z3-driven questionnaire analysis by:
    1. Creating SSA versions for all variable assignments
    2. Building Z3 constraints from preconditions, postconditions, and code blocks
    3. Discovering item dependencies through constraint analysis
    4. Providing compatibility interface for ItemClassifier

    Used by QMLTopology for dependency discovery and topological sorting.
    """

    def __init__(self, questionnaire_state: QMLState):
        """Initialize StaticBuilder with questionnaire state and build constraints."""
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

        # Isolated Z3 context for thread safety.
        # Z3's global context (main_ctx) is not thread-safe — background threads
        # (watchdog, IPC) can trigger Python GC which corrupts shared AST state.
        # Each StaticBuilder gets its own context so all Z3 objects are isolated.
        self.ctx = Context()

        # SSA version tracking: variable_name -> current_version
        self.version_map: Dict[str, int] = {}

        # SSA variable history: variable_name -> [(version, context_item_id)]
        self.version_history: Dict[str, List[Tuple[int, str]]] = {}

        # Z3 variables for SSA versions
        self.z3_vars: Dict[str, ExprRef] = {}  # "var_name_version" -> z3_var

        # Item outcome variables (special handling)
        self.item_vars: Dict[str, ExprRef] = {}  # item_id -> z3_var

        # Domain constraints D_i(S_i) - only min/max and enumeration constraints
        # These define the valid value space for each item variable
        # This is B as defined in the thesis: B := ∧_i D_i(S_i)
        self.domain_constraints: List[BoolRef] = []

        # CodeBlock constraints - SSA assignments from codeBlock execution
        # These define relationships between computed variables and item outcomes
        # e.g., var1 = q1.outcome + q2.outcome
        self.codeblock_constraints: List[BoolRef] = []

        # Behavioral constraints from preconditions and postconditions
        # Used for dependency discovery and constraint verification
        # NOTE: These are kept separate from codeblock_constraints for validation
        self.constraints: List[BoolRef] = []

        # Comprehensive dependency graph (items and variables as nodes)
        # Keys: item_id or "var:variable_name"
        # Values: set of dependencies (items or variables)
        self.dependency_graph: Dict[str, Set[str]] = {}

        # Track which item defines each variable version
        self.variable_definitions: Dict[Tuple[str, int], str] = {}

        # ItemClassifier compatibility - item details and order
        self.item_details: Dict[str, Dict[str, Any]] = {}  # Maps item_id to item details
        self.item_order: List[str] = []  # Processing order for ItemClassifier

        # Build SSA and constraints
        self._build()

    def _extract_domain_constraints(self, item_id: str, item_var: ExprRef, item: Dict[str, Any]):
        """
        Extract domain constraints D_i(S_i) from item input specification.

        Domain constraints define the valid value space for each item:
        - For Editbox/Slider: min <= S_i <= max
        - For RadioButton/Dropdown: S_i ∈ {v1, v2, ...}

        These constraints form B (base constraint) as defined in the thesis:
        B := ∧_i D_i(S_i)
        """
        input_spec = item.get('input', {})
        control = input_spec.get('control', '')

        if control in ('Editbox', 'Slider', 'Range'):
            # Min/max constraints for numeric controls
            min_val = input_spec.get('min')
            max_val = input_spec.get('max')

            if min_val is not None and isinstance(min_val, (int, float)):
                self.domain_constraints.append(item_var >= min_val)
            elif min_val is not None:
                self.logger.warning(f"Unsupported min value type for {item_id}: {type(min_val).__name__}")
            if max_val is not None and isinstance(max_val, (int, float)):
                self.domain_constraints.append(item_var <= max_val)
            elif max_val is not None:
                self.logger.warning(f"Unsupported max value type for {item_id}: {type(max_val).__name__}")

        elif control in ('Radio', 'RadioButton', 'Dropdown', 'Checkbox', 'Switch'):
            # Enumeration constraint for choice controls
            # labels = {1: "Yes", 2: "No"} → valid values are integer keys
            valid_values: List[int] = []

            labels = input_spec.get('labels')
            if isinstance(labels, dict):
                for k in labels.keys():
                    if isinstance(k, int):
                        valid_values.append(k)
                    else:
                        try:
                            valid_values.append(int(k))
                        except (TypeError, ValueError):
                            pass

            if valid_values:
                # D_i(S_i) = S_i ∈ {v1, v2, ...}
                self.domain_constraints.append(
                    Or(*[item_var == v for v in valid_values])
                )

    def _extract_dependencies_from_ast(self, node: ast.AST) -> Set[str]:
        """Extract all dependency references (items AND variables) from AST.

        Returns a set of dependency node names:
        - item_id for item outcome references (e.g., q1.outcome, q1)
        - "var:variable_name" for variable references
        """
        dependencies = set()
        for child in ast.walk(node):
            if isinstance(child, ast.Attribute):
                # Handle q1.outcome pattern
                if isinstance(child.value, ast.Name) and child.attr == 'outcome':
                    if child.value.id in self.item_vars:
                        dependencies.add(child.value.id)
            elif isinstance(child, ast.Name):
                name = child.id
                if name in self.item_vars:
                    # Direct item reference (e.g., in some contexts)
                    dependencies.add(name)
                elif name in self.version_map:
                    # Variable reference - track as var: node
                    dependencies.add(f"var:{name}")
        return dependencies

    def _build(self):
        """Build SSA versioning and Z3 constraints from questionnaire state."""
        with profile_block('z3_static_builder_build'):
            self._build_internal()

    def _build_internal(self):
        """Internal build implementation."""
        # First pass: create item outcome variables, extract domain constraints, populate item details
        # Textarea controls have string outcomes — no Z3 integer variable is created for them.
        for item in self.state.get_all_items():
            item_id = item.get('id')
            if item_id:
                # Check if this is a Textarea control (string outcome, not integer)
                input_spec = item.get('input', {})
                control = input_spec.get('control', '')

                if control == 'Textarea':
                    # Text items have string outcomes — skip Z3 variable creation
                    self.dependency_graph[item_id] = set()
                else:
                    # Item outcomes are integers (representing selected option/value)
                    item_var = Int(f"item_{item_id}", self.ctx)
                    self.item_vars[item_id] = item_var
                    self.dependency_graph[item_id] = set()

                    # Extract domain constraints D_i(S_i) from input specification
                    self._extract_domain_constraints(item_id, item_var, item)

                # Store item details for ItemClassifier compatibility
                self.item_details[item_id] = {
                    'preconditions': item.get('precondition', []),
                    'postconditions': item.get('postcondition', []),
                    'code_block': item.get('codeBlock', ''),
                    'control': control,
                }
                self.item_order.append(item_id)

        # Process initialization code
        init_code = self.state.get_code_init()
        if init_code:
            self._process_code_block('__init__', init_code)

        # Process each item (skip Text items — no Z3 variables to constrain)
        for item in self.state.get_all_items():
            item_id = item.get('id')
            if not item_id:
                continue

            # Textarea controls have string outcomes — skip Z3 constraint processing
            if item_id not in self.item_vars:
                continue

            # Process preconditions (path constraints)
            if 'precondition' in item:
                for idx, cond in enumerate(item.get('precondition', [])):
                    predicate = cond.get('predicate', '')
                    if predicate:
                        constraint, deps = self._build_precondition_constraint(predicate, item_id)
                        if constraint is not None:
                            # Precondition implies item can be reached
                            self.constraints.append(Implies(
                                self.item_vars[item_id] >= 0,  # Item is visited
                                constraint  # Precondition must be true
                            ))
                            # Dependencies are already added to dependency_graph in _build_precondition_constraint

            # Process code blocks (state transitions)
            if 'codeBlock' in item and item['codeBlock']:
                self._process_code_block(item_id, item['codeBlock'])

            # Process postconditions (invariants)
            if 'postcondition' in item:
                for idx, cond in enumerate(item.get('postcondition', [])):
                    predicate = cond.get('predicate', '')
                    if predicate:
                        constraint, deps = self._build_postcondition_constraint(predicate, item_id)
                        if constraint is not None:
                            # If item is completed, postcondition must hold
                            self.constraints.append(Implies(
                                self.item_vars[item_id] >= 0,  # Item has outcome
                                constraint  # Postcondition must be true
                            ))

    def _process_code_block(self, context_id: str, code: str):
        """Process code block and create SSA versions for assignments.

        Handles ast.Assign, ast.AugAssign, and ast.Attribute targets.
        Tracks Variable → Item/Variable dependencies in the dependency graph.
        Also tracks dependencies from enclosing if-conditions for nested assignments.
        """
        try:
            tree = ast.parse(code)

            # Build parent map so we can find enclosing if-conditions
            parent_map = self._build_parent_map(tree)

            for node in ast.walk(tree):
                if isinstance(node, ast.Assign):
                    # Collect dependencies from enclosing if-conditions
                    enclosing_deps = self._get_enclosing_if_deps(node, parent_map)

                    for target in node.targets:
                        if isinstance(target, ast.Name):
                            var_name = target.id
                            if var_name not in self.item_vars:
                                rhs_deps = self._extract_dependencies_from_ast(node.value)
                                rhs_deps.update(enclosing_deps)
                                z3_value = self._ast_to_z3(node.value, context_id)
                                self._register_variable_assignment(
                                    var_name, z3_value, rhs_deps, context_id
                                )
                        elif isinstance(target, ast.Attribute) and target.attr == 'outcome':
                            # Handle item.outcome = expr (e.g., q_total.outcome = q1.outcome + q2.outcome)
                            if isinstance(target.value, ast.Name):
                                self._register_outcome_assignment(
                                    target.value.id, node.value, enclosing_deps, context_id
                                )

                elif isinstance(node, ast.AugAssign):
                    # Handle augmented assignments: score += q1.outcome
                    enclosing_deps = self._get_enclosing_if_deps(node, parent_map)
                    target = node.target

                    if isinstance(target, ast.Name):
                        var_name = target.id
                        if var_name not in self.item_vars:
                            # Dependencies: RHS + current variable value + enclosing conditions
                            rhs_deps = self._extract_dependencies_from_ast(node.value)
                            rhs_deps.update(enclosing_deps)
                            if var_name in self.version_map:
                                rhs_deps.add(f"var:{var_name}")

                            # Build Z3 value: old_value OP rhs
                            rhs_z3 = self._ast_to_z3(node.value, context_id)
                            old_z3 = self._get_current_z3_var(var_name)
                            z3_value = self._apply_aug_op(node.op, old_z3, rhs_z3)

                            self._register_variable_assignment(
                                var_name, z3_value, rhs_deps, context_id
                            )
                    elif isinstance(target, ast.Attribute) and target.attr == 'outcome':
                        # Handle item.outcome += expr
                        if isinstance(target.value, ast.Name):
                            item_id = target.value.id
                            if item_id in self.item_vars:
                                rhs_deps = self._extract_dependencies_from_ast(node.value)
                                rhs_deps.update(enclosing_deps)
                                rhs_deps.add(item_id)
                                # Track dependency: context_id depends on the items in RHS
                                if context_id in self.dependency_graph:
                                    self.dependency_graph[context_id].update(
                                        d for d in rhs_deps if not d.startswith('var:') and d != context_id
                                    )

        except SyntaxError as e:
            self.logger.error(f"Syntax error in code block for {context_id}: {e}")

    def _register_variable_assignment(
        self, var_name: str, z3_value: Optional[ExprRef],
        deps: Set[str], context_id: str
    ):
        """Register an SSA variable assignment with dependencies and Z3 constraint."""
        new_version = self._get_next_version(var_name)
        versioned_name = f"{var_name}_{new_version}"
        var_node = f"var:{var_name}"

        # Create Z3 variable for this version
        z3_var = Int(versioned_name, self.ctx)
        self.z3_vars[versioned_name] = z3_var

        # Initialize variable node in dependency graph if needed
        if var_node not in self.dependency_graph:
            self.dependency_graph[var_node] = set()

        # Add dependencies from RHS to the variable node
        self.dependency_graph[var_node].update(deps)

        # Track definition source
        self.variable_definitions[(var_name, new_version)] = context_id

        # Variable depends on the item that defines it
        # (if defined in an item's codeBlock, not in __init__)
        if context_id != '__init__' and context_id in self.item_vars:
            self.dependency_graph[var_node].add(context_id)

        # Update version tracking AFTER evaluating RHS
        self.version_map[var_name] = new_version
        if var_name not in self.version_history:
            self.version_history[var_name] = []
        self.version_history[var_name].append((new_version, context_id))

        # Build constraint for assignment - store in codeblock_constraints
        if z3_value is not None:
            if context_id != '__init__':
                self.codeblock_constraints.append(Implies(
                    self.item_vars[context_id] >= 0,
                    z3_var == z3_value
                ))
            else:
                self.codeblock_constraints.append(z3_var == z3_value)

    def _register_outcome_assignment(
        self, item_id: str, value_node: ast.AST,
        enclosing_deps: Set[str], context_id: str
    ):
        """Register item.outcome = expr, tracking dependencies without creating SSA."""
        if item_id not in self.item_vars:
            return

        rhs_deps = self._extract_dependencies_from_ast(value_node)
        rhs_deps.update(enclosing_deps)

        # The item that contains this codeBlock depends on the RHS items
        if context_id in self.dependency_graph:
            self.dependency_graph[context_id].update(
                d for d in rhs_deps if not d.startswith('var:') and d != context_id
            )

        # Build Z3 constraint for the outcome assignment
        z3_value = self._ast_to_z3(value_node, context_id)
        if z3_value is not None and context_id in self.item_vars:
            self.codeblock_constraints.append(Implies(
                self.item_vars[context_id] >= 0,
                self.item_vars[item_id] == z3_value
            ))

    @staticmethod
    def _apply_aug_op(op: ast.operator, left: Optional[ExprRef], right: Optional[ExprRef]) -> Optional[ExprRef]:
        """Apply augmented assignment operator to Z3 expressions."""
        if left is None or right is None:
            return None
        if isinstance(op, ast.Add):
            return left + right
        elif isinstance(op, ast.Sub):
            return left - right
        elif isinstance(op, ast.Mult):
            return left * right
        elif isinstance(op, ast.FloorDiv):
            return left / right
        elif isinstance(op, ast.Mod):
            return left % right
        return None

    @staticmethod
    def _build_parent_map(tree: ast.AST) -> dict:
        """Build a mapping from child nodes to their parent nodes."""
        parent_map = {}
        for node in ast.walk(tree):
            for child in ast.iter_child_nodes(node):
                parent_map[child] = node
        return parent_map

    def _get_enclosing_if_deps(self, node: ast.AST, parent_map: dict) -> Set[str]:
        """Extract dependencies from all enclosing if-conditions of a node."""
        deps = set()
        current = node
        while current in parent_map:
            parent = parent_map[current]
            if isinstance(parent, ast.If):
                deps.update(self._extract_dependencies_from_ast(parent.test))
            current = parent
        return deps

    def _get_next_version(self, var_name: str) -> int:
        """Get next SSA version number for a variable."""
        current = self.version_map.get(var_name, -1)
        return current + 1

    def _get_current_z3_var(self, var_name: str) -> Optional[ExprRef]:
        """Get current Z3 variable for a given variable name."""
        if var_name in self.item_vars:
            return self.item_vars[var_name]

        current_version = self.version_map.get(var_name)
        if current_version is not None:
            versioned_name = f"{var_name}_{current_version}"
            return self.z3_vars.get(versioned_name)

        # Variable not yet defined - create version 0
        z3_var = Int(f"{var_name}_0", self.ctx)
        self.z3_vars[f"{var_name}_0"] = z3_var
        self.version_map[var_name] = 0
        return z3_var

    def _build_precondition_constraint(self, predicate: str, item_id: str) -> Tuple[Optional[BoolRef], Set[str]]:
        """Build Z3 constraint for precondition AND track dependencies.

        Extracts ALL dependencies (items AND variables) and adds them to the
        dependency graph for proper transitive chain resolution.

        Note: Self-references are excluded - an item referencing itself
        is not a dependency (would create invalid self-loops).
        """
        try:
            tree = ast.parse(predicate, mode='eval')

            # Extract ALL dependencies (items AND variables)
            all_deps = self._extract_dependencies_from_ast(tree.body)

            # Add to dependency graph (excluding self-references)
            for dep in all_deps:
                if dep != item_id:  # Exclude self-reference
                    self.dependency_graph[item_id].add(dep)

            constraint = self._ast_to_z3_bool(tree.body, item_id)

            # Return only item dependencies for backward compatibility
            item_deps = {d for d in all_deps if not d.startswith('var:')}
            return constraint, item_deps
        except Exception as e:
            self.logger.error(f"Error building precondition constraint for {item_id}: {e}")
            return None, set()

    def _build_postcondition_constraint(self, predicate: str, item_id: str) -> Tuple[Optional[BoolRef], Set[str]]:
        """Build Z3 constraint for postcondition AND track dependencies.

        Postconditions can also create dependencies! For example, if q2 has a
        postcondition referencing q1.outcome, q2 depends on q1.

        Note: Self-references ARE allowed in postconditions - an item's postcondition
        validating its own outcome (e.g., `q1.outcome > 0`) is valid and not a dependency.
        Self-references are excluded from the dependency graph.
        """
        try:
            tree = ast.parse(predicate, mode='eval')

            # Extract ALL dependencies (items AND variables)
            all_deps = self._extract_dependencies_from_ast(tree.body)

            # Add to dependency graph (excluding self-references - postconditions validating
            # their own item's outcome don't create dependencies)
            for dep in all_deps:
                if dep != item_id:  # Exclude self-reference
                    self.dependency_graph[item_id].add(dep)

            constraint = self._ast_to_z3_bool(tree.body, item_id)

            # Return only item dependencies for backward compatibility
            item_deps = {d for d in all_deps if not d.startswith('var:')}
            return constraint, item_deps
        except Exception as e:
            self.logger.error(f"Error building postcondition constraint for {item_id}: {e}")
            return None, set()

    def _ast_to_z3(self, node: ast.AST, context: str) -> Optional[ExprRef]:
        """Convert AST node to Z3 expression."""
        if isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return IntVal(1 if node.value else 0, self.ctx)
            elif isinstance(node.value, int):
                return IntVal(node.value, self.ctx)
            elif isinstance(node.value, str):
                return IntVal(hash(node.value) % 1000000, self.ctx)

        elif isinstance(node, ast.Name):
            return self._get_current_z3_var(node.id)

        elif isinstance(node, ast.Attribute):
            if isinstance(node.value, ast.Name) and node.attr == 'outcome':
                item_id = node.value.id
                if item_id in self.item_vars:
                    return self.item_vars[item_id]
                # Text items have string outcomes — return sentinel 0
                if item_id in self.item_details and self.item_details[item_id].get('control') == 'Textarea':
                    return IntVal(0, self.ctx)

        elif isinstance(node, ast.BinOp):
            left = self._ast_to_z3(node.left, context)
            right = self._ast_to_z3(node.right, context)
            if left is not None and right is not None:
                if isinstance(node.op, ast.Add):
                    return left + right
                elif isinstance(node.op, ast.Sub):
                    return left - right
                elif isinstance(node.op, ast.Mult):
                    return left * right
                elif isinstance(node.op, ast.Div):
                    return left / right  # Integer division in Z3
                elif isinstance(node.op, ast.FloorDiv):
                    return left / right
                elif isinstance(node.op, ast.Mod):
                    return left % right

        elif isinstance(node, ast.UnaryOp):
            operand = self._ast_to_z3(node.operand, context)
            if operand is not None:
                if isinstance(node.op, ast.USub):
                    return -operand
                elif isinstance(node.op, ast.UAdd):
                    return operand

        elif isinstance(node, ast.IfExp):
            # Ternary operator: a if condition else b
            test = self._ast_to_z3_bool(node.test, context)
            body = self._ast_to_z3(node.body, context)
            orelse = self._ast_to_z3(node.orelse, context)
            if test is not None and body is not None and orelse is not None:
                return If(test, body, orelse)

        return None

    def _ast_to_z3_bool(self, node: ast.AST, context: str) -> Optional[BoolRef]:
        """Convert AST node to Z3 boolean expression."""
        if isinstance(node, ast.Compare):
            # Support chained comparisons: a < b < c → (a < b) and (b < c)
            if len(node.ops) != len(node.comparators):
                return None
            clauses: List[BoolRef] = []
            lhs = self._ast_to_z3(node.left, context)
            if lhs is None:
                return None
            for op, comp in zip(node.ops, node.comparators):
                # In/NotIn need the raw AST comparator (list/tuple/set), not Z3 value
                if isinstance(op, (ast.In, ast.NotIn)):
                    if isinstance(comp, (ast.List, ast.Tuple, ast.Set)):
                        member_vals = [
                            self._ast_to_z3(elt, context)
                            for elt in comp.elts
                        ]
                        member_vals = [v for v in member_vals if v is not None]
                        if not member_vals:
                            return None
                        membership = Or(*[lhs == v for v in member_vals])
                        if isinstance(op, ast.In):
                            clauses.append(membership)
                        else:
                            clauses.append(Not(membership))
                    else:
                        return None
                    # For chained comparisons after In/NotIn, lhs stays the same
                    continue

                rhs = self._ast_to_z3(comp, context)
                if rhs is None:
                    return None
                if isinstance(op, ast.Eq):
                    clauses.append(lhs == rhs)
                elif isinstance(op, ast.NotEq):
                    clauses.append(lhs != rhs)
                elif isinstance(op, ast.Lt):
                    clauses.append(lhs < rhs)
                elif isinstance(op, ast.LtE):
                    clauses.append(lhs <= rhs)
                elif isinstance(op, ast.Gt):
                    clauses.append(lhs > rhs)
                elif isinstance(op, ast.GtE):
                    clauses.append(lhs >= rhs)
                else:
                    # ast.Is, ast.IsNot, etc. - unsupported, return None
                    return None
                lhs = rhs  # Next comparison uses current comparator as left
            return And(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None

        elif isinstance(node, ast.BoolOp):
            if isinstance(node.op, ast.And):
                clauses = [self._ast_to_z3_bool(v, context) for v in node.values]
                clauses = [c for c in clauses if c is not None]
                return And(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None
            elif isinstance(node.op, ast.Or):
                clauses = [self._ast_to_z3_bool(v, context) for v in node.values]
                clauses = [c for c in clauses if c is not None]
                return Or(*clauses) if len(clauses) > 1 else clauses[0] if clauses else None

        elif isinstance(node, ast.UnaryOp):
            if isinstance(node.op, ast.Not):
                operand = self._ast_to_z3_bool(node.operand, context)
                return Not(operand) if operand is not None else None

        elif isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return BoolVal(node.value, self.ctx)

        # Try to interpret as expression and check truthiness
        expr = self._ast_to_z3(node, context)
        if expr is not None:
            if isinstance(expr, BoolRef):
                return expr
            # Non-zero is true
            return expr != 0

        return None

    def get_constraints(self) -> List[BoolRef]:
        """Get all Z3 constraints."""
        return self.constraints

    def _resolve_item_dependencies(self, node: str, visited: Set[str]) -> Set[str]:
        """Get all item dependencies, following variable paths transitively.

        Walks the dependency graph, following var: nodes to find the ultimate
        item dependencies. For example:
        - q2 → var:score → q1 resolves to q2 → q1

        Args:
            node: Starting node (item_id or "var:variable_name")
            visited: Set of already visited nodes (to prevent infinite loops)

        Returns:
            Set of item IDs that this node ultimately depends on
        """
        if node in visited:
            return set()
        visited.add(node)

        item_deps = set()
        for dep in self.dependency_graph.get(node, set()):
            if dep.startswith('var:'):
                # Recursively resolve variable dependencies
                item_deps.update(self._resolve_item_dependencies(dep, visited.copy()))
            else:
                # Direct item dependency
                item_deps.add(dep)
        return item_deps

    def get_item_dependencies(self) -> Dict[str, Set[str]]:
        """Get item-to-item dependencies (resolved through variables).

        Returns a dictionary mapping each item to the set of items it depends on,
        with transitive dependencies through variables resolved.

        For example, if:
        - q1 has codeBlock: score = q1.outcome
        - q2 has precondition: score > 5

        Then get_item_dependencies() returns {'q2': {'q1'}, ...} because q2
        depends on q1 transitively through var:score.
        """
        result = {}
        for item_id in self.item_vars.keys():
            result[item_id] = self._resolve_item_dependencies(item_id, set())
        return result

    def get_dependency_graph(self) -> Dict[str, Set[str]]:
        """Get full dependency graph including variable nodes.

        Returns the raw dependency graph with both item nodes and var: nodes.
        Useful for debugging and visualization.
        """
        return {k: v.copy() for k, v in self.dependency_graph.items()}

    def get_all_z3_vars(self) -> Dict[str, ExprRef]:
        """Get all Z3 variables (SSA versions and item outcomes)."""
        all_vars = dict(self.z3_vars)
        all_vars.update(self.item_vars)
        return all_vars

    def get_domain_base(self) -> BoolRef:
        """
        Get domain-only base constraint B as defined in the thesis.

        B := ∧_i D_i(S_i) where D_i(S_i) are domain constraints:
        - min/max for Editbox/Slider controls
        - enumeration for RadioButton/Dropdown controls

        This is the correct B for use in:
        - Per-item validation: W_i = B ∧ P_i ∧ ¬Q_i
        - Global validation: F = B ∧ ∧(P_i ⇒ Q_i)
        - Path-based validation: A_i = B ∧ ∧{j∈Pred(i)}(P_j ⇒ Q_j)
        """
        if not self.domain_constraints:
            return BoolVal(True, self.ctx)
        elif len(self.domain_constraints) == 1:
            return self.domain_constraints[0]
        else:
            return And(*self.domain_constraints)

    def get_full_base(self) -> BoolRef:
        """
        Get full base constraint B_full = B ∧ codeblock_constraints.

        This includes:
        - Domain constraints D_i(S_i) from get_domain_base()
        - CodeBlock constraints from codeBlock assignments (SSA)

        Does NOT include precondition/postcondition implications from self.constraints,
        as those are what we're validating against.

        Use this for postcondition validation when postconditions reference
        computed variables (not just item outcomes). The codeBlock constraints
        establish the relationship between computed variables and item outcomes,
        enabling proper bounds checking.

        Example: If var1 = q1.outcome + q2.outcome (from codeBlocks),
        and q1 ∈ [0,10], q2 ∈ [10,20], then var1 ∈ [10,30].
        Without codeBlock constraints, var1 would be unconstrained.
        """
        all_constraints = list(self.domain_constraints) + list(self.codeblock_constraints)
        if not all_constraints:
            return BoolVal(True, self.ctx)
        elif len(all_constraints) == 1:
            return all_constraints[0]
        else:
            return And(*all_constraints)

    def compile_conditions(self, item_id: str, conditions: List[Dict[str, Any]]) -> BoolRef:
        """Compile a list of conditions to a single Z3 boolean expression (ItemClassifier compatibility)."""
        if not conditions:
            return BoolVal(True, self.ctx)

        compiled_conditions = []

        for condition in conditions:
            predicate = condition.get('predicate', '')
            if predicate:
                compiled = self._compile_predicate_to_z3(predicate, item_id)
                if compiled is not None:
                    compiled_conditions.append(compiled)

        if not compiled_conditions:
            return BoolVal(True, self.ctx)
        elif len(compiled_conditions) == 1:
            return compiled_conditions[0]
        else:
            return And(*compiled_conditions)

    def _compile_predicate_to_z3(self, predicate: str, context: str) -> Optional[BoolRef]:
        """Compile a predicate string to Z3 boolean expression."""
        try:
            tree = ast.parse(predicate, mode='eval')
            return self._ast_to_z3_bool(tree.body, context)
        except Exception as e:
            self.logger.error(f"Error compiling predicate '{predicate}' in context {context}: {e}")
            return None

    def debug_dump(self) -> str:
        """Generate debug output."""
        lines = []
        lines.append("="*60)
        lines.append("SSA BUILDER DEBUG DUMP")
        lines.append("="*60)

        lines.append(f"\n📊 SSA Versions ({len(self.version_map)} variables):")
        for var, version in sorted(self.version_map.items()):
            lines.append(f"  {var}: current version = {version}")
            if var in self.version_history:
                for v, ctx in self.version_history[var]:
                    lines.append(f"    v{v} at {ctx}")

        lines.append(f"\n📦 Item Variables ({len(self.item_vars)} items):")
        resolved_deps = self.get_item_dependencies()
        for item_id in sorted(self.item_vars.keys()):
            deps = resolved_deps.get(item_id, set())
            if deps:
                lines.append(f"  {item_id} depends on: {', '.join(sorted(deps))}")
            else:
                lines.append(f"  {item_id} (no dependencies)")

        lines.append(f"\n🔗 Dependency Graph ({len(self.dependency_graph)} nodes):")
        for node, deps in sorted(self.dependency_graph.items()):
            if deps:
                lines.append(f"  {node} → {', '.join(sorted(deps))}")

        lines.append(f"\n🔗 CodeBlock Constraints: {len(self.codeblock_constraints)}")
        lines.append(f"🔗 Pre/Post Constraints: {len(self.constraints)}")

        lines.append(f"\n🔍 All Z3 Variables: {len(self.get_all_z3_vars())}")

        return "\n".join(lines)