# Discovery provenance for the exact ac-mode obstruction

This diagnostic record is separate from the twelve configured direct
`J/rank` optimization starts. No additional optimizer, random restart,
or continued `J` search was launched.

After those starts had finished, the root agent requested a bounded test
of the newly proposed **active ac-mode positivity lemma**. The fixed
probe `continuation7_opt_ac_probe.py` evaluated twelve listed
`(k,u,r,l)` tuples on the original rational 32-sign host, using its exact
seven-mode moment expansion. It also evaluated the first six tuples on
each of the twelve retained actual roots from the completed high-rank
search, using original-law eigensystems and actual common powers.
Thus there were twelve exact sign-host coefficient tables and 72
floating saved-root coefficient tables. These are not evaluations of
the complete target `F`.

No negative active coefficient appeared on the sign host in that list.
Saved-root case 9, an 18-state weighted alternating-trap root, had a
strict numerical ac candidate at `(k,u,r,l)=(8,1,2,1)`: its smallest
square eigenvalue was approximately `1.4741760083e-6`, with coefficient
approximately `-3.7935052175e-5`. The entire probe output is retained in
`continuation7_opt_ac_probe_results.json`. A floating eigenvalue or sign
was not used as a mathematical conclusion.

The root agent then requested rational reduction and an exact spectral
filter certificate. Fourteen deterministic principal-flow restrictions
of this one saved conductance matrix were inspected. For each restriction
the original law was rebuilt from that restricted flow's own row sums;
no conditional normalization was asserted to preserve the sign.

| Retained old vertices | Minimum numerical ac coefficient |
|---|---:|
| 4 through 12 | 1.08153e-7 |
| 4 through 13 | 2.70267e-7 |
| 4 through 14 | 4.20428e-7 |
| 3 through 14 | 8.37324e-6 |
| 2 through 15 | -3.78338e-5 |
| 2 through 14 | -3.79385e-5 |
| 2 through 13 | -4.64784e-5 |
| 2 through 12 | -1.25643e-4 |
| 1 through 12 | -1.25661e-4 |
| 3 through 12 | -8.36426e-5 |
| 2 through 12, deleting 5 | 4.53631e-8 |
| 2 through 12, deleting 7 | 4.74491e-4 |
| 2 through 12, deleting 4 | 4.85234e-6 |
| 2 through 12, deleting 10 | 1.49128e3 |

Two further fixed reconstructions rounded the 18-state host and the
selected ten-state host to three significant decimal digits in each
nonzero conductance. Both retained a negative numerical coefficient.
The ten-state reconstruction becomes the explicitly listed integer flow
in `continuation7_opt_ac_obstruction.md` after multiplying by `10^10`.
Three numerical filter shifts were inspected on that one rounded host:
`1/1024`, `1205/10^6`, and `1204553/10^9`; all retained a negative
adjugate-squared average. The simplest shift, `1/1024`, was selected.

Only the ensuing standard-library exact certificate supplies the sign
conclusion. It directly constructs the final integer host, proves its
original normalization and actual powers, proves root invertibility,
and verifies the negative spectral average by integer arithmetic. It
also proves that the complete target density at `h=1` is greater than
four. None of the discovery diagnostics is a premise of that proof.
