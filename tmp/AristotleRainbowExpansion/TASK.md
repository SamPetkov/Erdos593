# Aristotle target: rainbow witness matrix bridge

Submitted 2026-07-15 (UTC) as Aristotle project
`a9602e2d-381b-464e-9a60-dfc546b97fda`.

Target file: `Erdos593/TripleSystem/RainbowExpansionTarget.lean`.

The sole intended placeholder is
`IsObligatory.completeBipartiteExpansion_of_witnessedMatrices`.
It must remain an exact, gap-free Lean 4.32 proof of the stated sufficient
condition: the codegree/closure-chain work is represented explicitly by the
universal witness-matrix hypothesis, rather than assumed as an invisible
axiom.

The submitted prompt instructed the prover to use the existing
`RainbowBipartite.exists_rainbow_bipartite_submatrix` result and construct a
non-induced triple-system embedding, without weakening the statement or adding
axioms, `sorry`, `admit`, `unsafe`, or `implemented_by`.

Pre-submission audit: 51 Lean files, exactly one intended `sorry`, no
credential matches, and target SHA-256
`5CDEF6237F53573AAFD82CB47896C08424D43D10D72744FAEFA7724FA4CD3C5C`.
The target statement typechecked locally under the canonical project Lean
4.32 environment (with only its intended placeholder).
