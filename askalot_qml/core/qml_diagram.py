"""
QMLDiagram - Mermaid Diagram Generation for QML Questionnaires

This module generates Mermaid diagrams showing:
- Items and their dependencies discovered through Z3 analysis
- Topological ordering and dependency chains
- Cycle detection and highlighting
- Flow-based and analysis-based coloring schemes
"""

import logging
from typing import Optional, List, Dict, Any
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.questionnaire_state import QuestionnaireState


class QMLDiagram:
    """Generate Mermaid diagrams for QML questionnaires using Z3 topology."""

    def __init__(self, topology: QMLTopology, questionnaire_state: QuestionnaireState):
        """
        Initialize diagram generator with Z3 topology.

        Args:
            topology: Z3-driven topology analysis results
            questionnaire_state: Questionnaire state for item details
        """
        self.topology = topology
        self.state = questionnaire_state
        self.logger = logging.getLogger(__name__)

        # Build item lookup for convenience
        self.items_by_id = {item['id']: item for item in self.state.get_all_items() if item.get('id')}

    def generate_base_diagram(self) -> str:
        """
        Generate the cacheable base diagram structure.
        Includes: items, dependencies, variables, preconditions, postconditions, styles
        Excludes: item coloring classes (visited, current, always, etc.)
        """
        mermaid = ["flowchart TD"]
        self._edge_ids = []

        # Add topological order chain if available (this includes item nodes)
        if self.topology and self.topology.topological_order and not self.topology.has_cycles:
            self._add_topological_chain(mermaid)
        else:
            # Add item nodes without chain
            self._add_item_nodes(mermaid)

        # Generate variable nodes
        self._add_variable_nodes(mermaid)

        # Generate precondition nodes and connections
        self._add_precondition_nodes(mermaid)

        # Generate postcondition nodes and connections
        self._add_postcondition_nodes(mermaid)

        # Add cycle highlighting if cycles exist
        if self.topology and self.topology.has_cycles:
            self._add_cycle_highlighting(mermaid)

        # Add item styling markers (for dynamic coloring insertion)
        mermaid.append("")
        mermaid.append("  %% BEGIN_ITEM_STYLING")
        mermaid.append("  %% END_ITEM_STYLING")

        # Add ONLY static styling (variables, conditions, NOT items)
        self._add_static_styles(mermaid)

        # Add all CSS class definitions
        self._add_css_definitions(mermaid)

        # Add animation declarations at the end
        if hasattr(self, '_edge_ids') and self._edge_ids:
            mermaid.append("")
            for edge_id in self._edge_ids:
                mermaid.append(f"  {edge_id}@{{ animate: true }}")

        # Add variable shape styling
        if self.topology.static_builder.version_map:
            mermaid.append("")
            for var_name in self.topology.static_builder.version_map.keys():
                mermaid.append(f"  var_{var_name}@{{ shape: rounded }}")

        return "\n".join(mermaid)

    def _add_item_nodes(self, mermaid: List[str]):
        """Add item nodes to the diagram."""
        mermaid.append("")
        mermaid.append("  %% Items")
        for item_id in self.topology.items:
            item = self.items_by_id[item_id]
            title = item.get('title', 'No title')
            # Escape special characters for Mermaid
            title = self._escape_for_mermaid(title)
            mermaid.append(f'  {item_id}["{item_id}: {title}"]')

    def _add_variable_nodes(self, mermaid: List[str]):
        """Add variable nodes to the diagram."""
        if not self.topology.static_builder.version_map:
            return

        mermaid.append("")
        for var_name in sorted(self.topology.static_builder.version_map.keys()):
            mermaid.append(f'  var_{var_name}[{var_name}]')

            # Connect items to variables they assign (solid line with arrow from item to variable)
            for item_id in self.topology.items:
                item = self.items_by_id[item_id]
                if 'codeBlock' in item and f'{var_name} =' in item['codeBlock']:
                    mermaid.append(f'  var_{var_name} ---> {item_id}')
                    break  # Only connect to the first assignment

    def _add_precondition_nodes(self, mermaid: List[str]):
        """Add precondition nodes and their connections."""
        preconditions = []
        for item_id in self.topology.items:
            item = self.items_by_id[item_id]
            if 'precondition' in item:
                for i, precond in enumerate(item['precondition']):
                    preconditions.append({
                        'id': f'{item_id}_precond_{i}',
                        'owner': item_id,
                        'predicate': precond.get('predicate', '')
                    })

        if not preconditions:
            return

        mermaid.append("")
        mermaid.append("  %% BEGIN_PRECONDITIONS")

        for precond in preconditions:
            owner = precond['owner']
            predicate = self._truncate_text(precond['predicate'], 50)
            predicate = self._escape_for_mermaid(predicate)
            precond_id = precond['id']

            # Connect owner item to precondition (containment)
            mermaid.append(f'  {owner} ---- {precond_id}(["{predicate}"])')

            # Connect precondition to referenced items based on dependencies
            deps = self.topology.dependencies.get(owner, [])
            for dep_item in deps:
                if dep_item in predicate:
                    mermaid.append(f'  {precond_id} -..-> {dep_item}')

            # Connect precondition to referenced variables
            for var_name in self.topology.static_builder.version_map.keys():
                if var_name in predicate:
                    mermaid.append(f'  {precond_id} -..-> var_{var_name}')

        mermaid.append("  %% END_PRECONDITIONS")

    def _add_postcondition_nodes(self, mermaid: List[str]):
        """Add postcondition nodes and their connections."""
        mermaid.append("")
        mermaid.append("  %% BEGIN_POSTCONDITIONS")

        postconditions = []
        for item_id in self.topology.items:
            item = self.items_by_id[item_id]
            if 'postcondition' in item:
                for i, postcond in enumerate(item['postcondition']):
                    postconditions.append({
                        'id': f'{item_id}_postcond_{i}',
                        'owner': item_id,
                        'predicate': postcond.get('predicate', '')
                    })

        if postconditions:
            for postcond in postconditions:
                owner = postcond['owner']
                predicate = self._truncate_text(postcond['predicate'], 50)
                predicate = self._escape_for_mermaid(predicate)
                postcond_id = postcond['id']

                # Connect owner item to postcondition (containment)
                mermaid.append(f'  {owner} ---- {postcond_id}{{{{"{predicate}"}}}}')

                # Connect postcondition to referenced variables
                for var_name in self.topology.static_builder.version_map.keys():
                    if var_name in predicate:
                        mermaid.append(f'  {postcond_id} -..-> var_{var_name}')

                # Connect postcondition to referenced items
                for ref_item_id in self.topology.items:
                    if ref_item_id != owner and ref_item_id in postcond.get('predicate', ''):
                        mermaid.append(f'  {postcond_id} -..-> {ref_item_id}')

        mermaid.append("  %% END_POSTCONDITIONS")

    def _add_topological_chain(self, mermaid: List[str]):
        """Add animated chain showing topological order."""
        order = self.topology.topological_order
        edge_ids = []

        # Add item nodes first
        for item_id in order:
            item = self.items_by_id[item_id]
            title = item.get('title', 'No title')
            title = self._escape_for_mermaid(title)
            mermaid.append(f'  {item_id}["{item_id}: {title}"]')

        # Generate the chain connections
        for i in range(len(order) - 1):
            current = order[i]
            next_item = order[i + 1]
            edge_id = f"e{i + 1}"
            edge_ids.append(edge_id)
            mermaid.append(f'  {current} {edge_id}@==> {next_item}')

        # Store edge IDs for later animation declarations
        self._edge_ids = edge_ids

    def _add_cycle_highlighting(self, mermaid: List[str]):
        """Add cycle detection and highlighting."""
        mermaid.append("")
        mermaid.append("  %% Cycle Detection")

        # Get all nodes involved in cycles
        cycle_nodes = set()
        for cycle in self.topology.cycles:
            cycle_nodes.update(cycle[:-1])  # Exclude duplicate last element

        # Highlight cycle edges
        for cycle in self.topology.cycles:
            for i in range(len(cycle) - 1):
                from_node = cycle[i]
                to_node = cycle[i + 1]
                mermaid.append(f'  {from_node} ===> |CYCLE| {to_node}')

        # Style cycle nodes
        mermaid.append("")
        mermaid.append("  %% Apply cycle node styling")
        for node in cycle_nodes:
            mermaid.append(f'  {node}:::cycleNode')

    def _add_static_styles(self, mermaid: List[str]):
        """Add only static styling for variables and conditions (NOT items)."""
        mermaid.append("")

        # Apply variable styles
        for var_name in self.topology.static_builder.version_map.keys():
            mermaid.append(f'  var_{var_name}:::variable')

        # Add condition styling section with markers for QML Explorer
        mermaid.append("")
        mermaid.append("  %% BEGIN_CONDITION_STYLING")

        # Preconditions and postconditions
        for item_id in self.topology.items:
            item = self.items_by_id[item_id]
            if 'precondition' in item:
                for i, _ in enumerate(item['precondition']):
                    mermaid.append(f'  {item_id}_precond_{i}:::precondition')
            if 'postcondition' in item:
                for i, _ in enumerate(item['postcondition']):
                    mermaid.append(f'  {item_id}_postcond_{i}:::postcondition')

        mermaid.append("  %% END_CONDITION_STYLING")

    def _add_css_definitions(self, mermaid: List[str]):
        """Add all CSS class definitions."""
        mermaid.append("")
        mermaid.append("  classDef default fill:#F9F9F9,stroke:#333,stroke-width:2px")
        mermaid.append("  classDef current fill:#FF9900,stroke:#000,stroke-width:2px")
        mermaid.append("  classDef visited fill:#66CFCD,stroke:#000,stroke-width:1px")
        mermaid.append("  classDef pending fill:#D3D3D3,stroke:#000,stroke-width:1px")
        mermaid.append("  classDef always fill:#00CC00,stroke:#000,stroke-width:2px")
        mermaid.append("  classDef conditional fill:#FFCC00,stroke:#000,stroke-width:2px")
        mermaid.append("  classDef tautological fill:#4169E1,stroke:#000,stroke-width:2px")
        mermaid.append("  classDef infeasible fill:#9900CC,stroke:#000,stroke-width:2px,color:#FFF")
        mermaid.append("  classDef never fill:#FF0000,stroke:#000,stroke-width:2px,color:#FFF")
        mermaid.append("  classDef precondition fill:#F5F5DC,stroke:#000,stroke-width:1px")
        mermaid.append("  classDef postcondition fill:#E6F0FF,stroke:#000,stroke-width:1px")
        mermaid.append("  classDef variable fill:#CCCCFF,stroke:#000,stroke-width:1px,color:#000")

    def apply_flow_coloring(self, base_diagram: str, current_item_id: Optional[str] = None) -> str:
        """
        Apply flow mode coloring to items based on visited state.
        Inserts item coloring lines before the %% BEGIN_CONDITION_STYLING marker.

        Args:
            base_diagram: The base Mermaid diagram structure
            current_item_id: ID of the currently active item

        Returns:
            Diagram with flow-based coloring applied
        """
        lines = base_diagram.split('\n')
        coloring = []

        # Get visited items from state
        visited_items = {item['id'] for item in self.state.get_all_items()
                        if item.get('visited', False)}

        # Generate item coloring
        for item_id in self.topology.items:
            if current_item_id and item_id == current_item_id:
                coloring.append(f"  {item_id}:::current")
            elif item_id in visited_items:
                coloring.append(f"  {item_id}:::visited")
            else:
                coloring.append(f"  {item_id}:::pending")

        # Insert coloring before %% BEGIN_CONDITION_STYLING
        return self._insert_coloring(lines, coloring)

    def apply_analysis_coloring(self, base_diagram: str, classifier: Optional[Any] = None) -> str:
        """
        Apply analysis mode coloring based on Z3 classifications.

        Args:
            base_diagram: The base Mermaid diagram structure
            classifier: ItemClassifier instance to query classifications from

        Returns:
            Diagram with analysis-based coloring applied
        """
        from askalot_qml.z3.item_classifier import ItemClassifier

        lines = base_diagram.split('\n')
        coloring = []

        if classifier and isinstance(classifier, ItemClassifier):
            # Query classifications directly from classifier
            for item_id in self.topology.items:
                classification = classifier.classify_item(item_id)

                # Extract classification details
                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond = classification.get("postcondition", {})
                postcond_invariant = postcond.get("invariant", "UNKNOWN")
                is_vacuous = postcond.get("vacuous", False)

                # Apply coloring based on classification
                if precond_status == "ALWAYS":
                    if postcond_invariant == "CONSTRAINING" and not is_vacuous:
                        coloring.append(f"  {item_id}:::always")
                    elif postcond_invariant == "TAUTOLOGICAL":
                        coloring.append(f"  {item_id}:::tautological")
                    elif postcond_invariant == "INFEASIBLE":
                        coloring.append(f"  {item_id}:::infeasible")
                    elif postcond_invariant == "NONE":
                        # Items without postconditions: use basic coloring based on reachability
                        coloring.append(f"  {item_id}:::always")
                    else:
                        coloring.append(f"  {item_id}:::visited")
                elif precond_status == "CONDITIONAL":
                    if postcond_invariant == "TAUTOLOGICAL":
                        coloring.append(f"  {item_id}:::tautological")
                    elif postcond_invariant == "INFEASIBLE":
                        coloring.append(f"  {item_id}:::infeasible")
                    elif postcond_invariant == "NONE":
                        # Items without postconditions: use basic coloring based on reachability
                        coloring.append(f"  {item_id}:::conditional")
                    else:
                        coloring.append(f"  {item_id}:::conditional")
                elif precond_status == "NEVER":
                    coloring.append(f"  {item_id}:::never")
                else:
                    coloring.append(f"  {item_id}:::pending")
        else:
            # No classifier - all items pending
            for item_id in self.topology.items:
                coloring.append(f"  {item_id}:::pending")

        return self._insert_coloring(lines, coloring)

    def _insert_coloring(self, lines: List[str], coloring: List[str]) -> str:
        """Insert coloring lines between %% BEGIN_ITEM_STYLING and %% END_ITEM_STYLING markers."""
        begin_index = -1
        end_index = -1

        for i, line in enumerate(lines):
            if "%% BEGIN_ITEM_STYLING" in line:
                begin_index = i
            elif "%% END_ITEM_STYLING" in line:
                end_index = i
                break

        if begin_index >= 0 and end_index >= 0:
            # Insert coloring between the markers, replacing any existing content
            lines = lines[:begin_index + 1] + [""] + coloring + [""] + lines[end_index:]
        elif begin_index >= 0:
            # Only begin marker found, insert after it
            lines = lines[:begin_index + 1] + [""] + coloring + [""] + lines[begin_index + 1:]
        else:
            # Fallback: append at end if markers not found
            lines.extend([""] + coloring)
            self.logger.warning("%% BEGIN_ITEM_STYLING or %% END_ITEM_STYLING markers not found in diagram")

        return "\n".join(lines)

    def _escape_for_mermaid(self, text: str) -> str:
        """Escape special characters for Mermaid."""
        if not text:
            return text
        # For Mermaid, we need to escape < > properly and keep quotes
        return (text.replace('<', '&lt;')
                    .replace('>', '&gt;')
                    .replace('"', '&quot;'))

    def _truncate_text(self, text: str, max_length: int) -> str:
        """Truncate text to maximum length."""
        if len(text) <= max_length:
            return text
        return text[:max_length - 3] + "..."


    def generate_analysis_report(self) -> str:
        """Generate a concise text report of the analysis."""
        lines = []
        lines.append("=" * 60)
        lines.append("QML ANALYSIS REPORT")
        lines.append("=" * 60)

        # Summary
        lines.append("\n📊 Summary:")
        lines.append(f"  Items: {len(self.items_by_id)}")

        precond_count = sum(len(item.get('precondition', [])) for item in self.items_by_id.values())
        postcond_count = sum(len(item.get('postcondition', [])) for item in self.items_by_id.values())

        if precond_count > 0:
            lines.append(f"  Preconditions: {precond_count}")
        if postcond_count > 0:
            lines.append(f"  Postconditions: {postcond_count}")

        # Only show variables that are actually used (have versions > 0)
        used_vars = {name: count for name, count in self.topology.static_builder.version_map.items() if count > 0}
        if used_vars:
            lines.append(f"  Variables: {len(used_vars)}")

        if self.topology:
            if self.topology.has_cycles:
                lines.append(f"  ⚠️  Cycles: {len(self.topology.cycles)}")
            else:
                lines.append("  ✅ No cycles")

        # Topology information
        if self.topology:
            lines.append("\n🔄 Flow:")
            if self.topology.topological_order:
                lines.append(f"  Order: {' → '.join(self.topology.topological_order[:3])}...")

            components = self.topology.get_components()
            if len(components) > 1:
                lines.append(f"  Components: {len(components)}")

        # Only show items with interesting properties
        interesting_items = []
        for item_id in self.topology.items:
            item = self.items_by_id[item_id]
            has_preconds = len(item.get('precondition', [])) > 0
            has_postconds = len(item.get('postcondition', [])) > 0
            has_code = 'codeBlock' in item

            if has_preconds or has_postconds or has_code:
                interesting_items.append((item_id, item, has_preconds, has_postconds, has_code))

        if interesting_items:
            lines.append("\n📦 Key Items:")
            for item_id, item, has_preconds, has_postconds, has_code in interesting_items:
                title = item.get('title', 'No title')
                props = []
                if has_preconds:
                    props.append(f"{len(item.get('precondition', []))} preconds")
                if has_postconds:
                    props.append(f"{len(item.get('postcondition', []))} postconds")
                if has_code:
                    props.append("code")

                prop_str = f" ({', '.join(props)})" if props else ""
                lines.append(f"  {item_id}: {title}{prop_str}")

        return "\n".join(lines)

