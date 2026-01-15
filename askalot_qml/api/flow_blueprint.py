"""Flow API blueprint for QML survey navigation and evaluation."""

import logging
from pathlib import Path
from typing import Any, Callable, Dict, Optional

from flask import Blueprint, current_app, jsonify, request

from askalot_qml.core import QMLLoader
from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.flow_processor import FlowProcessor

# Type alias for audit callback function
AuditCallback = Callable[[str, str, str, Optional[Dict[str, Any]]], None]


def create_flow_blueprint(
    repository,
    qml_dir: Optional[str | Path] = None,
    schema_path: Optional[str | Path] = None,
    url_prefix: str = "/api/flow",
    audit_callback: Optional[AuditCallback] = None
) -> Blueprint:
    """
    Create QML flow API blueprint.

    Args:
        repository: Repository instance for survey persistence
        qml_dir: Directory containing QML files
        schema_path: Path to QML JSON schema
        url_prefix: URL prefix for the blueprint
        audit_callback: Optional callback for audit logging with signature:
            audit_callback(entity_type, entity_id, action, context_extra)

    Returns:
        Flask blueprint with flow endpoints
    """
    blueprint = Blueprint('qml_flow', __name__, url_prefix=url_prefix)
    logger = logging.getLogger(__name__)

    def _log_audit(entity_type: str, entity_id: str, action: str, context_extra: Optional[Dict[str, Any]] = None) -> None:
        """Log audit event if callback is provided."""
        if audit_callback:
            try:
                audit_callback(entity_type, entity_id, action, context_extra)
            except Exception as e:
                logger.warning(f"Failed to log audit event ({entity_type}.{action}): {e}")
    
    def _get_loader() -> QMLLoader:
        """Get configured QML loader."""
        return QMLLoader(
            qml_dir=qml_dir, 
            schema_path=schema_path,
            logger=logger
        )
    
    def _get_flow_processor(questionnaire_state: QuestionnaireState) -> FlowProcessor:
        """Get FlowProcessor for the given questionnaire state."""
        return FlowProcessor(questionnaire_state)
    
    def _load_questionnaire(qml_name: str):
        """Load and initialize a questionnaire state from a QML file path."""
        loader = _get_loader()
        logger.debug(f"Loading QML file: {qml_name}")
        
        # Load QML file using the modern API
        parsed_qml = loader.load_from_file(qml_name)
        logger.info("QML loaded and validated successfully.")
        questionnaire_state = QuestionnaireState(parsed_qml)
        
        return questionnaire_state
    
    def _update_survey_position(survey, item_data: Optional[Dict[str, Any]]) -> None:
        """Update survey's current position tracking fields.

        Args:
            survey: The survey object to update
            item_data: Current item data containing 'id' and 'blockId', or None if survey complete
        """
        if item_data:
            survey.current_item_id = item_data.get('id')
            survey.current_block_id = item_data.get('blockId')
        else:
            # Survey is complete - clear position
            survey.current_item_id = None
            survey.current_block_id = None

    def _initialize_survey_state(survey):
        """Initialize a survey with a questionnaire state."""
        # Get the questionnaire from the database to find its QML name
        questionnaire = repository.get_questionnaire(survey.questionnaire_id)
        if not questionnaire:
            logger.error(f"Cannot find questionnaire {survey.questionnaire_id} for survey {survey.id}")
            raise ValueError(f"Cannot find questionnaire {survey.questionnaire_id} for survey {survey.id}")

        # Load the questionnaire from the QML file
        survey.questionnaire_state = _load_questionnaire(questionnaire.qml_name)

        # Initialize FlowProcessor with questionnaire state
        processor = _get_flow_processor(survey.questionnaire_state)

        repository.upsert_survey(survey)

        # Log audit event for survey started
        _log_audit('survey', survey.id, 'started', {
            'questionnaire_id': survey.questionnaire_id,
            'campaign_id': survey.campaign_id
        })

        return processor
    
    @blueprint.route('/current-item', methods=['GET'])
    def current_item():
        """Get the current item in the survey flow based on preconditions."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get('survey_id')
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400
            
            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            
            # Lazy initialization if questionnaire_state is missing
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.questionnaire_state)

            # Get current item using FlowProcessor
            item_data = processor.get_current_item(survey.questionnaire_state, backward=False)
            if not item_data:
                # Survey is complete - update position and save
                _update_survey_position(survey, None)
                survey.status = "completed"
                survey.completed = True
                repository.upsert_survey(survey)

                # Log audit event for survey completed
                _log_audit('survey', survey_id, 'completed', {
                    'questionnaire_id': survey.questionnaire_id,
                    'campaign_id': survey.campaign_id
                })

                return jsonify({
                    "status": "complete",
                    "survey_id": survey_id,
                    "message": "Survey completed"
                }), 200

            # Update survey position tracking and save
            _update_survey_position(survey, item_data)
            repository.upsert_survey(survey)

            # Add survey_id to response for client convenience
            item_data['survey_id'] = survey_id

            # Return the item data
            return jsonify(item_data), 200
        except Exception as e:
            logger.error(f"Error getting current item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route('/evaluate-item', methods=['POST'])
    def evaluate_item():
        """Evaluate current item and record answer without changing position.

        When skip_postcondition is True, the answer is saved but postcondition
        validation is skipped. This is used for backward navigation where:
        - The item will be marked as unvisited anyway
        - The saved answer is just for convenience (restored when user returns)
        - Real validation happens when user leaves the item going forward
        """
        try:
            data = request.get_json() or {}
            # Get survey_id from request body (client must always provide it)
            survey_id = data.get('survey_id')
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Get item_id and outcome from the request
            item_id = data.get('item_id')
            if not item_id:
                return jsonify({"error": "No item_id provided"}), 400

            outcome = data.get('outcome')

            # skip_postcondition: Skip validation when navigating backward
            # The item will be marked unvisited, so validation is deferred to forward navigation
            skip_postcondition = data.get('skip_postcondition', False)

            # Initialize processor if needed
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.questionnaire_state)

            # Process the item using FlowProcessor
            result = processor.process_item(survey.questionnaire_state, item_id, outcome, skip_postcondition=skip_postcondition)

            if not result.get("success", False):
                return jsonify({"message": result.get("message", "Failed to process item")}), 400

            # Save the updated survey state (position is updated by navigation endpoints only)
            repository.upsert_survey(survey)
            
            # If there was code output, return it for display in the modal
            if "output" in result and result["output"]:
                output_text = "<br>".join(result["output"])
                return jsonify({"status": "success", "survey_id": survey_id, "message": f"Print: {output_text}"}), 200
            
            response_data = {
                "status": "success", 
                "survey_id": survey_id
            }
                        
            return jsonify(response_data), 200
        except Exception as e:
            logger.error(f"Error evaluating item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route('/previous-item', methods=['GET'])
    def previous_item():
        """Get the previous item from the survey history."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get('survey_id')
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400
            
            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404
            
            # Initialize processor if needed
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.questionnaire_state)

            # Get the previous item using FlowProcessor
            item_data = processor.get_current_item(survey.questionnaire_state, backward=True)
            if not item_data:
                return jsonify({"error": "No previous item available"}), 404

            # Update survey position tracking and save after backward navigation
            _update_survey_position(survey, item_data)
            repository.upsert_survey(survey)

            # Add survey_id to response for client convenience
            item_data['survey_id'] = survey_id

            # Return the item data
            return jsonify(item_data), 200
        except Exception as e:
            logger.error(f"Error getting previous item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route('/diagram', methods=['GET'])
    def get_diagram():
        """Get the mermaid diagram data for the current survey."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get('survey_id')
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Initialize processor if needed
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.questionnaire_state)

            # Check for cached base diagram
            base_diagram = None
            if 'base_mermaid_diagram' in survey.questionnaire_state:
                base_diagram = survey.questionnaire_state['base_mermaid_diagram']
                logger.debug(f"Using cached base diagram for survey {survey_id}")
            else:
                # Generate and cache base diagram
                from askalot_qml.core.qml_diagram import QMLDiagram
                diagram_gen = QMLDiagram(processor.engine.topology, survey.questionnaire_state)
                base_diagram = diagram_gen.generate_base_diagram()

                # Cache the base diagram in survey state
                survey.questionnaire_state['base_mermaid_diagram'] = base_diagram
                repository.upsert_survey(survey)
                logger.info(f"Generated and cached base diagram for survey {survey_id}")

            # Use saved current_item_id for highlighting (set by navigation endpoints)
            current_item_id = survey.current_item_id

            # Generate flow diagram with coloring applied to base
            mermaid_data = processor.generate_flow_diagram(base_diagram, current_item_id)

            # Compute navigable nodes (items that can be clicked for direct navigation)
            # Only items in history are navigable - "valid path" means we've visited before
            navigation_history = survey.questionnaire_state.get_history()
            navigable_nodes = set(navigation_history)

            # Return the diagram data with navigable nodes
            return jsonify({
                "mermaidData": mermaid_data,
                "navigableNodes": list(navigable_nodes),
                "currentItemId": current_item_id
            }), 200
        except Exception as e:
            logger.error(f"Error generating diagram: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route('/navigation-path', methods=['GET'])
    def get_navigation_path():
        """Get the pre-computed navigation path for the survey."""
        try:
            # Get survey_id from query parameters (client must always provide it)
            survey_id = request.args.get('survey_id')
            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Initialize processor if needed
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.questionnaire_state)

            # Get the navigation path from FlowProcessor
            navigation_path = processor.get_navigation_path()

            # Return path information
            return jsonify({
                "survey_id": survey_id,
                "navigation_path": navigation_path,
                "total_items": len(navigation_path),
                "has_cycles": processor.engine.has_cycles(),
                "cycles": processor.engine.get_cycles() if processor.engine.has_cycles() else [],
                "topological_order": processor.engine.get_topological_order()
            }), 200
        except Exception as e:
            logger.error(f"Error getting navigation path: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route('/navigate-to-item', methods=['POST'])
    def navigate_to_item():
        """Navigate directly to a specific item in the survey.

        Navigation is only allowed if:
        1. The target item is in the navigation history (previously visited), OR
        2. The target item has a valid path (all prerequisite items have been answered)

        Request body:
            survey_id: ID of the survey
            target_item_id: ID of the item to navigate to

        Returns:
            Item data if navigation is valid, error otherwise
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get('survey_id')
            target_item_id = data.get('target_item_id')

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400
            if not target_item_id:
                return jsonify({"error": "No target_item_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Initialize processor if needed
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                processor = _get_flow_processor(survey.questionnaire_state)

            # Get the target item
            target_item = survey.questionnaire_state.get_item(target_item_id)
            if not target_item:
                return jsonify({"error": f"Item {target_item_id} not found in questionnaire"}), 404

            # Check navigation validity
            navigation_history = survey.questionnaire_state.get_history()
            is_in_history = target_item_id in navigation_history

            # Check if item has valid path (all prerequisites answered)
            has_valid_path = False
            if not is_in_history:
                # Check if all items before this in the navigation path have outcomes
                navigation_path = survey.questionnaire_state.get_navigation_path()
                if target_item_id in navigation_path:
                    target_index = navigation_path.index(target_item_id)
                    # All preceding items must have been visited (have outcomes)
                    has_valid_path = True
                    for i in range(target_index):
                        preceding_item = survey.questionnaire_state.get_item(navigation_path[i])
                        if preceding_item:
                            # Item must be visited OR disabled (skipped by precondition)
                            if not preceding_item.get('visited') and not preceding_item.get('disabled'):
                                has_valid_path = False
                                break

            if not is_in_history and not has_valid_path:
                return jsonify({
                    "error": "Cannot navigate to this item",
                    "reason": "Item is not in history and does not have a valid path (prerequisites not completed)"
                }), 400

            # Perform navigation
            if is_in_history:
                # Navigate backward through history to reach the target
                history_index = navigation_history.index(target_item_id)
                # Truncate history to include only up to target item
                new_history = navigation_history[:history_index + 1]

                # Mark items after target as unvisited
                for item_id in navigation_history[history_index + 1:]:
                    item = survey.questionnaire_state.get_item(item_id)
                    if item:
                        item['visited'] = False

                # Update history in questionnaire state
                survey.questionnaire_state['history'] = new_history
            else:
                # Add target to history (forward navigation with valid path)
                if target_item_id not in navigation_history:
                    survey.questionnaire_state.add_to_history(target_item_id)

            # Update survey position
            _update_survey_position(survey, target_item)
            repository.upsert_survey(survey)

            # Add survey_id to response
            target_item['survey_id'] = survey_id

            return jsonify(target_item), 200

        except Exception as e:
            logger.error(f"Error navigating to item: {e}")
            return jsonify({"error": str(e)}), 500

    @blueprint.route('/reset', methods=['POST'])
    def reset_survey():
        """Reset a survey to its initial state.

        Clears all outcomes, history, and runtime state.
        Returns the first item so the UI can display it.

        Request body:
            survey_id: ID of the survey to reset

        Returns:
            First item data with survey_id
        """
        try:
            data = request.get_json() or {}
            survey_id = data.get('survey_id')

            if not survey_id:
                return jsonify({"error": "No survey_id provided"}), 400

            survey = repository.get_survey(survey_id)
            if not survey:
                return jsonify({"error": f"Survey {survey_id} not found"}), 404

            # Initialize if needed (shouldn't happen but be safe)
            if not survey.questionnaire_state:
                processor = _initialize_survey_state(survey)
            else:
                # Reset the questionnaire state
                survey.questionnaire_state.reset()
                processor = _get_flow_processor(survey.questionnaire_state)

            # Reset survey status
            survey.status = "in_progress"
            survey.completed = False

            # Get the first item
            first_item = processor.get_current_item(survey.questionnaire_state)

            # Update survey position and save
            _update_survey_position(survey, first_item)
            repository.upsert_survey(survey)

            if first_item:
                first_item['survey_id'] = survey_id

            # Log audit event for survey reset
            _log_audit('survey', survey_id, 'reset', {
                'questionnaire_id': survey.questionnaire_id,
                'campaign_id': survey.campaign_id
            })

            logger.info(f"Survey {survey_id} reset successfully")
            return jsonify({
                "status": "success",
                "item": first_item
            }), 200

        except Exception as e:
            logger.error(f"Error resetting survey: {e}")
            return jsonify({"error": str(e)}), 500

    return blueprint