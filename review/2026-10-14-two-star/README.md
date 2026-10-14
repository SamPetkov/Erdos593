# Two-star smoothing research addition

The unrestricted common-power density theorem remains open. This packet proves the all-host exponent regions `r>=u, k>=2u` and `u>=r+h, k>=2r+h`, including their equality boundaries, and records an exact obstruction to removing the long-edge premise from this particular entropy trial.

Read [the complete proof](proof.md), run [the standard-library checker](exact_checks.py), and compare [the actual retained output](exact_output.txt). The checker writes `exact_certificate.json` locally, with rational values and rigorous log enclosures. That generated report is not a universal proof and is intentionally not committed.

```sh
python review/2026-10-14-two-star/exact_checks.py
```

[Validation metadata](validation.json) separates analytical derivation, finite replay, and unperformed independent/Lean review. The source contract retains the original law, singular roots, negative eigenvalues, period two, additional unit modes and support zeros.

This additive packet does not edit manuscripts, PDFs, accepted Lean sources or workflows. It is proposed for mathematical review, not automatic integration into the author-review manuscript.
