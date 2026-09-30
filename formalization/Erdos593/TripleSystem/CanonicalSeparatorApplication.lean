import Erdos593.TripleSystem.CanonicalAtomForestReconstruction
import Erdos593.Separator.SeparatorForest

/-!
# Instantiation on the existing canonical atom incidence graph

This uses the already defined literal atom supports and its existing acyclicity
theorem. It proves an interface for connected partitions of actual atom labels.
It does NOT silently identify them with all supported hypergraph decompositions;
that hypergraph partition correspondence and removal of trivial point factors
remain separate obligations. Candidate source: no kernel replay obtained here.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u
variable {V E : Type u} [Fintype V] [Fintype E]
  [DecidableEq V] [DecidableEq E]
variable (F : TripleSystem V E) [DecidableRel F.levi.Adj]

/-- The newly defined graph is definitionally the existing canonical incidence graph. -/
theorem canonical_separator_incidence_eq
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    E593Separator.incidenceGraph (atomIncident F hlinear hbridge) =
      atomPointIncidenceGraph F hlinear hbridge := rfl

/-- Constructed certificates on the actual atom labels and original point carrier. -/
noncomputable def canonicalSeparatorCertificate
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    E593Separator.Certificate (atomIncident F hlinear hbridge) :=
  E593Separator.certificateOfForest (atomIncident F hlinear hbridge) (by
    rw [canonical_separator_incidence_eq F hlinear hbridge]
    exact atomPointIncidenceGraph_isAcyclic F hlinear hbridge)

/-- The canonical forest instantiates the general local/global refinement isomorphism. -/
noncomputable def canonicalAtomConnectedPartitionOrderIso
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    E593Separator.Local (atomIncident F hlinear hbridge) ≃o
      {R : E593Separator.Partition (Index F) //
        E593Separator.ConnectedPartition (atomIncident F hlinear hbridge) R} :=
  E593Separator.forestPartitionOrderIso (atomIncident F hlinear hbridge) (by
    rw [canonical_separator_incidence_eq F hlinear hbridge]
    exact atomPointIncidenceGraph_isAcyclic F hlinear hbridge)

/-- The application uses the original support relation, not a guessed atom count. -/
theorem canonical_separator_local_recovery
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge)
    (L : E593Separator.Local (atomIncident F hlinear hbridge)) (p : V)
    (a b : E593Separator.Star (atomIncident F hlinear hbridge) p) :
    (E593Separator.extend (atomIncident F hlinear hbridge) L).rel a.val b.val ↔
      (L p).rel a b :=
  E593Separator.local_recovery (atomIncident F hlinear hbridge)
    (canonicalSeparatorCertificate F hlinear hbridge) L p a b

end Erdos593.TripleSystem.CanonicalAtom
