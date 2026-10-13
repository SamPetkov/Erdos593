# Second continuation: an exact obstruction to ordered-fan positivity

## Verdict and scope

The unrestricted common-power density target and its proposed complete-cover comparison remain unresolved here. The result below is an exact failure of a newly tested sufficient mechanism: positivity of the mode coefficient obtained by expanding the `ac` edge, even when both fan exponent pairs are ordered as the target requires. It is distinct from the previously supplied negative `ab`-mode example.

The actual host below is strictly positive, its selected mode has strictly positive eigenvalue, and the tuple satisfies `k>=u`, `r>=l`, and `h>=1`. Its full density is certified strictly above one. This is therefore an obstruction to ordered-fan modewise positivity, not a target or cover counterexample.

## 1. The exact coefficient being tested

For the original finite probability space, define the actual fan source

`f_i^(s,t)(b,d)=E_(a~mu) phi_i(a) K_s(a,b) K_t(a,d)`.

Expanding only the `ac` edge in the exact target and integrating the actual variables `a,c` gives

`F=sum_i theta_i^(r+h) w_i`,

`w_i=E_(b,d~mu) K_u(b,d) f_i^(k,u)(b,d) f_i^(r,l)(b,d)`.

The two exponent pairs `(k,u)` and `(r,l)` are ordered under the target hypotheses. No arbitrary source functions have been substituted. The proposed stronger claim was that these particular ordered-pair correlations are always nonnegative.

For the complete orthonormal multiplication tensor

`C_ijk=E_mu phi_i phi_j phi_k`,

the exact finite coefficient formula is

`w_i=sum_(j,z,j',z',q) theta_j^k theta_z^u theta_j'^r theta_z'^l theta_q^u C_ijz C_ij'z' C_jj'q C_zz'q`.

This formula is used below only with the actual moments of the specified host.

## 2. An actual strictly positive host

Use six signs in the order

`(R_ab,R_ac,R_ad,R_bc,R_bd,R_cd)`.

Put

`S_a=R_ab R_ac R_ad`, `S_b=R_ab R_bc R_bd`,

`S_c=R_ac R_bc R_cd`, `S_d=R_ad R_bd R_cd`.

The state space is the 32-element set

`X={R in {-1,1}^6 : S_a+S_b+S_c-S_d=2}`,

with its original uniform probability `mu=1/32`. Equivalently its mass on the full 64-element cube is

`2^(-6)[1+(S_a+S_b+S_c-S_d)/2]`.

Let `phi_0=1`, and let `phi_1,...,phi_6` be the six displayed signs. They are centered orthonormal functions. Their nonzero cubic moments are precisely `C_000=1`, `C_0ii=1` and permutations, together with the distinct star triples

`C_123=C_145=C_246=1/2`, `C_356=-1/2`,

and their permutations. Repeated centered cubic moments vanish.

Choose the positive root coefficients

`s=(2^(-20), 1/8, 1/8, 1/2, 2^(-10), 1/8)`

and define the actual relative-measure kernel

`T(x,y)=1+sum_(j=1)^6 s_j phi_j(x)phi_j(y)`.

Here

`sum_j s_j=918529/1048576<1`,

so every entry is strictly positive; its row sums relative to the original `mu` are one. Its maximum is attained on every diagonal and equals `1967105/1048576`. Therefore

`p=1048576/1967105`, `W=pT`

is a symmetric strictly positive host in `[0,1]` with every original-measure row sum equal to `p`.

The actual square `A=T^2` has active eigenvalues `theta_j=s_j^2`. All other 25 centered eigenvalues are zero. Thus there are four positive centered values and an additional zero value; no two-band premise is being invoked.

## 3. A negative coefficient with both ordered fan pairs

Take

`(k,u,r,l,h)=(6,1,1,1,1)`

and the actual mode `phi_1=R_ab`. Its eigenvalue is `t=theta_1=2^(-40)>0`. The two fan pairs are `(6,1)` and `(1,1)`.

Substitution of the actual cubic moments into the finite coefficient formula gives the following short exact polynomial. Define

`b=2^(-19)+2^(-26)+2^(-44)`,

`a=b+2^(-36)+2^(-48)+2^(-54)+3*2^(-58)+2^(-126)+2^(-144)+2^(-148)`.

Then

`w_1=-2^(-56)-2^(-73)-3*2^(-146)+a t+t^2+t^3+b t^6+t^7+t^8`.

This identity can be checked by the displayed seven-index multiplication table and a finite sum; the independent direct-source check below does not require trusting the collection of monomials.

It also gives a simple exact sign bound. We have `a<2^(-18)`, `0<b<1`, and, at `t=2^(-40)`,

`t^2+t^3+b t^6+t^7+t^8<2t^2=2^(-79)`.

Consequently

`w_1<-2^(-56)+2^(-58)+2^(-79)<-2^(-57)<0`.

The exact value is

`w_1=-25908675969415941482969103743877699232242578026326762535140335342354156769771519 / 2^320`.

Since `theta_1^(r+h)=2^(-80)>0`, this is also a genuinely negative weighted contribution in the `ac`-edge expansion. It is not an eigenvalue-zero artifact.

### How the negative constant term arises

At `theta_1=0`, the only fan pairs for this mode are `(2,3),(3,2),(4,5),(5,4)`. Put `x=theta_2=theta_3=2^(-6)`, `z=theta_4=2^(-2)`, `v=theta_5=2^(-20)`, and `theta_6=2^(-6)`. The positive same-pair part is

`(1/4)[2 x^9+z^7 v^2+v^7 z^2]`,

while the negative star-coupling part is

`-(theta_6/16)[2 x^7 z v+z^6 v x^2+v^6 z x^2]`.

Their sum is exactly `-2^(-56)-2^(-73)-3*2^(-146)`. The two ordered fans weight the same actual multiplication-tensor coordinates very differently; their coordinate signs alone do not determine the sign of the weighted pairing.

## 4. The full density is strictly above one

For this same host and tuple, exact finite summation gives

`F=1+G/2^400`,

where the positive integer is

`G=53047964877241186958143039567241805346358222654157490333030570521999807694119299278485580305198804410382063801422839809`.

In particular `F>1`. Its decimal value, for scale only, is approximately `1.0205433119882814`; no decimal comparison is used for the certificate.

There is also a prior analytical certification: `p=1048576/1967105>1/4`, and the previously proved two-diamond compensation threshold at `r=l` is at most `1/4`. That established restricted theorem therefore applies. The example is intentionally not being presented as a new density class.

The exact density was evaluated using the active spectral expansion

`sum_(a,b,c,d,e,f=0)^6 theta_a^6 theta_b^2 theta_c theta_d theta_e theta_f C_abc C_ade C_bdf C_cef`.

The zero-eigenvalue complement contributes nothing because every edge exponent is positive. The moments used in this expression were independently recomputed over all 32 original states.

## 5. Independent finite check using actual sources

The following standard-library Python calculation constructs all original states, verifies orthonormality and `T^2=K_1` under `mu`, integrates both actual fan sources directly, and checks the exact negative bound and full-density certificate. It uses no floating-point arithmetic.

```python
from fractions import Fraction as Q
from itertools import product

states = []
for signs in product((-1, 1), repeat=6):
    ab, ac, ad, bc, bd, cd = signs
    sa, sb, sc, sd = ab*ac*ad, ab*bc*bd, ac*bc*cd, ad*bd*cd
    if sa + sb + sc - sd == 2:
        states.append(signs)
assert len(states) == 32
phi = [[1] + list(x) for x in states]
mu = Q(1, 32)
assert all(sum(mu*phi[x][i]*phi[x][j] for x in range(32)) == int(i == j)
           for i in range(7) for j in range(7))
C = [[[sum(mu*phi[x][i]*phi[x][j]*phi[x][k] for x in range(32))
       for k in range(7)] for j in range(7)] for i in range(7)]
s = [Q(1), Q(1, 2**20), Q(1, 8), Q(1, 8),
     Q(1, 2), Q(1, 2**10), Q(1, 8)]
theta = [x*x for x in s]
T = [[sum(s[i]*phi[a][i]*phi[b][i] for i in range(7))
      for b in range(32)] for a in range(32)]
assert min(map(min, T)) > 0
assert max(map(max, T)) == Q(1967105, 1048576)
assert all(sum(mu*T[a][b] for b in range(32)) == 1 for a in range(32))
K = {e: [[sum(theta[i]**e*phi[a][i]*phi[b][i] for i in range(7))
           for b in range(32)] for a in range(32)] for e in (1, 2, 6)}
assert all(K[1][a][b] == sum(mu*T[a][x]*T[x][b] for x in range(32))
           for a in range(32) for b in range(32))
f61 = [[sum(mu*phi[a][1]*K[6][a][b]*K[1][a][d] for a in range(32))
        for d in range(32)] for b in range(32)]
f11 = [[sum(mu*phi[a][1]*K[1][a][b]*K[1][a][d] for a in range(32))
        for d in range(32)] for b in range(32)]
w = sum(mu*mu*K[1][b][d]*f61[b][d]*f11[b][d]
        for b in range(32) for d in range(32))
t = Q(1, 2**40)
b = Q(1, 2**19) + Q(1, 2**26) + Q(1, 2**44)
a = b + Q(1, 2**36) + Q(1, 2**48) + Q(1, 2**54) + Q(3, 2**58)
a += Q(1, 2**126) + Q(1, 2**144) + Q(1, 2**148)
poly = -Q(1, 2**56) - Q(1, 2**73) - Q(3, 2**146)
poly += a*t + t*t + t**3 + b*t**6 + t**7 + t**8
assert w == poly and w < -Q(1, 2**57)
F = Q(0)
for ab, ac, ad in product(range(7), repeat=3):
    ca = C[ab][ac][ad]
    if not ca:
        continue
    for bc, bd in product(range(7), repeat=2):
        cb = C[ab][bc][bd]
        if not cb:
            continue
        for cd in range(7):
            cc, dd = C[ac][bc][cd], C[ad][bd][cd]
            if cc and dd:
                F += (ca*cb*cc*dd*theta[ab]**6*theta[ac]**2
                      *theta[ad]*theta[bc]*theta[bd]*theta[cd])
G = 53047964877241186958143039567241805346358222654157490333030570521999807694119299278485580305198804410382063801422839809
assert F == 1 + Q(G, 2**400) and F > 1
```

The audit was also independently repeated by the root agent from the original 32 states. It reproduced the actual fan pairing and full density. This is an analytical finite certificate, not Lean verification or a literature-novelty claim.

## 6. Consequence for the open cover route

The tuple inequalities do align the signs of the symmetrized and antisymmetrized scalar fan coefficients. They do not make the actual `K_u` multiplication form entrywise positive in those coordinates. The example proves that such alignment cannot establish the needed ac-mode positivity in general.

Complete cover comparisons remain a collective question. This negative coefficient does not show that any complete two-sheet cover exceeds `F^2`, and no such conclusion is drawn.

### The precise reflection route blocked by this example

After sheet relabellings make the `ab,ac,ad` matchings identity, a two-sheet cover is specified by three bits for `bc,bd,cd`. Besides the trivial `000` cover, six possibilities are gauge-equivalent to switching just one base edge: `100,010,001` correspond to `bc,bd,cd`, while `110,101,011` correspond to `ab,ac,ad`. The remaining `111` case is the bipartite double cover. Sheet relabellings preserve every original node weight and edge label.

For one switched edge `e=xy`, let `H_e(x,y)` be the actual two-terminal kernel obtained by integrating the other two vertices in `K4-e`, retaining their original measures and all five other edge powers. This kernel is entrywise nonnegative but is generally not symmetric, because the powers incident to its two terminals can differ. Direct expansion of the two copies gives

`F=tr(K_(n_e) H_e^*)`,

`Z_switch=tr((K_(n_e) H_e^*)^2)`.

If `H_e` were self-adjoint PSD, the nonnegative eigenvalues of `K_(n_e)^(1/2) H_e K_(n_e)^(1/2)` would imply `Z_switch<=F^2`. This conditional argument uses one PSD sandwich, not a sign claim for a generic product of three PSD matrices.

For the long edge `ac` in the displayed actual example,

`<phi_1,H_ac phi_1>_mu=w_1<0`.

Thus the example blocks precisely that PSD two-terminal reflection proof for a target-compatible long-edge switch. The six complete trace comparisons and the bipartite-double-cover comparison are not settled by this diagnostic.

### An exact collective identity without a symmetry assumption

There is an alternative sandwich that preserves actual entrywise nonnegativity. Put `C=T^(n_e)`, with the original-measure composition. Then `C` is entrywise nonnegative and self-adjoint, and `C^2=K_(n_e)`. It need not be PSD. Let

`B=C H_e C`, `S=(B+B^*)/2`, `J=(B-B^*)/2`.

The kernel `B` is entrywise nonnegative. Cyclicity of the finite weighted operator trace, self-adjointness of `K_(n_e)`, and invariance of trace under adjoints give

`tr(B)=F`, `tr(B^2)=Z_switch`.

Since `S` is self-adjoint and `J` is skew-adjoint, `tr(SJ)=0` and `tr(J^2)=-||J||_HS^2`. Consequently the exact collective comparison is

`F^2-Z_switch=(tr S)^2-tr(S^2)+||J||_HS^2`.

All operators and the Hilbert–Schmidt norm here use the original `mu`. The positive skew term is retained. The identity alone supplies no sign for the complete expression.

For the `ac` example, `C phi_1=s_1^(n_e) phi_1` with `s_1>0`, so

`<phi_1,S phi_1>_mu=s_1^(2 n_e) w_1<0`.

Thus even the symmetric part of this actual nonnegative sandwich is not PSD. A valid complete-cover proof through this identity would have to control its collective trace deficit together with the skew term; it cannot assert PSD of this symmetric part. This is a precise obstruction to that sufficient mechanism and remains distinct from failure of the full cover comparison.
