import Erdos593.TripleSystem.CanonicalAtomCountSpectrum

/-!
# Connected positive-rank canonical atom-count maximizers

Unvalidated candidate isolated from private PR47 at
16fc602b5eeb5a7711293f5f3bec4e10c1ec0b99. Only the five required-interface
helpers and four maximizer declarations are retained; no K3 phase candidates.
Statements and proof bodies are unchanged. Requires independent pinned replay.
-/

namespace Erdos593.TripleSystem.CanonicalAtom

universe u

/-- The one arithmetic constant used by all rank-one endpoint proofs. -/
theorem spectrum_q_one : Erdos593.Spectrum.q 1 = 2 := by
  have hlo := Erdos593.Spectrum.two_le_q 1 (by decide)
  have hhi := (Erdos593.Spectrum.q_le_iff 1 2).mpr (by norm_num)
  omega

/-- Hide decidable-instance transport at a single boundary. -/
theorem canonicalAtomCount_eq_card_index
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj] :
    canonicalAtomCount F = Nat.card (Index F) := by
  classical
  have key : ∀ (d1 d2 : DecidableEq V) (e1 e2 : DecidableEq E)
      (r1 r2 : DecidableRel F.levi.Adj),
      Nat.card (@Index V E F _ _ d1 e1 r1) =
        Nat.card (@Index V E F _ _ d2 e2 r2) := by
    intro d1 d2 e1 e2 r1 r2
    rw [Subsingleton.elim d1 d2, Subsingleton.elim e1 e2,
      Subsingleton.elim r1 r2]
  unfold canonicalAtomCount
  exact key _ _ _ _ _ _

/-- Recover intrinsic structure on the original reduced system once. -/
theorem reduced_obligatory_intrinsic_for_spectrum
    {V E : Type u} [Fintype V] [Fintype E]
    (F : TripleSystem V E) (hred : F.HasNoIsolatedPoints)
    (hobl : F.IsObligatory) : F.Intrinsic := by
  let i : TripleSystem.Iso F.isolatedReduction F :=
    { vertexEquiv := Equiv.subtypeUnivEquiv (fun x => hred x)
      edgeEquiv := Equiv.refl E
      map_inc_iff := fun _ _ => Iff.rfl }
  exact (TripleSystem.Iso.intrinsic_iff i).mp
    ((isObligatory_iff_isolatedReduction_intrinsic F).mp hobl)

/-- The parameter predicate already contains all structural hypotheses. -/
theorem ConnectedAtomParameters.toIntrinsic
    {V E : Type u} [Fintype V] [Fintype E]
    {F : TripleSystem V E} {s b k : ℕ}
    (hF : ConnectedAtomParameters F s b k) : F.Intrinsic :=
  reduced_obligatory_intrinsic_for_spectrum F hF.2.1 hF.1

/-- Positive-rank arithmetic, independent of any hypergraph representation. -/
theorem AllowedConnectedAtomCount.positive_rank_bound
    {s b k : ℕ} (h : AllowedConnectedAtomCount s b k) (hb : 1 ≤ b) :
    1 ≤ k ∧ k + 1 + Erdos593.Spectrum.q b ≤ s := by
  rcases h with ⟨hb0, _, _⟩ | ⟨hb1, hk, hs, _⟩ | ⟨_, hk, hs⟩
  · omega
  · rw [hb1, spectrum_q_one]
    omega
  · exact ⟨hk, hs⟩

/-- The numerical bound uses the actual canonical atom count. -/
theorem connected_positive_rank_atom_count_bound
    {V E : Type u} [Fintype V] [Fintype E]
    (F : TripleSystem V E) (s b k : ℕ)
    (hF : ConnectedAtomParameters F s b k) (hb : 1 ≤ b) :
    1 ≤ k ∧ k + 1 + Erdos593.Spectrum.q b ≤ s := by
  exact (connected_atom_count_necessity F s b k hF).positive_rank_bound hb

/--
For an actual finite system of positive rank, maximality among all finite
realisations with the same parameters is equivalent to the sharp formula.
The witness supplied by `exists_maximum_atom_count` rules out vacuous
maximality. No maximality or concentration conclusion is assumed by the
spectrum dependency.
-/
theorem connected_atom_count_maximal_iff
    {V E : Type u} [Fintype V] [Fintype E]
    (F : TripleSystem V E) (s b k : ℕ)
    (hF : ConnectedAtomParameters F s b k) (hb : 1 ≤ b) :
    (∀ (n m k' : ℕ) (G : TripleSystem (Fin n) (Fin m)),
      ConnectedAtomParameters G s b k' → k' ≤ k) ↔
      k = s - 1 - Erdos593.Spectrum.q b := by
  obtain ⟨hkpos, hkbound⟩ :=
    connected_positive_rank_atom_count_bound F s b k hF hb
  constructor
  · intro hmax
    have hs : 2 + Erdos593.Spectrum.q b ≤ s := by omega
    obtain ⟨n, m, G, hG⟩ := exists_maximum_atom_count s b hb hs
    have hle := hmax n m (s - 1 - Erdos593.Spectrum.q b) G hG
    omega
  · intro hkmax n m k' G hG
    obtain ⟨_, hGbound⟩ :=
      connected_positive_rank_atom_count_bound G s b k' hG hb
    omega

/--
Every system attaining the sharp positive-rank count has one minimum-order
cyclic atom carrying the full rank; every other canonical atom is a singleton
triple. Linearity and the bridge property are deduced from obligatoriness,
not added as hypotheses. The conclusion concerns `Index F`, not a chosen
assembly or a numerical surrogate for canonical atoms.
-/
theorem every_maximum_atom_count_structure
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (s b k : ℕ) (hF : ConnectedAtomParameters F s b k)
    (hb : 1 ≤ b) (hmax : k = s - 1 - Erdos593.Spectrum.q b) :
    ∃ hlinear : F.Linear, ∃ hbridge : F.BridgeAtEveryEdge,
      ∃ A : Index F,
        _root_.SimpleGraph.FiniteCycleRank.cycleRank
          (atomRestriction F hlinear hbridge A).levi = b ∧
        coreOrder F A = 2 + Erdos593.Spectrum.q b ∧
        ∀ B : Index F, B ≠ A →
          ∃ e : E, ∃ hzero :
            (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0,
            B = Index.singleton e hzero := by
  classical
  obtain ⟨_, hbound⟩ :=
    connected_positive_rank_atom_count_bound F s b k hF hb
  obtain ⟨hobl, hred, hconn, _, hcard, hrank, hkcount⟩ := hF
  have hintrinsic := reduced_obligatory_intrinsic_for_spectrum F hred hobl
  obtain ⟨hlinear, hbridge, hberge⟩ := hintrinsic
  have hkIndex : Nat.card (Index F) = k :=
    (canonicalAtomCount_eq_card_index F).symm.trans hkcount
  have hcount :
      Nat.card V = Nat.card E + Nat.card (Index F) + 1 +
        Erdos593.Spectrum.q b := by
    omega
  refine ⟨hlinear, hbridge, ?_⟩
  exact exists_concentrated_atom_of_extremal_count F hlinear hbridge hberge
    hconn b hb hrank hcount

/-- The same structure theorem from the genuine universal maximality property. -/
theorem every_maximizer_structure
    {V E : Type u} [Fintype V] [Fintype E]
    [DecidableEq V] [DecidableEq E]
    (F : TripleSystem V E) [DecidableRel F.levi.Adj]
    (s b k : ℕ) (hF : ConnectedAtomParameters F s b k) (hb : 1 ≤ b)
    (hmax : ∀ (n m k' : ℕ) (G : TripleSystem (Fin n) (Fin m)),
      ConnectedAtomParameters G s b k' → k' ≤ k) :
    ∃ hlinear : F.Linear, ∃ hbridge : F.BridgeAtEveryEdge,
      ∃ A : Index F,
        _root_.SimpleGraph.FiniteCycleRank.cycleRank
          (atomRestriction F hlinear hbridge A).levi = b ∧
        coreOrder F A = 2 + Erdos593.Spectrum.q b ∧
        ∀ B : Index F, B ≠ A →
          ∃ e : E, ∃ hzero :
            (Erdos593.SimpleGraph.bridgeFree F.levi).degree (Sum.inr e) = 0,
            B = Index.singleton e hzero := by
  exact every_maximum_atom_count_structure F s b k hF hb
    ((connected_atom_count_maximal_iff F s b k hF hb).mp hmax)

end Erdos593.TripleSystem.CanonicalAtom
