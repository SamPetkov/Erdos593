import Erdos593.TripleSystem.TriangleHostRamsey
import Mathlib.SetTheory.Cardinal.Continuum

noncomputable section

open scoped Cardinal

abbrev ErdosRadoCarrier : Type u :=
  (Order.succ (Cardinal.continuum : Cardinal.{u})).out

instance : DecidableEq ErdosRadoCarrier := Classical.decEq _

theorem erdosRadoCarrier_cardinal :
    #ErdosRadoCarrier = Order.succ (Cardinal.continuum : Cardinal.{u}) :=
  Cardinal.mk_out _

#check Erdos593.TripleSystem.TriangleHost.PairRamseyTriangle ErdosRadoCarrier
