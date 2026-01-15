from typing import Any, Dict, List, Union
from .table import Table


class ItemProxy:
    """
    A proxy object that provides convenient access to item properties in code blocks and conditions.
    This allows syntax like q_age.outcome, q_age.min, etc. in preconditions/postconditions and code blocks.
    """
    def __init__(self, item: Dict[str, Any]):
        self.id = item.get('id')
        self.raw_outcome = item.get('outcome')
        self.kind = item.get('kind')
        self.from_outcome(self.raw_outcome)

        # Extract additional properties from the item's input configuration
        self.input_props = {}
        input_config = item.get('input', {})

        # Extract common properties like min, max, etc.
        for prop in ['min', 'max', 'step', 'default', 'left', 'right', 'on', 'off']:
            if prop in input_config:
                self.input_props[prop] = input_config[prop]
                setattr(self, prop, input_config[prop])

        # Extract labels dictionary if present
        if 'labels' in input_config:
            self.labels = input_config['labels']
            self.input_props['labels'] = input_config['labels']

        # Store the control type
        if 'control' in input_config:
            self.control = input_config['control']
            self.input_props['control'] = input_config['control']

    def __repr__(self):
        return f"<ItemProxy id={self.id} outcome={self.outcome}>"
    
    def from_outcome(self, outcome: Union[Dict[str, Any], Any]):
        """
        Convert the outcome (dictionary or primitive value) to a more convenient format based on item kind.
        
        Args:
            outcome: The raw outcome dictionary or primitive value
            
        Returns:
            - None or {} for Comment
            - int/string/etc for Question
            - List[int] for QuestionGroup
            - Table for MatrixQuestion
        """
            
        if self.kind == "Question":
            if outcome is None or outcome == {}:
                self.outcome = None
                return
            
            # Handle both dictionary format {'_': value} and primitive values
            if isinstance(outcome, dict):
                self.outcome = outcome.get('_')
            else:
                # Direct primitive value
                self.outcome = outcome
            return
            
        elif self.kind == "QuestionGroup":
            if outcome is None or outcome == {}:
                self.outcome = None
                return

            # Find the number of items by looking at keys like '_0', '_1', etc.
            indices = [int(key[1:]) for key in outcome.keys() if key.startswith('_') and key[1:].isdigit()]
            if not indices:
                raise ValueError("No indices found in outcome")
                
            size = max(indices) + 1
            result = [None] * size
            
            for i in range(size):
                key = f'_{i}'
                if key in outcome:
                    result[i] = outcome[key]
                    
            self.outcome = result
            return
            
        elif self.kind == "MatrixQuestion":
            # First check if outcome is None or empty to avoid AttributeError
            if outcome is None or outcome == {}:
                self.outcome = None
                return
                
            # Determine dimensions by parsing keys like '_0_0', '_0_1', etc.
            max_row = 0
            max_col = 0
            
            for key in outcome.keys():
                if not key.startswith('_'):
                    continue
                    
                parts = key[1:].split('_')
                if len(parts) != 2:
                    continue
                    
                if not parts[0].isdigit() or not parts[1].isdigit():
                    continue
                    
                row = int(parts[0])
                col = int(parts[1])
                max_row = max(max_row, row)
                max_col = max(max_col, col)
            
            if max_row == 0 and max_col == 0 and not outcome:
                self.outcome = None
                return
                
            # Create table with proper dimensions
            rows = max_row + 1
            cols = max_col + 1
            table = Table(rows, cols)
            
            # Fill in the values
            for key, value in outcome.items():
                if not key.startswith('_'):
                    continue
                    
                parts = key[1:].split('_')
                if len(parts) != 2:
                    continue
                    
                if not parts[0].isdigit() or not parts[1].isdigit():
                    continue
                    
                row = int(parts[0])
                col = int(parts[1])
                table[row, col] = value
                
            self.outcome = table
            return

        elif outcome is None or outcome == {}:
            self.outcome = outcome


        
    def to_outcome(self) -> Dict[str, Any]:
        """
        Convert the proxy representation of outcome back to the storage dictionary format.
        
        Returns:
            Dictionary representation of the outcome suitable for storage
        """
    
        if self.kind == "Question":
            if self.outcome is None:
                return None
            return {'_': self.outcome}
            
        elif self.kind == "QuestionGroup":
            if self.outcome is None:
                return None        
            outcome = {}
            for i, value in enumerate(self.outcome):
                if value is not None:
                    outcome[f'_{i}'] = value
            return outcome
            
        elif self.kind == "MatrixQuestion":
            if not isinstance(self.outcome, Table):
                return None
            outcome = {}
            for row in range(self.outcome.rows):
                for col in range(self.outcome.cols):
                    value = self.outcome[row, col]
                    # Only include non-None values
                    # Note: 0 can be a valid answer (e.g., first option in dropdown)
                    if value is not None:
                        outcome[f'_{row}_{col}'] = value
            return outcome
            
        return self.outcome
    
    
