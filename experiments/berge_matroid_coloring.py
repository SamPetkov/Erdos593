#!/usr/bin/env python3
"""Verify Berge-cycle matroid and coloring identities for generated uniform systems.

The program builds deterministic members of the class B_r from r-uniform
expansions of finite bipartite graphs by one-point amalgamations. It checks:

* subset rank:
      rk_B(A) = |V(A)| - c(A) - (r-2)|A|;
* equality with the ordinary cycle-matroid rank of an independently glued
  bipartite shadow;
* the weak chromatic-polynomial identity
      W_F(q) = sum_A (-1)^|A| q^(n-(r-2)|A|-rk_B(A));
* the equivalent antiferromagnetic Potts identity
      W_F(q) = q^((r-2)m) Z_J(q, -q^(-(r-2)));
* the strong chromatic-polynomial identity
      S_F(q) = ((q-2)_(r-2))^m P_J(q);
* the closed forms for Berge forests and connected unicyclic systems.

No third-party packages are required.
"""

from __future__ import annotations

import argparse
import collections
import dataclasses
import itertools
import json
from fractions import Fraction
from pathlib import Path
from typing import Dict, Iterable, List, Mapping, Tuple


@dataclasses.dataclass(frozen=True)
class Graph:
    order: int
    edges: Tuple[Tuple[int, int], ...]


@dataclasses.dataclass(frozen=True)
class Hypergraph:
    order: int
    edges: Tuple[frozenset[int], ...]


@dataclasses.dataclass(frozen=True)
class Case:
    name: str
    uniformity: int
    hypergraph: Hypergraph
    shadow: Graph


class DSU:
    def __init__(self, size: int) -> None:
        self.parent = list(range(size))
        self.rank = [0] * size

    def find(self, value: int) -> int:
        while self.parent[value] != value:
            self.parent[value] = self.parent[self.parent[value]]
            value = self.parent[value]
        return value

    def union(self, left: int, right: int) -> None:
        left = self.find(left)
        right = self.find(right)
        if left == right:
            return
        if self.rank[left] < self.rank[right]:
            left, right = right, left
        self.parent[right] = left
        if self.rank[left] == self.rank[right]:
            self.rank[left] += 1

    def component_count(self) -> int:
        return len({self.find(index) for index in range(len(self.parent))})


def graph(order: int, edges: Iterable[Tuple[int, int]]) -> Graph:
    normalized = tuple(tuple(sorted(edge)) for edge in edges)
    if any(left == right for left, right in normalized):
        raise ValueError("graphs must be loopless")
    if len(set(normalized)) != len(normalized):
        raise ValueError("graphs must be simple")
    return Graph(order, normalized)


def expand(base: Graph, uniformity: int) -> Hypergraph:
    if uniformity < 2:
        raise ValueError("uniformity must be at least two")
    next_vertex = base.order
    edges: List[frozenset[int]] = []
    for left, right in base.edges:
        private = range(next_vertex, next_vertex + uniformity - 2)
        next_vertex += uniformity - 2
        edges.append(frozenset((left, right, *private)))
    return Hypergraph(next_vertex, tuple(edges))


def amalgamate_hypergraphs(
    left: Hypergraph, right: Hypergraph, left_root: int, right_root: int
) -> Hypergraph:
    mapping: Dict[int, int] = {}
    next_vertex = left.order
    for vertex in range(right.order):
        if vertex == right_root:
            mapping[vertex] = left_root
        else:
            mapping[vertex] = next_vertex
            next_vertex += 1
    new_edges = tuple(
        frozenset(mapping[vertex] for vertex in edge) for edge in right.edges
    )
    return Hypergraph(next_vertex, left.edges + new_edges)


def amalgamate_graphs(
    left: Graph, right: Graph, left_root: int, right_root: int
) -> Graph:
    mapping: Dict[int, int] = {}
    next_vertex = left.order
    for vertex in range(right.order):
        if vertex == right_root:
            mapping[vertex] = left_root
        else:
            mapping[vertex] = next_vertex
            next_vertex += 1
    new_edges = tuple(
        tuple(sorted((mapping[u], mapping[v]))) for u, v in right.edges
    )
    return graph(next_vertex, left.edges + new_edges)


def graph_components(base: Graph) -> int:
    dsu = DSU(base.order)
    for left, right in base.edges:
        dsu.union(left, right)
    return dsu.component_count()


def graph_rank(base: Graph, mask: int) -> int:
    dsu = DSU(base.order)
    for index, (left, right) in enumerate(base.edges):
        if mask & (1 << index):
            dsu.union(left, right)
    return base.order - dsu.component_count()


def support_stats(system: Hypergraph, mask: int) -> Tuple[int, int]:
    selected = [
        index for index in range(len(system.edges)) if mask & (1 << index)
    ]
    if not selected:
        return 0, 0
    support = sorted(set().union(*(system.edges[index] for index in selected)))
    point_index = {vertex: index for index, vertex in enumerate(support)}
    dsu = DSU(len(support) + len(selected))
    for local_index, edge_index in enumerate(selected):
        edge_node = len(support) + local_index
        for vertex in system.edges[edge_index]:
            dsu.union(edge_node, point_index[vertex])
    return len(support), dsu.component_count()


def hypergraph_rank(system: Hypergraph, uniformity: int, mask: int) -> int:
    support_order, components = support_stats(system, mask)
    if mask == 0:
        return 0
    return support_order - components - (uniformity - 2) * mask.bit_count()


def monochromatic_equivalence_classes(system: Hypergraph, mask: int) -> int:
    dsu = DSU(system.order)
    for index, edge in enumerate(system.edges):
        if not (mask & (1 << index)):
            continue
        vertices = tuple(edge)
        for vertex in vertices[1:]:
            dsu.union(vertices[0], vertex)
    return dsu.component_count()


def weak_polynomial_from_hypergraph(system: Hypergraph) -> Dict[int, int]:
    coefficients: collections.Counter[int] = collections.Counter()
    edge_count = len(system.edges)
    for mask in range(1 << edge_count):
        exponent = monochromatic_equivalence_classes(system, mask)
        coefficients[exponent] += -1 if mask.bit_count() % 2 else 1
    return {
        exponent: coefficient
        for exponent, coefficient in sorted(coefficients.items(), reverse=True)
        if coefficient
    }


def weak_polynomial_from_matroid(
    system: Hypergraph, shadow: Graph, uniformity: int
) -> Dict[int, int]:
    coefficients: collections.Counter[int] = collections.Counter()
    edge_count = len(shadow.edges)
    for mask in range(1 << edge_count):
        exponent = (
            system.order
            - (uniformity - 2) * mask.bit_count()
            - graph_rank(shadow, mask)
        )
        coefficients[exponent] += -1 if mask.bit_count() % 2 else 1
    return {
        exponent: coefficient
        for exponent, coefficient in sorted(coefficients.items(), reverse=True)
        if coefficient
    }


def evaluate_polynomial(coefficients: Mapping[int, int], q: int) -> int:
    return sum(
        coefficient * q**exponent
        for exponent, coefficient in coefficients.items()
    )


def potts_random_cluster(shadow: Graph, q: int, v: Fraction) -> Fraction:
    total = Fraction(0)
    edge_count = len(shadow.edges)
    for mask in range(1 << edge_count):
        components = shadow.order - graph_rank(shadow, mask)
        total += Fraction(q**components) * v ** mask.bit_count()
    return total


def chromatic_count_graph(shadow: Graph, q: int) -> int:
    count = 0
    for coloring in itertools.product(range(q), repeat=shadow.order):
        if all(
            coloring[left] != coloring[right] for left, right in shadow.edges
        ):
            count += 1
    return count


def weak_count_hypergraph(system: Hypergraph, q: int) -> int:
    count = 0
    for coloring in itertools.product(range(q), repeat=system.order):
        if all(
            len({coloring[vertex] for vertex in edge}) > 1
            for edge in system.edges
        ):
            count += 1
    return count


def strong_count_hypergraph(system: Hypergraph, q: int) -> int:
    count = 0
    for coloring in itertools.product(range(q), repeat=system.order):
        if all(
            len({coloring[vertex] for vertex in edge}) == len(edge)
            for edge in system.edges
        ):
            count += 1
    return count


def falling_factorial(start: int, length: int) -> int:
    result = 1
    for offset in range(length):
        result *= start - offset
    return result


def cycle_nullity(shadow: Graph) -> int:
    return len(shadow.edges) - graph_rank(
        shadow, (1 << len(shadow.edges)) - 1
    )


def unique_circuit_length(shadow: Graph) -> int | None:
    if cycle_nullity(shadow) != 1:
        return None
    edge_count = len(shadow.edges)
    for size in range(3, edge_count + 1):
        for subset in itertools.combinations(range(edge_count), size):
            mask = sum(1 << index for index in subset)
            if size - graph_rank(shadow, mask) != 1:
                continue
            if all(
                (mask ^ (1 << index)).bit_count()
                - graph_rank(shadow, mask ^ (1 << index))
                == 0
                for index in subset
            ):
                return size
    raise AssertionError("nullity-one shadow had no circuit")


def make_cases() -> List[Case]:
    k2 = graph(2, [(0, 1)])
    p3 = graph(3, [(0, 1), (1, 2)])
    p4 = graph(4, [(0, 1), (1, 2), (2, 3)])
    c4 = graph(4, [(0, 1), (1, 2), (2, 3), (3, 0)])
    k23 = graph(
        5,
        [(0, 2), (0, 3), (0, 4), (1, 2), (1, 3), (1, 4)],
    )

    cases: List[Case] = []
    for uniformity in (3, 4, 5):
        for name, base in (("edge", k2), ("path", p3), ("cycle4", c4)):
            cases.append(
                Case(
                    f"{name}_r{uniformity}",
                    uniformity,
                    expand(base, uniformity),
                    base,
                )
            )

    for uniformity in (3, 4):
        left = expand(p3, uniformity)
        right = expand(k2, uniformity)
        private_left = p3.order
        cases.append(
            Case(
                f"private_attachment_r{uniformity}",
                uniformity,
                amalgamate_hypergraphs(left, right, private_left, 0),
                amalgamate_graphs(p3, k2, 0, 0),
            )
        )

        central = expand(k2, uniformity)
        shadow = k2
        system = central
        attachment_count = min(3, uniformity)
        for index in range(attachment_count):
            atom = expand(k2, uniformity)
            system = amalgamate_hypergraphs(system, atom, index, 0)
            shadow = amalgamate_graphs(shadow, k2, index % 2, 0)
        cases.append(
            Case(
                f"multi_attachment_edge_r{uniformity}",
                uniformity,
                system,
                shadow,
            )
        )

        left = expand(c4, uniformity)
        right = expand(p3, uniformity)
        system = amalgamate_hypergraphs(left, right, c4.order, 0)
        shadow = amalgamate_graphs(c4, p3, 0, 0)
        cases.append(
            Case(
                f"unicyclic_attachment_r{uniformity}",
                uniformity,
                system,
                shadow,
            )
        )

    cases.append(Case("k23_r3", 3, expand(k23, 3), k23))
    cases.append(Case("path4_r4", 4, expand(p4, 4), p4))
    return cases


def run_case(case: Case) -> dict:
    system = case.hypergraph
    shadow = case.shadow
    uniformity = case.uniformity
    edge_count = len(system.edges)
    if edge_count != len(shadow.edges):
        raise AssertionError("edge-count mismatch")

    subsets_checked = 0
    rank_failures: List[dict] = []
    nullity_failures: List[dict] = []
    for mask in range(1 << edge_count):
        subsets_checked += 1
        hyper_rank = hypergraph_rank(system, uniformity, mask)
        shadow_rank = graph_rank(shadow, mask)
        if hyper_rank != shadow_rank:
            rank_failures.append(
                {
                    "mask": mask,
                    "hyper_rank": hyper_rank,
                    "shadow_rank": shadow_rank,
                }
            )

        support_order, support_components = support_stats(system, mask)
        incidence_nullity = (
            (uniformity - 1) * mask.bit_count()
            - support_order
            + support_components
            if mask
            else 0
        )
        matroid_nullity = mask.bit_count() - shadow_rank
        if incidence_nullity != matroid_nullity:
            nullity_failures.append(
                {
                    "mask": mask,
                    "incidence_nullity": incidence_nullity,
                    "matroid_nullity": matroid_nullity,
                }
            )

    hyper_weak = weak_polynomial_from_hypergraph(system)
    matroid_weak = weak_polynomial_from_matroid(system, shadow, uniformity)
    if hyper_weak != matroid_weak:
        raise AssertionError(
            f"{case.name}: weak polynomial mismatch: "
            f"{hyper_weak} != {matroid_weak}"
        )

    weak_evaluations: Dict[str, dict] = {}
    for q in (2, 3, 4, 5):
        polynomial_value = evaluate_polynomial(hyper_weak, q)
        potts_value = (
            Fraction(q ** ((uniformity - 2) * edge_count))
            * potts_random_cluster(
                shadow, q, -Fraction(1, q ** (uniformity - 2))
            )
        )
        if (
            potts_value.denominator != 1
            or potts_value.numerator != polynomial_value
        ):
            raise AssertionError(f"{case.name}: Potts mismatch at q={q}")
        record = {
            "polynomial": polynomial_value,
            "potts": potts_value.numerator,
        }
        if system.order <= 10 and q <= 3:
            direct = weak_count_hypergraph(system, q)
            if direct != polynomial_value:
                raise AssertionError(
                    f"{case.name}: direct weak mismatch at q={q}"
                )
            record["direct"] = direct
        weak_evaluations[str(q)] = record

    strong_evaluations: Dict[str, dict] = {}
    for q in range(2, 6):
        graph_count = chromatic_count_graph(shadow, q)
        factor = falling_factorial(q - 2, uniformity - 2) ** edge_count
        predicted = factor * graph_count
        record = {
            "shadow_chromatic": graph_count,
            "private_factor": factor,
            "predicted": predicted,
        }
        if system.order <= 9 and q <= 4:
            direct = strong_count_hypergraph(system, q)
            if direct != predicted:
                raise AssertionError(
                    f"{case.name}: direct strong mismatch at q={q}"
                )
            record["direct"] = direct
        strong_evaluations[str(q)] = record

    components = graph_components(shadow)
    rank = graph_rank(shadow, (1 << edge_count) - 1)
    beta = edge_count - rank
    expected_rank = system.order - (uniformity - 2) * edge_count - components
    expected_beta = (uniformity - 1) * edge_count - system.order + components
    if rank != expected_rank or beta != expected_beta:
        raise AssertionError(f"{case.name}: global rank formula mismatch")

    closed_form: dict | None = None
    if beta == 0:
        closed_form = {"type": "forest", "evaluations": {}}
        for q in (2, 3, 4, 5):
            weak = q**components * (q ** (uniformity - 1) - 1) ** edge_count
            strong = q**components * falling_factorial(
                q - 1, uniformity - 1
            ) ** edge_count
            if weak != weak_evaluations[str(q)]["polynomial"]:
                raise AssertionError(
                    f"{case.name}: forest weak formula mismatch"
                )
            if strong != strong_evaluations[str(q)]["predicted"]:
                raise AssertionError(
                    f"{case.name}: forest strong formula mismatch"
                )
            closed_form["evaluations"][str(q)] = {
                "weak": weak,
                "strong": strong,
            }
    elif beta == 1 and components == 1:
        circuit_length = unique_circuit_length(shadow)
        assert circuit_length is not None
        closed_form = {
            "type": "connected_unicyclic",
            "circuit_length": circuit_length,
            "evaluations": {},
        }
        for q in (2, 3, 4, 5):
            x = q ** (uniformity - 1) - 1
            weak = x ** (edge_count - circuit_length) * (
                x**circuit_length + q - 1
            )
            private = (
                falling_factorial(q - 2, uniformity - 2) ** edge_count
            )
            strong = private * (q - 1) ** (
                edge_count - circuit_length
            ) * ((q - 1) ** circuit_length + q - 1)
            if weak != weak_evaluations[str(q)]["polynomial"]:
                raise AssertionError(
                    f"{case.name}: unicyclic weak formula mismatch"
                )
            if strong != strong_evaluations[str(q)]["predicted"]:
                raise AssertionError(
                    f"{case.name}: unicyclic strong formula mismatch"
                )
            closed_form["evaluations"][str(q)] = {
                "weak": weak,
                "strong": strong,
            }

    compact_closed_form = None
    if closed_form is not None:
        compact_closed_form = {"type": closed_form["type"]}
        if "circuit_length" in closed_form:
            compact_closed_form["circuit_length"] = closed_form[
                "circuit_length"
            ]

    return {
        "name": case.name,
        "uniformity": uniformity,
        "vertices": system.order,
        "hyperedges": edge_count,
        "components": components,
        "shadow_vertices": shadow.order,
        "matroid_rank": rank,
        "matroid_nullity": beta,
        "subsets_checked": subsets_checked,
        "rank_failures": len(rank_failures),
        "nullity_failures": len(nullity_failures),
        "weak_polynomial": [
            {"exponent": exponent, "coefficient": coefficient}
            for exponent, coefficient in hyper_weak.items()
        ],
        "weak_values_q2_to_q5": {
            q: weak_evaluations[q]["polynomial"] for q in weak_evaluations
        },
        "strong_values_q2_to_q5": {
            q: strong_evaluations[q]["predicted"]
            for q in strong_evaluations
        },
        "closed_form": compact_closed_form,
    }


def comparable(data: dict) -> dict:
    return data


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()

    records = [run_case(case) for case in make_cases()]
    summary = {
        "cases": len(records),
        "edge_subsets_checked": sum(
            record["subsets_checked"] for record in records
        ),
        "rank_failures": sum(record["rank_failures"] for record in records),
        "nullity_failures": sum(
            record["nullity_failures"] for record in records
        ),
        "forest_cases": sum(
            record["closed_form"] is not None
            and record["closed_form"]["type"] == "forest"
            for record in records
        ),
        "unicyclic_cases": sum(
            record["closed_form"] is not None
            and record["closed_form"]["type"] == "connected_unicyclic"
            for record in records
        ),
    }
    if summary["rank_failures"] or summary["nullity_failures"]:
        raise AssertionError(summary)

    output = {
        "status": "passed",
        "interpretation": (
            "Finite verification only. Every generated B_r case had the same "
            "edge-subset rank and nullity as its independently glued bipartite "
            "shadow; weak coloring polynomials agreed with the matroid/Potts "
            "formula, and strong coloring counts agreed with the shadow "
            "chromatic-polynomial formula."
        ),
        "summary": summary,
        "records": records,
    }

    if args.check:
        expected = json.loads(args.check.read_text(encoding="utf-8"))
        if comparable(output) != comparable(expected):
            raise SystemExit(f"generated result differs from {args.check}")

    text = json.dumps(output, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(text, encoding="utf-8")
    else:
        print(text, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
