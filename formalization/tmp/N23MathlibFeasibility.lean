import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph

open scoped Cardinal

#check Cardinal.ToType
#check Cardinal.mk_toType
#check Cardinal.mk_toType'
#check Cardinal.lift_mk_toType
#check Cardinal.continuum
#check Cardinal.succ
#check Cardinal.aleph0
#check Cardinal.aleph_one
#check Cardinal.aleph_one_le_continuum
#check Cardinal.two_power_aleph0
#check Cardinal.mk_real
#check Cardinal.mk_nat
#check Cardinal.mk_fintype

abbrev N23Carrier := (Cardinal.succ Cardinal.continuum).ToType

#check N23Carrier
#check Cardinal.mk N23Carrier
#check Cardinal.mk_toType (Cardinal.succ Cardinal.continuum)
