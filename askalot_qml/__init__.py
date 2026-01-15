"""
Askalot QML Module

Z3-driven QML processing and analysis engine for the Askalot platform.
"""

from askalot_qml.core import QMLLoader, QMLTopology, QMLEngine, FlowProcessor, AnalysisProcessor, PythonRunner
from askalot_qml.z3 import StaticBuilder, PragmaticZ3Compiler
from askalot_qml.models import ItemProxy, QuestionnaireState, Table
from askalot_qml.api import create_analysis_blueprint, create_flow_blueprint

__version__ = "2.0.0"

__all__ = [
    # Loader
    "QMLLoader",
    # Processor
    "QMLTopology",
    "QMLEngine",
    "FlowProcessor",
    "AnalysisProcessor",
    "PythonRunner",
    # Z3
    "StaticBuilder",
    "PragmaticZ3Compiler",
    # Models
    "ItemProxy",
    "QuestionnaireState",
    "Table",
    # API
    "create_analysis_blueprint",
    "create_flow_blueprint",
]