#!/usr/bin/env python3
"""Assumption and boundary audit for the uniform cycle-collapse theorem.

This audit is deliberately narrower than the main adversarial search. It:
  * validates the checked exhaustive linear-cycle result;
  * removes source linearity and finds the lexicographically first collapse
    failure, then verifies that the proof's boundary pair shares the full base;
  * exhaustively classifies every noncollapsed Berge triangle in the smallest
    K3 depth-two test used here; and
  * exhibits the sharp s = 1 counterexample, where the source remains linear.

No third-party packages are required.
"""

from __future__ import annotations

import argparse
import dataclasses
import itertools
import json
import sys
from pathlib import Path
from typing import FrozenSet, Sequence, Tuple

Edge = FrozenSet[int]


@dataclasses.dataclass(frozen=True)
class Hypergraph:
    uniformity: int
    vertex_count: int
    edges: Tuple[Edge, ...]
    name: str


@dataclasses.dataclass(frozen=True)
class Lift:
    host: Hypergraph
    base: Hypergraph
    coordinate_count: int
    node_sequences: Tuple[Tuple[int, ...], ...]
    base_edge_of: Tuple[int, ...]
    base_node_of: Tuple[int, ...]
    apex_node_of: Tuple[int, ...]
    apex_vertex_of: Tuple[int, ...]


def graph(vertex_count: int, pairs: Sequence[Tuple[int, int]], name: str) -> Hypergraph:
    return Hypergraph(
        uniformity=2,
        vertex_count=vertex_count,
        edges=tuple(frozenset(pair) for pair in pairs),
        name=name,
    )


def is_proper_prefix(left: Tuple[int, ...], right: Tuple[int, ...]) -> bool:
    return len(left) < len(right) and right[: len(left)] == left


def complete_rank_lift(base: Hypergraph, depth: int, name: str) -> Lift:
    alphabet = range(len(base.edges))
    sequences: list[Tuple[int, ...]] = [()]
    for length in range(1, depth + 1):
        sequences.extend(itertools.product(alphabet, repeat=length))
    node_index = {sequence: index for index, sequence in enumerate(sequences)}

    n = base.vertex_count
    edges: list[Edge] = []
    base_edge_of: list[int] = []
    base_node_of: list[int] = []
    apex_node_of: list[int] = []
    apex_vertex_of: list[int] = []

    for sigma in sequences:
        for tau in sequences:
            if not is_proper_prefix(sigma, tau):
                continue
            base_edge = tau[len(sigma)]
            sigma_index = node_index[sigma]
            tau_index = node_index[tau]
            base_vertices = {
                sigma_index * n + coordinate for coordinate in base.edges[base_edge]
            }
            for apex_coordinate in range(n):
                apex = tau_index * n + apex_coordinate
                edges.append(frozenset(base_vertices | {apex}))
                base_edge_of.append(base_edge)
                base_node_of.append(sigma_index)
                apex_node_of.append(tau_index)
                apex_vertex_of.append(apex)

    return Lift(
        host=Hypergraph(
            uniformity=base.uniformity + 1,
            vertex_count=len(sequences) * n,
            edges=tuple(edges),
            name=name,
        ),
        base=base,
        coordinate_count=n,
        node_sequences=tuple(sequences),
        base_edge_of=tuple(base_edge_of),
        base_node_of=tuple(base_node_of),
        apex_node_of=tuple(apex_node_of),
        apex_vertex_of=tuple(apex_vertex_of),
    )


def decode_vertex(lift: Lift, vertex: int) -> dict:
    node_index, coordinate = divmod(vertex, lift.coordinate_count)
    return {
        "encoded": vertex,
        "node_index": node_index,
        "node": list(lift.node_sequences[node_index]),
        "coordinate": coordinate,
    }


def describe_edge(lift: Lift, edge_index: int) -> dict:
    return {
        "edge_index": edge_index,
        "base_node": list(lift.node_sequences[lift.base_node_of[edge_index]]),
        "apex_node": list(lift.node_sequences[lift.apex_node_of[edge_index]]),
        "base_edge_index": lift.base_edge_of[edge_index],
        "base_edge_coordinates": sorted(lift.base.edges[lift.base_edge_of[edge_index]]),
        "apex": decode_vertex(lift, lift.apex_vertex_of[edge_index]),
        "vertices": [
            decode_vertex(lift, vertex)
            for vertex in sorted(lift.host.edges[edge_index])
        ],
    }


def relaxed_noncollapsed_triangles(lift: Lift) -> list[dict]:
    """Enumerate Berge triangles without imposing pairwise source linearity.

    The connector order is v0 in e2∩e0, v1 in e0∩e1, v2 in e1∩e2.
    """
    records: list[dict] = []
    host_edges = lift.host.edges
    n = lift.coordinate_count

    for e0, e1, e2 in itertools.combinations(range(len(host_edges)), 3):
        intersections = (
            host_edges[e2].intersection(host_edges[e0]),
            host_edges[e0].intersection(host_edges[e1]),
            host_edges[e1].intersection(host_edges[e2]),
        )
        if any(not intersection for intersection in intersections):
            continue

        for v0 in sorted(intersections[0]):
            for v1 in sorted(intersections[1]):
                for v2 in sorted(intersections[2]):
                    connectors = (v0, v1, v2)
                    if len(set(connectors)) != 3:
                        continue
                    node_indices = tuple(vertex // n for vertex in connectors)
                    if len(set(node_indices)) == 1:
                        continue

                    node_lengths = tuple(
                        len(lift.node_sequences[node]) for node in node_indices
                    )
                    minimum = min(node_lengths)
                    minimum_positions = tuple(
                        index
                        for index, length in enumerate(node_lengths)
                        if length == minimum
                    )

                    edge_cycle = (e0, e1, e2)
                    boundary_intersection_size = None
                    boundary_edges = None
                    if len(minimum_positions) == 1:
                        position = minimum_positions[0]
                        left = edge_cycle[(position - 1) % 3]
                        right = edge_cycle[position]
                        boundary_edges = (left, right)
                        boundary_intersection_size = len(
                            host_edges[left].intersection(host_edges[right])
                        )

                    pair_intersection_sizes = (
                        len(host_edges[e0].intersection(host_edges[e1])),
                        len(host_edges[e1].intersection(host_edges[e2])),
                        len(host_edges[e2].intersection(host_edges[e0])),
                    )

                    records.append(
                        {
                            "edge_cycle": list(edge_cycle),
                            "connectors": [
                                decode_vertex(lift, vertex) for vertex in connectors
                            ],
                            "connector_node_lengths": list(node_lengths),
                            "minimum_positions": list(minimum_positions),
                            "boundary_edges": (
                                list(boundary_edges) if boundary_edges is not None else None
                            ),
                            "boundary_intersection_size": boundary_intersection_size,
                            "pair_intersection_sizes": list(pair_intersection_sizes),
                            "pairwise_linear": max(pair_intersection_sizes) <= 1,
                        }
                    )
    return records


def uniformity_one_counterexample() -> dict:
    base = Hypergraph(
        uniformity=1,
        vertex_count=1,
        edges=(frozenset({0}),),
        name="single one-uniform edge",
    )
    lift = complete_rank_lift(base, 2, "FullLift_2(singleton)")
    if len(lift.host.edges) != 3:
        raise AssertionError("unexpected one-uniform test lift")
    selected = (0, 1, 2)
    edge_sets = [lift.host.edges[index] for index in selected]
    pair_intersections = [
        edge_sets[2].intersection(edge_sets[0]),
        edge_sets[0].intersection(edge_sets[1]),
        edge_sets[1].intersection(edge_sets[2]),
    ]
    connectors = tuple(next(iter(intersection)) for intersection in pair_intersections)
    if len(set(connectors)) != 3:
        raise AssertionError("the one-uniform example is not a Berge triangle")
    if any(
        len(left.intersection(right)) > 1
        for left, right in itertools.combinations(edge_sets, 2)
    ):
        raise AssertionError("the one-uniform source triangle is not linear")
    connector_nodes = [
        list(lift.node_sequences[vertex // lift.coordinate_count])
        for vertex in connectors
    ]
    if len({tuple(node) for node in connector_nodes}) == 1:
        raise AssertionError("the one-uniform counterexample unexpectedly collapses")

    return {
        "base_uniformity": 1,
        "lift_uniformity": 2,
        "source_is_pairwise_linear": True,
        "edge_cycle": [describe_edge(lift, index) for index in selected],
        "connectors": [decode_vertex(lift, vertex) for vertex in connectors],
        "connector_nodes": connector_nodes,
        "conclusion": (
            "The three complete-rank lift edges form a linear graph triangle whose "
            "three connector nodes are distinct. Thus s >= 2 is essential."
        ),
    }


def comparable(data: dict) -> dict:
    result = dict(data)
    result.pop("generated_from", None)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--baseline",
        type=Path,
        default=Path("experiments/cycle_collapse_results.json"),
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    baseline = json.loads(args.baseline.read_text(encoding="utf-8"))
    totals = baseline.get("totals", {})
    if baseline.get("status") != "passed":
        raise AssertionError("the baseline cycle-collapse search is not marked passed")
    if totals.get("failures") != 0:
        raise AssertionError("the baseline search contains failures")
    if totals.get("cycles") != totals.get("collapsed_and_projected"):
        raise AssertionError("the baseline search did not certify every linear cycle")

    k3 = graph(3, [(0, 1), (1, 2), (0, 2)], "K3")
    lift = complete_rank_lift(k3, 2, "FullLift_2(K3)")
    relaxed = relaxed_noncollapsed_triangles(lift)
    if not relaxed:
        raise AssertionError("no relaxed noncollapse counterexample was found")

    unique_minimum = sum(
        len(record["minimum_positions"]) == 1 for record in relaxed
    )
    boundary_full_base = sum(
        record["boundary_intersection_size"] == k3.uniformity
        for record in relaxed
    )
    pairwise_linear = sum(record["pairwise_linear"] for record in relaxed)

    if unique_minimum != len(relaxed):
        raise AssertionError("not every relaxed failure has one minimum occurrence")
    if boundary_full_base != len(relaxed):
        raise AssertionError("the proof's repeated-boundary-base certificate failed")
    if pairwise_linear != 0:
        raise AssertionError("a pairwise-linear noncollapse cycle was found")

    first = relaxed[0]
    first_edges = [
        describe_edge(lift, edge_index) for edge_index in first["edge_cycle"]
    ]

    output = {
        "status": "passed",
        "baseline_linear_cycle_search": {
            "cycles": totals["cycles"],
            "collapsed_and_projected": totals["collapsed_and_projected"],
            "cycles_using_nonimmediate_prefix_jump": totals[
                "cycles_using_nonimmediate_prefix_jump"
            ],
            "failures": totals["failures"],
        },
        "drop_linearity_audit": {
            "host": lift.host.name,
            "noncollapsed_berge_triangles": len(relaxed),
            "with_unique_minimum_occurrence": unique_minimum,
            "whose_two_boundary_edges_share_the_full_base": boundary_full_base,
            "pairwise_linear_failures": pairwise_linear,
            "first_counterexample": {
                **first,
                "edges": first_edges,
                "conclusion": (
                    "The two boundary edges share the complete two-point base. "
                    "This is exactly the contradiction excluded by source linearity."
                ),
            },
        },
        "drop_s_ge_two_audit": uniformity_one_counterexample(),
        "minimal_hypothesis_findings": {
            "global_source_finiteness": (
                "not used by cycle collapse; only the displayed Berge cycle is finite"
            ),
            "global_source_linearity": (
                "can be weakened to pairwise linearity of the edges on the displayed cycle"
            ),
            "base_simplicity": (
                "used to make the extensional lift simple and to recover edge indices, "
                "but not in the minimum-node contradiction itself"
            ),
            "infinite_kappa": (
                "not used by cycle collapse; it is used by chromatic preservation"
            ),
            "complete_rank": (
                "not used by the local collapse argument once every target edge has "
                "the full-base-plus-one-apex form"
            ),
            "s_ge_two": "essential, as certified by the explicit linear s=1 triangle",
            "vertex_injectivity_and_exact_edge_mapping": (
                "essential to pull the common target base back to the same source vertices"
            ),
            "distinct_cycle_edge_indices": (
                "essential in the unique-minimum case to distinguish the two boundary edges"
            ),
        },
        "generated_from": {
            "baseline": str(args.baseline),
            "audit_host": "FullLift_2(K3)",
        },
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if comparable(output) != comparable(expected):
            sys.stderr.write(f"generated audit differs from {args.check}\n")
            return 1

    text = json.dumps(output, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        sys.stdout.write(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
