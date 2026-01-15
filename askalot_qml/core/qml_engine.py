"""
QMLEngine - Unified Processing Engine for QML Analysis and Flow

This module provides the common pipeline used by both analyzer and flow modes:
1. Z3 constraint generation from preconditions, postconditions, and code blocks (StaticBuilder)
2. Dependency discovery and topology building (QMLTopology)
3. Kahn's topological sorting for stable ordering

Both Flow and Analysis modes use this same foundation, then add mode-specific processing.
"""

import logging
from typing import Dict, List, Set, Optional, Any

from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.z3.static_builder import StaticBuilder


class QMLEngine:
    """
    Unified processing engine that provides the common pipeline for both flow and analysis modes.

    Common Pipeline:
    1. StaticBuilder - Generate Z3 constraints from preconditions, postconditions, code blocks
    2. QMLTopology - Extract dependency pairs, build full graph, run Kahn's topological sort

    This foundation is then used by:
    - FlowProcessor - For runtime navigation with simple diagrams
    - AnalysisProcessor - For static analysis with Z3 classification
    """

    def __init__(self, questionnaire_state: QuestionnaireState):
        """
        Initialize the unified QML processing engine.

        Args:
            questionnaire_state: The questionnaire to process
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state

        # Step 1: Build StaticBuilder constraints (owned by engine)
        self.logger.debug("Building StaticBuilder constraints...")
        self.static_builder = StaticBuilder(questionnaire_state)

        # Step 2: Build topology using the static builder
        self.logger.debug("Building topology from static builder...")
        self.topology = QMLTopology(questionnaire_state, self.static_builder)

        self.logger.info(f"QML Engine initialized: {len(self.topology.items)} items, "
                        f"{len(self.static_builder.get_constraints())} constraints, "
                        f"cycles: {self.topology.has_cycles}")

    def get_items(self) -> List[str]:
        """Get all item IDs in the questionnaire."""
        return self.topology.items.copy()

    def get_dependencies(self) -> Dict[str, Set[str]]:
        """Get item dependencies discovered through Z3 analysis."""
        return self.topology.get_dependency_chains()

    def get_topological_order(self) -> Optional[List[str]]:
        """
        Get the topological order using Kahn's algorithm with stable sorting.
        Returns None if cycles exist.
        """
        return self.topology.get_topological_order()

    def has_cycles(self) -> bool:
        """Check if the questionnaire has dependency cycles."""
        return self.topology.has_cycles

    def get_cycles(self) -> List[List[str]]:
        """Get detected dependency cycles."""
        return self.topology.get_cycles()

    def get_constraints(self) -> List[Any]:
        """Get Z3 constraints for advanced analysis."""
        return self.static_builder.get_constraints()

    def get_statistics(self) -> Dict[str, Any]:
        """Get comprehensive statistics about the questionnaire structure."""
        stats = self.topology.get_statistics()

        # Add StaticBuilder-specific stats
        stats.update({
            'z3_constraints': len(self.static_builder.get_constraints()),
            'z3_variables': len(self.static_builder.get_all_z3_vars()),
            'ssa_versions': len(self.static_builder.version_map),
        })

        return stats

    def debug_dump(self) -> str:
        """Generate comprehensive debug output for troubleshooting."""
        lines = []
        lines.append("=" * 60)
        lines.append("QML ENGINE DEBUG DUMP")
        lines.append("=" * 60)

        stats = self.get_statistics()
        lines.append(f"\n📊 Engine Summary:")
        lines.append(f"  Total items: {stats['total_items']}")
        lines.append(f"  Z3 constraints: {stats['z3_constraints']}")
        lines.append(f"  Z3 variables: {stats['z3_variables']}")
        lines.append(f"  SSA versions: {stats['ssa_versions']}")
        lines.append(f"  Has cycles: {stats['has_cycles']}")

        if stats['has_cycles']:
            lines.append(f"  Number of cycles: {stats['num_cycles']}")

        # Include topology debug info
        lines.append("\n" + self.topology.debug_dump())

        return "\n".join(lines)