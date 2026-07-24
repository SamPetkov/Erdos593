# Public chronology of the Problem 593 proof and formalisation

**Checked:** 24 July 2026

This file separates two different priority questions: mathematical priority for
the classification and public priority for a complete Lean formalisation.  It
records only publicly timestamped material and makes no inference about private
development, source access, or influence.

## Mathematical classification

- **23 June 2026, 17:57:39 UTC:** Eric Li submitted
  arXiv:2606.24882v1.  That version contains the first publicly posted complete
  proof of the finite classification in Erdős Problem 593.  The manuscript in
  this repository cites Li for that priority and at the points where his
  one-apex and bridge-trace architecture is used.

## Lean development in this repository

- **15 July 2026, 03:49:51 Europe/Sofia:** commit
  [`ba37b8c`](https://github.com/SamPetkov/Erdos593/commit/ba37b8c511ab390c14a905110366d7cac1ffa08f)
  published the verified Lean formalisation scaffold.
- **15 July 2026, 12:09:28 Europe/Sofia:** commit
  [`6fd00a7`](https://github.com/SamPetkov/Erdos593/commit/6fd00a76064401f3f10aabef474f59d3c6ecd6bf)
  published the complete finite constructive/intrinsic structural
  classification.
- **19 July 2026, 01:09:39 Europe/Sofia:** commit
  [`8153938`](https://github.com/SamPetkov/Erdos593/commit/815393868ea462cb2956e70c3e1c0c499f373f10)
  published the complete Problem 593 Lean endpoints, including
  `F.IsObligatory ↔ F.isolatedReduction.Intrinsic` and the equivalent
  constructive formulation.

## Li's second version and separate formalisation

- **23 July 2026, 02:20:32 UTC:** the first commit currently visible in
  [`ericlisg/erdos-593-1177-lean`](https://github.com/ericlisg/erdos-593-1177-lean)
  published a separate Lean formalisation of Problems 593 and 1177.
- **23 July 2026, 05:42:12 UTC:** arXiv:2606.24882v2 was submitted, adding the
  statement that all results had been formally verified in Lean 4.

On these public timestamps, the complete Problem 593 endpoints in this
repository predate Li's v2 and the public commit of Li's separate
formalisation.  It is therefore accurate to describe this project as the
**earliest complete public Lean formalisation located in the present audit**,
while continuing to describe Li's v1 as the first publicly posted complete
mathematical proof.

The qualifier “located in the present audit” is deliberate.  It avoids a claim
about unpublished work or an unlocated public repository.  No claim about
copying or causal influence is made.
