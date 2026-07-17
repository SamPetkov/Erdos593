import Mathlib.SetTheory.Cardinal.Continuum

noncomputable section

open scoped Cardinal

abbrev ErdosRadoCarrier : Type u :=
  (Order.succ (Cardinal.continuum : Cardinal.{u})).out

instance : DecidableEq ErdosRadoCarrier := Classical.decEq _

theorem mk_erdosRadoCarrier :
    #ErdosRadoCarrier = Order.succ (Cardinal.continuum : Cardinal.{u}) :=
  Cardinal.mk_out _
