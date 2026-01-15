import logging
from typing import Dict, Any, List, Optional, TypedDict
from typing_extensions import NotRequired

class Condition(TypedDict):
    """
    Condition structure for preconditions and postconditions.

    For preconditions: hint describes when the item is intended to show
    (useful for questionnaire design, not shown to respondents).

    For postconditions: hint contains the message shown to users when
    their answer doesn't satisfy the validation constraint.
    """
    predicate: str
    hint: NotRequired[str]


class ItemOption(TypedDict):
    """Option structure for radio/checkbox items."""
    value: Any
    label: str


class QuestionnaireItem(TypedDict):
    """
    Type structure for a questionnaire item.
    Items are the primary execution units in the functional flow.
    """
    # Core item properties
    id: str
    blockId: str  # Reference to the enclosing block
    kind: str  # 'Question', 'Comment', etc.
    title: str

    # Input configuration
    input: NotRequired[Dict[str, Any]]  # Control type and configuration

    # Flow control
    precondition: NotRequired[List[Condition]]
    postcondition: NotRequired[List[Condition]]
    codeBlock: NotRequired[str]

    # Runtime state (added during execution)
    outcome: NotRequired[Any]  # User's answer/selection
    visited: NotRequired[bool]  # Has been shown to user
    disabled: NotRequired[bool]  # Is accessible
    context: NotRequired[Dict[str, Any]]  # Variable state AFTER this item's execution


class QuestionnaireBlock(TypedDict):
    """
    Type structure for a questionnaire block.
    Blocks are logical groupings of items for organization.
    """
    id: str
    title: NotRequired[str]
    # No items here - blocks are just metadata for grouping


class QuestionnaireState(dict):
    """
    Questionnaire execution state with flat item structure and exposed types.

    Items reference their blocks rather than being nested inside them.
    Maintains functional approach where context flows through items without mutation.
    Each item's context represents the variable state after that item's execution.

    This class inherits from dict to maintain JSON serialization compatibility
    while providing type-safe access methods.
    """

    def __init__(self, state: Dict[str, Any] = None):
        """
        Initialize questionnaire state from dictionary.

        Args:
            state: Dictionary containing questionnaire data (from QML or saved state)
        """
        self.logger = logging.getLogger(__name__)
        super().__init__(state or {})

        # Ensure required fields exist
        self.setdefault('history', [])
        self.setdefault('visited_items', [])  # All items ever visited (never truncated)
        self.setdefault('blocks', [])
        self.setdefault('items', [])
        self.setdefault('variables', {})

        # Warnings collected during flow processing (for data analysis)
        # Each warning has: item_id, type ('precondition'|'postcondition'|'codeblock'), message
        self.setdefault('warnings', [])

        # Cache for base Mermaid diagram (used in flow mode)
        # This field stores the structural diagram without item coloring
        self.setdefault('base_mermaid_diagram', None)

    def __str__(self) -> str:
        """String representation of the state."""
        return f"QuestionnaireState(items={len(self.get_items())}, blocks={len(self.get_blocks())})"

    def __repr__(self) -> str:
        """Detailed representation of the state."""
        return f"QuestionnaireState({super().__repr__()})"

    # Block access methods
    def get_blocks(self) -> List[QuestionnaireBlock]:
        """Get all block definitions."""
        return self.get('blocks', [])

    def get_block(self, block_id: str) -> Optional[QuestionnaireBlock]:
        """
        Get a block by its ID.

        Args:
            block_id: The block identifier

        Returns:
            Block dictionary or None if not found
        """
        for block in self.get_blocks():
            if block.get('id') == block_id:
                return block
        return None

    # Item access methods
    def get_items(self) -> List[QuestionnaireItem]:
        """
        Get all items in flat structure.

        Returns:
            List of all items with their blockId references
        """
        return self.get('items', [])

    def get_all_items(self) -> List[QuestionnaireItem]:
        """
        Compatibility method - redirects to get_items().
        Will be removed in future versions.

        Returns:
            List of all items
        """
        return self.get_items()

    def get_item(self, item_id: str) -> Optional[QuestionnaireItem]:
        """
        Get an item by its ID.

        Args:
            item_id: The item identifier

        Returns:
            Item dictionary or None if not found
        """
        for item in self.get_items():
            if item.get('id') == item_id:
                return item
        return None

    def get_items_by_block(self, block_id: str) -> List[QuestionnaireItem]:
        """
        Get all items belonging to a specific block.

        Args:
            block_id: The block identifier

        Returns:
            List of items in the specified block
        """
        return [item for item in self.get_items()
                if item.get('blockId') == block_id]

    # Code access
    def get_code_init(self) -> str:
        """Get the initialization code for the questionnaire."""
        return self.get('codeInit', '')

    # Runtime state methods
    def add_to_history(self, item_id: str) -> None:
        """
        Add an item to navigation history.

        Args:
            item_id: The item identifier to add
        """
        if 'history' not in self:
            self['history'] = []
        self['history'].append(item_id)

    def get_history(self) -> List[str]:
        """Get navigation history."""
        return self.get('history', [])

    # Visited items methods (for direct navigation)
    def add_to_visited(self, item_id: str) -> None:
        """
        Add an item to the visited items set.
        Unlike history, visited_items is never truncated.

        Args:
            item_id: The item identifier to add
        """
        if 'visited_items' not in self:
            self['visited_items'] = []
        if item_id not in self['visited_items']:
            self['visited_items'].append(item_id)

    def get_visited_items(self) -> List[str]:
        """Get all visited items (never truncated, unlike history)."""
        return self.get('visited_items', [])

    def is_item_visited(self, item_id: str) -> bool:
        """Check if an item has ever been visited."""
        return item_id in self.get_visited_items()

    def reset(self) -> None:
        """
        Reset the questionnaire state to its initial state.

        Clears all runtime state including:
        - Navigation path (triggers re-initialization with initCode)
        - Navigation history
        - Visited items
        - Warnings
        - Cached diagrams
        - Item outcomes, visited status, disabled status, and context

        After reset, the FlowProcessor will re-initialize the questionnaire,
        including re-running the initCode block with fresh context.
        """
        # Clear navigation state
        self['history'] = []
        self['visited_items'] = []
        self['warnings'] = []

        # Clear navigation_path to trigger re-initialization in FlowProcessor
        # This ensures initCode is re-run with empty outcomes and fresh context
        self.pop('navigation_path', None)

        # Clear cached diagrams (will be regenerated)
        self.pop('base_mermaid_diagram', None)

        # Clear runtime state from all items
        for item in self.get_items():
            # Remove runtime fields
            item.pop('outcome', None)
            item.pop('visited', None)
            item.pop('disabled', None)
            item.pop('context', None)

    def set_current_item(self, item_id: str) -> None:
        """
        Set the current active item.

        Args:
            item_id: The item identifier
        """
        self['current_item_id'] = item_id

    def get_current_item_id(self) -> Optional[str]:
        """Get the current active item ID."""
        return self.get('current_item_id')

    # Navigation path methods
    def set_navigation_path(self, path: List[str]) -> None:
        """
        Set the pre-computed navigation path from Z3 topology analysis.

        Args:
            path: List of item IDs in topological order
        """
        self['navigation_path'] = path

    def get_navigation_path(self) -> List[str]:
        """Get the pre-computed navigation path."""
        return self.get('navigation_path', [])

    # Warning collection methods (for data analysis)
    def add_warning(self, item_id: str, warning_type: str, message: str) -> None:
        """
        Add a warning encountered during flow processing.

        Warnings are collected for later analysis during data processing.
        They indicate issues like unevaluatable preconditions/postconditions
        or code block errors that were handled gracefully at runtime.

        Args:
            item_id: The item where the warning occurred
            warning_type: Type of warning ('precondition', 'postcondition', 'codeblock')
            message: Description of the warning
        """
        if 'warnings' not in self:
            self['warnings'] = []
        self['warnings'].append({
            'item_id': item_id,
            'type': warning_type,
            'message': message
        })

    def get_warnings(self) -> List[Dict[str, str]]:
        """Get all warnings collected during flow processing."""
        return self.get('warnings', [])

    def has_warnings(self) -> bool:
        """Check if any warnings were collected."""
        return len(self.get('warnings', [])) > 0