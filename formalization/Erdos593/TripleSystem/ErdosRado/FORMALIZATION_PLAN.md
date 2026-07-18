# Erdős–Rado trace formalization

This directory formalizes the classical trace argument used in the proof of
Erdős problem 593.  The proof is deliberately split into construction,
separation, counting, and packaging layers so that the difficult recursion is
not hidden inside a cardinal-arithmetic theorem.

## Target theorem

The construction is closed by the following theorem:

```lean
theorem stoppedCoherentTraceSystemsForEveryColoring :
    ∀ d : TraceColoring,
      ∃ T : CoherentTraceSystem d, T.IsEndhomogeneous ∧
        ∀ (ρ : Ordinal) (a : T.level ρ), ρ < TraceHeight →
          ¬ Nonempty
            (TraceCandidate d (T.levelTracePrefix ρ a))
```

Once this theorem is proved, the downstream argument is:

1. `levelCode_levelNode` identifies a node's code with a restriction of its
   endpoint's code.
2. `levelCodeInjective_of_stopped` proves separation on every short level.
3. `exists_height_eq_traceHeight_of_stopped` uses cardinal counting to find a
   full-height endpoint.
4. `exists_full_endhomogeneous_of_stopped` extracts its trace.
5. `fullEndhomogeneousLimitChain_of_stoppedCoherentTraceSystems` packages the
   restrictions as the required limit chain.
6. `TriangleHostRamseyUnconditional.lean` instantiates the lifted-host
   obstruction with `pairRamseyTriangle_erdosRadoCarrier`.

No further combinatorial assumption is needed for the unconditional
non-linear obstruction.

## Construction plan

The source-canonical recursion should be developed below the counting layer.
Its central one-anchor specification is:

```lean
theorem sourceRun_spec
    (d : TraceColoring) (a : TraceCarrier)
    (η : Ordinal) (hη : η ≤ TraceHeight) :
    ∃ p : TracePrefix a,
      sourceRun d a η = p.graph ∧
      p.IsSourceCanonicalFor d ∧
      p.length ≤ η ∧
      (p.length = η ∨
        (p.length < η ∧
          ¬ Nonempty (TraceCandidate d p)))
```

Implement it in four layers:

1. **Graph API (complete).** Define `TracePrefix.graph` and prove its behavior under
   restriction, successor extension, and limit prefixes.
2. **Stopped recursion (complete).** Define the source-eligible set, its least element,
   the source step, and `sourceRun`.  Prove successor and limit equations and
   that the run remains fixed after its first terminal stage.
3. **Cross-anchor coherence (complete).** Prove that the run at a selected earlier node
   is the corresponding restriction of the parent's run.  The local algebra
   is provided by `TracePrefix.atCandidate`, `valueSet_atCandidate`, and
   `restrict_atCandidate_node`.
4. **System packaging (complete).** `SourceSystem.lean` uses the terminal
   source-canonical prefixes as `CoherentTraceSystem.height` and `.node`, and
   proves strictness, coherent heights, coherent prefixes, endhomogeneity, and
   the stopping property.  `Theorem.lean` composes this construction with the
   existing counting and limit layers to obtain the public Erdos--Rado
   homogeneous-pair-set theorem.

The highest-risk obligation is cross-anchor coherence.  It must not be
replaced by same-anchor candidate persistence: that statement is false.

This obligation is discharged in `SourceCoherence.lean`.  Its stronger
`sourceRun_at_candidate` theorem replays a canonical prefix below any
candidate above it; `sourceRun_at_node_stage` then specializes this to every
earlier stage below a selected node.  `SourceTerminal.lean` now extracts the
terminal prefix and proves that reanchoring below any internal node is exactly
the terminal source run there.  `SourceEndhomogeneous.lean` proves directly
from the canonical-candidate invariant that every such prefix is
endhomogeneous.  `SourceSystem.lean` completes coherent-system packaging.

The first frozen theorem in this layer is:

```lean
theorem sourceRun_at_node_stage
    {c : TraceColoring} {a : TraceCarrier} {p : TracePrefix a}
    (hcanonical : p.IsSourceCanonicalFor c)
    (ξ : p.length.ToType)
    {θ : Ordinal} (hθ : θ ≤ ξ.toOrd) :
    sourceRun c (p.node ξ) θ =
      (p.restrict θ
        (hθ.trans (le_of_lt ξ.toOrd.2))).graph
```

Its successor step uses two canonical witnesses: the least candidate chosen
at the current coordinate and the later candidate whose value becomes the
new anchor.  Restrict the later candidate to the current prefix, reanchor the
prefix there, and transport the earlier least candidate with
`TraceCandidate.IsLeast.atCandidateOfLt`.  The transported value is exactly
the next node.  At a limit stage, use `sourceRun_limit` and `graph_restrict`.

In particular, a candidate for `p` need not remain a candidate for
`p.snoc q`.  Extending the prefix adds a new color-agreement requirement,
which an arbitrary old candidate may fail.  The proof must instead use the
exact identity
`valueSet c (p.atCandidate q) = valueSet c p ∩ Set.Iio q.value`.

Terminality at `ξ.toOrd` is now obtained from the least-candidate witness, and
stopped-run persistence gives `sourceRun_at_node_traceHeight`.  The identity
`terminalPrefix_at_node` is the frozen input for the coherent height and
coherent prefix fields.  The remaining construction target is discharged by
`TraceIteration.stoppedCoherentTraceSystemsForEveryColoring`.

## Automated proof-search protocol

Use Codex to control definitions, dependency direction, integration, and
validation.  Use Aristotle for independent proof search from one immutable,
compiling commit:

- one ambitious whole-construction scout for lemma discovery;
- separate tasks for the graph API, successor recursion, limit/fixed-point
  recursion, cross-anchor coherence, system packaging, and final invariants;
- exactly one principal hole per focused task, with the pinned toolchain,
  manifest, and required import closure included;
- no downstream theorem, equivalent construction hypothesis, new axiom,
  `sorry`, `admit`, `unsafe`, or `native_decide`.

Returned files are suggestions, not trusted proofs.  Inspect their dependency
direction and integrate only the smallest independently checked lemmas.

## Acceptance checks

For every accepted patch:

1. Elaborate the changed leaf module with warnings treated as errors.
2. Elaborate downstream modules in dependency order.
3. Search for prohibited proof escapes.
4. Run `#print axioms` on public construction theorems.
5. Build the Erdos593 umbrella target.
6. Regenerate and check the self-contained artifact.
7. Require the GitHub Actions checks to pass.

Only one local Lean process should run at a time.  Remote Aristotle tasks may
run in parallel, but every task must start from the same recorded baseline.

## Readability conventions

- Use descriptive names and short helper lemmas instead of dense tactic blocks.
- Keep the construction, invariant, and counting arguments in separate files.
- State the mathematical role of every public definition or theorem.
- Prefer `∀`, `∃`, `→`, `∧`, `≤`, and `↔` in theorem statements.
- Do not advertise a proposition as proved until its Lean declaration has
  elaborated and its axioms have been audited.
