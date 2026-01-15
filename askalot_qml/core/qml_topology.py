"""
QMLTopology - Z3-Driven Dependency Analysis and Topological Sorting

This module uses Z3 constraint solving to discover dependencies between
questionnaire items and detect cycles through satisfiability checking.
"""

import logging
from typing import Dict, Set, List, Optional, Tuple
from collections import deque
import heapq
from z3 import *

from askalot_qml.models.questionnaire_state import QuestionnaireState
from askalot_qml.z3.static_builder import StaticBuilder


class QMLTopology:
    """
    Z3-driven topology analysis for questionnaire items.

    Uses Z3 constraint solving to:
    1. Discover item dependencies through constraint analysis
    2. Detect cycles using satisfiability checking
    3. Compute topological ordering with Kahn's algorithm
    """

    def __init__(self, questionnaire_state: QuestionnaireState, static_builder: StaticBuilder):
        """
        Initialize topology analysis with Z3.

        Args:
            questionnaire_state: The questionnaire to analyze
            static_builder: Pre-built StaticBuilder with Z3 constraints
        """
        self.logger = logging.getLogger(__name__)
        self.state = questionnaire_state
        self.static_builder = static_builder

        # Get item list for ordering
        self.items = [item['id'] for item in self.state.get_all_items() if item.get('id')]

        # Dependency graph from SSA analysis
        self.dependencies: Dict[str, Set[str]] = {}

        # Reverse dependency graph
        self.reverse_dependencies: Dict[str, Set[str]] = {}

        # Topological order (if no cycles)
        self.topological_order: List[str] = []

        # Cycle detection results
        self.cycles: List[List[str]] = []
        self.has_cycles: bool = False

        # Build topology using Z3
        self._build_dependency_graph()
        self._detect_cycles_z3()
        if not self.has_cycles:
            self._compute_topological_order()

    def _build_dependency_graph(self):
        """Build dependency graph from Z3 constraint analysis."""
        # Initialize dependency sets
        for item_id in self.items:
            self.dependencies[item_id] = set()
            self.reverse_dependencies[item_id] = set()

        # Get dependencies discovered by SSA builder
        item_deps = self.static_builder.get_item_dependencies()

        # Build both forward and reverse dependency graphs
        for item_id, deps in item_deps.items():
            self.dependencies[item_id] = deps.copy()
            for dep_id in deps:
                if dep_id in self.reverse_dependencies:
                    self.reverse_dependencies[dep_id].add(item_id)

        self.logger.debug(f"Built dependency graph with {len(self.dependencies)} items")
        for item_id, deps in self.dependencies.items():
            if deps:
                self.logger.debug(f"  {item_id} depends on: {', '.join(sorted(deps))}")

    def _detect_cycles_z3(self):
        """Detect cycles using Z3 satisfiability checking."""
        if not self.items:
            return

        solver = Solver()

        # Create ordering variables for each item
        order_vars = {}
        for item_id in self.items:
            order_vars[item_id] = Int(f"order_{item_id}")
            # Each item has a unique position
            solver.add(order_vars[item_id] >= 0)
            solver.add(order_vars[item_id] < len(self.items))

        # Add uniqueness constraints
        for i, item1 in enumerate(self.items):
            for item2 in self.items[i+1:]:
                solver.add(order_vars[item1] != order_vars[item2])

        # Add dependency constraints
        # If A depends on B, then order(A) > order(B)
        for item_id, deps in self.dependencies.items():
            for dep_id in deps:
                if dep_id in order_vars:  # Ensure dependency exists in our items
                    solver.add(order_vars[item_id] > order_vars[dep_id])

        # Check satisfiability
        result = solver.check()

        if result == unsat:
            # Cycles exist - find them using graph traversal
            self.has_cycles = True
            self._find_cycles_dfs()
            self.logger.warning(f"Z3 detected cycles in dependency graph")
        elif result == sat:
            self.has_cycles = False
            self.logger.info("No cycles detected by Z3")
        else:
            self.logger.warning("Z3 solver returned unknown")
            # Fall back to DFS-based cycle detection
            self._find_cycles_dfs()

    def _find_cycles_dfs(self):
        """Find actual cycles using DFS when Z3 detects unsatisfiability."""
        visited = set()
        rec_stack = set()

        def dfs(node: str, path: List[str]) -> bool:
            """DFS to find cycles."""
            visited.add(node)
            rec_stack.add(node)
            path.append(node)

            for neighbor in self.dependencies.get(node, set()):
                if neighbor not in visited:
                    if dfs(neighbor, path[:]):
                        return True
                elif neighbor in rec_stack:
                    # Found a cycle
                    cycle_start = path.index(neighbor)
                    cycle = path[cycle_start:] + [neighbor]
                    self.cycles.append(cycle)
                    return True

            rec_stack.remove(node)
            return False

        # Check each unvisited node
        for item_id in self.items:
            if item_id not in visited:
                if dfs(item_id, []):
                    break  # Found at least one cycle

        if self.cycles:
            for i, cycle in enumerate(self.cycles):
                self.logger.warning(f"  Cycle {i+1}: {' -> '.join(cycle)}")

    def _compute_topological_order(self):
        """Compute topological order using Kahn's algorithm with priority queue.

        Uses a min-heap keyed by original QML file order to ensure that when
        multiple items are available (in_degree = 0), the one appearing first
        in the original QML file is processed first.
        """
        if self.has_cycles:
            self.logger.error("Cannot compute topological order: cycles detected")
            return

        # Build index map for original QML order
        item_index = {item_id: idx for idx, item_id in enumerate(self.items)}

        # Calculate in-degrees
        in_degree = {item_id: len(self.dependencies[item_id])
                     for item_id in self.items}

        # Use a min-heap (priority queue) keyed by original QML index
        # Heap entries are (original_index, item_id)
        heap = []
        for item_id in self.items:
            if in_degree[item_id] == 0:
                heapq.heappush(heap, (item_index[item_id], item_id))

        result = []

        while heap:
            _, current = heapq.heappop(heap)
            result.append(current)

            # For each item that depends on current, decrease in-degree
            for dependent in self.reverse_dependencies.get(current, set()):
                in_degree[dependent] -= 1
                if in_degree[dependent] == 0:
                    # Add to heap with original QML index as priority
                    heapq.heappush(heap, (item_index[dependent], dependent))

        # Check if we processed all items
        if len(result) == len(self.items):
            self.topological_order = result
            self.logger.info(f"Computed topological order for {len(result)} items")
        else:
            # This shouldn't happen if cycle detection works correctly
            self.logger.error("Failed to compute complete topological order")
            self.has_cycles = True

    def get_topological_order(self) -> Optional[List[str]]:
        """Get the topological order of items."""
        if self.has_cycles:
            return None
        return self.topological_order.copy()

    def get_cycles(self) -> List[List[str]]:
        """Get all detected cycles."""
        return self.cycles.copy()

    def get_dependency_chains(self) -> Dict[str, Set[str]]:
        """
        Get dependency chains for each item.
        Returns a dict mapping each item to its dependencies.
        """
        return {item_id: deps.copy() for item_id, deps in self.dependencies.items()}

    def get_components(self) -> List[Set[str]]:
        """
        Get connected components in the dependency graph.
        Each component is a set of interdependent items.
        """
        visited = set()
        components = []

        def explore_component(start_item: str) -> Set[str]:
            """Explore a component using BFS."""
            component = set()
            queue = deque([start_item])

            while queue:
                current = queue.popleft()
                if current in visited:
                    continue

                visited.add(current)
                component.add(current)

                # Add items this depends on
                for dep in self.dependencies.get(current, set()):
                    if dep not in visited:
                        queue.append(dep)

                # Add items that depend on this
                for dep in self.reverse_dependencies.get(current, set()):
                    if dep not in visited:
                        queue.append(dep)

            return component

        # Process items
        for item_id in self.items:
            if item_id not in visited:
                component = explore_component(item_id)
                components.append(component)

        self.logger.debug(f"Found {len(components)} connected components")
        return components

    def get_statistics(self) -> Dict[str, any]:
        """Get statistics about the dependency topology."""
        stats = {
            'total_items': len(self.items),
            'total_components': len(self.get_components()),
            'has_cycles': self.has_cycles,
            'num_cycles': len(self.cycles),
            'cycles': self.get_cycles() if self.has_cycles else [],
            'topological_order_exists': not self.has_cycles,
            'topological_order': self.topological_order if not self.has_cycles else None,
        }

        # Component sizes
        components = self.get_components()
        stats['component_sizes'] = [len(c) for c in components]
        stats['isolated_items'] = len([c for c in components if len(c) == 1])

        # Dependency stats
        total_dependencies = sum(len(deps) for deps in self.dependencies.values())
        stats['total_dependencies'] = total_dependencies
        stats['items_with_dependencies'] = len([item for item, deps in self.dependencies.items() if deps])

        # Find most dependent items
        if self.dependencies:
            most_dependent = max(self.dependencies.items(), key=lambda x: len(x[1]))
            if most_dependent[1]:  # Has dependencies
                stats['most_dependent_item'] = (most_dependent[0], len(most_dependent[1]))

        # Find most depended upon items
        if self.reverse_dependencies:
            most_depended_upon = max(self.reverse_dependencies.items(), key=lambda x: len(x[1]))
            if most_depended_upon[1]:  # Has dependents
                stats['most_depended_upon_item'] = (most_depended_upon[0], len(most_depended_upon[1]))

        return stats

    def get_dependency_layers(self) -> List[Set[str]]:
        """
        Group items into layers based on their dependencies.
        Items in the same layer have no dependencies on each other.
        """
        if self.has_cycles:
            # If there are cycles, we can't create proper layers
            # Return all items in a single layer
            return [set(self.items)]

        layers = []
        remaining = set(self.items)
        processed = set()

        while remaining:
            # Find items that have no unprocessed dependencies
            current_layer = set()

            for item_id in remaining:
                dependencies = self.dependencies.get(item_id, set())
                # Check if all dependencies have been processed
                if dependencies.issubset(processed):
                    current_layer.add(item_id)

            if not current_layer:
                # No progress possible - should not happen if cycle detection works
                self.logger.warning("Cannot create dependency layers - possible undetected cycles")
                # Add remaining items as a final layer
                layers.append(remaining)
                break

            layers.append(current_layer)
            processed.update(current_layer)
            remaining -= current_layer

        return layers

    def can_reach(self, from_item: str, to_item: str) -> bool:
        """Check if one item can reach another through dependencies using Z3."""
        if from_item == to_item:
            return True

        # Use BFS to check reachability
        visited = set()
        queue = deque([from_item])

        while queue:
            current = queue.popleft()
            if current == to_item:
                return True

            if current in visited:
                continue

            visited.add(current)

            # Add items that current depends on
            for dep in self.dependencies.get(current, set()):
                if dep not in visited:
                    queue.append(dep)

        return False

    def debug_dump(self) -> str:
        """Generate debug output."""
        lines = []
        lines.append("="*60)
        lines.append("Z3-DRIVEN QML TOPOLOGY DEBUG DUMP")
        lines.append("="*60)

        lines.append(f"\n📊 Summary:")
        lines.append(f"  Total items: {len(self.items)}")
        lines.append(f"  Has cycles: {self.has_cycles}")
        lines.append(f"  Number of cycles: {len(self.cycles)}")
        lines.append(f"  Z3 constraints: {len(self.static_builder.get_constraints())}")

        if self.cycles:
            lines.append("\n⚠️  Cycles Detected by Z3:")
            for i, cycle in enumerate(self.cycles):
                lines.append(f"  Cycle {i+1}: {' -> '.join(cycle)}")

        lines.append("\n🔗 Dependencies (from Z3 analysis):")
        for item_id in self.items:
            deps = self.dependencies.get(item_id, set())
            if deps:
                lines.append(f"  {item_id} depends on: {', '.join(sorted(deps))}")

        lines.append("\n🔄 Reverse Dependencies:")
        for item_id in self.items:
            rev_deps = self.reverse_dependencies.get(item_id, set())
            if rev_deps:
                lines.append(f"  {item_id} is depended on by: {', '.join(sorted(rev_deps))}")

        if self.topological_order:
            lines.append("\n📋 Topological Order (Kahn's Algorithm):")
            lines.append(f"  {' -> '.join(self.topological_order)}")

        # Components
        components = self.get_components()
        lines.append(f"\n🏝️  Connected Components ({len(components)}):")
        for i, component in enumerate(components):
            lines.append(f"  Component {i+1}: {', '.join(sorted(component))}")

        # SSA information
        lines.append("\n" + self.static_builder.debug_dump())

        return "\n".join(lines)