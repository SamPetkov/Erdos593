import Mathlib.SetTheory.Cardinal.Continuum
import Mathlib.SetTheory.Cardinal.Aleph

open scoped Cardinal

#check Cardinal.out
#check Cardinal.mk_out
#check Cardinal.outMkEquiv
#check Cardinal.continuum
#check Order.succ
#check Cardinal.aleph0
#check Cardinal.aleph
#check Cardinal.aleph_one_le_continuum
#check Cardinal.two_power_aleph0
#check Cardinal.mk_real
#check Cardinal.mk_nat
#check Cardinal.mk_fintype

abbrev N23Carrier := (Order.succ Cardinal.continuum).out

#check N23Carrier
#check Cardinal.mk N23Carrier
#check Cardinal.mk_out (Order.succ Cardinal.continuum)
