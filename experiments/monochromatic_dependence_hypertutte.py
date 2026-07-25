#!/usr/bin/env python3
"""Verify monochromatic dependence, hypergraph Tutte collapse, and Ising identities.

This standard-library program constructs deterministic members of the generated
class B_r for r=3,4,5. It checks, for every edge subset:

* the intrinsic Berge-cycle matroid rank;
* the modular-plus-graphic associated-polymatroid identity;
* the termwise specialization of the 2026 hypergraph Tutte polynomial;
* the many-body Potts / graph random-cluster reduction;
* the exact monochromatic-event dependence factor.

For cases below a configurable state-space threshold, it directly enumerates
all q-colorings for q=2,3 and verifies the full monochromatic-edge count
distribution, factorial moments, forest and unicyclic closed forms, and the
bipartite Ising gauge identity.

No third-party packages are required.
"""

from __future__ import annotations

import argparse
import collections
import dataclasses
import itertools
import json
import math
import sys
import time
from fractions import Fraction
from pathlib import Path
from typing import Dict, FrozenSet, Iterable, List, Sequence, Set, Tuple


Vertex = str
Edge = FrozenSet[Vertex]
ShadowEdge = Tuple[Vertex, Vertex]


@dataclasses.dataclass
class Case:
    name: str
    uniformity: int
    vertices: Set[Vertex]
    edges: List[Edge]
    shadow_vertices: Set[Vertex]
    shadow_edges: List[ShadowEdge]


def graph_piece(
    name: str,
    graph_vertices: Sequence[int],
    graph_edges: Sequence[Tuple[int, int]],
    uniformity: int,
) -> Case:
    shadow_map = {v: f"{name}:s:{v}" for v in graph_vertices}
    hyper_map = {v: f"{name}:h:core:{v}" for v in graph_vertices}

    shadow_vertices = set(shadow_map.values())
    vertices = set(hyper_map.values())
    shadow_edges: List[ShadowEdge] = []
    edges: List[Edge] = []

    for index, (left, right) in enumerate(graph_edges):
        shadow_edges.append((shadow_map[left], shadow_map[right]))
        hyperedge = {hyper_map[left], hyper_map[right]}
        for private_index in range(uniformity - 2):
            private = f"{name}:h:priv:{index}:{private_index}"
            vertices.add(private)
            hyperedge.add(private)
        edges.append(frozenset(hyperedge))

    return Case(
        name=name,
        uniformity=uniformity,
        vertices=vertices,
        edges=edges,
        shadow_vertices=shadow_vertices,
        shadow_edges=shadow_edges,
    )


def renamed(
    case: Case,
    hyper_old: Vertex,
    hyper_new: Vertex,
    shadow_old: Vertex,
    shadow_new: Vertex,
) -> Case:
    return Case(
        name=case.name,
        uniformity=case.uniformity,
        vertices={hyper_new if vertex == hyper_old else vertex for vertex in case.vertices},
        edges=[
            frozenset(hyper_new if vertex == hyper_old else vertex for vertex in edge)
            for edge in case.edges
        ],
        shadow_vertices={
            shadow_new if vertex == shadow_old else vertex
            for vertex in case.shadow_vertices
        },
        shadow_edges=[
            (
                shadow_new if left == shadow_old else left,
                shadow_new if right == shadow_old else right,
            )
            for left, right in case.shadow_edges
        ],
    )


def amalgamate(
    left: Case,
    right: Case,
    left_hyper_vertex: Vertex,
    right_hyper_vertex: Vertex,
    left_shadow_vertex: Vertex,
    right_shadow_vertex: Vertex,
    name: str,
) -> Case:
    if left.uniformity != right.uniformity:
        raise ValueError("uniformities do not match")
    right_renamed = renamed(
        right,
        right_hyper_vertex,
        left_hyper_vertex,
        right_shadow_vertex,
        left_shadow_vertex,
    )
    return Case(
        name=name,
        uniformity=left.uniformity,
        vertices=left.vertices | right_renamed.vertices,
        edges=left.edges + right_renamed.edges,
        shadow_vertices=left.shadow_vertices | right_renamed.shadow_vertices,
        shadow_edges=left.shadow_edges + right_renamed.shadow_edges,
    )


def disjoint_union(left: Case, right: Case, name: str) -> Case:
    if left.uniformity != right.uniformity:
        raise ValueError("uniformities do not match")
    return Case(
        name=name,
        uniformity=left.uniformity,
        vertices=left.vertices | right.vertices,
        edges=left.edges + right.edges,
        shadow_vertices=left.shadow_vertices | right.shadow_vertices,
        shadow_edges=left.shadow_edges + right.shadow_edges,
    )


def build_cases() -> List[Case]:
    cases: List[Case] = []
    for uniformity in (3, 4, 5):
        prefix = f"r{uniformity}"
        k2 = graph_piece(f"{prefix}_K2", [0, 1], [(0, 1)], uniformity)
        p3 = graph_piece(
            f"{prefix}_P3", [0, 1, 2], [(0, 1), (1, 2)], uniformity
        )
        c4 = graph_piece(
            f"{prefix}_C4",
            [0, 1, 2, 3],
            [(0, 1), (1, 2), (2, 3), (3, 0)],
            uniformity,
        )
        k23 = graph_piece(
            f"{prefix}_K23",
            [0, 1, 2, 3, 4],
            [(0, 2), (0, 3), (0, 4), (1, 2), (1, 3), (1, 4)],
            uniformity,
        )
        cases.extend((k2, p3, c4, k23))

        edge_core = graph_piece(
            f"{prefix}_edge_core", [0, 1], [(0, 1)], uniformity
        )
        cases.append(
            amalgamate(
                c4,
                edge_core,
                f"{prefix}_C4:h:core:0",
                f"{prefix}_edge_core:h:core:0",
                f"{prefix}_C4:s:0",
                f"{prefix}_edge_core:s:0",
                f"{prefix}_C4_core_leaf",
            )
        )

        edge_private = graph_piece(
            f"{prefix}_edge_private", [0, 1], [(0, 1)], uniformity
        )
        cases.append(
            amalgamate(
                c4,
                edge_private,
                f"{prefix}_C4:h:priv:0:0",
                f"{prefix}_edge_private:h:core:0",
                f"{prefix}_C4:s:0",
                f"{prefix}_edge_private:s:0",
                f"{prefix}_C4_private_leaf",
            )
        )

        c4_second = graph_piece(
            f"{prefix}_C4_second",
            [0, 1, 2, 3],
            [(0, 1), (1, 2), (2, 3), (3, 0)],
            uniformity,
        )
        cases.append(
            amalgamate(
                c4,
                c4_second,
                f"{prefix}_C4:h:priv:1:0",
                f"{prefix}_C4_second:h:core:2",
                f"{prefix}_C4:s:1",
                f"{prefix}_C4_second:s:2",
                f"{prefix}_two_C4",
            )
        )

        cases.append(disjoint_union(c4, p3, f"{prefix}_C4_disjoint_P3"))
    return cases


def all_subsets(size: int) -> Iterable[Tuple[int, ...]]:
    for mask in range(1 << size):
        yield tuple(index for index in range(size) if (mask >> index) & 1)


def graph_component_count(
    vertices: Set[Vertex], edges: Sequence[ShadowEdge]
) -> int:
    adjacency: Dict[Vertex, Set[Vertex]] = {vertex: set() for vertex in vertices}
    for left, right in edges:
        adjacency[left].add(right)
        adjacency[right].add(left)

    unseen = set(vertices)
    components = 0
    while unseen:
        components += 1
        root = unseen.pop()
        stack = [root]
        while stack:
            vertex = stack.pop()
            for neighbour in adjacency[vertex]:
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    stack.append(neighbour)
    return components


def shadow_kappa(case: Case, subset: Sequence[int]) -> int:
    return graph_component_count(
        case.shadow_vertices, [case.shadow_edges[index] for index in subset]
    )


def shadow_rank(case: Case, subset: Sequence[int]) -> int:
    return len(case.shadow_vertices) - shadow_kappa(case, subset)


def supported_components(
    case: Case, subset: Sequence[int]
) -> Tuple[int, Set[Vertex]]:
    if not subset:
        return 0, set()

    supported_vertices = set().union(*(case.edges[index] for index in subset))
    adjacency: Dict[Tuple[str, object], Set[Tuple[str, object]]] = (
        collections.defaultdict(set)
    )
    for edge_index in subset:
        edge_node = ("e", edge_index)
        for vertex in case.edges[edge_index]:
            point_node = ("v", vertex)
            adjacency[edge_node].add(point_node)
            adjacency[point_node].add(edge_node)

    unseen = set(adjacency)
    components = 0
    while unseen:
        components += 1
        root = unseen.pop()
        stack = [root]
        while stack:
            node = stack.pop()
            for neighbour in adjacency[node]:
                if neighbour in unseen:
                    unseen.remove(neighbour)
                    stack.append(neighbour)
    return components, supported_vertices


def hypergraph_kappa_spanning(case: Case, subset: Sequence[int]) -> int:
    supported_count, supported_vertices = supported_components(case, subset)
    return supported_count + len(case.vertices) - len(supported_vertices)


def intrinsic_berge_rank(case: Case, subset: Sequence[int]) -> int:
    supported_count, supported_vertices = supported_components(case, subset)
    return (
        len(supported_vertices)
        - supported_count
        - (case.uniformity - 2) * len(subset)
    )


def nullity(case: Case, subset: Sequence[int]) -> int:
    return len(subset) - shadow_rank(case, subset)


def girth_and_shortest_circuit_count(case: Case) -> Tuple[int | None, int]:
    edge_count = len(case.edges)
    for size in range(1, edge_count + 1):
        dependent = sum(
            nullity(case, subset) > 0
            for subset in itertools.combinations(range(edge_count), size)
        )
        if dependent:
            return size, dependent
    return None, 0


def polynomial_coefficients_from_subset_expansion(
    case: Case, colors: int
) -> List[int]:
    """Return coefficients of Phi_F(q,t) in increasing powers of t."""
    edge_count = len(case.edges)
    coefficients = [0] * (edge_count + 1)
    for subset in all_subsets(edge_count):
        size = len(subset)
        weight = colors ** hypergraph_kappa_spanning(case, subset)
        for degree in range(size + 1):
            coefficients[degree] += (
                weight
                * math.comb(size, degree)
                * ((-1) ** (size - degree))
            )
    return coefficients


def polynomial_coefficients_from_shadow(
    case: Case, colors: int
) -> List[Fraction]:
    edge_count = len(case.edges)
    coefficients = [Fraction(0) for _ in range(edge_count + 1)]
    prefactor = colors ** ((case.uniformity - 2) * edge_count)

    for subset in all_subsets(edge_count):
        size = len(subset)
        weight = Fraction(
            prefactor * colors ** shadow_kappa(case, subset),
            colors ** ((case.uniformity - 2) * size),
        )
        for degree in range(size + 1):
            coefficients[degree] += (
                weight
                * math.comb(size, degree)
                * ((-1) ** (size - degree))
            )
    return coefficients


def direct_monochromatic_distribution(
    case: Case, colors: int, state_limit: int
) -> List[int] | None:
    state_count = colors ** len(case.vertices)
    if state_count > state_limit:
        return None

    vertices = sorted(case.vertices)
    position = {vertex: index for index, vertex in enumerate(vertices)}
    distribution = [0] * (len(case.edges) + 1)

    for coloring in itertools.product(range(colors), repeat=len(vertices)):
        monochromatic = 0
        for edge in case.edges:
            if len({coloring[position[vertex]] for vertex in edge}) == 1:
                monochromatic += 1
        distribution[monochromatic] += 1
    return distribution


def falling_factorial(value: int, order: int) -> int:
    result = 1
    for offset in range(order):
        result *= value - offset
    return result


def factorial_moment(distribution: Sequence[int], order: int) -> Fraction:
    total = sum(distribution)
    numerator = sum(
        count * falling_factorial(value, order)
        for value, count in enumerate(distribution)
    )
    return Fraction(numerator, total)


def random_cluster(case: Case, colors: int, edge_weight: Fraction) -> Fraction:
    total = Fraction(0)
    for subset in all_subsets(len(case.shadow_edges)):
        total += (
            colors ** shadow_kappa(case, subset)
            * edge_weight ** len(subset)
        )
    return total


def evaluate_polynomial(coefficients: Sequence[int], value: int) -> int:
    return sum(
        coefficient * value**degree
        for degree, coefficient in enumerate(coefficients)
    )


def expected_forest_coefficients(case: Case, colors: int) -> List[int]:
    """Coefficients of q^c (q^(r-1)+t-1)^m."""
    edge_count = len(case.edges)
    components = shadow_kappa(case, tuple(range(edge_count)))
    constant = colors ** (case.uniformity - 1) - 1
    return [
        colors**components
        * math.comb(edge_count, degree)
        * constant ** (edge_count - degree)
        for degree in range(edge_count + 1)
    ]


def expected_unicyclic_coefficients(
    case: Case, colors: int, cycle_length: int
) -> List[int]:
    """Expand Y^(m-l)(Y^l+(q-1)(t-1)^l), Y=q^(r-1)+t-1."""
    edge_count = len(case.edges)
    constant = colors ** (case.uniformity - 1) - 1

    def multiply(left: List[int], right: List[int]) -> List[int]:
        result = [0] * (len(left) + len(right) - 1)
        for i, left_value in enumerate(left):
            for j, right_value in enumerate(right):
                result[i + j] += left_value * right_value
        return result

    def power_linear(power: int) -> List[int]:
        return [
            math.comb(power, degree) * constant ** (power - degree)
            for degree in range(power + 1)
        ]

    outer = power_linear(edge_count - cycle_length)
    cycle = power_linear(cycle_length)
    correction = [
        (colors - 1)
        * math.comb(cycle_length, degree)
        * ((-1) ** (cycle_length - degree))
        for degree in range(cycle_length + 1)
    ]
    inner = [
        left + right
        for left, right in itertools.zip_longest(cycle, correction, fillvalue=0)
    ]
    return multiply(outer, inner)


def fraction_string(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"{value.numerator}/{value.denominator}"


def verify_case(case: Case, state_limit: int) -> Tuple[dict, collections.Counter]:
    edge_count = len(case.edges)
    all_edges = tuple(range(edge_count))
    rho = shadow_rank(case, all_edges)
    beta = edge_count - rho
    components = shadow_kappa(case, all_edges)
    girth, shortest_circuits = girth_and_shortest_circuit_count(case)

    counters: collections.Counter[str] = collections.Counter()
    for subset in all_subsets(edge_count):
        counters["edge_subsets"] += 1

        shadow_value = shadow_rank(case, subset)
        intrinsic_value = intrinsic_berge_rank(case, subset)
        if intrinsic_value != shadow_value:
            raise AssertionError(
                f"{case.name}: rank mismatch on {subset}: "
                f"{intrinsic_value} != {shadow_value}"
            )
        counters["rank_checks"] += 1

        kappa_f = hypergraph_kappa_spanning(case, subset)
        polymatroid_rank = len(case.vertices) - kappa_f
        expected_polymatroid_rank = (
            (case.uniformity - 2) * len(subset) + shadow_value
        )
        if polymatroid_rank != expected_polymatroid_rank:
            raise AssertionError(
                f"{case.name}: polymatroid mismatch on {subset}"
            )
        counters["polymatroid_checks"] += 1

        direct_x_exponent = kappa_f - components
        direct_y_exponent = (
            case.uniformity * len(subset)
            - len(subset)
            - len(case.vertices)
            + kappa_f
        )
        subset_nullity = len(subset) - shadow_value
        transformed_x_exponent = (
            (case.uniformity - 2) * beta
            + (case.uniformity - 1) * (rho - shadow_value)
            - (case.uniformity - 2) * subset_nullity
        )
        if (
            direct_x_exponent,
            direct_y_exponent,
        ) != (
            transformed_x_exponent,
            subset_nullity,
        ):
            raise AssertionError(
                f"{case.name}: hypergraph Tutte term mismatch on {subset}"
            )
        counters["hypertutte_term_checks"] += 1

    direct_enumerations = 0
    moment_checks = 0
    for colors in (2, 3):
        subset_coefficients = polynomial_coefficients_from_subset_expansion(
            case, colors
        )
        shadow_coefficients = polynomial_coefficients_from_shadow(case, colors)
        if any(
            Fraction(left) != right
            for left, right in zip(subset_coefficients, shadow_coefficients)
        ):
            raise AssertionError(
                f"{case.name}: many-body Potts reduction failed for q={colors}"
            )
        counters["potts_polynomial_checks"] += 1

        distribution = direct_monochromatic_distribution(
            case, colors, state_limit
        )
        if distribution is not None:
            direct_enumerations += 1
            counters["direct_coloring_distributions"] += 1
            counters["direct_colorings"] += sum(distribution)
            if distribution != subset_coefficients:
                raise AssertionError(
                    f"{case.name}: direct coloring distribution mismatch for q={colors}"
                )

            probability = Fraction(1, colors ** (case.uniformity - 1))
            maximum_binomial_order = edge_count if girth is None else girth - 1
            for order in range(maximum_binomial_order + 1):
                observed = factorial_moment(distribution, order)
                expected = (
                    falling_factorial(edge_count, order)
                    * probability**order
                )
                if observed != expected:
                    raise AssertionError(
                        f"{case.name}: factorial moment {order} mismatch"
                    )
                moment_checks += 1

            if girth is not None:
                observed = factorial_moment(distribution, girth)
                expected = (
                    falling_factorial(edge_count, girth)
                    * probability**girth
                    + math.factorial(girth)
                    * shortest_circuits
                    * (colors - 1)
                    * probability**girth
                )
                if observed != expected:
                    raise AssertionError(
                        f"{case.name}: first circuit factorial moment mismatch"
                    )
                moment_checks += 1

        for subset in all_subsets(edge_count):
            kappa_f = hypergraph_kappa_spanning(case, subset)
            joint_probability = Fraction(
                colors**kappa_f, colors ** len(case.vertices)
            )
            product_probability = Fraction(
                1, colors ** ((case.uniformity - 1) * len(subset))
            )
            expected_joint = (
                product_probability * colors ** nullity(case, subset)
            )
            if joint_probability != expected_joint:
                raise AssertionError(
                    f"{case.name}: dependence factor failed for q={colors}, A={subset}"
                )
            counters["dependence_checks"] += 1

    if case.uniformity >= 3:
        a = Fraction(1, 2 ** (case.uniformity - 2))
        antiferromagnetic = random_cluster(case, 2, -a)
        ferromagnetic = (
            (1 - a) ** edge_count
            * random_cluster(case, 2, a / (1 - a))
        )
        if antiferromagnetic != ferromagnetic:
            raise AssertionError(f"{case.name}: Ising gauge identity failed")
        counters["ising_gauge_checks"] += 1

    coefficients_q3 = polynomial_coefficients_from_subset_expansion(case, 3)
    if beta == 0:
        if coefficients_q3 != expected_forest_coefficients(case, 3):
            raise AssertionError(f"{case.name}: forest law failed")
        counters["forest_law_checks"] += 1

    if beta == 1 and components == 1 and girth is not None:
        if coefficients_q3 != expected_unicyclic_coefficients(case, 3, girth):
            raise AssertionError(f"{case.name}: unicyclic law failed")
        counters["unicyclic_law_checks"] += 1

    weak_q2 = evaluate_polynomial(
        polynomial_coefficients_from_subset_expansion(case, 2), 0
    )
    positive_ising_parameter = Fraction(
        1, 2 ** (case.uniformity - 2) - 1
    )
    ferromagnetic_partition = random_cluster(
        case, 2, positive_ising_parameter
    )
    reconstructed_q2 = (
        (2 ** (case.uniformity - 2) - 1) ** edge_count
        * ferromagnetic_partition
    )
    if Fraction(weak_q2) != reconstructed_q2:
        raise AssertionError(f"{case.name}: Property-B Ising formula failed")

    return (
        {
            "name": case.name,
            "uniformity": case.uniformity,
            "vertices": len(case.vertices),
            "edges": edge_count,
            "components": components,
            "berge_rank": rho,
            "berge_nullity": beta,
            "berge_girth": girth,
            "shortest_berge_circuits": shortest_circuits,
            "direct_distributions_checked": direct_enumerations,
            "factorial_moment_checks": moment_checks,
            "weak_2_colorings": weak_q2,
            "ferromagnetic_ising_parameter": fraction_string(
                positive_ising_parameter
            ),
        },
        counters,
    )


def comparable(data: dict) -> dict:
    result = dict(data)
    result.pop("elapsed_seconds", None)
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--state-limit",
        type=int,
        default=2_000_000,
        help="maximum q^n for direct coloring enumeration",
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    started = time.time()
    records = []
    totals: collections.Counter[str] = collections.Counter()

    for case in build_cases():
        record, counters = verify_case(case, args.state_limit)
        records.append(record)
        totals.update(counters)

    output = {
        "status": "passed",
        "interpretation": (
            "Finite verification only. Every tested edge subset satisfied the "
            "modular-plus-graphic polymatroid identity, the termwise hypergraph "
            "Tutte specialization, the many-body Potts reduction, and the exact "
            "monochromatic-event dependence law. Direct coloring counts, "
            "factorial moments, forest/unicyclic laws, and the bipartite Ising "
            "gauge identity agreed whenever enumerated."
        ),
        "configuration": {
            "uniformities": [3, 4, 5],
            "state_limit": args.state_limit,
            "case_count": len(records),
        },
        "totals": dict(sorted(totals.items())),
        "cases": records,
        "elapsed_seconds": round(time.time() - started, 3),
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if comparable(output) != comparable(expected):
            sys.stderr.write(f"generated result differs from {args.check}\n")
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
