# Smoothing continuation: tree doubles and short-edge calibration

This packet is stacked on the preceding [two-star proof and checker](../2026-10-14-two-star/README.md). The unrestricted ordered density theorem remains open.

[The tree-smoothing theorem](proof.md) proves an all-host density bound for an actual Markov tree and its product-smoothed copy, with simultaneously paid chords satisfying explicit length/parity conditions. It specializes to two hubs with arbitrarily many leaves and any compatible leaf graph. The normalization, all pair marginals, actual path interiors, strictness and tensorization are proved. This is not claimed to enlarge every unresolved K4 exponent region.

[The endpoint-calibrated law](short_edge.md) addresses the short-edge failure directly: its endpoint marginal is the actual K_k, and its selection cost is recorded exactly. It has a complete matched-star proof and a rigorously positive budget on the nine-state fixture where the old trial is negative. Its general asymmetric budget is not proved nonnegative.

```sh
python review/2026-10-14-smoothing-extension/exact_checks.py
```

The [checker](exact_checks.py) imports the standard-library exact arithmetic/logarithm helper from the preceding packet. It writes a detailed local `generated_certificate.json`. [Retained output](exact_output.txt) reports 1669 counted exact assertions, including nonuniform, periodic, negative-mode, extra-unit/zero-mode and strictly positive singular roots. [Validation metadata](validation.json) records hashes and the distinction between proof and finite evidence.

Only this review packet is added. No manuscript, PDF, accepted Lean, workflow, service request or automatic merge is changed. These are single-assistant analytical derivations and local exact checks, not independent review or Lean acceptance.
