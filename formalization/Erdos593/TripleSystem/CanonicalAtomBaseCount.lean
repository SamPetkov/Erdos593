import Erdos593.TripleSystem.CanonicalAtomContainment
import Erdos593.TripleSystem.CanonicalAtomTransport

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

theorem card_index_eq_one_of_onePointIndecomposable
    {V E : Type u}
    [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hF : F.Intrinsic)
    (hconnected : F.levi.Connected)
    (hreduced : F.HasNoIsolatedPoints)
    (hindec : OnePointIndecomposable F) :
    Nat.card (Index F) = 1 := by
  let i := F.edgeRestrictionUnivIso hreduced
  have hconnected' : (F.edgeRestriction Set.univ).levi.Connected :=
    i.leviIso.connected_iff.mpr hconnected
  have hindec' : OnePointIndecomposable (F.edgeRestriction Set.univ) :=
    (onePointIndecomposable_iff_of_iso i).mpr hindec
  obtain ⟨A, hA⟩ := indecomposable_edgeRestriction_subset_atom
    F hF Set.univ hconnected' hindec'
  apply Nat.card_eq_one_iff_exists.mpr
  refine ⟨A, ?_⟩
  intro B
  obtain ⟨e, he⟩ := atomOf_surjective F hF.1 hF.2.1 B
  have heA : atomOf F hF.1 hF.2.1 e = A := hA (Set.mem_univ e)
  exact he.symm.trans heA

theorem card_index_eq_one_of_unique_edges
    {V E : Type u}
    [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E] [Unique E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (hlinear : F.Linear) (hbridge : F.BridgeAtEveryEdge) :
    Nat.card (Index F) = 1 := by
  apply Nat.card_eq_one_iff_exists.mpr
  refine ⟨atomOf F hlinear hbridge (default : E), ?_⟩
  intro A
  obtain ⟨e, he⟩ := atomOf_surjective F hlinear hbridge A
  have he0 : e = (default : E) := Subsingleton.elim e _
  exact he.symm.trans (congrArg (atomOf F hlinear hbridge) he0)

end Erdos593.TripleSystem.CanonicalAtom
