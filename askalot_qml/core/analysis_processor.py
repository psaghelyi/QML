"""
AnalysisProcessor - Analysis Mode Implementation for QML Static Analysis

This processor handles static analysis of questionnaires:
- Uses topological order + ItemClassifier for Z3 analysis
- Determines item availability (ALWAYS/CONDITIONALLY/NEVER)
- Determines postcondition effects (TAUTOLOGICAL/CONSTRAINING/INFEASIBLE)
- Generates detailed Mermaid diagrams with classification colors
- Supports isolated Z3 analysis for safety

Uses the common QMLEngine pipeline then adds Z3-based item classification.
"""

import logging
from typing import Optional, Dict, Any, List

from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.qml_engine import QMLEngine
from askalot_qml.z3.item_classifier import ItemClassifier


class AnalysisProcessor:
    """
    Analysis mode processor for static questionnaire analysis.

    Provides:
    - Z3-based item classification (availability and postcondition effects)
    - Detailed analysis diagrams with semantic coloring
    - Comprehensive static analysis reports
    """

    def __init__(self, questionnaire_state: QuestionnaireState):
        """
        Initialize analysis processor with questionnaire state.

        Args:
            questionnaire_state: The questionnaire to analyze
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

        # Use unified engine for common pipeline
        self.engine = QMLEngine(questionnaire_state)

        # Item classifications (lazy-loaded)
        self._classifications: Optional[Dict[str, Any]] = None

        self.logger.info(f"AnalysisProcessor initialized for {len(self.engine.get_items())} items")

    def get_item_classifications(self) -> Dict[str, Any]:
        """
        Get Z3-based item classifications (lazy-loaded).

        Returns:
            Dict mapping item_id to classification results
        """
        if self._classifications is not None:
            return self._classifications

        try:
            self.logger.info("Running direct Z3 analysis...")
            classifier = ItemClassifier(self.engine.static_builder)
            self._classifications = classifier.classify_all_items()
            self.logger.info("Direct Z3 analysis completed successfully")
        except Exception as e:
            self.logger.error(f"Z3 analysis failed: {e}")
            self._classifications = {}

        return self._classifications

    def classify_item(self, item_id: str) -> Dict[str, Any]:
        """
        Get classification for a specific item.

        Args:
            item_id: ID of the item to classify

        Returns:
            Classification result for the item
        """
        classifications = self.get_item_classifications()
        return classifications.get(item_id, {
            "precondition": {"status": "UNKNOWN"},
            "postcondition": {
                "invariant": "UNKNOWN",
                "vacuous": False,
                "global": {"q_globally_true": False, "q_globally_false": False},
            },
        })

    def generate_analysis_diagram(self, enable_z3_analysis: bool = True) -> str:
        """
        Generate detailed Mermaid diagram with Z3 analysis coloring.

        Args:
            enable_z3_analysis: Whether to use Z3 classification for coloring

        Returns:
            Mermaid diagram string with analysis coloring
        """
        from askalot_qml.core.qml_diagram import QMLDiagram
        from askalot_qml.z3.item_classifier import ItemClassifier

        diagram_generator = QMLDiagram(self.engine.topology, self.state)
        base_diagram = diagram_generator.generate_base_diagram()

        if enable_z3_analysis:
            # Create classifier and apply analysis coloring
            classifier = ItemClassifier(self.engine.static_builder)
            return diagram_generator.apply_analysis_coloring(base_diagram, classifier)
        else:
            # No analysis - just return base diagram
            return base_diagram

    def generate_analysis_report(self) -> str:
        """
        Generate comprehensive text analysis report.

        Returns:
            Detailed text report of questionnaire analysis
        """
        from askalot_qml.core.qml_diagram import QMLDiagram

        diagram_generator = QMLDiagram(self.engine.topology, self.state)
        base_report = diagram_generator.generate_analysis_report()

        # Add Z3 classification summary if available
        classifications = self.get_item_classifications()
        if classifications:
            lines = [base_report, "", "🔬 Z3 Analysis Results:"]

            # Count classification types
            always_count = sum(1 for c in classifications.values()
                             if c.get("precondition", {}).get("status") == "ALWAYS")
            conditional_count = sum(1 for c in classifications.values()
                                  if c.get("precondition", {}).get("status") == "CONDITIONAL")
            never_count = sum(1 for c in classifications.values()
                            if c.get("precondition", {}).get("status") == "NEVER")

            tautological_count = sum(1 for c in classifications.values()
                                   if c.get("postcondition", {}).get("invariant") == "TAUTOLOGICAL")
            constraining_count = sum(1 for c in classifications.values()
                                   if c.get("postcondition", {}).get("invariant") == "CONSTRAINING")
            infeasible_count = sum(1 for c in classifications.values()
                                 if c.get("postcondition", {}).get("invariant") == "INFEASIBLE")

            lines.append(f"  Precondition Reachability:")
            lines.append(f"    Always: {always_count}, Conditional: {conditional_count}, Never: {never_count}")
            lines.append(f"  Postcondition Effects:")
            lines.append(f"    Tautological: {tautological_count}, Constraining: {constraining_count}, Infeasible: {infeasible_count}")

            # Highlight problematic items
            problematic_items = []
            for item_id, classification in classifications.items():
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond_invariant = classification.get("postcondition", {}).get("invariant", "UNKNOWN")

                if precond_status == "NEVER":
                    problematic_items.append(f"{item_id} (never reachable)")
                elif postcond_invariant == "INFEASIBLE":
                    problematic_items.append(f"{item_id} (infeasible postcondition)")

            if problematic_items:
                lines.append(f"\n⚠️  Potential Issues:")
                for item in problematic_items[:5]:  # Show first 5
                    lines.append(f"    {item}")
                if len(problematic_items) > 5:
                    lines.append(f"    ... and {len(problematic_items) - 5} more")

            return "\n".join(lines)

        return base_report

    def get_statistics(self) -> Dict[str, Any]:
        """
        Get analysis-specific statistics.

        Returns:
            Statistics about the questionnaire analysis
        """
        stats = self.engine.get_statistics()

        # Add analysis-specific information
        classifications = self.get_item_classifications()
        stats.update({
            'analysis_mode': True,
            'z3_analysis_available': bool(classifications)
        })

        if classifications:
            # Add classification statistics
            precond_stats = {}
            postcond_stats = {}

            for item_id, classification in classifications.items():
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond_invariant = classification.get("postcondition", {}).get("invariant", "UNKNOWN")

                precond_stats[precond_status] = precond_stats.get(precond_status, 0) + 1
                postcond_stats[postcond_invariant] = postcond_stats.get(postcond_invariant, 0) + 1

            stats.update({
                'precondition_classification': precond_stats,
                'postcondition_classification': postcond_stats,
            })

        return stats

    def debug_dump(self) -> str:
        """Generate debug output for analysis processor."""
        lines = []
        lines.append("=" * 60)
        lines.append("ANALYSIS PROCESSOR DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append(f"\n📊 Analysis Summary:")
        lines.append(f"  Z3 analysis available: {stats['z3_analysis_available']}")
        lines.append(f"  Has cycles: {self.engine.has_cycles()}")

        if stats.get('precondition_classification'):
            lines.append(f"\n🎯 Precondition Classification:")
            for status, count in stats['precondition_classification'].items():
                lines.append(f"    {status}: {count}")

        if stats.get('postcondition_classification'):
            lines.append(f"\n📋 Postcondition Classification:")
            for invariant, count in stats['postcondition_classification'].items():
                lines.append(f"    {invariant}: {count}")

        # Include engine debug info
        lines.append("\n" + self.engine.debug_dump())

        return "\n".join(lines)