# Information retained by the actual Markov loop

The loop route retains a genuine four-variable semigroup law.
Its pair marginals alone do not determine a density lower bound of one,
even if **all six** pair marginals are retained. This is a limitation of
that relaxation, not a counterexample to the original density.

## Actual law and covariance bound

With the original-law conventions of [the compensation derivation](ordered-negative-mass.md),
put \(C=1+\sigma(2u+2r+h)\) and
\[
\rho(a,b,c,d)=\frac{\mu_a\mu_b\mu_c\mu_d}{C}
 K_u(a,d)K_u(b,d)K_r(b,c)K_{r+h}(a,c).
\]
Composition gives its normalization \(C\), and the chord marginals
\[
\rho_{ab}=\frac{\mu_a\mu_b}{C}K_{2u}(a,b)K_{2r+h}(a,b),\qquad
\rho_{cd}=\frac{\mu_c\mu_d}{C}K_{r+u}(c,d)K_{r+h+u}(c,d).
\]
For \(X_0=K_k(a,b),Y_0=K_l(c,d)\), \(F=C\mathbb E_\rho X_0Y_0\).
Writing \(H_{ab},H_{cd}\) for the original-law integrals inserting the
respective chord in the displayed pair marginals, and \(J_{ab},J_{cd}\)
for the corresponding pointwise-squared insertions, covariance
Cauchy--Schwarz gives
\[
F\ge\frac{H_{ab}H_{cd}}C-
 \sqrt{\left(J_{ab}-H_{ab}^2/C\right)
             \left(J_{cd}-H_{cd}^2/C\right)}.
\]
There is no general proof here that this lower bound reaches one.

## An exact pair-marginal countermodel

Take the actual positive binary root
\(\mu(\pm1)=1/2,\ T(x,y)=1+xy/2\), so
\(K_j(x,y)=1+\theta^jxy\) with \(\theta=1/4\).
At \((k,u,r,l,h)=(5,4,3,2,1)\), put
\[
C=1+\theta^{15},\quad
m=(\theta^7+\theta^8)/C,\quad
s=(\theta^4+\theta^{11})/C,\quad
t=(\theta^3+\theta^{12})/C.
\]
The actual loop has pair correlations \(ab=cd=m\),
\(ac=ad=bd=s\), and \(bc=t\). Its fourth correlation is \(m>0\).

Instead consider the **different** law on four fair signs
\[
P(a,b,c,d)=\frac1{16}
 \{1+m(ab+cd)+s(ac+ad+bd)+tbc-\tfrac9{10}abcd\}.
\]
It has exactly the same six full pair marginals as \(\rho\).
Indeed summing over the other two signs removes every other monomial.
It is strictly positive: direct rational bounds give
\(2m+3s+t\le225/4096<1/10\), so the bracket is at least
\(1/10-(2m+3s+t)>0\). Its constant coefficient gives total mass one.

Nevertheless,
\[
C\mathbb E_P[(1+\theta^5ab)(1+\theta^2cd)]
=\frac{35182609779915}{35184372088832}<1,
\]
whereas the actual common-power density is
\[
F=1+\theta^9+\theta^{10}+\theta^{12}+\theta^{13}
              +\theta^{14}+2\theta^{15}
 =\frac{536873515}{536870912}>1.
\]
The fourth moment of \(P\) is \(-9/10\), rather than the actual loop's
positive \(m\). Thus a compensation argument must retain higher-order
semigroup structure. Changing the joint law while preserving its pairs
is not an admissible alteration of the actual density.

The [short exact checker](check_loop_information.py) derives the law
from actual weighted matrix powers, checks every pair table and all
sixteen probabilities, and reproduces both fractions. It is a finite
algebraic diagnostic, not a universal density proof or Lean validation.
