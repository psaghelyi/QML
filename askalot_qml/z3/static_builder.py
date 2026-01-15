"""
StaticBuilder - Z3-Driven Static Analysis for QML Questionnaires

This module provides Static Single Assignment (SSA) versioning and Z3 constraint
generation for questionnaire analysis. It builds formal models from preconditions,
postconditions, and code blocks to enable dependency discovery and verification.

Moved from processor/ to z3/ as it belongs with other Z3 constraint solving utilities.
"""

import logging
from typing import Dict, Any, List, Set, Optional, Tuple
from z3 import *
import ast

from askalot_qml.models.questionnaire_state import QuestionnaireState

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

    def __init__(self, questionnaire_state: QuestionnaireState):
        """Initialize StaticBuilder with questionnaire state and build constraints."""
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

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

        # Behavioral constraints from preconditions, postconditions, and code blocks
        # Used for dependency discovery and constraint verification
        self.constraints: List[BoolRef] = []

        # Item dependencies discovered through constraint analysis
        self.item_dependencies: Dict[str, Set[str]] = {}  # item -> set of items it depends on

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

        if control in ('Editbox', 'Slider'):
            # Min/max constraints for numeric controls
            min_val = input_spec.get('min')
            max_val = input_spec.get('max')

            if min_val is not None:
                self.domain_constraints.append(item_var >= min_val)
            if max_val is not None:
                self.domain_constraints.append(item_var <= max_val)

        elif control in ('RadioButton', 'Dropdown'):
            # Enumeration constraint for choice controls
            options = input_spec.get('options', [])
            if options:
                valid_values = []
                for opt in options:
                    if 'value' in opt:
                        valid_values.append(opt['value'])

                if valid_values:
                    # D_i(S_i) = S_i ∈ {v1, v2, ...}
                    self.domain_constraints.append(
                        Or(*[item_var == v for v in valid_values])
                    )

    def _build(self):
        """Build SSA versioning and Z3 constraints from questionnaire state."""
        with profile_block('z3_static_builder_build'):
            self._build_internal()

    def _build_internal(self):
        """Internal build implementation."""
        # First pass: create item outcome variables, extract domain constraints, populate item details
        for item in self.state.get_all_items():
            item_id = item.get('id')
            if item_id:
                # Item outcomes are integers (representing selected option/value)
                item_var = Int(f"item_{item_id}")
                self.item_vars[item_id] = item_var
                self.item_dependencies[item_id] = set()

                # Extract domain constraints D_i(S_i) from input specification
                self._extract_domain_constraints(item_id, item_var, item)

                # Store item details for ItemClassifier compatibility
                self.item_details[item_id] = {
                    'preconditions': item.get('precondition', []),
                    'postconditions': item.get('postcondition', []),
                    'code_block': item.get('codeBlock', ''),
                }
                self.item_order.append(item_id)

        # Process initialization code
        init_code = self.state.get_code_init()
        if init_code:
            self._process_code_block('__init__', init_code)

        # Process each item
        for item in self.state.get_all_items():
            item_id = item.get('id')
            if not item_id:
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
                            self.item_dependencies[item_id].update(deps)

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
        """Process code block and create SSA versions for assignments."""
        try:
            tree = ast.parse(code)

            for node in ast.walk(tree):
                if isinstance(node, ast.Assign):
                    for target in node.targets:
                        if isinstance(target, ast.Name):
                            var_name = target.id
                            # Skip if it's an item ID
                            if var_name not in self.item_vars:
                                # Create new SSA version
                                new_version = self._get_next_version(var_name)
                                versioned_name = f"{var_name}_{new_version}"

                                # Create Z3 variable for this version
                                z3_var = Int(versioned_name)
                                self.z3_vars[versioned_name] = z3_var

                                # Update version tracking
                                self.version_map[var_name] = new_version
                                if var_name not in self.version_history:
                                    self.version_history[var_name] = []
                                self.version_history[var_name].append((new_version, context_id))

                                # Build constraint for assignment
                                z3_value = self._ast_to_z3(node.value, context_id)
                                if z3_value is not None:
                                    if context_id != '__init__':
                                        # Assignment only happens if item is visited
                                        self.constraints.append(Implies(
                                            self.item_vars[context_id] >= 0,
                                            z3_var == z3_value
                                        ))
                                    else:
                                        # Init assignments are unconditional
                                        self.constraints.append(z3_var == z3_value)

        except SyntaxError as e:
            self.logger.error(f"Syntax error in code block for {context_id}: {e}")

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
        z3_var = Int(f"{var_name}_0")
        self.z3_vars[f"{var_name}_0"] = z3_var
        self.version_map[var_name] = 0
        return z3_var

    def _build_precondition_constraint(self, predicate: str, item_id: str) -> Tuple[Optional[BoolRef], Set[str]]:
        """Build Z3 constraint for precondition and track dependencies."""
        dependencies = set()
        try:
            tree = ast.parse(predicate, mode='eval')
            # Extract item dependencies from the predicate
            for node in ast.walk(tree):
                if isinstance(node, ast.Attribute) and isinstance(node.value, ast.Name):
                    if node.attr == 'outcome' and node.value.id in self.item_vars:
                        dependencies.add(node.value.id)
                elif isinstance(node, ast.Name) and node.id in self.item_vars:
                    dependencies.add(node.id)

            constraint = self._ast_to_z3_bool(tree.body, item_id)
            return constraint, dependencies
        except Exception as e:
            self.logger.error(f"Error building precondition constraint for {item_id}: {e}")
            return None, dependencies

    def _build_postcondition_constraint(self, predicate: str, item_id: str) -> Tuple[Optional[BoolRef], Set[str]]:
        """Build Z3 constraint for postcondition."""
        dependencies = set()
        try:
            tree = ast.parse(predicate, mode='eval')
            constraint = self._ast_to_z3_bool(tree.body, item_id)
            return constraint, dependencies
        except Exception as e:
            self.logger.error(f"Error building postcondition constraint for {item_id}: {e}")
            return None, dependencies

    def _ast_to_z3(self, node: ast.AST, context: str) -> Optional[ExprRef]:
        """Convert AST node to Z3 expression."""
        if isinstance(node, ast.Constant):
            if isinstance(node.value, bool):
                return IntVal(1 if node.value else 0)
            elif isinstance(node.value, int):
                return IntVal(node.value)
            elif isinstance(node.value, str):
                return IntVal(hash(node.value) % 1000000)

        elif isinstance(node, ast.Name):
            return self._get_current_z3_var(node.id)

        elif isinstance(node, ast.Attribute):
            if isinstance(node.value, ast.Name) and node.attr == 'outcome':
                item_id = node.value.id
                if item_id in self.item_vars:
                    return self.item_vars[item_id]

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
            if len(node.ops) == 1 and len(node.comparators) == 1:
                left = self._ast_to_z3(node.left, context)
                right = self._ast_to_z3(node.comparators[0], context)
                if left is not None and right is not None:
                    op = node.ops[0]
                    if isinstance(op, ast.Eq):
                        return left == right
                    elif isinstance(op, ast.NotEq):
                        return left != right
                    elif isinstance(op, ast.Lt):
                        return left < right
                    elif isinstance(op, ast.LtE):
                        return left <= right
                    elif isinstance(op, ast.Gt):
                        return left > right
                    elif isinstance(op, ast.GtE):
                        return left >= right

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
                return BoolVal(node.value)

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

    def get_item_dependencies(self) -> Dict[str, Set[str]]:
        """Get discovered item dependencies."""
        return self.item_dependencies

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
            return BoolVal(True)
        elif len(self.domain_constraints) == 1:
            return self.domain_constraints[0]
        else:
            return And(*self.domain_constraints)

    def compile_conditions(self, item_id: str, conditions: List[Dict[str, Any]]) -> BoolRef:
        """Compile a list of conditions to a single Z3 boolean expression (ItemClassifier compatibility)."""
        if not conditions:
            return BoolVal(True)

        compiled_conditions = []

        for condition in conditions:
            predicate = condition.get('predicate', '')
            if predicate:
                compiled = self._compile_predicate_to_z3(predicate, item_id)
                if compiled is not None:
                    compiled_conditions.append(compiled)

        if not compiled_conditions:
            return BoolVal(True)
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
        for item_id in sorted(self.item_vars.keys()):
            deps = self.item_dependencies.get(item_id, set())
            if deps:
                lines.append(f"  {item_id} depends on: {', '.join(sorted(deps))}")
            else:
                lines.append(f"  {item_id} (no dependencies)")

        lines.append(f"\n🔗 Z3 Constraints: {len(self.constraints)}")

        lines.append(f"\n🔍 All Z3 Variables: {len(self.get_all_z3_vars())}")

        return "\n".join(lines)