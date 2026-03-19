"""
Server-side graph layout using Graphviz layout engines.

Computes node positions and edge routes for the JSON graph IR produced by
QMLDiagram.generate_base_graph(). Uses pygraphviz to invoke Graphviz
layout engines.

Supported engines:
- dot:   Hierarchical DAG layout (default, best for questionnaire flow)
- neato: Spring model / force-directed (Kamada-Kawai)
- fdp:   Force-directed (Fruchterman-Reingold)
- sfdp:  Scalable force-directed (large graphs)
- twopi: Radial layout from root node
- circo: Circular layout

The layout is computed once per analysis and sent with the API response.
The browser receives pre-positioned data — rendering is instant (no
client-side layout library needed).

Coordinate system:
- Graphviz uses points (1 point = 1/72 inch)
- We convert to pixels at 96 DPI: 1 point = 96/72 ≈ 1.333 pixels
- Graphviz Y-axis points upward; we flip it so Y increases downward
  (matching SVG coordinate system)
"""

import logging
from typing import Any

logger = logging.getLogger(__name__)

# Graphviz points to pixels (96 DPI)
POINTS_TO_PX = 96.0 / 72.0

# Inches to pixels (96 DPI)
INCHES_TO_PX = 96.0

# Valid layout engines
LAYOUT_ENGINES = ('dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo')


def compute_layout(graph_data: dict, engine: str = 'dot') -> dict:
    """Compute node positions and edge routes using a Graphviz engine.

    Takes a graph_data dict (from generate_base_graph) and returns
    the same dict with x, y, width, height added to each node
    and bend_points added to each edge.

    For large graphs (>LARGE_GRAPH_THRESHOLD nodes), only item nodes and
    topological edges are sent to Graphviz. Auxiliary nodes (preconditions,
    postconditions, variables) are positioned relative to their owner items
    after layout, avoiding the O(n²) Graphviz scaling.

    Args:
        graph_data: Dict with 'nodes', 'edges', 'metadata' keys
        engine: Graphviz layout engine ('dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo')

    Returns:
        Same dict with layout positions added (mutates in place)
    """
    nodes = graph_data.get('nodes', [])
    if not nodes:
        return graph_data

    # For large graphs, use lightweight layout that only positions items
    if len(nodes) > LARGE_GRAPH_THRESHOLD:
        return _compute_layout_large(graph_data, engine)

    return _compute_layout_full(graph_data, engine)


# Threshold above which we switch to item-only Graphviz layout
LARGE_GRAPH_THRESHOLD = 150


def _compute_layout_large(graph_data: dict, engine: str = 'dot') -> dict:
    """Lightweight layout for large graphs.

    Only sends item nodes + topological edges to Graphviz, then positions
    auxiliary nodes (preconditions, postconditions, variables) relative
    to their owner items. Non-topological edges get straight-line paths.
    """
    import pygraphviz as pgv

    if engine not in LAYOUT_ENGINES:
        engine = 'dot'

    nodes = graph_data.get('nodes', [])
    edges = graph_data.get('edges', [])
    node_map = {n['id']: n for n in nodes}

    item_nodes = [n for n in nodes if n['type'] == 'item']
    aux_nodes = [n for n in nodes if n['type'] != 'item']

    # Build Graphviz graph with item nodes only
    G = pgv.AGraph(directed=True, strict=False)
    G.graph_attr.update({
        'rankdir': 'TB',
        'splines': 'line',  # Straight lines — much faster than curved for large graphs
        'nodesep': '0.4',
        'ranksep': '0.6',
        'overlap': 'false',
    })

    for node in item_nodes:
        w_inches, h_inches = _estimate_node_size(node)
        G.add_node(node['id'], width=str(w_inches), height=str(h_inches),
                    fixedsize='true', shape='box', group='items')

    # Only add topological edges (the main flow chain)
    seen_edges = set()
    for edge in edges:
        if edge.get('type') != 'topological':
            continue
        key = (edge['source'], edge['target'])
        if key not in seen_edges and edge['source'] in node_map and edge['target'] in node_map:
            seen_edges.add(key)
            G.add_edge(edge['source'], edge['target'])

    G.layout(prog=engine)

    # Extract item positions
    max_y = 0.0
    for gv_node in G.nodes():
        pos = gv_node.attr.get('pos', '')
        if pos:
            parts = pos.split(',')
            if len(parts) == 2:
                y = float(parts[1]) * POINTS_TO_PX
                if y > max_y:
                    max_y = y

    for gv_node in G.nodes():
        node_id = str(gv_node)
        if node_id not in node_map:
            continue
        pos = gv_node.attr.get('pos', '')
        if not pos:
            continue
        parts = pos.split(',')
        if len(parts) != 2:
            continue
        x = float(parts[0]) * POINTS_TO_PX
        y = max_y - float(parts[1]) * POINTS_TO_PX
        w = float(gv_node.attr.get('width', '1')) * INCHES_TO_PX
        h = float(gv_node.attr.get('height', '0.5')) * INCHES_TO_PX
        node_map[node_id]['x'] = round(x, 1)
        node_map[node_id]['y'] = round(y, 1)
        node_map[node_id]['width'] = round(w, 1)
        node_map[node_id]['height'] = round(h, 1)

    # Extract topological edge bend points from Graphviz
    gv_edge_map: dict[tuple[str, str], Any] = {}
    for gv_edge in G.edges():
        gv_edge_map[(str(gv_edge[0]), str(gv_edge[1]))] = gv_edge

    # Position auxiliary nodes relative to their owner items
    # Group aux nodes by owner
    aux_by_owner: dict[str, list[dict]] = {}
    for node in aux_nodes:
        owner_id = node.get('owner', '')
        if owner_id and owner_id in node_map and 'x' in node_map[owner_id]:
            aux_by_owner.setdefault(owner_id, []).append(node)
        else:
            # Variables or unowned nodes — assign size but no Graphviz position
            w_inches, h_inches = _estimate_node_size(node)
            node['width'] = round(w_inches * INCHES_TO_PX, 1)
            node['height'] = round(h_inches * INCHES_TO_PX, 1)

    # Place auxiliary nodes to the right of their owner, stacked vertically
    AUX_OFFSET_X = 220  # Pixels to the right of owner
    AUX_SPACING_Y = 50  # Vertical spacing between stacked aux nodes
    for owner_id, aux_list in aux_by_owner.items():
        owner = node_map[owner_id]
        base_x = owner['x'] + owner['width'] / 2 + AUX_OFFSET_X
        base_y = owner['y'] - ((len(aux_list) - 1) * AUX_SPACING_Y) / 2
        for i, node in enumerate(aux_list):
            w_inches, h_inches = _estimate_node_size(node)
            node['x'] = round(base_x, 1)
            node['y'] = round(base_y + i * AUX_SPACING_Y, 1)
            node['width'] = round(w_inches * INCHES_TO_PX, 1)
            node['height'] = round(h_inches * INCHES_TO_PX, 1)

    # Position variable nodes: find their first assignment target item
    var_nodes = [n for n in aux_nodes if n['type'] == 'variable' and 'x' not in n]
    if var_nodes:
        var_target: dict[str, str] = {}
        for edge in edges:
            if edge.get('type') == 'variable_assignment':
                var_id = edge['source']
                if var_id not in var_target and edge['target'] in node_map and 'x' in node_map[edge['target']]:
                    var_target[var_id] = edge['target']
        for node in var_nodes:
            target_id = var_target.get(node['id'])
            if target_id and 'x' in node_map[target_id]:
                target = node_map[target_id]
                node['x'] = round(target['x'] - target['width'] / 2 - AUX_OFFSET_X, 1)
                node['y'] = round(target['y'], 1)

    # Assign bend points to all edges
    node_order = {n['id']: i for i, n in enumerate(nodes)}
    for edge in edges:
        gv_edge = gv_edge_map.get((edge['source'], edge['target']))
        if gv_edge:
            pos = gv_edge.attr.get('pos', '')
            parsed = _parse_edge_pos(pos, max_y)
            points = parsed['points']
            arrow_end = parsed.get('arrow_end')
            arrow_start = parsed.get('arrow_start')

            tgt_node = node_map.get(edge['target'])
            src_node = node_map.get(edge['source'])
            if (arrow_end and tgt_node and src_node
                    and 'x' in tgt_node and 'x' in src_node):
                dx_tgt = (arrow_end['x'] - tgt_node['x']) ** 2 + (arrow_end['y'] - tgt_node['y']) ** 2
                dx_src = (arrow_end['x'] - src_node['x']) ** 2 + (arrow_end['y'] - src_node['y']) ** 2
                if dx_src < dx_tgt:
                    points = list(reversed(points))
                    arrow_end, arrow_start = arrow_start, arrow_end
                    if not arrow_end and points:
                        arrow_end = points[-1]

            edge['bend_points'] = points
            if arrow_end:
                edge['arrow_end'] = arrow_end
            if arrow_start:
                edge['arrow_start'] = arrow_start
        else:
            _assign_synthetic_edge_path(edge, node_map, node_order)

    # Compute SVG bounds
    _compute_bounds(graph_data, nodes, engine)
    return graph_data


def _compute_layout_full(graph_data: dict, engine: str = 'dot') -> dict:
    """Full Graphviz layout for small/medium graphs (original algorithm)."""
    import pygraphviz as pgv

    if engine not in LAYOUT_ENGINES:
        logger.warning(f"Unknown layout engine '{engine}', falling back to 'dot'")
        engine = 'dot'

    nodes = graph_data.get('nodes', [])
    edges = graph_data.get('edges', [])

    if not nodes:
        return graph_data

    # Hierarchical engines (dot) use directed graph with rank constraints;
    # force-directed engines (neato, fdp, sfdp) work better undirected
    is_hierarchical = engine in ('dot',)

    G = pgv.AGraph(directed=True, strict=False)

    if is_hierarchical:
        G.graph_attr.update({
            'rankdir': 'TB',
            'splines': 'curved',
            'nodesep': '0.6',
            'ranksep': '0.8',
            'overlap': 'false',
        })
    elif engine == 'twopi':
        # Radial: find root node (first item in topological order)
        topo_order = graph_data.get('metadata', {}).get('topological_order', [])
        root = topo_order[0] if topo_order else (nodes[0]['id'] if nodes else '')
        G.graph_attr.update({
            'root': root,
            'overlap': 'false',
            'splines': 'curved',
            'ranksep': '2.0',
        })
    elif engine == 'circo':
        G.graph_attr.update({
            'overlap': 'false',
            'splines': 'curved',
            'mindist': '1.5',
        })
    else:
        # neato, fdp, sfdp
        G.graph_attr.update({
            'overlap': 'false',
            'splines': 'curved',
            'sep': '+20',
            'esep': '+10',
        })
        if engine == 'neato':
            G.graph_attr['mode'] = 'major'
        elif engine == 'sfdp':
            G.graph_attr['K'] = '1.5'

    # Build node lookup
    node_map = {n['id']: n for n in nodes}

    # Separate nodes by type
    item_nodes = [n for n in nodes if n['type'] == 'item']
    aux_nodes = [n for n in nodes if n['type'] != 'item']

    # Add item nodes
    for node in item_nodes:
        w_inches, h_inches = _estimate_node_size(node)
        attrs = {
            'width': str(w_inches),
            'height': str(h_inches),
            'fixedsize': 'true',
            'shape': 'box',
        }
        if is_hierarchical:
            attrs['group'] = 'items'  # Same group = same column in dot
        G.add_node(node['id'], **attrs)

    # Add auxiliary nodes (preconditions, postconditions, variables)
    for node in aux_nodes:
        w_inches, h_inches = _estimate_node_size(node)
        G.add_node(
            node['id'],
            width=str(w_inches),
            height=str(h_inches),
            fixedsize='true',
            shape='box',
        )

    # Rank constraints only apply to dot engine
    if is_hierarchical:
        owners_seen = set()
        for node in aux_nodes:
            owner_id = node.get('owner')
            if owner_id and owner_id in node_map:
                key = (owner_id, node['id'])
                if key not in owners_seen:
                    owners_seen.add(key)
                    G.add_subgraph([owner_id, node['id']], rank='same')

        # Place variable nodes on same rank as their first target item
        var_first_target = {}
        for edge in edges:
            if edge.get('type') == 'variable_assignment':
                var_id = edge['source']
                if var_id not in var_first_target and var_id in node_map and edge['target'] in node_map:
                    var_first_target[var_id] = edge['target']
        for var_id, target_id in var_first_target.items():
            G.add_subgraph([var_id, target_id], rank='same')

    # Add edges (cycle edges are excluded — they get synthetic arc paths later)
    seen_edges = set()
    for edge in edges:
        key = (edge['source'], edge['target'])
        if key not in seen_edges and edge['source'] in node_map and edge['target'] in node_map:
            seen_edges.add(key)
            edge_type = edge.get('type', '')
            if edge_type == 'cycle':
                continue  # Skip — synthetic arc generated after layout
            attrs = {}
            if is_hierarchical and edge_type in ('dependency', 'containment', 'variable_assignment'):
                attrs['constraint'] = 'false'
            # For force-directed engines, weight topological edges higher
            # to keep the main flow chain tighter
            if not is_hierarchical and edge_type == 'topological':
                attrs['weight'] = '5'
            elif not is_hierarchical and edge_type in ('containment',):
                attrs['len'] = '1.5'
            G.add_edge(edge['source'], edge['target'], **attrs)

    # Compute layout
    G.layout(prog=engine)

    # Find Y bounds for flipping (Graphviz Y points up, SVG Y points down)
    max_y = 0.0
    for gv_node in G.nodes():
        pos = gv_node.attr.get('pos', '')
        if pos:
            parts = pos.split(',')
            if len(parts) == 2:
                y = float(parts[1]) * POINTS_TO_PX
                if y > max_y:
                    max_y = y

    # Extract node positions
    for gv_node in G.nodes():
        node_id = str(gv_node)
        if node_id not in node_map:
            continue

        pos = gv_node.attr.get('pos', '')
        if not pos:
            continue

        parts = pos.split(',')
        if len(parts) != 2:
            continue

        x = float(parts[0]) * POINTS_TO_PX
        y = max_y - float(parts[1]) * POINTS_TO_PX  # Flip Y
        w = float(gv_node.attr.get('width', '1')) * INCHES_TO_PX
        h = float(gv_node.attr.get('height', '0.5')) * INCHES_TO_PX

        node_map[node_id]['x'] = round(x, 1)
        node_map[node_id]['y'] = round(y, 1)
        node_map[node_id]['width'] = round(w, 1)
        node_map[node_id]['height'] = round(h, 1)

    # Build edge lookup from Graphviz for bend points
    gv_edge_map: dict[tuple[str, str], Any] = {}
    for gv_edge in G.edges():
        src, tgt = str(gv_edge[0]), str(gv_edge[1])
        gv_edge_map[(src, tgt)] = gv_edge

    # Extract edge bend points
    node_order = {n['id']: i for i, n in enumerate(nodes)}
    for edge in edges:
        gv_edge = gv_edge_map.get((edge['source'], edge['target']))
        if gv_edge:
            pos = gv_edge.attr.get('pos', '')
            parsed = _parse_edge_pos(pos, max_y)
            points = parsed['points']
            arrow_end = parsed.get('arrow_end')
            arrow_start = parsed.get('arrow_start')

            # Graphviz may reverse edge routing for edges that go against
            # the rank direction (e.g., upward in TB mode). Detect this by
            # checking if arrow_end is closer to the source than the target,
            # and reverse the path if so.
            tgt_node = node_map.get(edge['target'])
            src_node = node_map.get(edge['source'])
            if (arrow_end and tgt_node and src_node
                    and 'x' in tgt_node and 'x' in src_node):
                dx_tgt = (arrow_end['x'] - tgt_node['x']) ** 2 + (arrow_end['y'] - tgt_node['y']) ** 2
                dx_src = (arrow_end['x'] - src_node['x']) ** 2 + (arrow_end['y'] - src_node['y']) ** 2
                if dx_src < dx_tgt:
                    # Graphviz reversed the edge — flip everything
                    points = list(reversed(points))
                    arrow_end, arrow_start = arrow_start, arrow_end
                    # If no arrow_end after swap, synthesize from last bend point
                    if not arrow_end and points:
                        arrow_end = points[-1]

            edge['bend_points'] = points
            if arrow_end:
                edge['arrow_end'] = arrow_end
            if arrow_start:
                edge['arrow_start'] = arrow_start
        else:
            _assign_synthetic_edge_path(edge, node_map, node_order)

    # Compute SVG bounds with padding
    _compute_bounds(graph_data, nodes, engine)
    return graph_data


def _compute_bounds(graph_data: dict, nodes: list, engine: str):
    """Compute SVG bounds from positioned nodes."""
    padding = 40
    min_x = min((n.get('x', 0) - n.get('width', 0) / 2 for n in nodes if 'x' in n), default=0)
    min_y_val = min((n.get('y', 0) - n.get('height', 0) / 2 for n in nodes if 'y' in n), default=0)
    max_x = max((n.get('x', 0) + n.get('width', 0) / 2 for n in nodes if 'x' in n), default=100)
    max_y_val = max((n.get('y', 0) + n.get('height', 0) / 2 for n in nodes if 'y' in n), default=100)

    graph_data['layout'] = {
        'width': round(max_x - min_x + padding * 2, 1),
        'height': round(max_y_val - min_y_val + padding * 2, 1),
        'offset_x': round(-min_x + padding, 1),
        'offset_y': round(-min_y_val + padding, 1),
        'engine': engine,
    }


def _assign_synthetic_edge_path(edge: dict, node_map: dict, node_order: dict):
    """Assign bend points to an edge without Graphviz routing.

    Backward cycle edges (source after target in file order) get a curved arc.
    All other edges get straight lines between node centers.
    """
    src_node = node_map.get(edge['source'])
    tgt_node = node_map.get(edge['target'])
    if not (src_node and tgt_node and 'x' in src_node and 'x' in tgt_node):
        edge['bend_points'] = []
        return

    is_backward_cycle = (
        edge.get('type') == 'cycle'
        and node_order.get(edge['source'], 0) > node_order.get(edge['target'], 0)
    )
    if is_backward_cycle:
        arc = _generate_cycle_arc(src_node, tgt_node)
        edge['bend_points'] = arc['points']
        edge['arrow_end'] = arc['arrow_end']
    else:
        edge['bend_points'] = [
            {'x': round(src_node['x'], 1), 'y': round(src_node['y'], 1)},
            {'x': round(tgt_node['x'], 1), 'y': round(tgt_node['y'], 1)},
        ]


def _estimate_node_size(node: dict) -> tuple[float, float]:
    """Estimate node size in inches for Graphviz.

    Returns:
        (width_inches, height_inches)
    """
    label = node.get('label', node['id'])
    node_type = node.get('type', 'item')

    # Character width approximation (inches)
    char_width = 0.08
    padding = 0.4
    max_width = 4.0

    if node_type == 'item':
        width = min(max(len(label) * char_width + padding, 1.8), max_width)
        height = 0.6
    else:  # precondition, postcondition, variable
        width = min(max(len(label) * char_width + padding, 1.2), 3.0)
        height = 0.4

    return width, height


def _generate_cycle_arc(src_node: dict, tgt_node: dict) -> dict:
    """Generate a synthetic cubic Bezier arc for a cycle back-edge.

    Creates control points that curve to the left of the nodes,
    giving cycle edges a distinctive looping appearance that doesn't
    overlap with the forward flow chain in the center.

    Args:
        src_node: Source node dict with x, y, width, height
        tgt_node: Target node dict with x, y, width, height

    Returns:
        Dict with 'points' (4 points for cubic Bezier) and 'arrow_end'.
    """
    sx, sy = src_node['x'], src_node['y']
    tx, ty = tgt_node['x'], tgt_node['y']
    src_w = src_node.get('width', 100)
    tgt_w = tgt_node.get('width', 100)

    # Start/end at the left edge of each node
    start_x = round(sx - src_w / 2, 1)
    start_y = round(sy, 1)
    end_x = round(tx - tgt_w / 2, 1)
    end_y = round(ty, 1)

    # Control points offset to the left, proportional to the vertical span
    span = abs(sy - ty)
    offset_x = max(80, span * 0.4)

    cp1_x = round(start_x - offset_x, 1)
    cp1_y = round(start_y, 1)
    cp2_x = round(end_x - offset_x, 1)
    cp2_y = round(end_y, 1)

    return {
        'points': [
            {'x': start_x, 'y': start_y},
            {'x': cp1_x, 'y': cp1_y},
            {'x': cp2_x, 'y': cp2_y},
            {'x': end_x, 'y': end_y},
        ],
        'arrow_end': {'x': end_x, 'y': end_y},
    }


def _parse_edge_pos(pos_str: str, max_y: float) -> dict:
    """Parse Graphviz edge pos attribute into B-spline path data.

    Graphviz pos format: "e,ex,ey x1,y1 x2,y2 x3,y3 ..."
    - e,x,y = arrowhead endpoint (where the arrow tip points)
    - s,x,y = arrow tail endpoint (where the arrow starts)
    - remaining points = B-spline control points (groups of 3 for cubic Bezier)

    The B-spline path is: M p0 C p1,p2,p3 C p4,p5,p6 ...
    For ortho splines, the control points are collinear so curves
    degenerate to straight orthogonal segments.

    Args:
        pos_str: Graphviz edge position string
        max_y: Maximum Y for coordinate flipping

    Returns:
        Dict with 'points' (B-spline path points) and optional
        'arrow_end'/'arrow_start' endpoint positions.
    """
    if not pos_str:
        return {'points': []}

    arrow_end = None
    arrow_start = None
    path_points = []
    parts = pos_str.strip().split(' ')

    for part in parts:
        part = part.strip()
        if not part:
            continue

        if part.startswith('e,'):
            coords = part[2:].split(',')
            if len(coords) == 2:
                try:
                    x = float(coords[0]) * POINTS_TO_PX
                    y = max_y - float(coords[1]) * POINTS_TO_PX
                    arrow_end = {'x': round(x, 1), 'y': round(y, 1)}
                except ValueError:
                    continue
        elif part.startswith('s,'):
            coords = part[2:].split(',')
            if len(coords) == 2:
                try:
                    x = float(coords[0]) * POINTS_TO_PX
                    y = max_y - float(coords[1]) * POINTS_TO_PX
                    arrow_start = {'x': round(x, 1), 'y': round(y, 1)}
                except ValueError:
                    continue
        else:
            coords = part.split(',')
            if len(coords) == 2:
                try:
                    x = float(coords[0]) * POINTS_TO_PX
                    y = max_y - float(coords[1]) * POINTS_TO_PX
                    path_points.append({'x': round(x, 1), 'y': round(y, 1)})
                except ValueError:
                    continue

    result: dict = {'points': path_points}
    if arrow_end:
        result['arrow_end'] = arrow_end
    if arrow_start:
        result['arrow_start'] = arrow_start
    return result
