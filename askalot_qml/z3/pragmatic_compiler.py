#!/usr/bin/env python3
"""
Pragmatic Z3 compiler with improved basic type handling for questionnaire validation
Focuses on better boolean representation while keeping Python's dynamic nature
"""
from z3 import (
    Context, ExprRef, BoolRef, ArithRef,
    Int, IntVal, Bool, BoolVal,
    And, Or, Not, If,
)
import ast
import logging
from typing import Dict, Union, List, Any

class PragmaticZ3Compiler(ast.NodeVisitor):
    """
    Improved Z3 compiler with better basic type handling for questionnaire validation.
    Maintains Python's dynamic typing while improving Z3 representation.
    """

    def __init__(self, predefined: Dict[str, ExprRef], item_id: str = "", z3var_func=None, ctx: Context = None, text_items: set = None):
        self.constraints = []
        self.env = {k: v for k, v in predefined.items()}
        self.gen = 0
        self.item_id = item_id
        self.ctx = ctx
        self.z3var_func = z3var_func or (lambda name: Int(name, self.ctx) if self.ctx else Int(name))
        self.logger = logging.getLogger(__name__)
        # Set of item IDs with Textarea controls (string outcomes, no Z3 variables)
        self.text_items = text_items or set()

    def _e(self, node: ast.AST) -> Union[ExprRef, List[ExprRef]]:
        """Evaluate an expression node"""
        return self.visit(node)

    def _to_z3_bool(self, expr: ExprRef) -> BoolRef:
        """Convert expression to Z3 boolean context"""
        if isinstance(expr, BoolRef):
            return expr
        elif isinstance(expr, ArithRef):
            return expr != 0  # Non-zero is True
        else:
            return expr != 0

    def _to_z3_int(self, expr: ExprRef) -> ArithRef:
        """Convert expression to Z3 integer context"""
        if isinstance(expr, ArithRef):
            return expr
        elif isinstance(expr, BoolRef):
            return If(expr, IntVal(1, self.ctx), IntVal(0, self.ctx))
        else:
            return expr

    def visit_Name(self, n: ast.Name):
        if n.id in self.env:
            return self.env[n.id]
        # Create new variable - default to integer for questionnaire compatibility
        var_name = n.id
        self.env[var_name] = self.z3var_func(var_name)
        return self.env[var_name]

    def visit_Constant(self, n: ast.Constant):
        """Handle constants with proper type representation"""
        if isinstance(n.value, bool):
            return BoolVal(n.value, self.ctx)
        elif isinstance(n.value, int):
            return IntVal(n.value, self.ctx)
        elif isinstance(n.value, str):
            return IntVal(hash(n.value) % 1000000, self.ctx)
        else:
            return IntVal(0, self.ctx)

    def visit_Attribute(self, n: ast.Attribute):
        """Handle attribute access like item.outcome"""
        if isinstance(n.value, ast.Name) and n.attr == 'outcome':
            item_id = n.value.id
            # Textarea controls have string outcomes — return sentinel 0 instead of creating a Z3 variable
            if item_id in self.text_items:
                return IntVal(0, self.ctx) if self.ctx else IntVal(0)
            var_name = f"S_{item_id}"
            if var_name in self.env:
                return self.env[var_name]
            self.env[var_name] = self.z3var_func(var_name)
            return self.env[var_name]
        name = getattr(n.value, 'id', type(n.value).__name__)
        raise ValueError(f"Unsupported attribute access: {name}.{n.attr}")

    def visit_Call(self, n: ast.Call):
        """Handle function calls including type casting"""
        if isinstance(n.func, ast.Name):
            if n.func.id == 'print':
                return IntVal(0, self.ctx)
            elif n.func.id == 'range':
                return self.visit(n.args[0]) if n.args else IntVal(0, self.ctx)
            elif n.func.id == 'int':
                if n.args:
                    arg = self._e(n.args[0])
                    if isinstance(arg, BoolRef):
                        return If(arg, IntVal(1, self.ctx), IntVal(0, self.ctx))
                    elif isinstance(arg, ArithRef):
                        return arg
                    else:
                        return IntVal(0, self.ctx)
                return IntVal(0, self.ctx)
            elif n.func.id == 'bool':
                if n.args:
                    arg = self._e(n.args[0])
                    if isinstance(arg, BoolRef):
                        return arg
                    elif isinstance(arg, ArithRef):
                        return arg != 0
                    else:
                        return BoolVal(False, self.ctx)
                return BoolVal(False, self.ctx)
        return IntVal(0, self.ctx)

    def visit_BinOp(self, n: ast.BinOp):
        """Handle binary operations - follows Python semantics for type coercion"""
        left, right = self._e(n.left), self._e(n.right)

        # Arithmetic operations convert booleans to integers automatically (Python behavior)
        # True -> 1, False -> 0
        if isinstance(n.op, (ast.Add, ast.Sub, ast.Mult, ast.Div, ast.FloorDiv, ast.Mod)):
            # Convert booleans to integers for arithmetic
            if isinstance(left, BoolRef):
                left = If(left, IntVal(1, self.ctx), IntVal(0, self.ctx))
            if isinstance(right, BoolRef):
                right = If(right, IntVal(1, self.ctx), IntVal(0, self.ctx))

            if isinstance(n.op, ast.Add):
                return left + right
            elif isinstance(n.op, ast.Sub):
                return left - right
            elif isinstance(n.op, ast.Mult):
                return left * right
            elif isinstance(n.op, ast.Div):
                return left / right
            elif isinstance(n.op, ast.FloorDiv):
                return left / right  # Z3 doesn't distinguish div types for ints
            elif isinstance(n.op, ast.Mod):
                return left % right
        else:
            raise ValueError(f"Unsupported binary operator: {type(n.op)}")

    def visit_Compare(self, n: ast.Compare):
        """Handle comparison operations - always return boolean.
        Supports chained comparisons: a < b < c → (a < b) and (b < c).
        """
        if len(n.ops) != len(n.comparators):
            raise ValueError(f"Mismatched ops/comparators: {len(n.ops)} vs {len(n.comparators)}")
        clauses = []
        lhs = self._e(n.left)
        for op, comp in zip(n.ops, n.comparators):
            rhs = self._e(comp)
            if isinstance(op, ast.Gt):
                clauses.append(lhs > rhs)
            elif isinstance(op, ast.GtE):
                clauses.append(lhs >= rhs)
            elif isinstance(op, ast.Lt):
                clauses.append(lhs < rhs)
            elif isinstance(op, ast.LtE):
                clauses.append(lhs <= rhs)
            elif isinstance(op, ast.Eq):
                clauses.append(lhs == rhs)
            elif isinstance(op, ast.NotEq):
                clauses.append(lhs != rhs)
            elif isinstance(op, ast.In):
                clauses.append(self._handle_in_operator(lhs, rhs))
            elif isinstance(op, ast.NotIn):
                clauses.append(Not(self._handle_in_operator(lhs, rhs)))
            else:
                raise ValueError(f"Unsupported comparator: {type(op).__name__}")
            lhs = rhs
        return And(*clauses) if len(clauses) > 1 else clauses[0]

    def _handle_in_operator(self, lhs: ExprRef, rhs: Any) -> BoolRef:
        """Handle 'in' operator with better container support"""
        if rhs is None:
            self.logger.warning(f"Right side of 'in' operator is None in item {self.item_id}")
            return BoolVal(False, self.ctx)

        if isinstance(rhs, list):
            if len(rhs) == 0:
                return BoolVal(False, self.ctx)
            return Or([lhs == val for val in rhs])
        elif isinstance(rhs, ExprRef):
            return lhs == rhs
        else:
            self.logger.warning(f"Unsupported container type {type(rhs)} for 'in' operator")
            return BoolVal(False, self.ctx)

    def visit_BoolOp(self, n: ast.BoolOp):
        """Handle boolean operations with proper boolean context"""
        # Convert all operands to boolean context
        bool_values = [self._to_z3_bool(self._e(val)) for val in n.values]
        
        if isinstance(n.op, ast.And):
            return And(bool_values)
        elif isinstance(n.op, ast.Or):
            return Or(bool_values)
        else:
            raise ValueError(f"Unsupported boolean operator: {type(n.op)}")

    def visit_UnaryOp(self, n: ast.UnaryOp):
        """Handle unary operations"""
        operand = self._e(n.operand)

        if isinstance(n.op, ast.Not):
            return Not(self._to_z3_bool(operand))
        elif isinstance(n.op, ast.USub):
            # Unary minus (negative numbers)
            return -operand
        elif isinstance(n.op, ast.UAdd):
            # Unary plus (rarely used, but supported)
            return operand
        else:
            raise ValueError(f"Unsupported unary operator: {type(n.op)}")

    def visit_Assign(self, n: ast.Assign):
        """Handle assignment with dynamic typing"""
        # Handle multi-target assignments (a = b = 5) by processing each target
        if len(n.targets) > 1:
            rhs_expr = self._e(n.value)
            for target in n.targets:
                if isinstance(target, ast.Name):
                    self._assign_to_name(target, rhs_expr)
                elif isinstance(target, ast.Attribute) and target.attr == 'outcome':
                    self._assign_to_outcome(target, rhs_expr)
                else:
                    self.logger.warning(
                        f"Skipping unsupported multi-target type in {self.item_id}: "
                        f"{type(target).__name__}"
                    )
            return

        target = n.targets[0]
        rhs_expr = self._e(n.value)

        # Handle attribute assignment (item.outcome = value)
        if isinstance(target, ast.Attribute) and target.attr == 'outcome':
            self._assign_to_outcome(target, rhs_expr)
            return

        # Handle tuple unpacking (a, b = 1, 2) - not supported in Z3 context
        if isinstance(target, ast.Tuple):
            self.logger.warning(
                f"Tuple unpacking not supported in Z3 context for {self.item_id}, skipping"
            )
            return

        # Handle subscript (arr[0] = 5) - not supported in Z3 context
        if isinstance(target, ast.Subscript):
            self.logger.warning(
                f"Subscript assignment not supported in Z3 context for {self.item_id}, skipping"
            )
            return

        if not isinstance(target, ast.Name):
            self.logger.warning(
                f"Unsupported assignment target type in {self.item_id}: "
                f"{type(target).__name__}, skipping"
            )
            return

        self._assign_to_name(target, rhs_expr)

    def _assign_to_name(self, target: ast.Name, rhs_expr):
        """Assign RHS expression to a Name target with SSA versioning."""
        # Handle list/container assignments specially
        if isinstance(rhs_expr, list):
            # Store the list directly in the environment for use in 'in' operator
            # Lists cannot be represented as Z3 variables, so we store them as-is
            self.env[target.id] = rhs_expr
            return

        # Create SSA variable based on RHS type
        var_name = f"{self.item_id}_{target.id}_{self.gen}"

        # Determine variable type based on RHS expression
        if isinstance(rhs_expr, BoolRef):
            ssa_var = Bool(var_name, self.ctx)
        elif isinstance(rhs_expr, ArithRef):
            ssa_var = Int(var_name, self.ctx)
        else:
            # Default to integer for compatibility
            ssa_var = self.z3var_func(var_name)

        self.gen += 1

        # Direct assignment - preserve types
        self.constraints.append(ssa_var == rhs_expr)

        self.env[target.id] = ssa_var

    def _assign_to_outcome(self, target: ast.Attribute, rhs_expr):
        """Assign RHS expression to an item.outcome attribute target."""
        if isinstance(target.value, ast.Name):
            item_id = target.value.id
            var_name = f"S_{item_id}"
            lhs = self.z3var_func(var_name)
            # Convert RHS to integer for outcome assignment
            rhs_int = self._to_z3_int(rhs_expr)
            self.constraints.append(lhs == rhs_int)
            self.env[var_name] = lhs

    def visit_AugAssign(self, n: ast.AugAssign):
        """Handle augmented assignment (+=, -=, *=, /=, etc.)"""
        target = n.target

        # Get current value of the target
        if isinstance(target, ast.Name):
            # Get current value from environment
            current_val = self.env.get(target.id)
            if current_val is None:
                current_val = IntVal(0, self.ctx)
        elif isinstance(target, ast.Attribute) and target.attr == 'outcome':
            # Handle attribute augmented assignment (item.outcome += value)
            if isinstance(target.value, ast.Name):
                item_id = target.value.id
                var_name = f"S_{item_id}"
                current_val = self.env.get(var_name)
                if current_val is None:
                    current_val = self.z3var_func(var_name)
                    self.env[var_name] = current_val
        else:
            self.logger.warning(
                f"Unsupported augmented assignment target in {self.item_id}: "
                f"{type(target).__name__}, skipping"
            )
            return

        # Evaluate the right-hand side
        rhs_expr = self._e(n.value)

        # Convert both to integers for arithmetic operations
        current_int = self._to_z3_int(current_val)
        rhs_int = self._to_z3_int(rhs_expr)

        # Perform the augmented operation
        if isinstance(n.op, ast.Add):
            new_value = current_int + rhs_int
        elif isinstance(n.op, ast.Sub):
            new_value = current_int - rhs_int
        elif isinstance(n.op, ast.Mult):
            new_value = current_int * rhs_int
        elif isinstance(n.op, ast.FloorDiv):
            new_value = current_int / rhs_int
        elif isinstance(n.op, ast.Mod):
            new_value = current_int % rhs_int
        else:
            raise ValueError(f"Unsupported augmented assignment operator: {type(n.op)}")

        # Now handle the assignment part
        if isinstance(target, ast.Name):
            # Create SSA variable for the new value
            var_name = f"{self.item_id}_{target.id}_{self.gen}"
            ssa_var = self.z3var_func(var_name)
            self.gen += 1
            self.constraints.append(ssa_var == new_value)
            self.env[target.id] = ssa_var
        elif isinstance(target, ast.Attribute) and target.attr == 'outcome':
            # Update attribute value with SSA
            if isinstance(target.value, ast.Name):
                item_id = target.value.id
                var_name = f"S_{item_id}"
                # Create SSA variable for the new value
                ssa_var_name = f"{self.item_id}_S_{item_id}_{self.gen}"
                ssa_var = self.z3var_func(ssa_var_name)
                self.gen += 1
                self.constraints.append(ssa_var == new_value)
                self.env[var_name] = ssa_var

    def visit_If(self, n: ast.If):
        """Handle if statements with proper boolean conditions"""
        cond = self._to_z3_bool(self._e(n.test))
        
        # Process branches
        then_c = PragmaticZ3Compiler(self.env.copy(), f"{self.item_id}_then_{self.gen}", self.z3var_func, ctx=self.ctx, text_items=self.text_items)
        then_c.gen = self.gen
        for s in n.body:
            then_c.visit(s)

        else_c = PragmaticZ3Compiler(self.env.copy(), f"{self.item_id}_else_{self.gen}", self.z3var_func, ctx=self.ctx, text_items=self.text_items)
        else_c.gen = then_c.gen
        for s in n.orelse:
            else_c.visit(s)
        
        self.gen = else_c.gen
        
        # Merge variables
        merged = set(then_c.env) | set(else_c.env)
        for name in merged:
            t = then_c.env.get(name, self.env.get(name))
            e = else_c.env.get(name, self.env.get(name))

            if t is None or e is None:
                continue

            # If both branches have the same list, keep it as-is
            if isinstance(t, list) and isinstance(e, list):
                # For lists, we can't merge them with If statements
                # Keep the list from the branch that was taken
                # In static analysis, we keep both possibilities
                self.env[name] = t if t == e else t  # Keep one of them
                continue
            elif isinstance(t, list) or isinstance(e, list):
                # If only one branch has a list, we have a type conflict
                # Skip merging this variable
                continue

            # Create fresh variable for merge
            var_name = f"{self.item_id}_{name}_{self.gen}"
            fresh = self.z3var_func(var_name)
            self.gen += 1

            # Handle type conversions if needed
            if isinstance(fresh, BoolRef):
                t_bool = self._to_z3_bool(t)
                e_bool = self._to_z3_bool(e)
                self.constraints.append(fresh == If(cond, t_bool, e_bool))
            else:
                t_int = self._to_z3_int(t)
                e_int = self._to_z3_int(e)
                self.constraints.append(fresh == If(cond, t_int, e_int))

            self.env[name] = fresh
        
        self.constraints += then_c.constraints + else_c.constraints

    def visit_For(self, n: ast.For):
        """Handle for loops with container support"""
        # Only simple Name targets are supported (not tuple unpacking like 'for a, b in ...')
        if not isinstance(n.target, ast.Name):
            self.logger.warning(
                f"For-loop tuple unpacking not supported in Z3 context for {self.item_id}, skipping"
            )
            return
        loop_var = n.target.id

        # Handle range() loops
        if (isinstance(n.iter, ast.Call) and
            isinstance(n.iter.func, ast.Name) and
            n.iter.func.id == "range"):

            if len(n.iter.args) == 1 and isinstance(n.iter.args[0], ast.Constant):
                K = n.iter.args[0].value
                if not isinstance(K, int) or K < 0 or K > 20:
                    raise ValueError(f"For-loop range must be 0-20, got: {K}")

                for k in range(K):
                    self.env[loop_var] = IntVal(k, self.ctx)
                    for s in n.body:
                        self.visit(s)
                return

        # Handle container literals
        if isinstance(n.iter, (ast.List, ast.Tuple, ast.Set)):
            container_values = []
            for elt in n.iter.elts:
                if isinstance(elt, ast.Constant):
                    if isinstance(elt.value, bool):
                        container_values.append(IntVal(1 if elt.value else 0, self.ctx))
                    elif isinstance(elt.value, (int, float)):
                        container_values.append(IntVal(int(elt.value), self.ctx))
                    elif isinstance(elt.value, str):
                        container_values.append(IntVal(hash(elt.value) % 1000000, self.ctx))
                    else:
                        container_values.append(IntVal(0, self.ctx))
                else:
                    val = self._e(elt)
                    container_values.append(self._to_z3_int(val))

            if len(container_values) > 20:
                raise ValueError(f"For-loop container too large: {len(container_values)}")

            for val in container_values:
                self.env[loop_var] = val
                for s in n.body:
                    self.visit(s)
            return

        raise ValueError("For-loop supports only range(), list, tuple, set literals")

    def visit_List(self, n: ast.List):
        """Handle list literals"""
        return [self._e(elt) for elt in n.elts]

    def visit_Tuple(self, n: ast.Tuple):
        """Handle tuple literals"""
        return [self._e(elt) for elt in n.elts]
        
    def visit_Set(self, n: ast.Set):
        """Handle set literals"""
        return [self._e(elt) for elt in n.elts]

    def visit_Module(self, n):
        for s in n.body:
            self.visit(s)

    def visit_Expr(self, n):
        self._e(n.value) 