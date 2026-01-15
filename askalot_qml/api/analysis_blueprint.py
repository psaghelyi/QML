"""Analysis API blueprint for QML processing and validation."""

import logging
from pathlib import Path
from typing import Optional, Callable

from flask import Blueprint, jsonify, request
from jsonschema import ValidationError

from askalot_qml.core import QMLLoader
from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.analysis_processor import AnalysisProcessor


def create_analysis_blueprint(
    qml_dir: Optional[str | Path] = None,
    schema_path: Optional[str | Path] = None,
    url_prefix: str = "/api/qml",
    qml_dir_resolver: Optional[Callable[[], Optional[str | Path]]] = None
) -> Blueprint:
    """
    Create QML analysis API blueprint.

    Args:
        qml_dir: Static directory containing QML files (used if qml_dir_resolver not provided)
        schema_path: Path to QML JSON schema
        url_prefix: URL prefix for the blueprint
        qml_dir_resolver: Optional callable that returns the QML directory based on request context.
                          Called per-request to support organization-scoped QML paths.
                          If provided, takes precedence over static qml_dir.

    Returns:
        Flask blueprint with analysis endpoints
    """
    blueprint = Blueprint('qml_analysis', __name__, url_prefix=url_prefix)
    logger = logging.getLogger(__name__)

    def _get_loader() -> QMLLoader:
        """Get configured QML loader."""
        # Use resolver if provided, otherwise fall back to static qml_dir
        resolved_qml_dir = qml_dir_resolver() if qml_dir_resolver else qml_dir
        return QMLLoader(
            qml_dir=resolved_qml_dir,
            schema_path=schema_path,
            logger=logger
        )
    
    @blueprint.route('/analysis', methods=['GET'])
    def get_analysis():
        """
        Get analysis for a QML file using the new topology-based approach.

        Query parameters:
            qml_name: Name of QML file to analyze

        Returns:
            JSON with analysis data including:
            - topology_stats: Dependency graph statistics
            - components: Connected components information
            - dependency_layers: Items grouped by dependency depth
            - mermaid_diagram: Flow visualization based on topology
            - analysis_report: Comprehensive text report of questionnaire structure
        """
        try:
            qml_name = request.args.get('qml_name')
            if not qml_name:
                return jsonify({"error": "qml_name parameter is required"}), 400

            # Load questionnaire
            loader = _get_loader()
            questionnaire_data = loader.load_from_file(qml_name)

            # Create questionnaire state
            state = QuestionnaireState(questionnaire_data)

            logger.debug(f"Starting analysis processing for {qml_name}")

            # Initialize AnalysisProcessor
            processor = AnalysisProcessor(state)

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

            # Generate analysis diagram using AnalysisProcessor
            mermaid_data = processor.generate_analysis_diagram(enable_z3_analysis=True)

            # Generate comprehensive analysis report
            analysis_report = processor.generate_analysis_report()

            logger.debug(f"Topology analysis completed for {qml_name}")

            return jsonify({
                "qml_name": qml_name,
                "topology_stats": topology_stats,
                "components": components,
                "dependency_layers": dependency_layers,
                "mermaid_diagram": mermaid_data,
                "analysis_report": analysis_report
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
            logger.error(f"Error generating analysis: {e}")
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