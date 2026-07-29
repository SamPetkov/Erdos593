# Erdős 593: copy-ready external/Lean interface patches

These patches supplement `MANUSCRIPT_LINE_EDIT_PATCHES.md` and
`STANDARD_DEFINITION_LINE_PATCHES.md`.  They do not change any theorem.  They
make the external proof boundary and the exact Lean theorem surface explicit.

## Patch 1: make isomorphism closure explicit

### Location

Introduction, immediately after the sentence defining `\mathcal B`.

### Insert

```tex
Membership in $\mathcal B$ is understood up to triple-system isomorphism.
```

### Reason

Obligatoriness is isomorphism-invariant, and the Lean `Constructible` predicate
has an explicit `ofIso` constructor.  Leaving this entirely implicit makes the
literal labelled-object definition narrower than the intended structural
class.

---

## Patch 2: name the compactness theorem precisely

### Location

Introduction, list of black-box inputs.

### Replace

```tex
the de Bruijn--Erd\H{o}s compactness theorem
```

by

```tex
the de Bruijn--Erd\H{o}s finite-colouring compactness theorem
```

### Reason

This identifies the exact graph-colouring theorem being used and avoids
confusion with other results bearing the same names.

---

## Patch 3: use lower-bound language for odd girth

### Location

Introduction, sentence describing the odd-cycle avoiding host.

### Replace

```tex
a classical Erd\H{o}s--Hajnal graph of uncountable chromatic number and
prescribed odd girth excludes an odd Berge cycle.
```

by

```tex
a classical Erd\H{o}s--Hajnal graph of uncountable chromatic number whose odd
girth exceeds a prescribed finite bound excludes an odd Berge cycle.
```

### Reason

The source theorem supplies avoidance of every odd cycle up to a chosen bound;
it does not assert that the odd girth is exactly a prescribed value.

---

## Patch 4: identify the exact Li interface

### Location

Immediately before Theorem 6.3.

### Replace

```tex
The next result is the fibre-decomposition form of Li's bridge-trace theorem
needed in this paper \citep[Theorem~4.6]{li2026}.
```

by

```tex
The next result is the forward finite-trace consequence of Li's exact
bridge-trace theorem, specialised to the present lift and rewritten in
base-fibre language \citep[Theorem~4.6]{li2026}.  We do not use or restate the
converse direction here.
```

### Reason

This states the logical interface exactly and avoids suggesting that the
manuscript has reproduced Li's full equivalence in different notation.

---

## Patch 5: state which expansion proof is used

### Location

After Corollary 3.3.

### Replace

```tex
Corollary~3.3 is also a consequence of
\citet[Theorem~1.2]{reiher2024}; the preceding argument gives a direct proof
in the present notation.
```

by

```tex
Corollary~3.3 is also a consequence of
\citet[Theorem~1.2]{reiher2024}.  The preceding direct argument is the proof
route used in this manuscript.
```

### Reason

Reiher is an attribution and comparison source here, not a hidden premise of
the manuscript proof.

---

## Patch 6: quote the public Lean endpoints literally

### Location

Start of `Formal verification and reproducibility`.

### Replace the opening paragraph by

```tex
The public Lean endpoints state the classification on the isolated reduction.
For every finite triple system $F$, they prove
\[
\begin{aligned}
\mathtt{F.IsObligatory}
&\Longleftrightarrow \mathtt{F.isolatedReduction.Intrinsic},\\
\mathtt{F.IsObligatory}
&\Longleftrightarrow
  \mathtt{Constructible\ F.isolatedReduction}.
\end{aligned}
\]
Together with the separately proved isolated-vertex equivalence, these are the
formal counterparts of the displayed formulation of Theorem~A.  Host systems
are unrestricted in cardinality but are quantified in the fixed ambient vertex
and edge universes of the theorem; this is the documented universe-polymorphic
convention of the Lean development.
```

### Reason

The current statement is mathematically correct, but the replacement makes the
surface distinction between `F` and `F^\circ` impossible to miss and states the
universe boundary accurately.

---

## Patch 7: separate Section 10 from the Lean claim

### Location

End of the formal-verification section, before the acknowledgments.

### Insert

```tex
The public Lean endpoints cover the finite classification theorem.  The finite
parameter consequences in Section~\ref{finite-parameter-consequences} are
conventional corollaries of that classification, checked separately by exact
integer arithmetic; they are not currently exported as additional Lean
theorems.
```

### Reason

The enlarged manuscript contains correct new finite results, but the present
Lean release does not expose them as named endpoints.

---

## Patch 8: explain the Lean proper-colouring definition

### Location

Formal-verification section, after the endpoint display.

### Insert

```tex
Lean expresses properness by requiring two differently coloured vertices in
every triple.  Since every edge has exactly three vertices, this is equivalent
to the manuscript convention that no hyperedge is monochromatic.
```

### Reason

This documents the only superficial difference between the prose and formal
colouring definitions.
