"""Test configuration for askalot_qml."""

import pytest
from pathlib import Path
import tempfile
import os


@pytest.fixture
def test_qml_dir():
    """Create temporary QML directory for tests."""
    with tempfile.TemporaryDirectory() as tmpdir:
        qml_dir = Path(tmpdir) / "qml"
        qml_dir.mkdir()
        yield qml_dir


@pytest.fixture
def sample_qml_content():
    """Sample QML content for testing."""
    return """
questionnaire:
  title: "Test Survey"
  init_code: |
    # Initialize variables
    pass
  blocks:
    - title: "Demographics"
      items:
        - id: "q_age"
          title: "What is your age?"
          kind: "Question"
          input:
            control: "Editbox"
            min: 18
            max: 100
          preconditions: []
          postconditions: []
        - id: "q_income"
          title: "What is your income?"
          kind: "Question"
          input:
            control: "Editbox"
            min: 0
          preconditions:
            - "q_age.outcome >= 18"
          postconditions: []
"""


@pytest.fixture
def sample_qml_file(test_qml_dir, sample_qml_content):
    """Create sample QML file for testing."""
    qml_file = test_qml_dir / "test.qml"
    qml_file.write_text(sample_qml_content)
    return qml_file


@pytest.fixture
def test_schema_path():
    """Path to test schema file."""
    # Use relative path for testing
    schema_path = Path(__file__).parent.parent.parent.parent / "data" / "definitions" / "qml-schema.json"
    if schema_path.exists():
        return schema_path
    return None


# Ensure test environment
os.environ.setdefault('PYTHONPATH', str(Path(__file__).parent.parent))