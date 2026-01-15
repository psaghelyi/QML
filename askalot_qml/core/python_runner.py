import ast
import re
from typing import Optional, Dict, Any

# Import profiling - graceful fallback if not available
try:
    from askalot_common import profile_block
except ImportError:
    from contextlib import contextmanager
    @contextmanager
    def profile_block(name, tags=None):
        yield

class PythonRunner:
    """A secure Python code execution environment that provides controlled access to specific modules and functions.
    This class implements a sandbox for executing Python code with restricted access to modules and built-in functions,
    helping prevent potentially malicious code execution while allowing safe operations.
    Attributes:
        _safe_modules (dict): Dictionary of allowed Python modules including math, random, statistics, etc.
        _safe_builtins (dict): Dictionary of allowed Python built-in functions.
        _forbidden_nodes (set): Set of AST node types that are disallowed.
        _forbidden_attrs (set): Set of attribute patterns that are disallowed.
    Methods:
        safe_print(*args, **kwargs): A wrapper around the built-in print function that prefixes output.
        run_code(code: str, **kwargs) -> dict: Safely executes Python code string in restricted environment.
        eval_expr(expr: str, **kwargs) -> bool: Safely evaluates Python expression and returns boolean result.
        validate_code(code: str) -> Optional[str]: Validates code for safety using AST analysis.
        validate_expr(expr: str) -> Optional[str]: Validates expression for safety using AST analysis.
    Example:
        runner = PythonRunner()
        result = runner.run_code("x = 1 + 1")
        bool_result = runner.eval_expr("2 > 1")
    Note:
        This class provides a secure environment for executing untrusted Python code by limiting available modules and functions.
    """
    def __init__(self):
        import math
        import random
        import statistics
        import itertools
        import functools
        import collections
        import re

        self._safe_modules = {
            'math': math,
            'random': random,
            'statistics': statistics,
            'itertools': itertools,
            'functools': functools,
            'collections': collections,
            're': re,
        }

        self._safe_builtins = {
            'abs': abs, 'all': all, 'any': any, 'ascii': ascii,
            'bin': bin, 'bool': bool, 'chr': chr, 'complex': complex,
            'divmod': divmod, 'enumerate': enumerate, 'filter': filter,
            'float': float, 'format': format, 'hash': hash, 'hex': hex,
            'int': int, 'isinstance': isinstance, 'issubclass': issubclass,
            'iter': iter, 'len': len, 'list': list, 'map': map,
            'max': max, 'min': min, 'next': next, 'oct': oct,
            'ord': ord, 'pow': pow, 'range': range, 'repr': repr,
            'reversed': reversed, 'round': round, 'set': set,
            'slice': slice, 'sorted': sorted, 'str': str, 'sum': sum,
            'tuple': tuple, 'zip': zip, 'print': self.safe_print,
        }

        # Store captured print output
        self.captured_output = []

        # Define forbidden node types for AST analysis
        self._forbidden_nodes = {
            ast.Import, ast.ImportFrom,  # No imports
            ast.AsyncFunctionDef, ast.ClassDef,  # No class or async function definitions
            ast.Await, ast.AsyncFor, ast.AsyncWith,  # No async operations
        }

        # Define forbidden attribute patterns
        self._forbidden_attrs = {
            '__.+__',  # No dunder methods
            'eval', 'exec', 'compile',  # No code execution
            'open', 'file', 'os', 'sys',  # No file/system access
            'globals', 'locals', 'getattr', 'setattr',  # No dynamic attribute access
            'subprocess', 'importlib',  # No subprocess or dynamic imports
            'builtins', '__import__',  # No access to builtin imports
            'socket', 'requests'  # No network access
        }

    def safe_print(self, *args, **kwargs):
        """A safe wrapper around the built-in print function that captures output"""
        # Convert args to string and join them
        output_str = " ".join(str(arg) for arg in args)
        
        # Add any keyword arguments that might affect formatting
        if 'sep' in kwargs:
            output_str = kwargs['sep'].join(str(arg) for arg in args)
        
        # Capture the output
        self.captured_output.append(output_str)
        
        # Also print to console for debugging
        print("print:", output_str, **kwargs)

    def validate_code(self, code: str) -> Optional[str]:
        """
        Validate code for safety using AST analysis.

        Args:
            code: The Python code to validate

        Returns:
            None if the code is safe, or an error message if unsafe
        """
        try:
            # Parse the code into an AST
            tree = ast.parse(code)

            # Check for disallowed constructs
            return self._check_ast_safety(tree)
        except SyntaxError as e:
            return f"Syntax error: {e}"
        except Exception as e:
            return f"Validation error: {e}"

    def validate_expr(self, expr: str) -> Optional[str]:
        """
        Validate expression for safety using AST analysis.

        Args:
            expr: The Python expression to validate

        Returns:
            None if the expression is safe, or an error message if unsafe
        """
        try:
            # Parse the expression into an AST
            tree = ast.parse(expr, mode='eval')

            # Check for disallowed constructs
            return self._check_ast_safety(tree)
        except SyntaxError as e:
            return f"Syntax error: {e}"
        except Exception as e:
            return f"Validation error: {e}"

    def _check_ast_safety(self, tree: ast.AST) -> Optional[str]:
        """
        Check if an AST is safe to execute.

        Args:
            tree: The AST to check

        Returns:
            None if the tree is safe, or an error message if unsafe
        """
        for node in ast.walk(tree):
            # Check node type
            if type(node) in self._forbidden_nodes:
                return f"Disallowed node type: {type(node).__name__}"

            # Check for Call nodes
            if isinstance(node, ast.Call):
                # Check if it's a direct function call
                if isinstance(node.func, ast.Name):
                    func_name = node.func.id
                    if func_name not in self._safe_builtins and func_name not in self._safe_modules:
                        return f"Call to disallowed function: {func_name}"
                # Check if it's an attribute call
                elif isinstance(node.func, ast.Attribute):
                    attr_name = node.func.attr
                    for pattern in self._forbidden_attrs:
                        if re.match(pattern, attr_name):
                            return f"Call to disallowed attribute: {attr_name}"

            # Check attribute access
            elif isinstance(node, ast.Attribute):
                attr_name = node.attr
                for pattern in self._forbidden_attrs:
                    if re.match(pattern, attr_name):
                        return f"Access to disallowed attribute: {attr_name}"

        return None  # No issues found

    def run_code(self, code: str, **kwargs) -> dict:
        """
        Safely execute code and return the local environment.

        Args:
            code: The Python code to execute
            **kwargs: Variables to include in the local environment

        Returns:
            A dictionary of the local environment after execution and captured output

        Raises:
            ValueError: If the code contains disallowed constructs
        """
        with profile_block('qml_run_code'):
            # Clear any previous captured output
            self.captured_output = []

            # Validate code safety
            error = self.validate_code(code)
            if error:
                raise ValueError(f"Unsafe code: {error}")

            # Set up execution environment
            global_env = {
                '__builtins__': self._safe_builtins,
                **self._safe_modules
            }

            local_env = {**kwargs}

            # Execute the code safely
            try:
                exec(code, global_env, local_env)
                # Add the captured output to the environment
                local_env['__output__'] = self.captured_output
                return local_env
            except Exception as e:
                # Add the exception to the environment
                local_env['__error__'] = str(e)
                # Add captured output up to the point of error
                local_env['__output__'] = self.captured_output
                return local_env

    def eval_expr(self, expr: str, **kwargs) -> bool:
        """
        Safely evaluate an expression and return the result as a boolean.

        Args:
            expr: The Python expression to evaluate
            **kwargs: Variables to include in the local environment

        Returns:
            The boolean result of the expression

        Raises:
            ValueError: If the expression contains disallowed constructs
        """
        with profile_block('qml_eval_expr'):
            # Validate expression safety
            error = self.validate_expr(expr)
            if error:
                raise ValueError(f"Unsafe expression: {error}")

            # Set up evaluation environment
            global_env = {
                '__builtins__': self._safe_builtins,
                **self._safe_modules
            }

            local_env = {**kwargs}

            # Evaluate the expression safely
            try:
                result = eval(expr, global_env, local_env)
                return bool(result)
            except Exception as e:
                # Log the error and return False
                print(f"Error evaluating expression '{expr}': {e}")
                return False

