# Third continuation: a commuting coarse-domination obstruction

## Status and scope

The unrestricted common-power density target is unresolved by this note.
Section 3 proves a different exact result: an explicit rational 18-state
strictly positive actual root, with commuting coarse and signed-channel
operators, satisfies `1<F(T)<F(S)` at a target-compatible tuple. Thus general
commuting coarse domination and individual signed-cycle positivity are
false; the original target and complete-cover comparisons are not refuted.

Section 1 gives a projection-supported extension of the prior flat-coarse
theorem. Section 2 supplies the exact negative compressed-power trace used
in the admissible construction of Section 3. The seed matrix by itself is
not asserted to be a Markov root.

## 1. Replacing the coarse constant projection by a Markov projection

Let `S` be an actual nonnegative self-adjoint Markov kernel on the original
finite probability `(I,pi)`, and let `H` be a real symmetric relative kernel
with `|H(i,j)|<=S(i,j)`. Form the actual uniform binary-fiber root
`T((i,a),(j,b))=S(i,j)+H(i,j)ab` on `mu(i,a)=pi_i/2`.
Suppose

`S^2=rho Id+(1-rho)P`, `0<=rho<1`,

where `P` is an entrywise nonnegative self-adjoint Markov projection. Then
for all six independent positive K4 edge exponents,

`F(T;n)>=F(S;n)>=1`.

No commutation hypothesis on `S,H` is required. The case `rho=1` is already
part of the flat-square theorem and does not need the projection below.

### Projection blocks and support

A finite nonnegative self-adjoint Markov projection is conditional averaging
on a partition `I=B_1 union ... union B_q`. Indeed, in each irreducible support
component its associated stochastic matrix has a simple eigenvalue one;
idempotence makes every other eigenvalue zero. Hence that component has rank
one, and its invariant probability is the restriction of `pi` normalized by
its component mass. Write `m_j=sum_(i in B_j) pi_i` and
`nu_j(i)=pi_i/m_j`. Then

`P(i,i')=1/m_j` for `i,i' in B_j`, and zero between distinct blocks.

For points in different blocks, `S^2(i,i')=0`. Since every original-weight
summand in `sum_z pi_z S(i,z)S(z,i')` is nonnegative, all those products
vanish. The bound `|H|<=S` therefore implies

`H^2(i,i')=sum_z pi_z H(i,z)H(z,i')=0`.

Thus `C=H^2` and all its powers preserve the same blocks.

### Original-measure transport

On block `B_j`, the conditional relative kernels are

`A_j=m_j S^2|_(B_j x B_j)` and `C_j=m_j C|_(B_j x B_j)`.

Original-`nu_j` composition gives `A_j^n=m_j S^(2n)|_B` and
`C_j^n=m_j H^(2n)|_B`. Here

`A_j=rho Id_(nu_j)+(1-rho)Pi_(nu_j)`,

and `C_j` is PSD. The seven-cycle proof of the flat signed-channel theorem
uses only that the channel factors are common positive powers of one PSD
operator; it does not require a separately nonnegative square root inside
this conditional block. That proof therefore applies to `A_j,C_j`.

Every connected K4 assignment must have all four coarse colors in one
block. Four original vertex weights and six relative-kernel factors give
exactly `m_j^(4-6)=m_j^(-2)`. Summing the blockwise nonnegative differences
proves the first inequality. The same transport and the flat coarse-square
bound give `F(S)>=sum_j m_j^(-2)>=1`.

This extension also allows an actual connected bipartite coarse root whose
square has two components. It does not extend by the same reasoning when a
positive global `Pi` term connects the blocks of `P`.

## 2. An exact negative trace of three compressed common PSD powers

The following proposed sufficient claim is false:

`tr((E C E)(E C^2 E)(E C^3 E))>=0`

for every PSD `C` and orthogonal projection `E`. In particular, compressed
powers need not retain the commutation that made their uncompressed trace
nonnegative.

Here is a five-dimensional rational construction. Let `e_0,...,e_4` be the
standard Euclidean basis and `t=1/16`. For orthogonal unit vectors `w,e` and
rational `c,s` with `c^2+s^2=1`, define

`G(w,e;c,s)=I+(c-1)(ww^T+ee^T)+s(we^T-ew^T)`.

This matrix is orthogonal, sends `e` to `s w+c e`, and acts as the identity
on the orthogonal complement of their plane. Set

`w_2=(3e_0+4e_1)/5`, `w_3=(3e_0-4e_1)/5`,

`U=G(e_0,e_2;63/65,16/65)`

`  *G(w_2,e_3;(1-t^6)/(1+t^6),2t^3/(1+t^6))`

`  *G(w_3,e_4;(1-t^16)/(1+t^16),2t^8/(1+t^16))`,

and

`R=U diag(0,0,t^4,t^2,1) U^T`, `C=R^2`.

Thus `R` is an exact rational PSD symmetric matrix with operator norm one,
and `C` is its actual algebraic square. Let `E` project onto
`span{e_0,e_1}`. Direct exact calculation gives

`tau=tr((E R^2 E)(E R^4 E)(E R^6 E)) < -2^(-156) < 0`.

The three compressed matrices are individually PSD. For scale only,
`tau` is approximately `-1.2813708419833329e-47`; the certificate below uses
no floating point arithmetic.

### Fully reproducible exact certificate

```python
from fractions import Fraction as Q

n = 5

def eye():
    return [[Q(i == j) for j in range(n)] for i in range(n)]

def transpose(a):
    return [list(x) for x in zip(*a)]

def mm(a, b):
    return [[sum(a[i][k]*b[k][j] for k in range(len(b)))
             for j in range(len(b[0]))] for i in range(len(a))]

def rotation(w, e, c, s):
    assert sum(x*x for x in w) == sum(x*x for x in e) == 1
    assert sum(x*y for x, y in zip(w, e)) == 0
    assert c*c+s*s == 1
    return [[Q(i == j)+(c-1)*(w[i]*w[j]+e[i]*e[j])
             +s*(w[i]*e[j]-e[i]*w[j])
             for j in range(n)] for i in range(n)]

e = eye()
t = Q(1, 16)
w2 = [Q(3, 5), Q(4, 5), Q(0), Q(0), Q(0)]
w3 = [Q(3, 5), Q(-4, 5), Q(0), Q(0), Q(0)]
g1 = rotation(e[0], e[2], Q(63, 65), Q(16, 65))
g2 = rotation(w2, e[3], (1-t**6)/(1+t**6), 2*t**3/(1+t**6))
g3 = rotation(w3, e[4], (1-t**16)/(1+t**16), 2*t**8/(1+t**16))
U = mm(mm(g1, g2), g3)
assert mm(U, transpose(U)) == eye()
d = [Q(0), Q(0), t**4, t**2, Q(1)]
R = mm([[U[i][j]*d[j] for j in range(n)] for i in range(n)], transpose(U))
assert R == transpose(R)
R2 = mm(R, R)
R4 = mm(R2, R2)
R6 = mm(R4, R2)
X = [[[a[i][j] for j in range(2)] for i in range(2)]
     for a in (R2, R4, R6)]
product = mm(mm(X[0], X[1]), X[2])
tau = product[0][0]+product[1][1]
assert tau < -Q(1, 2**156)
```

All orthogonality and arithmetic assertions in this block were executed.
The construction remains valid as a negative compressed trace after scaling
`R` by any nonzero real scalar. The seed alone does not give an admissible
host. Section 3 supplies the original-measure embedding and proves its exact
scope separately.

## 3. An actual commuting obstruction to general coarse domination

**Exact verdict.** The proposed extension `F(T)>=F(S)` to arbitrary commuting
coarse and signed-channel operators is false. The explicit rational
18-state construction below satisfies

`1 < F(T;n) < F(S;n)`

at the admissible tuple `(k,u,r,l,h)=(8,2,3,1,1)`, with `S H=H S` under the
original coarse measure. Its actual fine root is strictly positive and PSD.
This is a counterexample to that stronger contraction, not to the original
target `F(T;n)>=1`.

The construction refines the ten-state amplification argument in
[continuation3_markov.md](continuation3_markov.md) by putting the entire
channel into the centered subspaces of four coarse blocks. This makes the
coarse and channel operators commute exactly.

### Complete rational host data

Use the rational matrix `R`, number `t=1/16`, and negative trace `tau` from
Section 2; set `eta=2^(-156)`. Define a rational `9 x 5` isometry `V` as
follows. Its first two columns are supported on coordinates `0,1,2`, with
values

`(2,1,-2)/3` and `(2,-2,1)/3`.

Its next three columns are supported, respectively, on coordinate pairs
`(3,4)`, `(5,6)`, `(7,8)`, and each has values `(4,-3)/5`. All omitted entries
are zero. Then `V^T V=Id_5`. Put

`Rbar=V R V^T`.

This is a rational PSD contraction. Choose

`L=2^41`,

`w=(1,2,2,3L,4L,3L,4L,3L,4L)`,

`D=9+75L^2=sum_i w_i^2`, `pi_i=w_i^2/D`.

The coarse partition has blocks

`B_0={0,1,2}`, `B_1={3,4}`, `B_2={5,6}`, `B_3={7,8}`.

Its original block masses are

`m_0=9/D`, `m_1=m_2=m_3=25L^2/D`.

Let `P(i,j)=1/m_B` when `i,j` lie in the same block `B`, and zero otherwise.
As always, `Id(i,j)=1_(i=j)/pi_i` and `Pi(i,j)=1` are relative kernels. Set

`epsilon=eta/(65536 D^4)`, `delta=epsilon/(2D)`,

`S=epsilon Id+(1-2epsilon)P+epsilon Pi`,

`H(i,j)=epsilon Rbar_ij/(2w_iw_j)`.

On the 18 states `X={0,...,8} x {-1,+1}`, define

`mu(i,a)=pi_i/2`,

`T((i,a),(j,b))=S(i,j)+H(i,j)ab`,

`p=1/(2D)`, `W=pT`.

These formulas specify every host entry and every original mass using only
rational numbers.

### Admissibility and exact commutation

Every entry of `S` is at least `epsilon`. Since `Rbar` is a contraction and
`w_i>=1`, `|H(i,j)|<=epsilon/2`. Thus `T>=epsilon/2>0` entrywise. Symmetry is
immediate, and averaging the target fiber sign with its original mass `1/2`
gives the Markov row sum one. Also `S<=D` entrywise, so

`0<T<=D+epsilon/2<2D`, `0<W<1`.

Every original-`mu` weighted row of `W` is therefore exactly `p`.

Conjugation of a relative kernel to Euclidean coordinates uses
`diag(sqrt(pi))` on both sides. The Euclidean block-constant vectors are
`(1,2,2)/3` in `B_0` and `(3,4)/5` in each other block. They are orthogonal
to every column of `V`. Consequently

`P H=H P=0`, `Pi H=H Pi=0`,

where these products use the original `pi`. Hence

`S H=H S=epsilon H`.

The Euclidean representative of `H` is exactly `delta Rbar`; thus it is PSD.
The fine root is PSD as well, since its even and odd fiber subspaces carry
`S` and `H`. Actual entrywise positivity was proved separately above.

The coarse square has the exact form

`S^2=epsilon^2 Id+(1-2epsilon)P+(2epsilon-epsilon^2)Pi`.

All three coefficients are strictly positive. This example is therefore
inside the proposed nested-projection coarse-square class, with no coarse
coefficient placed at an endpoint.

### The actual cycle expansion

Use the exact target tuple

`(k,u,r,l,h)=(8,2,3,1,1)`,

so the edge exponents on `(ab,ac,ad,bc,bd,cd)` are

`n=(8,4,2,3,2,1)`, `N=20`.

Define `H_0(i,j)=D Rbar_ij/(w_iw_j)`, so that `H=delta H_0`. Original-measure
composition gives, for every positive integer `q`,

`H_0^q(i,j)=D (Rbar^q)_ij/(w_iw_j)`.

The two factors of the intermediate `w_j` cancel its original mass
`pi_j=w_j^2/D`. Since `Rbar` is a PSD contraction, every displayed kernel
power has absolute value at most `D`.

Averaging the four actual independent fiber signs gives

`F(T;n)-F(S;n)=sum_C delta^(2q_C) Gamma_C(epsilon)`,

where `C` runs over the four triangles and three quadrilaterals,
`q_C=sum_(e in C)n_e`, and

`Gamma_C(epsilon)=E_(pi^4) product_(e in C)H_0^(2n_e)
                              product_(e notin C)S^(2n_e)`.

This is an identity for the actual host, with no arbitrary sources. The
cycle weights are

| Cycle | Weight |
|---|---:|
| `bcd` | 6 |
| `acd` | 7 |
| `abd` | 12 |
| `abc` | 15 |
| `a-b-c-d-a` | 14 |
| `a-b-d-c-a` | 15 |
| `a-c-b-d-a` | 11 |

Thus `bcd` is the unique term of smallest channel degree.

### Exact weighted amplification of the negative trace

Replace the three coarse factors complementary to `bcd` by `P`, and call
the resulting coefficient `Gamma_0`. The hub and triangle vertices must
then be in one block `B`. The three relative-kernel factors contribute
`m_B^(-3)` and summing the hub's original mass contributes `m_B`. The
remaining original weights convert the channel cycle to an ordinary
compressed Euclidean trace. Therefore

`Gamma_0=D^2 tau/81
       +D^2/(625L^4) sum_(j=2)^4 (R^2)_jj (R^4)_jj (R^6)_jj`.

In the first block, restriction of `Rbar` to its two-dimensional centered
space is exactly the seed compression to coordinates `0,1`. Each other
block has one channel coordinate, giving the displayed diagonal product.
Each product belongs to `[0,1]`. Since `tau<-eta` and `L^4=2^164`,

`3/(625L^4)=3eta/160000 <= eta/162`,

and hence

`Gamma_0 <= -D^2 eta/162`.

### Keeping all parameters strictly positive

The nested projections give

`S^q=epsilon^q Id+[(1-epsilon)^q-epsilon^q]P
                  +[1-(1-epsilon)^q]Pi`.

Its coefficients are nonnegative. Thus `|S^q(i,j)|<=D`, and Bernoulli's
inequality gives

`||S^q-P||_max <= (q+1)epsilon D`.

The three complementary root powers at the leading triangle are `16,8,4`.
Telescoping their product, while bounding each of the three channel factors
by `D`, proves

`|Gamma_bcd(epsilon)-Gamma_0| <= (17+9+5)epsilon D^6
                            =31eta D^2/65536
                            <=eta D^2/324`.

Consequently

`Gamma_bcd(epsilon)<=-eta D^2/324<0`.

This already refutes individual-cycle positivity under the actual-root and
commutation requirements. To control the complete difference, every other
cycle has weight at least seven and `|Gamma_C|<=D^6`. The exact parameters
satisfy

`delta^2<=eta/(3888D^4)`.

Therefore the other six terms have total contribution at most
`6D^6 delta^14`, and the full actual difference obeys

`F(T;n)-F(S;n)
 <=delta^12[-eta D^2/324+6D^6 delta^2]
 <=-eta D^2 delta^12/648<0`.

All scales are the fixed rational values specified above; no limiting
parameter or numerical comparison remains.

### The full target density is strictly above one

In each coarse even power, the coefficient of `P` is

`b_n=(1-epsilon)^(2n)-epsilon^(2n)>=1-(2n+1)epsilon`.

Here `sum_e(2n_e+1)=46` and `epsilon<1/92`, so `product_e b_(n_e)>1/2`.
Keeping the all-`P` term in the nonnegative coarse expansion yields

`F(S;n)>(1/2) sum_B m_B^(-2)>=D^2/162`.

On the other hand,

`|F(T;n)-F(S;n)|<=7D^6 delta^12<1`.

Thus

`F(T;n)>D^2/162-1>1`.

This proves the promised strict pair of inequalities and prevents the
coarse-domination obstruction from being mistaken for target failure.

### All spectral values are accounted for

On the entire centered space of the actual fine square, the values and
multiplicities are

| Value | Multiplicity |
|---|---:|
| `(1-epsilon)^2` | 3 |
| `epsilon^2` | 5 |
| `delta^2` | 1 |
| `delta^2 t^4` | 1 |
| `delta^2 t^8` | 1 |
| `0` | 6 |

They account for all 17 centered dimensions. The five positive values are
distinct because `0<t<1`, `delta<epsilon<1/2`. Thus this is not a two-value
centered baseline with an omitted zero value.

### Additional exact checks of the commuting embedding

Run this block after the complete seed certificate in Section 2. It checks
the rational isometry, original-measure cancellation and commutation,
admissibility, weighted compression coefficient, and every rational bound
used above. The global inequalities come from the preceding proof; no
rounded full-density evaluation is used.

```python
eta = Q(1, 2**156)
L = 2**41
w = [1, 2, 2, 3*L, 4*L, 3*L, 4*L, 3*L, 4*L]
D = 9+75*L*L
pi = [Q(x*x, D) for x in w]
assert sum(pi) == 1
V = [[Q(0) for j in range(5)] for i in range(9)]
for i, x in enumerate([2, 1, -2]):
    V[i][0] = Q(x, 3)
for i, x in enumerate([2, -2, 1]):
    V[i][1] = Q(x, 3)
for j in range(2, 5):
    V[3+2*(j-2)][j] = Q(4, 5)
    V[4+2*(j-2)][j] = Q(-3, 5)
assert mm(transpose(V), V) == eye()
Rbar = mm(mm(V, R), transpose(V))
assert all(sum(Rbar[i][j]*w[j] for j in range(9)) == 0 for i in range(9))
blocks = [(0, 1, 2), (3, 4), (5, 6), (7, 8)]
masses = [sum(pi[i] for i in B) for B in blocks]
assert masses == [Q(9, D)]+[Q(25*L*L, D)]*3
P = [[Q(0) for j in range(9)] for i in range(9)]
for B, mass in zip(blocks, masses):
    for i in B:
        for j in B:
            P[i][j] = 1/mass
Id = [[Q(i == j)/pi[i] for j in range(9)] for i in range(9)]
epsilon = eta/(65536*D**4)
delta = epsilon/(2*D)
S = [[epsilon*Id[i][j]+(1-2*epsilon)*P[i][j]+epsilon
      for j in range(9)] for i in range(9)]
H = [[epsilon*Rbar[i][j]/(2*w[i]*w[j])
      for j in range(9)] for i in range(9)]

def compose_pi(a, b):
    return [[sum(pi[k]*a[i][k]*b[k][j] for k in range(9))
             for j in range(9)] for i in range(9)]

zeros = [[Q(0) for j in range(9)] for i in range(9)]
assert compose_pi(P, H) == compose_pi(H, P) == zeros
assert all(sum(pi[j]*H[i][j] for j in range(9)) == 0 for i in range(9))
scaled_H = [[epsilon*x for x in row] for row in H]
assert compose_pi(S, H) == compose_pi(H, S) == scaled_H
states = [(i, a) for i in range(9) for a in (-1, 1)]
mu = [pi[i]/2 for i, a in states]
T = [[S[i][j]+H[i][j]*a*b for j, b in states] for i, a in states]
p = Q(1, 2*D)
W = [[p*x for x in row] for row in T]
assert min(map(min, W)) > 0 and max(map(max, W)) < 1
assert all(sum(mu[j]*T[i][j] for j in range(18)) == 1 for i in range(18))
assert all(sum(mu[j]*W[i][j] for j in range(18)) == p for i in range(18))
B2 = mm(Rbar, Rbar)
B4 = mm(B2, B2)
B6 = mm(B4, B2)
H0 = [[D*Rbar[i][j]/(w[i]*w[j]) for j in range(9)] for i in range(9)]
assert compose_pi(H0, H0) == [[D*B2[i][j]/(w[i]*w[j])
                               for j in range(9)] for i in range(9)]
gamma0 = Q(0)
for B, mass in zip(blocks, masses):
    compressed = [[[A[i][j] for j in B] for i in B] for A in (B2, B4, B6)]
    product = mm(mm(compressed[0], compressed[1]), compressed[2])
    gamma0 += sum(product[i][i] for i in range(len(B)))/mass**2
expected = D**2*tau/81+Q(D**2, 625*L**4)*sum(
    R2[j][j]*R4[j][j]*R6[j][j] for j in range(2, 5))
assert gamma0 == expected <= -D**2*eta/162
assert 31*epsilon*D**6 <= D**2*eta/324
assert delta**2 <= eta/(3888*D**4)
assert 7*D**6*delta**12 < 1
assert 46*epsilon < Q(1, 2)
assert Q(D**2, 162)-1 > 1
```
