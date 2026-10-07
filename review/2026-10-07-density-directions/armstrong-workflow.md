# Statement fidelity before proof automation

This development adapts selected ideas from Scott Armstrong's [autoformalization post](https://www.scottnarmstrong.com/2026/10/autoformalization-is-now-very-easy/) and [LeanAutoformalizationSkills](https://github.com/scottnarmstrong/LeanAutoformalizationSkills/tree/05a07311f16bc581729e52f3e73647b95fa9bef1), pinned to commit `05a07311f16bc581729e52f3e73647b95fa9bef1`.

The mathematical/source dependency graph and the Lean proof-evidence graph are tracked separately. Complete declarations and literal definition bodies are frozen; source-facing binders are classified as SOURCE, STANDING, TYPING, RULED or EXCESS. In particular, universal sparsity must be proved from the exposure certificate, and an original-carrier density statement must not assume its desired equality through a replacement definition.

The actual helper audit in `source-checkpoints/binder-body-review.json` found no excess premise in the scoped exports, but explicitly retained the graph-carrier, expansion-cardinality and canonical-port adapters as pending obligations. Source review does not substitute for compilation, actual full-type/definition/ordered-axiom output review, or full-paper acceptance.

No upstream skill/code was installed or copied, no compiler or Mathlib pin was upgraded, no cache was rebuilt, and the paused monitors were not restarted. This is a scoped adaptation, not a claim to pass the upstream collection's entire frozen-anchor audit protocol.

Attribution: Scott Armstrong, LeanAutoformalizationSkills, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). The existing project's stricter resource and proof-acceptance safeguards remain in force.
