"""
QMLDiagram - Graph IR Generation for QML Questionnaires

This module generates a JSON graph intermediate representation (IR) showing:
- Items and their dependencies discovered through Z3 analysis
- Topological ordering and dependency chains
- Cycle detection and highlighting
- Validation-based coloring schemes (Z3 classification)

The graph IR is consumed by qml_layout.py (server-side Graphviz positioning)
and rendered as SVG DOM elements in the browser (Armiger QML Explorer).
"""

import logging
from typing import Optional, List, Dict, Any
from askalot_qml.core.qml_topology import QMLTopology
from askalot_qml.models.qml_state import QMLState


class QMLDiagram:
    """Generate graph IR for QML questionnaires using Z3 topology."""

    def __init__(self, topology: QMLTopology, questionnaire_state: QMLState):
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

    def generate_base_graph(self) -> dict:
        """
        Generate the cacheable base graph structure as JSON IR.

        Includes: items, dependencies, variables, preconditions, postconditions
        Excludes: item coloring classes (visited, current, always, etc.)

        Returns:
            Dict with 'nodes', 'edges', and 'metadata' keys
        """
        nodes = []
        edges = []

        # Compute topological order for chain
        has_cycles = self.topology.has_cycles if self.topology else False
        topological_order = []

        if self.topology and self.topology.topological_order:
            topological_order = list(self.topology.topological_order)

        # --- Item nodes ---
        order = topological_order if topological_order else list(self.topology.items) if self.topology else []
        for item_id in order:
            item = self.items_by_id.get(item_id)
            if not item:
                continue
            title = item.get('title', 'No title')
            label = f"{item_id}: {title}"

            node = {
                'id': item_id,
                'label': label,
                'type': 'item',
                'group': item.get('blockId', ''),
            }

            # Rich metadata for future node visualization
            kind = item.get('kind', '')
            if kind:
                node['item_type'] = kind.lower()

            input_config = item.get('input', {})
            control_type = input_config.get('control', '') if isinstance(input_config, dict) else ''
            if control_type:
                node['control_type'] = control_type.lower()

            nodes.append(node)

        # Topological chain edges (animated) — always add for vertical layout guidance.
        # When cycles exist, topological_order is empty; fall back to QML file order.
        chain = topological_order if topological_order else order
        if chain:
            for i in range(len(chain) - 1):
                edges.append({
                    'source': chain[i],
                    'target': chain[i + 1],
                    'type': 'topological',
                })

        # --- Variable nodes ---
        if self.topology and self.topology.static_builder.version_map:
            for var_name in sorted(self.topology.static_builder.version_map.keys()):
                nodes.append({
                    'id': f'var_{var_name}',
                    'label': var_name,
                    'type': 'variable',
                })

                # Variable assignment edges: variable -> item (variable points to items that modify it)
                for item_id in (self.topology.items if self.topology else []):
                    item = self.items_by_id.get(item_id)
                    if item and 'codeBlock' in item and f'{var_name} =' in item['codeBlock']:
                        edges.append({
                            'source': f'var_{var_name}',
                            'target': item_id,
                            'type': 'variable_assignment',
                        })

        # --- Precondition nodes ---
        for item_id in (self.topology.items if self.topology else []):
            item = self.items_by_id.get(item_id)
            if not item or 'precondition' not in item:
                continue

            for i, precond in enumerate(item['precondition']):
                precond_id = f'{item_id}_precond_{i}'
                predicate = precond.get('predicate', '')
                label = self._truncate_text(predicate, 50)

                nodes.append({
                    'id': precond_id,
                    'label': label,
                    'type': 'precondition',
                    'owner': item_id,
                })

                # Containment edge: precondition -> owner item
                edges.append({
                    'source': precond_id,
                    'target': item_id,
                    'type': 'containment',
                })

                # Dependency edges: precondition -> referenced items
                deps = self.topology.dependencies.get(item_id, []) if self.topology else []
                for dep_item in deps:
                    if dep_item in predicate:
                        edges.append({
                            'source': precond_id,
                            'target': dep_item,
                            'type': 'dependency',
                        })

                # Dependency edges: precondition -> referenced variables
                if self.topology:
                    for var_name in self.topology.static_builder.version_map.keys():
                        if var_name in predicate:
                            edges.append({
                                'source': precond_id,
                                'target': f'var_{var_name}',
                                'type': 'dependency',
                            })

        # --- Postcondition nodes ---
        for item_id in (self.topology.items if self.topology else []):
            item = self.items_by_id.get(item_id)
            if not item or 'postcondition' not in item:
                continue

            for i, postcond in enumerate(item['postcondition']):
                postcond_id = f'{item_id}_postcond_{i}'
                predicate = postcond.get('predicate', '')
                label = self._truncate_text(predicate, 50)

                nodes.append({
                    'id': postcond_id,
                    'label': label,
                    'type': 'postcondition',
                    'owner': item_id,
                })

                # Containment edge: postcondition -> owner item
                edges.append({
                    'source': postcond_id,
                    'target': item_id,
                    'type': 'containment',
                })

                # Dependency edges: postcondition -> referenced variables
                if self.topology:
                    for var_name in self.topology.static_builder.version_map.keys():
                        if var_name in predicate:
                            edges.append({
                                'source': postcond_id,
                                'target': f'var_{var_name}',
                                'type': 'dependency',
                            })

                # Dependency edges: postcondition -> referenced items
                for ref_item_id in (self.topology.items if self.topology else []):
                    if ref_item_id != item_id and ref_item_id in predicate:
                        edges.append({
                            'source': postcond_id,
                            'target': ref_item_id,
                            'type': 'dependency',
                        })

        # --- Cycle highlighting ---
        # Overlapping cycles (sharing nodes) are merged into groups so the
        # diagram shows one red cluster per interconnected circular region,
        # not one arc per iterative cycle-break.
        #
        # For each group: sort members by file order, connect with forward
        # red arrows, and close with exactly ONE backward arc.
        cycle_members = set()
        cycle_edges_list = []
        chain_pairs = set()
        chain_index = {item_id: i for i, item_id in enumerate(chain)} if chain else {}
        if chain:
            for i in range(len(chain) - 1):
                chain_pairs.add((chain[i], chain[i + 1]))
        if self.topology and self.topology.has_cycles:
            # Merge overlapping cycles into groups (union-find)
            cycle_sets = [set(c[:-1]) for c in self.topology.cycles]
            merged = self._merge_overlapping_sets(cycle_sets)

            for group in merged:
                cycle_members.update(group)

                # Sort by file order for normalized forward chain
                sorted_members = sorted(group, key=lambda x: chain_index.get(x, 0))

                if len(sorted_members) < 2:
                    continue  # Self-reference: no edges needed, just coloring

                # Forward edges between consecutive members (file order)
                for j in range(len(sorted_members) - 1):
                    pair = (sorted_members[j], sorted_members[j + 1])
                    if pair not in chain_pairs:
                        cycle_edges_list.append({
                            'source': sorted_members[j],
                            'target': sorted_members[j + 1],
                            'type': 'cycle',
                        })

                # ONE backward arc: last → first (closing the cycle)
                cycle_edges_list.append({
                    'source': sorted_members[-1],
                    'target': sorted_members[0],
                    'type': 'cycle',
                })

            edges.extend(cycle_edges_list)

            # Mark topological edges between cycle members as in_cycle (red).
            for edge in edges:
                if edge['type'] == 'topological':
                    if edge['source'] in cycle_members and edge['target'] in cycle_members:
                        edge['in_cycle'] = True

        metadata = {
            'has_cycles': has_cycles,
            'topological_order': topological_order,
            'cycle_nodes': sorted(cycle_members),
            'cycle_edges': [{'source': e['source'], 'target': e['target']} for e in cycle_edges_list],
        }

        return {
            'nodes': nodes,
            'edges': edges,
            'metadata': metadata,
        }

    def apply_validation_coloring(
        self, base_graph: dict,
        classifications: Optional[Dict[str, Any]] = None,
    ) -> dict:
        """Apply validation mode coloring based on Z3 classifications.

        Args:
            base_graph: Base graph dict from generate_base_graph()
            classifications: Pre-computed dict from classify_all_items()

        Returns:
            Graph dict with 'classes' map added
        """
        classes = {}

        if classifications:
            for item_id in self.topology.items:
                classification = classifications.get(item_id, {
                    "precondition": {"status": "UNKNOWN"},
                    "postcondition": {"invariant": "UNKNOWN", "vacuous": False},
                })

                precond_status = classification.get("precondition", {}).get("status", "UNKNOWN")
                postcond = classification.get("postcondition", {})
                postcond_invariant = postcond.get("invariant", "UNKNOWN")
                is_vacuous = postcond.get("vacuous", False)

                if precond_status == "ALWAYS":
                    if postcond_invariant == "CONSTRAINING" and not is_vacuous:
                        classes[item_id] = "always"
                    elif postcond_invariant == "TAUTOLOGICAL":
                        classes[item_id] = "tautological"
                    elif postcond_invariant == "INFEASIBLE":
                        classes[item_id] = "infeasible"
                    elif postcond_invariant == "NONE":
                        classes[item_id] = "always"
                    else:
                        classes[item_id] = "visited"
                elif precond_status == "CONDITIONAL":
                    if postcond_invariant == "TAUTOLOGICAL":
                        classes[item_id] = "tautological"
                    elif postcond_invariant == "INFEASIBLE":
                        classes[item_id] = "infeasible"
                    elif postcond_invariant == "NONE":
                        classes[item_id] = "conditional"
                    else:
                        classes[item_id] = "conditional"
                elif precond_status == "NEVER":
                    classes[item_id] = "never"
                else:
                    classes[item_id] = "pending"
        else:
            for item_id in self.topology.items:
                classes[item_id] = "pending"

        # Cycle membership overrides Z3 classification — cycle is the primary
        # issue to fix, and Z3 results are unreliable for cycle-involved items.
        cycle_nodes = base_graph.get('metadata', {}).get('cycle_nodes', [])
        for item_id in cycle_nodes:
            classes[item_id] = 'cycle'

        return {**base_graph, 'classes': classes}

    @staticmethod
    def _merge_overlapping_sets(sets: List[set]) -> List[set]:
        """Merge sets that share at least one element.

        Example: [{A,B}, {B,C}, {D,E}] → [{A,B,C}, {D,E}]
        """
        merged: List[set] = []
        for s in sets:
            # Find all existing groups that overlap with this set
            overlapping = [i for i, m in enumerate(merged) if m & s]
            if not overlapping:
                merged.append(s.copy())
            else:
                # Merge all overlapping groups + current set into the first
                target = merged[overlapping[0]]
                target.update(s)
                for i in reversed(overlapping[1:]):
                    target.update(merged.pop(i))
        return merged

    def _truncate_text(self, text: str, max_length: int) -> str:
        """Truncate text to maximum length."""
        if len(text) <= max_length:
            return text
        return text[:max_length - 3] + "..."

    def generate_validation_report(self) -> str:
        """Generate a concise text report of the validation."""
        lines = []
        lines.append("=" * 60)
        lines.append("QML VALIDATION REPORT")
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
