import Erdos593.Separator.SeparatorForest

/-!
# Connected coarsenings preserve the incidence forest

Source candidate for an existing missing step in the supported-decomposition
correspondence. No new acyclicity or refinement hypothesis is put on the
coarsened objects. The hypotheses concern only the original forest and
connectivity of the actual fibres of a surjective label map.
-/

namespace E593Separator

universe u v w
variable {A : Type u} {P : Type v} {B : Type w}

/-- A concrete certificate also proves ordinary graph acyclicity. -/
theorem Certificate.isAcyclic (Inc : A → P → Prop) (C : Certificate Inc) :
    (incidenceGraph Inc).IsAcyclic := by
  classical
  apply SimpleGraph.isAcyclic_iff_forall_adj_isBridge.mpr
  have bridge : ∀ (a : A) (p : P), Inc a p →
      (incidenceGraph Inc).IsBridge s(Sum.inl a, Sum.inr p) := by
    intro a p hap
    let cut : A ⊕ P → Prop
      | .inl x => C.root p x = some ⟨a, hap⟩
      | .inr q => q ≠ p ∧ ∃ x, Inc x q ∧ C.root p x = some ⟨a, hap⟩
    have cross : ∀ (x : A) (q : P),
        ((incidenceGraph Inc).deleteEdges {s(Sum.inl a, Sum.inr p)}).Adj
          (.inl x) (.inr q) → (cut (.inl x) ↔ cut (.inr q)) := by
      intro x q h
      have hx : Inc x q := by
        simpa [incidenceGraph] using h.1
      by_cases hqp : q = p
      · subst q
        have hxa : x ≠ a := by
          intro heq
          subst x
          exact h.2 (by simp)
        have hleft : ¬ cut (.inl x) := by
          intro hc
          change C.root p x = some ⟨a, hap⟩ at hc
          rw [C.at_star p x hx] at hc
          exact hxa (congrArg Subtype.val (Option.some.inj hc))
        exact iff_of_false hleft (fun hc => hc.1 rfl)
      · constructor
        · intro hc
          exact ⟨hqp, x, hx, hc⟩
        · rintro ⟨_, y, hy, hc⟩
          change C.root p x = some ⟨a, hap⟩
          exact (C.away p q hqp x y hx hy).trans hc
    have step : ∀ {x y : A ⊕ P},
        ((incidenceGraph Inc).deleteEdges {s(Sum.inl a, Sum.inr p)}).Adj x y →
        (cut x ↔ cut y) := by
      rintro (x | q) (y | r) h
      · have := h.1
        simp [incidenceGraph] at this
      · exact cross x r h
      · exact (cross y q h.symm).symm
      · have := h.1
        simp [incidenceGraph] at this
    have along : ∀ {x y : A ⊕ P}
        (walk : ((incidenceGraph Inc).deleteEdges
          {s(Sum.inl a, Sum.inr p)}).Walk x y), cut x → cut y := by
      intro x y walk
      induction walk with
      | nil => exact id
      | cons h _ ih => exact fun hx => ih ((step h).mp hx)
    intro reachable
    obtain ⟨walk⟩ := reachable
    have hc : cut (.inl a) := C.at_star p a hap
    exact (along walk hc).1 rfl
  rintro (a | p) (b | q) h
  · simp [incidenceGraph] at h
  · exact bridge a q (by simpa [incidenceGraph] using h)
  · simpa only [Sym2.eq_swap] using
      bridge b p (by simpa [incidenceGraph] using h)
  · simp [incidenceGraph] at h

/-- Ordinary acyclicity and the explicit certificate have the same domain. -/
theorem isAcyclic_iff_nonempty_certificate (Inc : A → P → Prop) :
    (incidenceGraph Inc).IsAcyclic ↔ Nonempty (Certificate Inc) :=
  ⟨fun h => ⟨certificateOfForest Inc h⟩,
   fun ⟨C⟩ => Certificate.isAcyclic Inc C⟩

/-- Incidence on actual nonempty fibres of a label map. -/
def imageIncidence (Inc : A → P → Prop) (f : A → B) (b : B) (p : P) : Prop :=
  ∃ a : A, f a = b ∧ Inc a p

/-- Connectivity is a path in the original piece intersection graph staying
inside one fibre; it is not defined by acyclicity of the output. -/
def FibreConnected (Inc : A → P → Prop) (f : A → B) : Prop :=
  ∀ a b, f a = f b →
    Closure (fun x y => f x = f y ∧ ∃ p, Inc x p ∧ Inc y p) a b

/-- Map an original star neighbour to the corresponding image star neighbour. -/
def imageStar (Inc : A → P → Prop) (f : A → B) (p : P) :
    Star Inc p → Star (imageIncidence Inc f) p :=
  fun a => ⟨f a.val, a.val, rfl, a.property⟩

def imageRootAux (Inc : A → P → Prop) (C : Certificate Inc)
    (f : A → B) (p : P) (a : A) :
    Option (Star (imageIncidence Inc f) p) :=
  (C.root p a).map (imageStar Inc f p)

/-- The mapped root does not depend on the representative of a connected fibre. -/
theorem imageRootAux_eq (Inc : A → P → Prop) (C : Certificate Inc)
    (f : A → B) (hf : FibreConnected Inc f) (p : P)
    {a b : A} (hab : f a = f b) :
    imageRootAux Inc C f p a = imageRootAux Inc C f p b := by
  have path := hf a b hab
  clear hab
  induction path with
  | refl a => rfl
  | step h =>
      rcases h with ⟨hxy, q, hx, hy⟩
      by_cases hqp : q = p
      · subst q
        simp only [imageRootAux, C.at_star p _ hx, C.at_star p _ hy, Option.map_some]
        apply congrArg Option.some
        exact Subtype.ext hxy
      · exact congrArg (fun root => root.map (imageStar Inc f p))
          (C.away p q hqp _ _ hx hy)
  | symm _ ih => exact ih.symm
  | trans _ _ ih1 ih2 => exact ih1.trans ih2

/-- Connected coarsening has a constructed certificate, not an assumed forest. -/
noncomputable def imageCertificate (Inc : A → P → Prop) (C : Certificate Inc)
    (f : A → B) (hsurj : Function.Surjective f) (hconn : FibreConnected Inc f) :
    Certificate (imageIncidence Inc f) := by
  classical
  let rep (b : B) := Classical.choose (hsurj b)
  have rep_spec (b : B) : f (rep b) = b := Classical.choose_spec (hsurj b)
  let root (p : P) (b : B) := imageRootAux Inc C f p (rep b)
  have root_rep (p : P) (a : A) :
      root p (f a) = imageRootAux Inc C f p a :=
    imageRootAux_eq Inc C f hconn p (rep_spec (f a))
  refine ⟨root, ?_, ?_⟩
  · intro p b hb
    rcases hb with ⟨a, rfl, ha⟩
    rw [root_rep]
    simp only [imageRootAux, C.at_star p a ha, Option.map_some]
    rfl
  · intro p q hqp b d hb hd
    rcases hb with ⟨a, rfl, ha⟩
    rcases hd with ⟨c, rfl, hc⟩
    rw [root_rep, root_rep]
    exact congrArg (fun z => z.map (imageStar Inc f p))
      (C.away p q hqp a c ha hc)

/-- Coarsening along connected fibres preserves ordinary incidence acyclicity. -/
theorem imageIncidence_isAcyclic (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) (f : A → B)
    (hsurj : Function.Surjective f) (hconn : FibreConnected Inc f) :
    (incidenceGraph (imageIncidence Inc f)).IsAcyclic :=
  Certificate.isAcyclic _
    (imageCertificate Inc (certificateOfForest Inc hF) f hsurj hconn)

/-- Two coarsened pieces still meet in at most one separator. -/
theorem image_support_inter_subsingleton (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) (f : A → B)
    (hsurj : Function.Surjective f) (hconn : FibreConnected Inc f)
    {b d : B} (hbd : b ≠ d) {p q : P}
    (hbp : imageIncidence Inc f b p) (hdp : imageIncidence Inc f d p)
    (hbq : imageIncidence Inc f b q) (hdq : imageIncidence Inc f d q) : p = q := by
  by_contra hpq
  have hN := noReturn_of_isAcyclic _ (imageIncidence_isAcyclic Inc hF f hsurj hconn)
  exact hbd (hN p b d hbp hdp (Closure.step ⟨q, Ne.symm hpq, hbq, hdq⟩))

/-- The existing partition object has the usual quotient by its equivalence relation. -/
def Partition.toSetoid (R : Partition A) : Setoid A :=
  ⟨R.rel, R.refl, R.symm, R.trans⟩

abbrev Partition.Block (R : Partition A) := Quotient R.toSetoid

def Partition.block (R : Partition A) (a : A) : R.Block := Quotient.mk R.toSetoid a

theorem Partition.block_eq_iff (R : Partition A) (a b : A) :
    R.block a = R.block b ↔ R.rel a b := by
  constructor
  · intro h
    exact @Quotient.exact A R.toSetoid a b h
  · intro h
    exact @Quotient.sound A R.toSetoid a b h

theorem Partition.block_surjective (R : Partition A) : Function.Surjective R.block := by
  intro b
  refine Quotient.inductionOn b ?_
  intro a
  exact ⟨a, rfl⟩

theorem ConnectedPartition.fibreConnected (Inc : A → P → Prop) (R : Partition A)
    (hR : ConnectedPartition Inc R) : FibreConnected Inc R.block := by
  intro a b hab
  have hr := hR a b ((R.block_eq_iff a b).mp hab)
  apply Closure.map ?_ hr
  intro x y h
  exact ⟨(R.block_eq_iff x y).mpr h.1, h.2⟩

theorem connectedPartition_quotient_isAcyclic (Inc : A → P → Prop)
    (hF : (incidenceGraph Inc).IsAcyclic) (R : Partition A)
    (hR : ConnectedPartition Inc R) :
    (incidenceGraph (imageIncidence Inc R.block)).IsAcyclic :=
  imageIncidence_isAcyclic Inc hF R.block R.block_surjective
    (ConnectedPartition.fibreConnected Inc R hR)

/-- Relabelling by an injective piece map preserves the forest assertion. -/
theorem incidence_isAcyclic_of_embedding (I : A → P → Prop) (J : B → P → Prop)
    (f : A → B) (hf : Function.Injective f)
    (hI : ∀ a p, I a p → J (f a) p) (hJ : (incidenceGraph J).IsAcyclic) :
    (incidenceGraph I).IsAcyclic := by
  let g : incidenceGraph I →g incidenceGraph J :=
    ⟨Sum.map f id, by
      rintro (a | p) (b | q) h
      · simp [incidenceGraph] at h
      · simpa [incidenceGraph] using hI a q (by simpa [incidenceGraph] using h)
      · simpa [incidenceGraph] using hI b p (by simpa [incidenceGraph] using h)
      · simp [incidenceGraph] at h⟩
  apply SimpleGraph.IsAcyclic.comap g ?_ hJ
  rintro (a | p) (b | q) h
  · exact congrArg Sum.inl (hf (Sum.inl.inj h))
  · cases h
  · cases h
  · exact congrArg Sum.inr (Sum.inr.inj h)

/-- Pull a genuine equivalence relation back to the original indices. -/
def pullbackPartition (R : Partition B) (f : A → B) : Partition A where
  rel a b := R.rel (f a) (f b)
  refl a := R.refl (f a)
  symm h := R.symm h
  trans h1 h2 := R.trans h1 h2

/-- The quotient map induced by pullback is injective without any surjectivity hypothesis. -/
def pullbackBlockMap (R : Partition B) (f : A → B) :
    (pullbackPartition R f).Block → R.Block :=
  Quotient.lift (fun a => R.block (f a)) (fun _ _ h => Quotient.sound h)

theorem pullbackBlockMap_injective (R : Partition B) (f : A → B) :
    Function.Injective (pullbackBlockMap R f) := by
  intro x y
  refine Quotient.inductionOn₂ x y ?_
  intro a b h
  change R.block (f a) = R.block (f b) at h
  apply ((pullbackPartition R f).block_eq_iff a b).mpr
  exact (R.block_eq_iff (f a) (f b)).mp h

theorem pullbackBlockMap_surjective (R : Partition B) (f : A → B)
    (hf : Function.Surjective f) : Function.Surjective (pullbackBlockMap R f) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro b
  obtain ⟨a, rfl⟩ := hf b
  exact ⟨(pullbackPartition R f).block a, rfl⟩

/-- The genuine shared separators, expressed without finiteness or a numeric degree. -/
def SharedSeparator (I : A → P → Prop) (p : P) : Prop :=
  ∃ a b : A, a ≠ b ∧ I a p ∧ I b p

theorem star_subsingleton_of_not_shared (I : A → P → Prop) (p : P)
    (hp : ¬ SharedSeparator I p) : Subsingleton (Star I p) := by
  refine ⟨?_⟩
  intro a b
  apply Subtype.ext
  by_contra hab
  exact hp ⟨a.val, b.val, hab, a.property, b.property⟩

/-- Extending across empty or singleton separator stars cannot create a cycle. -/
noncomputable def certificateRestoreTrivial (I : A → P → Prop) (keep : P → Prop)
    (htriv : ∀ p, ¬ keep p → Subsingleton (Star I p))
    (C : Certificate (fun a (p : {p // keep p}) => I a p.val)) : Certificate I := by
  classical
  let root (p : P) (a : A) : Option (Star I p) :=
    if hp : keep p then C.root ⟨p, hp⟩ a
    else if hn : Nonempty (Star I p) then some (Classical.choice hn) else none
  refine ⟨root, ?_, ?_⟩
  · intro p a ha
    dsimp only [root]
    by_cases hp : keep p
    · rw [dif_pos hp]
      exact C.at_star ⟨p, hp⟩ a ha
    · rw [dif_neg hp, dif_pos (show Nonempty (Star I p) from ⟨⟨a, ha⟩⟩)]
      letI := htriv p hp
      exact congrArg Option.some (Subsingleton.elim _ _)
  · intro p q hqp a b ha hb
    dsimp only [root]
    by_cases hp : keep p
    · simp only [dif_pos hp]
      by_cases hq : keep q
      · exact C.away ⟨p, hp⟩ ⟨q, hq⟩
          (fun h => hqp (congrArg Subtype.val h)) a b ha hb
      · letI := htriv q hq
        have hab : a = b := congrArg Subtype.val
          (Subsingleton.elim (⟨a, ha⟩ : Star I q) ⟨b, hb⟩)
        rw [hab]
    · simp only [dif_neg hp]

/-- Restricting the separator carrier restricts every certificate. -/
def certificateRestrict (I : A → P → Prop) (keep : P → Prop) (C : Certificate I) :
    Certificate (fun a (p : {p // keep p}) => I a p.val) where
  root p := C.root p.val
  at_star p a ha := C.at_star p.val a ha
  away p q hqp a b ha hb := C.away p.val q.val
    (fun h => hqp (Subtype.ext h)) a b ha hb

/-- Exact equivalence between full incidence acyclicity and the manuscript's
incidence graph retaining only points shared by at least two pieces. -/
theorem isAcyclic_iff_shared_pruning (I : A → P → Prop) :
    (incidenceGraph I).IsAcyclic ↔
      (incidenceGraph (fun a (p : {p // SharedSeparator I p}) => I a p.val)).IsAcyclic := by
  constructor
  · intro h
    exact Certificate.isAcyclic _ (certificateRestrict I _ (certificateOfForest I h))
  · intro h
    exact Certificate.isAcyclic I (certificateRestoreTrivial I (SharedSeparator I)
      (star_subsingleton_of_not_shared I) (certificateOfForest _ h))

end E593Separator
