# Erdős–Rado trace formalization

This directory formalizes the classical trace argument used in the proof of
Erdős problem 593.  The proof is deliberately split into construction,
separation, counting, and packaging layers so that the difficult recursion is
not hidden inside a cardinal-arithmetic theorem.

## Target theorem

The remaining construction obligation is the following statement (or a
definitionally equivalent source-canonical formulation):

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

The positive-atom and final lifting layers therefore do not need another
combinatorial assumption.

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

1. **Graph API.** Define `TracePrefix.graph` and prove its behavior under
   restriction, successor extension, and limit prefixes.
2. **Stopped recursion.** Define the source-eligible set, its least element,
   the source step, and `sourceRun`.  Prove successor and limit equations and
   that the run remains fixed after its first terminal stage.
3. **Cross-anchor coherence.** Prove that the run at a selected earlier node
   is the corresponding restriction of the parent's run.  The local algebra
   is provided by `TracePrefix.atCandidate`, `valueSet_atCandidate`, and
   `restrict_atCandidate_node`.
4. **System packaging.** Use the terminal source-canonical prefixes as
   `CoherentTraceSystem.height` and `.node`; prove strictness, coherent heights,
   coherent prefixes, endhomogeneity, and the stopping property.

The highest-risk obligation is cross-anchor coherence.  It must not be
replaced by same-anchor candidate persistence: that statement is false.

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
