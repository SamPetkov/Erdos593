import Erdos593.TripleSystem.TriangleHostLinearity
import Erdos593.TripleSystem.Obligatory

namespace Erdos593

universe u

namespace TripleSystem
namespace TriangleHost

/-- A minimal Ramsey hypothesis: every natural colouring of the pair-vertices
has a triangle whose three pair-faces receive one common colour. -/
def RamseyNat (\kappa : Type u) [DecidableEq \kappa] : Prop :=
  \forall c : Pair \kappa \to \mathbb{N}, \exists t : Triangle \kappa,
    \forall p q : Pair \kappa,
      p.1 \subseteq t.1 \to q.1 \subseteq t.1 \to c p = c q

/-- Under `RamseyNat`, the triangle host has no proper natural colouring. -/
theorem not_isProperColoring_nat_of_ramseyNat
    (\kappa : Type u) [DecidableEq \kappa]
    (hRamsey : RamseyNat \kappa) (c : Pair \kappa \to \mathbb{N}) :
    \neg (system \kappa).IsProperColoring c := by
  intro hc
  obtain \langle t, ht \rangle := hRamsey c
  rcases hc t with \langle x, hx, y, hy, hxy \rangle
  apply hxy
  exact ht x y hx hy

/-- Equivalently, the triangle host admits no natural proper colouring. -/
theorem no_natProperColoring_of_ramseyNat
    (\kappa : Type u) [DecidableEq \kappa]
    (hRamsey : RamseyNat \kappa) :
    \neg \exists c : Pair \kappa \to \mathbb{N}, (system \kappa).IsProperColoring c := by
  rintro \langle c, hc \rangle
  exact not_isProperColoring_nat_of_ramseyNat \kappa hRamsey c hc

end TriangleHost
end TripleSystem
end Erdos593
