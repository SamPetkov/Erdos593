import Mathlib.Data.Set.PowersetCard

universe u

abbrev PairCheck (κ : Type u) := Set.powersetCard κ 2
abbrev TriangleCheck (κ : Type u) := Set.powersetCard κ 3

example {κ : Type u} {t u : TriangleCheck κ}
    (h : (fun e : TriangleCheck κ => {p : PairCheck κ | p.1 ⊆ e.1}) t =
      (fun e : TriangleCheck κ => {p : PairCheck κ | p.1 ⊆ e.1}) u)
    {p : PairCheck κ} (hp : p.1 ⊆ t.1) : p.1 ⊆ u.1 := by
  exact (Set.ext_iff.mp h p).mp hp
