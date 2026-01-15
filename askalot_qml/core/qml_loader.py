"""Modern QML file loader with type safety and no Flask dependencies."""

import json
import logging
import os
from pathlib import Path
from typing import Any, Dict, List, Optional

import yaml
from jsonschema import validate, ValidationError


class QMLLoader:
    """
    Load and parse QML files into dictionary structures.

    Modern implementation without Flask dependencies, using pathlib
    and comprehensive type hints.

    Environment Variables:
        QML_DIR: Default directory containing QML files
        QML_SCHEMA: Default path to QML JSON schema for validation
    """

    def __init__(
        self,
        qml_dir: Optional[str | Path] = None,
        schema_path: Optional[str | Path] = None,
        logger: Optional[logging.Logger] = None
    ):
        """
        Initialize QML loader.

        Args:
            qml_dir: Directory containing QML files. Falls back to QML_DIR env var.
            schema_path: Path to QML JSON schema for validation. Falls back to QML_SCHEMA env var.
            logger: Optional logger instance
        """
        self.logger = logger or logging.getLogger(__name__)
        self.qml_dir = Path(qml_dir) if qml_dir else self._get_qml_dir_from_env()
        self.schema_path = Path(schema_path) if schema_path else self._get_schema_path_from_env()

        self.qml_content: Optional[str] = None
        self.parsed_yaml: Optional[Dict[str, Any]] = None

        self.logger.info(f"QMLLoader initialized with qml_dir={self.qml_dir}, schema_path={self.schema_path}")

    def _get_qml_dir_from_env(self) -> Path:
        """Get QML directory from QML_DIR environment variable."""
        qml_dir = os.environ.get('QML_DIR')
        if qml_dir:
            return Path(qml_dir)
        self.logger.warning("QML_DIR environment variable not set")
        return Path("data/qml")

    def _get_schema_path_from_env(self) -> Optional[Path]:
        """Get schema path from QML_SCHEMA environment variable."""
        schema_path = os.environ.get('QML_SCHEMA')
        if schema_path:
            path = Path(schema_path)
            if path.exists():
                return path
            self.logger.warning(f"QML_SCHEMA path does not exist: {schema_path}")
            return None
        self.logger.debug("QML_SCHEMA environment variable not set, schema validation disabled")
        return None
    
    def load_from_file(self, filename: str) -> Dict[str, Any]:
        """
        Load and parse QML file.
        
        Args:
            filename: Name of QML file (relative to qml_dir)
            
        Returns:
            Parsed questionnaire dictionary
            
        Raises:
            FileNotFoundError: If file doesn't exist
            ValidationError: If QML doesn't match schema
        """
        file_path = self.qml_dir / filename
        return self.load_from_path(file_path)
    
    def load_from_path(self, file_path: str | Path) -> Dict[str, Any]:
        """
        Load and parse QML from absolute path.
        
        Args:
            file_path: Full path to QML file
            
        Returns:
            Parsed questionnaire dictionary
            
        Raises:
            FileNotFoundError: If file doesn't exist
            ValidationError: If QML doesn't match schema
        """
        file_path = Path(file_path)
        
        if not file_path.exists():
            raise FileNotFoundError(f"QML file not found: {file_path}")
        
        # Load file content
        self.qml_content = file_path.read_text(encoding='utf-8')
        self.logger.info(f"Loaded QML file: {file_path}")
        
        # Parse YAML
        self.parsed_yaml = yaml.safe_load(self.qml_content)
        
        # Validate against schema if available
        if self.schema_path and self.schema_path.exists():
            self._validate_against_schema()
        else:
            self.logger.debug("Schema validation skipped (no schema available)")
        
        # Return questionnaire section
        if 'questionnaire' not in self.parsed_yaml:
            raise ValueError("QML file must contain 'questionnaire' section")

        # Flatten the structure before returning
        return self._flatten_questionnaire_structure(self.parsed_yaml['questionnaire'])
    
    def load_from_string(self, qml_content: str) -> Dict[str, Any]:
        """
        Load and parse QML from string content.
        
        Args:
            qml_content: QML YAML content as string
            
        Returns:
            Parsed questionnaire dictionary
            
        Raises:
            ValidationError: If QML doesn't match schema
        """
        self.qml_content = qml_content
        self.parsed_yaml = yaml.safe_load(qml_content)
        
        # Validate against schema if available
        if self.schema_path and self.schema_path.exists():
            self._validate_against_schema()
        
        if 'questionnaire' not in self.parsed_yaml:
            raise ValueError("QML content must contain 'questionnaire' section")

        # Flatten the structure before returning
        return self._flatten_questionnaire_structure(self.parsed_yaml['questionnaire'])
    
    def _validate_against_schema(self) -> None:
        """
        Validate loaded QML against JSON schema.
        
        Raises:
            ValidationError: If validation fails
        """
        if not self.parsed_yaml:
            raise ValueError("No QML content loaded")
        
        if not self.schema_path or not self.schema_path.exists():
            self.logger.warning(f"Schema file not found: {self.schema_path}")
            return
        
        # Load schema
        with open(self.schema_path, 'r', encoding='utf-8') as schema_file:
            schema = json.load(schema_file)
        
        try:
            validate(instance=self.parsed_yaml, schema=schema)
            self.logger.info("QML validation successful")
        except ValidationError as e:
            self.logger.error(f"QML validation failed: {e}")
            raise
    
    def list_available_files(self) -> List[str]:
        """
        List all available QML files in qml_dir.
        
        Returns:
            Sorted list of QML filenames
        """
        if not self.qml_dir.exists():
            self.logger.warning(f"QML directory does not exist: {self.qml_dir}")
            return []
        
        qml_files = [f.name for f in self.qml_dir.glob("*.qml")]
        self.logger.info(f"Found {len(qml_files)} QML files")
        
        return sorted(qml_files)
    
    def get_file_path(self, filename: str) -> Path:
        """
        Get full path for a QML file.

        Args:
            filename: QML filename

        Returns:
            Full path to file
        """
        return self.qml_dir / filename

    def _flatten_questionnaire_structure(self, questionnaire: Dict[str, Any]) -> Dict[str, Any]:
        """
        Flatten the nested block/item structure to a flat list of items.

        Transforms from:
            blocks: [{id: 'b1', items: [{id: 'q1', ...}, ...]}, ...]

        To:
            blocks: [{id: 'b1', ...}]  # Just block metadata
            items: [{id: 'q1', blockId: 'b1', ...}, ...]  # Flat list with blockId

        Args:
            questionnaire: Original questionnaire dictionary with nested structure

        Returns:
            Questionnaire dictionary with flat item structure
        """
        # Create a copy to avoid modifying the original
        result = dict(questionnaire)

        # Extract and flatten items
        flat_items = []
        flat_blocks = []

        for block in questionnaire.get('blocks', []):
            # Create block metadata without items
            block_metadata = {k: v for k, v in block.items() if k != 'items'}
            flat_blocks.append(block_metadata)

            # Extract items and add blockId reference
            for item in block.get('items', []):
                # Add blockId to each item
                item_with_block = dict(item)
                item_with_block['blockId'] = block['id']
                flat_items.append(item_with_block)

        # Update the result with flat structure
        result['blocks'] = flat_blocks
        result['items'] = flat_items

        self.logger.debug(
            f"Flattened questionnaire: {len(flat_blocks)} blocks, {len(flat_items)} items"
        )

        return result