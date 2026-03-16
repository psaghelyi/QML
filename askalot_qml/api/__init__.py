"""QML API endpoints."""

from askalot_qml.api.validation_blueprint import create_validation_blueprint
from askalot_qml.api.flow_blueprint import create_flow_blueprint

__all__ = ["create_validation_blueprint", "create_flow_blueprint"]