"""Validation API blueprint for QML processing and validation."""

import logging
from pathlib import Path
from typing import Optional, Callable

from flask import Blueprint, jsonify, request
from jsonschema import ValidationError

from askalot_qml.core import QMLLoader
from askalot_qml.models.qml_state import QMLState
from askalot_qml.core.validation_processor import ValidationProcessor


def create_validation_blueprint(
    qml_dir: Optional[str | Path] = None,
    url_prefix: str = "/api/qml",
    qml_dir_resolver: Optional[Callable[[], Optional[str | Path]]] = None
) -> Blueprint:
    """
    Create QML validation API blueprint.

    Args:
        qml_dir: Static directory containing QML files (used if qml_dir_resolver not provided)
        url_prefix: URL prefix for the blueprint
        qml_dir_resolver: Optional callable that returns the QML directory based on request context.
                          Called per-request to support organization-scoped QML paths.
                          If provided, takes precedence over static qml_dir.

    Returns:
        Flask blueprint with validation endpoints
    """
    blueprint = Blueprint('qml_validation', __name__, url_prefix=url_prefix)
    logger = logging.getLogger(__name__)

    def _get_loader() -> QMLLoader:
        """Get configured QML loader."""
        # Use resolver if provided, otherwise fall back to static qml_dir
        resolved_qml_dir = qml_dir_resolver() if qml_dir_resolver else qml_dir
        return QMLLoader(
            qml_dir=resolved_qml_dir,
            logger=logger
        )
    
    @blueprint.route('/validation', methods=['GET'])
    def get_validation():
        """
        Get validation for a QML file using the topology-based approach.

        Query parameters:
            qml_name: Name of QML file to validate

        Returns:
            JSON with validation data including:
            - topology_stats: Dependency graph statistics
            - components: Connected components information
            - dependency_layers: Items grouped by dependency depth
            - graph_data: Flow visualization graph with positioned nodes and edges
            - validation_report: Comprehensive text report of questionnaire structure
        """
        try:
            qml_name = request.args.get('qml_name')
            if not qml_name:
                return jsonify({"error": "qml_name parameter is required"}), 400

            # Load questionnaire
            loader = _get_loader()
            questionnaire_data = loader.load_from_file(qml_name)

            # Create questionnaire state
            state = QMLState(questionnaire_data)

            logger.debug(f"Starting validation processing for {qml_name}")

            # Initialize ValidationProcessor
            processor = ValidationProcessor(state)

            # Get topology statistics from the engine
            topology_stats = processor.engine.get_statistics()

            # Get components information
            components = []
            for i, component in enumerate(processor.engine.topology.get_components()):
                # Order items within component by topology order
                ordered_items = [item for item in processor.engine.get_items() if item in component]
                components.append({
                    "component_id": i,
                    "size": len(component),
                    "items": ordered_items,
                    "is_isolated": len(component) == 1
                })

            # Get dependency layers
            layers = processor.engine.topology.get_dependency_layers()
            dependency_layers = []
            for i, layer in enumerate(layers):
                dependency_layers.append({
                    "layer": i,
                    "items": sorted(layer),
                    "count": len(layer)
                })

            # Generate positioned graph data using ValidationProcessor
            layout_engine = request.args.get('layout_engine', 'dot')
            graph_data = processor.generate_validation_graph(
                enable_z3_validation=True,
                layout_engine=layout_engine,
            )

            # Get per-item Z3 classifications (already computed by generate_validation_graph)
            classifications = processor.get_item_classifications()
            item_classifications = {
                item_id: {
                    'precondition': c.get('precondition', {}).get('status', 'UNKNOWN'),
                    'postcondition': c.get('postcondition', {}).get('invariant', 'UNKNOWN'),
                }
                for item_id, c in classifications.items()
            }

            # Generate comprehensive validation report
            validation_report = processor.generate_validation_report()

            logger.debug(f"Validation completed for {qml_name}")

            return jsonify({
                "qml_name": qml_name,
                "topology_stats": topology_stats,
                "components": components,
                "dependency_layers": dependency_layers,
                "graph_data": graph_data,
                "item_classifications": item_classifications,
                "validation_report": validation_report
            }), 200

        except FileNotFoundError as e:
            logger.error(f"QML file not found: {e}")
            return jsonify({"error": f"QML file not found: {qml_name}"}), 404
        except ValidationError as e:
            logger.warning(f"QML schema validation failed for {qml_name}: {e.message}")
            return jsonify({
                "qml_name": qml_name,
                "valid": False,
                "validation_error": {
                    "message": e.message,
                    "path": list(e.absolute_path),
                    "schema_path": list(e.absolute_schema_path)
                }
            }), 400
        except Exception as e:
            logger.error(f"Error generating validation: {e}")
            return jsonify({"error": str(e)}), 500


    @blueprint.route('/validate', methods=['GET'])
    def validate_qml():
        """
        Validate QML file against schema.
        
        Query parameters:
            qml_name: Name of QML file to validate
            
        Returns:
            JSON with validation result
        """
        try:
            qml_name = request.args.get('qml_name')
            if not qml_name:
                return jsonify({"error": "qml_name parameter is required"}), 400
            
            # Load and validate
            loader = _get_loader()
            questionnaire_data = loader.load_from_file(qml_name)
            
            return jsonify({
                "qml_name": qml_name,
                "valid": True,
                "message": "QML validation successful"
            }), 200
            
        except FileNotFoundError as e:
            logger.error(f"QML file not found: {e}")
            return jsonify({"error": f"QML file not found: {qml_name}"}), 404
        except Exception as e:
            logger.error(f"QML validation failed: {e}")
            return jsonify({
                "qml_name": qml_name,
                "valid": False,
                "error": str(e)
            }), 400
    
    @blueprint.route('/files', methods=['GET'])
    def list_files():
        """
        List available QML files.
        
        Returns:
            JSON with list of QML filenames
        """
        try:
            loader = _get_loader()
            files = loader.list_available_files()
            
            return jsonify({
                "files": files,
                "count": len(files)
            }), 200
            
        except Exception as e:
            logger.error(f"Error listing QML files: {e}")
            return jsonify({"error": str(e)}), 500
    


    return blueprint