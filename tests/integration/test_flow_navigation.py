"""
Integration tests for FlowProcessor navigation.

Tests survey flow including:
- Forward/backward navigation with state handling
- Outcomes stored in questionnaire state
- Outcome persistence when navigating backward and taking different paths
- Topological order respecting dependencies
"""

import pytest
from pathlib import Path
from typing import Any, Optional

from askalot_qml.core.flow_processor import FlowProcessor
from askalot_qml.core.qml_loader import QMLLoader
from askalot_qml.models.questionnaire_state import QuestionnaireState


FIXTURES_DIR = Path(__file__).parent / "fixtures"


def get_outcome_value(item: dict) -> Optional[Any]:
    """
    Extract the outcome value from an item.

    Question items store outcomes as {'_': value}, so we extract the inner value.
    """
    outcome = item.get("outcome")
    if outcome is None:
        return None
    if isinstance(outcome, dict) and "_" in outcome:
        return outcome["_"]
    return outcome


def load_qml_fixture(filename: str) -> QuestionnaireState:
    """Load a QML fixture file and return QuestionnaireState."""
    loader = QMLLoader()
    qml_path = FIXTURES_DIR / filename
    data = loader.load_from_path(str(qml_path))
    return QuestionnaireState(data)


@pytest.mark.integration
@pytest.mark.flow
class TestFlowInitialization:
    """Test FlowProcessor initialization with real QML files."""

    def test_initialization_creates_navigation_path(self):
        """Test that initialization creates a navigation path from topological order."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        nav_path = state.get_navigation_path()
        assert nav_path is not None
        assert len(nav_path) > 0
        # First item should be q_start (no dependencies)
        assert nav_path[0] == "q_start"

    def test_initialization_executes_code_init(self):
        """Test that codeInit is executed during initialization."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Check that score variable was initialized
        first_item = state.get_item("q_start")
        assert first_item is not None
        context = first_item.get("context", {})
        assert "score" in context
        assert context["score"] == 0

    def test_initialization_sets_items_unvisited(self):
        """Test that all items start as unvisited."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        for item in state.get_items():
            assert item.get("visited") == False

    def test_initialization_respects_dependencies_in_navigation_path(self):
        """Test that navigation path respects item dependencies."""
        state = load_qml_fixture("dependencies.qml")
        processor = FlowProcessor(state)

        nav_path = state.get_navigation_path()

        # q_employed must come before q_job_title and q_years_employed
        employed_idx = nav_path.index("q_employed")
        job_title_idx = nav_path.index("q_job_title")
        years_idx = nav_path.index("q_years_employed")

        assert employed_idx < job_title_idx
        assert employed_idx < years_idx


@pytest.mark.integration
@pytest.mark.flow
class TestForwardNavigation:
    """Test forward navigation through the survey."""

    def test_first_item_is_returned_on_initial_navigation(self):
        """Test that the first item in topological order is returned initially."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        current = processor.get_current_item(state)
        assert current is not None
        assert current["id"] == "q_start"

    def test_navigation_adds_to_history(self):
        """Test that navigating to an item adds it to history."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        current = processor.get_current_item(state)

        history = state.get_history()
        assert "q_start" in history

    def test_forward_navigation_skips_items_with_unsatisfied_preconditions(self):
        """Test that items with unsatisfied preconditions are skipped."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Get first item and process with "Yes" to start
        current = processor.get_current_item(state)
        assert current["id"] == "q_start"

        # Process with outcome=1 (Yes)
        processor.process_item(state, "q_start", 1)

        # Next should be q_path (precondition: q_start.outcome == 1)
        current = processor.get_current_item(state)
        assert current["id"] == "q_path"

    def test_forward_navigation_skips_branch_with_unsatisfied_condition(self):
        """Test that entire branch is skipped when precondition is not met."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start -> Yes
        processor.process_item(state, "q_start", 1)
        processor.get_current_item(state)  # q_path

        # q_path -> Technology (1)
        processor.process_item(state, "q_path", 1)

        # Next should be tech path, not nature path
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_interest"

        # Complete tech path
        processor.process_item(state, "q_tech_interest", 2)
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_experience"

        processor.process_item(state, "q_tech_experience", 5)

        # Should skip nature path entirely and go to final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"


@pytest.mark.integration
@pytest.mark.flow
class TestOutcomeStorage:
    """Test that outcomes are properly stored in questionnaire state."""

    def test_outcome_stored_after_process_item(self):
        """Test that processing an item stores its outcome."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        item = state.get_item("q_start")
        assert get_outcome_value(item) == 1

    def test_multiple_outcomes_stored(self):
        """Test that multiple item outcomes are stored correctly."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Process several items
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)  # Technology

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2)  # Web

        # Verify all outcomes
        assert get_outcome_value(state.get_item("q_start")) == 1
        assert get_outcome_value(state.get_item("q_path")) == 1
        assert get_outcome_value(state.get_item("q_tech_interest")) == 2

    def test_code_block_updates_score_variable(self):
        """Test that codeBlock execution updates variables."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)

        # Process q_tech_interest with outcome 2 (Web)
        # codeBlock: score = score + q_tech_interest.outcome
        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2)

        # Check that score was updated in subsequent items
        next_item = state.get_item("q_tech_experience")
        assert next_item["context"]["score"] == 2

    def test_item_marked_visited_after_processing(self):
        """Test that items are marked as visited after processing."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        item = state.get_item("q_start")
        assert item["visited"] == True


@pytest.mark.integration
@pytest.mark.flow
class TestBackwardNavigation:
    """Test backward navigation through the survey."""

    def test_backward_navigation_returns_previous_item(self):
        """Test that backward navigation returns to the previous item."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Navigate forward
        processor.get_current_item(state)  # q_start
        processor.process_item(state, "q_start", 1)
        processor.get_current_item(state)  # q_path

        # Navigate backward
        previous = processor.get_current_item(state, backward=True)
        assert previous is not None
        assert previous["id"] == "q_start"

    def test_backward_navigation_marks_current_as_unvisited(self):
        """Test that backward navigation marks the current item as unvisited."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Navigate forward
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)
        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)

        # q_path should be visited
        assert state.get_item("q_path")["visited"] == True

        # Navigate backward from q_path
        processor.get_current_item(state, backward=True)

        # q_path should be unvisited now
        assert state.get_item("q_path")["visited"] == False

    def test_backward_navigation_updates_history(self):
        """Test that backward navigation removes item from history."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)
        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)

        # History should have both items
        assert "q_start" in state.get_history()
        assert "q_path" in state.get_history()

        # Navigate backward
        processor.get_current_item(state, backward=True)

        # q_path should be removed from history
        assert "q_start" in state.get_history()
        assert "q_path" not in state.get_history()

    def test_backward_navigation_at_start_returns_none(self):
        """Test that backward navigation at start returns None."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Get first item (adds to history)
        processor.get_current_item(state)

        # Try to go back from first item
        previous = processor.get_current_item(state, backward=True)

        # Should return None (can't go back further)
        assert previous is None


@pytest.mark.integration
@pytest.mark.flow
class TestOutcomePersistenceOnPathChange:
    """Test that outcomes persist when navigating backward and taking different paths."""

    def test_outcomes_persist_when_going_backward(self):
        """Test that outcomes remain when navigating backward."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Complete part of the survey
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)  # Technology

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 3)  # Mobile

        # Navigate backward to q_path
        processor.get_current_item(state, backward=True)  # to q_path

        # q_tech_interest outcome should still be there
        assert get_outcome_value(state.get_item("q_tech_interest")) == 3
        # q_path outcome should still be there
        assert get_outcome_value(state.get_item("q_path")) == 1
        # q_start outcome should still be there
        assert get_outcome_value(state.get_item("q_start")) == 1

    def test_outcomes_overwritten_when_revisiting_item(self):
        """Test that outcomes are overwritten when item is revisited with new answer."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Start survey
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)  # Technology

        # Go back and change answer
        processor.get_current_item(state, backward=True)

        # Re-answer with different value
        processor.process_item(state, "q_path", 2)  # Nature

        # Outcome should be updated
        assert get_outcome_value(state.get_item("q_path")) == 2

    def test_different_path_after_backward_navigation(self):
        """Test taking a different path after going backward."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Take Technology path first
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)  # Technology

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2)

        # Now go back to q_path and choose Nature instead
        processor.get_current_item(state, backward=True)  # to q_path
        processor.process_item(state, "q_path", 2)  # Nature

        # Forward navigation should now go to Nature path
        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_interest"

        # Old tech answers should still exist (not cleared)
        assert get_outcome_value(state.get_item("q_tech_interest")) == 2

    def test_score_recalculated_on_different_path(self):
        """Test that score is recalculated when taking a different path."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Take Technology path
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 3)  # Mobile = 3 points

        # Check score after tech_interest
        tech_exp = state.get_item("q_tech_experience")
        assert tech_exp["context"]["score"] == 3

        # Go back and take Nature path
        processor.get_current_item(state, backward=True)  # to q_path
        processor.process_item(state, "q_path", 2)  # Nature

        processor.get_current_item(state)  # q_nature_interest
        processor.process_item(state, "q_nature_interest", 1)  # Wildlife = 1 point

        # Score should reflect new path
        nature_freq = state.get_item("q_nature_frequency")
        assert nature_freq["context"]["score"] == 1


@pytest.mark.integration
@pytest.mark.flow
class TestCompleteFlowScenarios:
    """Test complete survey flow scenarios."""

    def test_complete_technology_path(self):
        """Test completing the entire technology path."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start
        current = processor.get_current_item(state)
        assert current["id"] == "q_start"
        processor.process_item(state, "q_start", 1)

        # q_path
        current = processor.get_current_item(state)
        assert current["id"] == "q_path"
        processor.process_item(state, "q_path", 1)  # Technology

        # q_tech_interest
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_interest"
        processor.process_item(state, "q_tech_interest", 1)  # AI

        # q_tech_experience
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_experience"
        processor.process_item(state, "q_tech_experience", 10)

        # q_final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"
        processor.process_item(state, "q_final", 1)

        # Verify final score: 1 (AI) + 10 (experience >= 5) = 11
        final_item = state.get_item("q_final")
        assert final_item["context"]["score"] == 11

    def test_complete_nature_path(self):
        """Test completing the entire nature path."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        # q_path -> Nature
        processor.get_current_item(state)
        processor.process_item(state, "q_path", 2)

        # q_nature_interest
        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_interest"
        processor.process_item(state, "q_nature_interest", 2)  # Plants

        # q_nature_frequency
        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_frequency"
        processor.process_item(state, "q_nature_frequency", 1)  # Daily

        # q_final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"

        # Verify final score: 2 (Plants) + 5 (frequency <= 2) = 7
        assert current["context"]["score"] == 7

    def test_survey_ends_when_user_declines(self):
        """Test that survey ends quickly when user declines to start."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # q_start -> No
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 2)  # No

        # Should skip q_path (precondition: q_start.outcome == 1)
        # and go directly to q_final
        current = processor.get_current_item(state)
        assert current["id"] == "q_final"

    def test_back_and_forth_multiple_times(self):
        """Test navigating back and forth multiple times."""
        state = load_qml_fixture("branching_flow.qml")
        processor = FlowProcessor(state)

        # Forward through several items
        processor.get_current_item(state)
        processor.process_item(state, "q_start", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_path", 1)

        processor.get_current_item(state)
        processor.process_item(state, "q_tech_interest", 2)

        # Go back
        processor.get_current_item(state, backward=True)
        assert state.get_history()[-1] == "q_path"

        # Go forward again
        current = processor.get_current_item(state)
        assert current["id"] == "q_tech_interest"

        # Go back twice
        processor.get_current_item(state, backward=True)
        processor.get_current_item(state, backward=True)
        assert state.get_history()[-1] == "q_start"

        # Go forward and take different path
        current = processor.get_current_item(state)
        assert current["id"] == "q_path"
        processor.process_item(state, "q_path", 2)  # Nature

        current = processor.get_current_item(state)
        assert current["id"] == "q_nature_interest"


@pytest.mark.integration
@pytest.mark.flow
class TestDependencyBasedNavigation:
    """Test navigation with complex dependencies."""

    def test_navigation_with_dependencies_qml(self):
        """Test navigation respects dependencies in dependencies.qml."""
        state = load_qml_fixture("dependencies.qml")
        processor = FlowProcessor(state)

        # q_employed first
        current = processor.get_current_item(state)
        assert current["id"] == "q_employed"
        processor.process_item(state, "q_employed", 1)  # Yes

        # Complete the survey and verify job questions were shown
        visited_ids = []
        while True:
            current = processor.get_current_item(state)
            if current is None or current.get("isLast"):
                break
            visited_ids.append(current["id"])
            # Provide simple answers
            processor.process_item(state, current["id"], 1)

        # Job questions should have been visited (precondition satisfied)
        assert "q_job_title" in visited_ids
        assert "q_years_employed" in visited_ids

    def test_skipped_branch_when_not_employed(self):
        """Test that employment questions are skipped when not employed."""
        state = load_qml_fixture("dependencies.qml")
        processor = FlowProcessor(state)

        # q_employed -> No
        processor.get_current_item(state)
        processor.process_item(state, "q_employed", 2)

        # Should skip job questions and go to degree
        current = processor.get_current_item(state)
        assert current["id"] == "q_degree"


@pytest.mark.integration
@pytest.mark.flow
class TestPreconditionErrorHandling:
    """Test handling of malformed or unevaluatable preconditions."""

    def test_malformed_precondition_shows_item_with_warning(self, caplog):
        """Test that items with unevaluatable preconditions are shown with warning."""
        import logging

        state = load_qml_fixture("malformed_precondition.qml")

        with caplog.at_level(logging.WARNING):
            processor = FlowProcessor(state)

            # First question should work
            current = processor.get_current_item(state)
            assert current["id"] == "q_first"
            processor.process_item(state, "q_first", 1)

            # q_malformed should be SHOWN (assume True when can't evaluate)
            # to allow data collection even with malformed preconditions
            current = processor.get_current_item(state)
            assert current["id"] == "q_malformed"

            # Check that a warning was logged about the malformed precondition
            assert any(
                "Unable to evaluate" in record.message
                for record in caplog.records
            )

            # Verify warning is also collected in QuestionnaireState for data analysis
            assert state.has_warnings()
            warnings = state.get_warnings()
            assert len(warnings) >= 1
            assert any(w["item_id"] == "q_malformed" for w in warnings)
            assert any(w["type"] == "precondition" for w in warnings)

    def test_malformed_precondition_survey_completes(self):
        """Test that survey can complete even with malformed preconditions."""
        state = load_qml_fixture("malformed_precondition.qml")
        processor = FlowProcessor(state)

        # Navigate through the entire survey with a max iterations guard
        visited_ids = []
        max_iterations = 10
        for _ in range(max_iterations):
            current = processor.get_current_item(state)
            if current is None:
                break
            current_id = current["id"]
            if current_id not in visited_ids:
                visited_ids.append(current_id)
            processor.process_item(state, current_id, 1)
            if current.get("isLast"):
                break

        # All items should be visited including malformed (assume True on error)
        assert "q_first" in visited_ids
        assert "q_malformed" in visited_ids
        assert "q_last" in visited_ids
