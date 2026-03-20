"""
FlowProcessor - Flow Mode Implementation for QML Navigation

This processor handles runtime navigation for survey flow:
- Uses pre-computed topological order from QMLTopology for navigation path
- Evaluates preconditions dynamically at runtime (NOT using Z3)
- Optimized for performance (no expensive Z3 item classification during navigation)
- Tracks full navigation history for robust backward navigation
- Skips visited items when unvisited items remain ahead

Architecture:
1. Z3 Usage (initialization only):
   - Builds dependency graph via StaticBuilder
   - Detects cycles via QMLTopology
   - Computes stable topological order (Kahn's algorithm)

2. Runtime Navigation (no Z3):
   - Iterates through pre-computed navigation path
   - Evaluates preconditions via Python expressions
   - Tracks visited/isLast state attributes
   - Returns first item with satisfied preconditions

Uses the common QMLEngine pipeline for topology analysis.
"""

import copy
import logging
from typing import Optional, Dict, Any, List

from askalot_qml.models.qml_state import QMLState
from askalot_qml.models.item_proxy import ItemProxy
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.core.python_runner import PythonRunner


class FlowProcessor:
    """
    Flow mode processor for runtime survey navigation.

    Provides:
    - Pre-computed topological navigation path
    - Graph data generation for flow visualization
    - Current item tracking and bidirectional navigation
    - Performance-optimized (no Z3 during navigation)

    Navigation strategy:
    1. Initialization (uses Z3 once):
       - Builds dependency graph from preconditions/postconditions/code blocks
       - Detects cycles via Z3 satisfiability checking
       - Computes stable topological order (Kahn's algorithm preserving QML order)

    2. Forward Navigation (no Z3):
       - Iterates through pre-computed navigation path
       - Skips visited items if unvisited items remain ahead
       - Evaluates preconditions dynamically via Python eval
       - Returns first item with satisfied preconditions

    3. Backward Navigation:
       - Uses navigation history stack (list of visited item IDs)
       - Pops current item and marks as unvisited
       - Returns to previous item from history

    State attributes:
    - visited: Item has been completed by user
    - isLast: Last item in survey (completion marker)
    """

    def __init__(self, questionnaire_state: QMLState):
        """
        Initialize flow processor with questionnaire state.

        This constructor creates a full QMLEngine (which includes Z3 topology analysis).
        For already-initialized surveys, use from_cached_state() instead to skip Z3.

        Args:
            questionnaire_state: The questionnaire to process
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state
        self.python_runner = PythonRunner()
        self.topology: Optional[QMLTopology] = None

        # Use unified engine for common pipeline
        self.engine = QMLEngine(questionnaire_state)
        self.topology = self.engine.topology

        # Only initialize the questionnaire if it hasn't been initialized yet
        # Check if navigation_path exists as a marker of initialization
        if not questionnaire_state.get_navigation_path():
            self._initialize_questionnaire(questionnaire_state)
            self.logger.info("Questionnaire initialized for the first time")
        else:
            self.logger.debug("Questionnaire already initialized, skipping initialization")

        self.logger.info(f"FlowProcessor initialized for {len(self.engine.get_items())} items")

    @classmethod
    def from_cached_state(cls, questionnaire_state: QMLState) -> 'FlowProcessor':
        """Create a lightweight FlowProcessor without Z3/QMLEngine initialization.

        Use this when the survey is already initialized (has navigation_path cached).
        Skips QMLEngine/StaticBuilder/QMLTopology creation entirely, avoiding Z3 overhead.

        Runtime navigation (get_current_item, process_item) only needs:
        - PythonRunner for precondition/postcondition evaluation
        - The cached navigation path from questionnaire_state

        Args:
            questionnaire_state: Already-initialized QMLState with cached navigation path
        """
        instance = cls.__new__(cls)
        instance.logger = logging.getLogger(__name__)
        instance.state = questionnaire_state
        instance.python_runner = PythonRunner()
        instance.topology = None
        instance.engine = None
        instance.logger.debug("FlowProcessor created from cached state (no Z3)")
        return instance

    def _evaluate_condition(
        self,
        condition_expr: str,
        context: Dict[str, Any],
        item_id: str = None,
        condition_type: str = 'condition'
    ) -> bool:
        """
        Evaluate a condition expression in the given context.

        Args:
            condition_expr: The Python expression to evaluate
            context: Variables and item proxies available for evaluation
            item_id: Optional item ID for warning collection
            condition_type: Type of condition ('precondition', 'postcondition')

        Returns:
            - True if condition expression evaluates to truthy value
            - True if expression cannot be evaluated (unsupported AST constructs,
              missing variables, type errors, etc.) - a warning is logged to
              QMLState for data analysis
            - False if condition expression evaluates to falsy value

        Design rationale:
            When evaluation fails due to unsupported Python features or runtime errors,
            we "fail open" by returning True. This ensures items are shown even with
            evaluation errors, allowing data collection. Warnings are recorded in
            QMLState.warnings for post-survey analysis.
        """
        if not condition_expr:
            return True  # If no condition, it's always satisfied

        try:
            return self.python_runner.eval_expr(expr=condition_expr, **context)
        except Exception as e:
            # Warning because this indicates malfunction or unrecognized Python elements
            # Assume True to show the item anyway - better to collect data than skip
            warning_msg = (
                f"Unable to evaluate {condition_type} '{condition_expr}': {e}. "
                f"Assuming condition is True."
            )
            self.logger.warning(warning_msg)

            # Collect warning in QMLState for data processing analysis
            if item_id:
                self.state.add_warning(item_id, condition_type, warning_msg)

            return True

    def _execute_code_block(
        self,
        code_block: str,
        context: Dict[str, Any],
        item_id: str = None
    ) -> Dict[str, Any]:
        """
        Execute a code block in the given context and return the updated context.

        Args:
            code_block: Python code to execute
            context: Variables and item proxies available for execution
            item_id: Optional item ID for warning collection

        Returns:
            Updated context dictionary. On error, returns original context unchanged
            and logs a warning (collected in QMLState for data analysis).
        """
        if not code_block:
            return context  # No code block means no changes to context

        try:
            # Execute code and get the updated context
            result = self.python_runner.run_code(code=code_block, **context)
            return result
        except Exception as e:
            warning_msg = f"Error executing code block: {e}. Context unchanged."
            self.logger.warning(warning_msg)

            # Collect warning in QMLState for data processing analysis
            if item_id:
                self.state.add_warning(item_id, 'codeblock', warning_msg)

            return context

    def _initialize_questionnaire(self, questionnaire_state: QMLState) -> None:
        """
        Initialize questionnaire state and build topology.
        This should only be called once when first loading a questionnaire.

        Args:
            questionnaire_state: The questionnaire state object
        """
        # Topological order is always available (cycle members linearized in file order)
        questionnaire_state.set_navigation_path(self.topology.topological_order)
        self.logger.info(f"Stored navigation path ({len(self.topology.topological_order)} items)")

        # Check for cycles
        if self.topology.has_cycles:
            cycles_str = ", ".join([" -> ".join(cycle) for cycle in self.topology.cycles])
            self.logger.warning(f"Questionnaire has cycles: {cycles_str}")

        # Create initial context with item proxies
        init_context = {}

        all_items = questionnaire_state.get_all_items()

        # Create ItemProxy for each item in the context
        for item in all_items:
            item_proxy = ItemProxy(item)
            init_context[item['id']] = item_proxy

        # Execute questionnaire initialization code block
        init_context = self._execute_code_block(questionnaire_state.get_code_init(), init_context)

        # update the outcomes of all the items from the init context
        variables = {k: v for k, v in init_context.items() if not isinstance(v, ItemProxy)}
        for item in all_items:
            item_proxy = init_context[item['id']]
            # Convert the simplified outcome back to the storage format
            item['outcome'] = item_proxy.to_outcome()
            # Ensure visited field is always present
            item['visited'] = False

            context = {}  # create a context for the item

            # copy the variables from the init context to the item's context.
            for var_key, var_value in variables.items():
                context[var_key] = copy.deepcopy(var_value)

            item['context'] = context

    def _check_preconditions(self, item: Dict[str, Any], all_items: List[Dict[str, Any]]) -> bool:
        """
        Check if item's preconditions are satisfied.

        Preconditions are evaluated in the current context (variables + item outcomes).
        An item is shown only if ALL its preconditions evaluate to True.

        Returns:
            True if all preconditions are satisfied, no preconditions exist,
            or any precondition cannot be evaluated (assumes True on error).
            False only if a precondition explicitly evaluates to False.

            When a precondition cannot be evaluated (unrecognized Python, missing vars),
            a warning is logged and the item is shown anyway to allow data collection.
        """
        precondition = item.get('precondition')
        if not isinstance(precondition, list):
            return True  # No preconditions

        # Clone context and add item proxies
        context = copy.deepcopy(item.get('context', {}))
        for other_item in all_items:
            item_proxy = ItemProxy(other_item)
            context[other_item['id']] = item_proxy

        # Evaluate all preconditions - ALL must be satisfied
        item_id = item.get('id')
        for condition in precondition:
            if not self._evaluate_condition(
                condition.get('predicate', ''),
                context,
                item_id=item_id,
                condition_type='precondition'
            ):
                return False

        return True

    def get_current_item(self, questionnaire_state: QMLState, backward: bool = False) -> Optional[Dict[str, Any]]:
        """
        Get the current item based on preconditions and navigation history.

        Forward navigation strategy:
        1. Iterates through pre-computed navigation path (topological order)
        2. Skips visited items if unvisited items remain ahead
        3. Evaluates preconditions dynamically via Python expressions (NOT Z3)
        4. Items with unsatisfied preconditions are skipped (not shown to user)
        5. Returns first item with satisfied preconditions
        6. Tracks item in navigation history for backward navigation

        Backward navigation strategy:
        1. Pops current item from navigation history
        2. Marks current item as unvisited
        3. Returns to previous item from history stack

        Args:
            questionnaire_state: Current questionnaire state
            backward: Whether to navigate backward

        Returns:
            Item data dict or None if survey is complete
        """
        if not questionnaire_state.get_navigation_path():
            self.logger.error("Navigation path not initialized. Call initialize_questionnaire first.")
            return None

        all_items = questionnaire_state.get_all_items()

        # Handle backward navigation
        if backward:
            # Get navigation history from questionnaire state
            navigation_history = questionnaire_state.get_history()

            # Check if we have navigation history
            if not navigation_history:
                self.logger.warning("No navigation history for backward navigation")
                return None

            # Pop the current item from history
            current_id = navigation_history.pop()
            # Find and mark current item as unvisited
            for item in all_items:
                if item['id'] == current_id:
                    item['visited'] = False
                    break

            # Return to previous item if exists
            if navigation_history:
                prev_id = navigation_history[-1]
                for item in all_items:
                    if item['id'] == prev_id:
                        self.logger.debug(f"Backward navigation to: {prev_id}")
                        return item

            return None

        # Forward navigation - use stored navigation path
        navigation_path = questionnaire_state.get_navigation_path()

        def is_item_visited(item):
            """Check if an item has been visited by the user.

            Note: We only check the visited flag, NOT outcome values.
            Items may have non-empty outcomes from default values in QML,
            but they're not "visited" until the user has actually seen them.
            """
            if not item:
                return True  # Missing items don't block completion
            return item.get('visited', False)

        def is_item_done(item):
            """Check if an item is done: either visited or has unsatisfied preconditions.

            Items with unsatisfied preconditions are implicitly skipped —
            they don't need to be visited for the survey to be complete.
            """
            if not item:
                return True
            if item.get('visited'):
                return True
            # Item with unsatisfied preconditions is implicitly done (skipped)
            if not self._check_preconditions(item, all_items):
                return True
            return False

        # Check if all items are already done (survey complete)
        # In this case, return the last item rather than looping
        all_done = all(
            is_item_done(questionnaire_state.get_item(item_id))
            for item_id in navigation_path
        )

        if all_done:
            # All items done - return last visited item with isLast flag
            for item_id in reversed(navigation_path):
                item = questionnaire_state.get_item(item_id)
                if item and item.get('visited'):
                    item['isLast'] = True
                    return item
            return None

        # Navigate using the pre-computed path - find next item that needs attention
        for item_id in navigation_path:
            item = questionnaire_state.get_item(item_id)
            if not item:
                continue

            # Skip items already visited
            if is_item_visited(item):
                continue

            # Check preconditions — items with unsatisfied preconditions are skipped
            if self._check_preconditions(item, all_items):
                # Track navigation in questionnaire state
                navigation_history = questionnaire_state.get_history()
                if item_id not in navigation_history:
                    questionnaire_state.add_to_history(item_id)
                return item
            # else: precondition not satisfied — skip silently

        # Return last visited item if no more items
        visited_items = [item for item in all_items if item.get('visited')]
        if visited_items:
            last_item = visited_items[-1]
            last_item['isLast'] = True
            return last_item

        return None

    def process_item(
        self,
        questionnaire_state: QMLState,
        item_id: str,
        outcome: Dict[str, Any],
        skip_postcondition: bool = False
    ) -> Dict[str, Any]:
        """
        Process an item with the given outcome and return the updated context.
        Updates the item's outcome and context in the questionnaire state.

        Args:
            questionnaire_state: The questionnaire state object
            item_id: The ID of the item to process
            outcome: The outcome value for the item
            skip_postcondition: If True, skip postcondition validation.
                Used for backward navigation where:
                - The item will be marked as unvisited anyway
                - The saved answer is just for convenience (restored when user returns)
                - Real validation happens when user leaves the item going forward

        Returns:
            Dictionary with success status and optional error message or output
        """
        all_items = questionnaire_state.get_all_items()

        # Find the item in the questionnaire state
        current_item = questionnaire_state.get_item(item_id)
        if not current_item:
            self.logger.error(f"Item {item_id} not found in questionnaire state")
            return {'success': False, 'message': f"Item {item_id} not found"}

        # Clone the current context to avoid modifying the original
        new_context = copy.deepcopy(current_item['context'])

        # Fill in the new context with the ItemProxies
        for item in all_items:
            item_proxy = ItemProxy(item)
            if item['id'] == item_id:
                item_proxy.from_outcome(outcome)
            new_context[item['id']] = item_proxy

        # Validate postcondition (unless skipped for backward navigation)
        # When navigating backward, the item will be marked unvisited and the user
        # must re-validate when leaving forward again
        if not skip_postcondition:
            postcondition = current_item.get('postcondition')
            if isinstance(postcondition, list):
                for condition in postcondition:
                    if not self._evaluate_condition(
                        condition.get('predicate', ''),
                        new_context,
                        item_id=item_id,
                        condition_type='postcondition'
                    ):
                        # Return the hint message instead of just False
                        hint = condition.get('hint', 'Postcondition failed')
                        return {'success': False, 'message': hint}

        # Execute the code block
        new_context = self._execute_code_block(
            current_item.get('codeBlock'),
            new_context,
            item_id=item_id
        )

        # Extract captured output if any
        output_messages = new_context.pop('__output__', [])

        # Update outcomes for all items that may have been modified in the code block
        # and mark them as visited if they now have outcomes
        for item in all_items:
            item_proxy = new_context[item['id']]
            updated_outcome = item_proxy.to_outcome()

            # If the outcome has changed or is newly set, update it and mark as visited
            if updated_outcome != item.get('outcome'):
                item['outcome'] = updated_outcome
                if updated_outcome is not None:
                    item['visited'] = True

        # The current item is always marked as visited since it was actively processed
        current_item['visited'] = True

        # Propagate variables to all subsequent items
        variables = {k: v for k, v in new_context.items() if not isinstance(v, ItemProxy)}
        found_current_item = False
        for item in all_items:
            # find the current item
            if item['id'] == item_id:
                found_current_item = True
            # if the current item has been found, propagate the variables to the subsequent items
            elif found_current_item:
                for var_name, var_value in variables.items():
                    item['context'][var_name] = copy.deepcopy(var_value)

        # Add output messages to the result if any
        result = {'success': True}
        if output_messages:
            result['output'] = output_messages

        return result

    def get_navigation_path(self) -> List[str]:
        """
        Get the pre-computed navigation path (topological order).

        Returns:
            List of item IDs in topological order (cycle members linearized in file order)
        """
        return self.engine.get_topological_order()

    def get_statistics(self) -> Dict[str, Any]:
        """
        Get flow-specific statistics.

        Returns:
            Statistics about the questionnaire flow
        """
        stats = self.engine.get_statistics()

        # Add flow-specific information
        navigation_path = self.get_navigation_path()
        stats.update({
            'flow_mode': True,
            'navigation_path_length': len(navigation_path),
            'navigation_path': navigation_path,
            'can_use_topological_order': not self.engine.has_cycles(),
        })

        return stats

    def debug_dump(self) -> str:
        """Generate debug output for flow processor."""
        lines = []
        lines.append("=" * 60)
        lines.append("FLOW PROCESSOR DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append(f"\n📊 Flow Summary:")
        lines.append(f"  Navigation path length: {stats['navigation_path_length']}")
        lines.append(f"  Using topological order: {stats['can_use_topological_order']}")
        lines.append(f"  Has cycles: {self.engine.has_cycles()}")

        if self.engine.has_cycles():
            cycles = self.engine.get_cycles()
            lines.append(f"  Number of cycles: {len(cycles)}")

        lines.append(f"\n📋 Navigation Path:")
        navigation_path = stats['navigation_path']
        if len(navigation_path) <= 10:
            lines.append(f"  {' → '.join(navigation_path)}")
        else:
            lines.append(f"  {' → '.join(navigation_path[:5])} ... {' → '.join(navigation_path[-5:])}")

        # Include engine debug info
        lines.append("\n" + self.engine.debug_dump())

        return "\n".join(lines)