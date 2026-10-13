# A Jordan-operator bound for actual unequal stars

**Verdict.** The unrestricted density target remains unresolved. This
note proves the averaged actual unequal-star inequality under a new
explicit source cap, and for every projection of balanced visible trace
and rank at most ten. Neither condition is assumed in the unrestricted
target. All powers, sources and integrals below retain the original
probability. This is not the supplied Dirichlet identity rearranged.

The key mechanism is a bound for an entire self-adjoint Jordan
multiplication operator. Its lower and upper spectral endpoints are used
together. This permits collective compensation for a negative cubic term;
neither modewise nor pointwise positivity is asserted.

## 1. Actual fields and nonnegative quadratic quantities

Let `S` be a real nonnegative self-adjoint Markov kernel on a finite
original probability `(I,pi)`, put `B=S^2`, and let `Q=Q*=Q^2` be an
original-law projection of rank `d`. On `E=ran Q`, use the actual source

\[
R_i=QD_{\mathbf1_i/\pi_i}Q\big|_E,
\quad \mathbb E_iR_i=I_E,
\quad M_s=B^sR,
\quad X_s=M_s-I_E.\tag{1}
\]

Each `M_s(i)` is PSD and has original-law mean `I_E`. For positive
integers `s,t`, define

\[
g_{st}=\mathbb E_i\operatorname{tr}(X_s(i)X_t(i)),
\qquad v_s=g_{ss}.\tag{2}
\]

If `phi_0=1,phi_1,...` is a complete original orthonormal eigenbasis of
`B`, with eigenvalues `lambda_j in [0,1]`, then

\[
g_{st}=\sum_{j>0}\lambda_j^{s+t}
  \|QD_{\phi_j}Q\|_{HS}^2\ge0.\tag{3}
\]

The list includes every additional stationary mode and every zero mode.
Only the chosen constant vector is removed. Thus this formula applies
also to disconnected roots and connected roots whose squares disconnect.

The trilinear trace is symmetric in three real symmetric arguments.
Sort the exponents as `x<=y<=z`. Spectral ordering gives

\[
g_{xy}\ge v_y,\qquad g_{xz}\ge g_{yz}\ge v_z.\tag{4}
\]

Expansion of the original fields gives the exact relation

\[
J_{xyz}-d=g_{xy}+g_{xz}+g_{yz}+C_{xyz},
\quad C_{xyz}=\mathbb E_i\operatorname{tr}(X_xX_yX_z).\tag{5}
\]

The next step supplies a new bound on `C`, with no unknown cubic term on
its right side.

## 2. The interval-centering lemma

For a real symmetric matrix `A`, the Jordan multiplication operator on
real symmetric matrices is

\[
\mathcal L_A(Y)=(AY+YA)/2.\tag{6}
\]

It is self-adjoint for the Hilbert--Schmidt inner product, and
`<Y,L_A Y>=tr(A Y^2)`. If its quadratic forms lie in the interval
`[a,b]`, then
`||L_A-(a+b)I/2||<= (b-a)/2`. The same assertion holds on the original
weighted direct sum of the matrix spaces, for a pointwise field `A_i`.
Consequently, for arbitrary fields `Y,Z` in that space,

\[
\boxed{\langle Y,\mathcal L_A Z\rangle
\ge {a+b\over2}\langle Y,Z\rangle
    -{b-a\over2}\|Y\|\|Z\|.}\tag{7}
\]

This follows by applying Cauchy--Schwarz to the centered self-adjoint
operator, and is valid even when the pairing on the left is negative.
The operator is compressed to the traceless symmetric subspace when
that subspace is used; invariance of the uncompressed operator is not
being assumed.

## 3. A universal source-cap theorem

Suppose the **actual shortest-time field** obeys

\[
0\preceq M_x(i)\preceq L I_E\quad\text{for every }i.\tag{8}
\]

We may take `L>=1` when `d>0`. Since `X_x=M_x-I_E`, the operator
`L_(X_x)` has quadratic-form interval `[-1,L-1]`. Indeed `Y^2` is PSD,
so `-tr Y^2<=tr(X_x Y^2)<=(L-1)tr Y^2`. Apply (7) to `Y=X_y,Z=X_z`
and use symmetry of the trilinear trace. This proves

\[
\boxed{C_{xyz}\ge {L-2\over2}g_{yz}
                         -{L\over2}\sqrt{v_yv_z}.}\tag{9}
\]

Inserting it into (5) gives the stronger, explicitly computable bound

\[
\boxed{J_{xyz}-d\ge
g_{xy}+g_{xz}+{L\over2}g_{yz}
                    -{L\over2}\sqrt{v_yv_z}.}\tag{10}
\]

Using (4),

\[
\begin{aligned}
J_{xyz}-d
&\ge v_y+\left(1+{L\over2}\right)v_z
                  -{L\over2}\sqrt{v_yv_z}\\
&=\left(\sqrt{v_y}-{L\over4}\sqrt{v_z}\right)^2
 +\left(1+{L\over2}-{L^2\over16}\right)v_z.
\end{aligned}\tag{11}
\]

Therefore

\[
\boxed{L\le4+4\sqrt2\quad\Longrightarrow\quad J_{xyz}\ge d.}\tag{12}
\]

The rational cap `L<=9` gives the especially simple certificate

\[
J_{xyz}-d\ge
\left(\sqrt{v_y}-{9\over4}\sqrt{v_z}\right)^2
                              +{7\over16}v_z.\tag{13}
\]

The proof did not assume a bound on the dimension, the number of bands,
or the scalar kernel entries. It assumed (8), which must be checked on
the actual compressed field. A sufficient uniform condition is
`max_i ||(BR)_i||op<=4+4sqrt2`: later fields are Markov averages of the
first one and preserve that cap. Bounding scalar kernel entries can be
a further sufficient test, but is not required here.

For `L<4+4sqrt2`, equality implies `v_z=0`, which by (3), since `z>=1`,
is equivalent to `BR=I_E`. Conversely that condition gives equality.
No equality classification at the endpoint is needed for the theorem.
The rank-zero case is identically zero.

## 4. Balanced visible trace: all ranks at most ten

Suppose now that

\[
\operatorname{tr}[(BR)_i]=d\quad\text{for every }i.\tag{14}
\]

This condition is exactly `B[Q(i,i)]=d`. It includes a constant diagonal
projection `Q(i,i)=d`, but also allows nonconstant diagonal variation in
the zero eigenspace of `B`. Every positive-time `M_s` then has trace `d`,
so `X_s` is traceless.

For a traceless symmetric `d` by `d` matrix `Y`,

\[
\|Y\|_{op}^2\le {d-1\over d}\|Y\|_{HS}^2.\tag{15}
\]

To prove (15), an eigenvalue `eta` is the negative sum of the other
`d-1` eigenvalues, whence `eta^2<=(d-1)sum_others eta_j^2` by ordinary
Cauchy--Schwarz. Apply this to an eigenvalue of greatest absolute value.

Because `M_x` is PSD with trace `d`,

\[
-\|Y\|_{HS}^2
\le\operatorname{tr}(X_xY^2)
\le d\|Y\|_{op}^2-\|Y\|_{HS}^2
\le(d-2)\|Y\|_{HS}^2.\tag{16}
\]

Thus the compression of `L_(X_x)` to traceless symmetric matrices has
interval `[-1,d-2]`. For `d>=2`, apply (7) on that subspace:

\[
C_{xyz}\ge {d-3\over2}g_{yz}
                   -{d-1\over2}\sqrt{v_yv_z}.\tag{17}
\]

Equations (5), (4) now yield

\[
\boxed{\begin{aligned}
J_{xyz}-d
&\ge v_y+{d+1\over2}v_z
                -{d-1\over2}\sqrt{v_yv_z}\\
&=\left(\sqrt{v_y}-{d-1\over4}\sqrt{v_z}\right)^2
  +{ -d^2+10d+7\over16}v_z.
\end{aligned}}\tag{18}
\]

The last coefficient is positive for every integer `2<=d<=10`.
For `d=1`, (14) says `BR=1`, so all positive-time fields are one.
We have proved

\[
\boxed{\operatorname{rank}Q\le10,\quad B[Q(i,i)]=\operatorname{rank}Q
\quad\Longrightarrow\quad J_{xyz}\ge\operatorname{rank}Q
\quad\text{for all }x,y,z\ge1.}\tag{19}
\]

For every positive rank in (19), equality holds exactly when `BR=I_E`.
There is no reflection, commutation or band-count condition. This is a
theorem about balanced visible sources, not about all projections of rank
at most ten. For rank two the companion algebraic identity is stronger:
its cubic term vanishes exactly and the full pair surplus remains.

## 5. Consequence and its exact limit

For an actual binary projection channel `T=S+sigma tau H`, on original
probability `pi_i/2`, with `H=H*`, `H^2=beta Q`, `beta>=0` and `|H|<=S`,
the original sign expansion and the previously proved quadrilateral
lemma imply

\[
F(T;n)\ge F(S;n)+d\sum_{D\in\mathcal C(K_4)}
                              \beta^{\sum_{e\in D}n_e}.\tag{20}
\]

It is enough that the actual star contractions satisfy (12), or that
(19) holds. For a uniform first-step cap, or balanced visible rank at most
ten, this covers all six positive exponents simultaneously. The same
original-measure sign calculation is written in the cubic-subspace note.

One still needs a separate coarse density bound to infer `F(T;n)>=1`.
Moreover an arbitrary target root need not admit this projection-channel
description. An arbitrary actual source can have unbounded visible norm
and nonconstant surviving trace. Those are the real restrictions, and
they are not treated as routine final steps.

The threshold in (12) is the threshold of the displayed quadratic
argument; no optimality claim is made. Likewise (19) proves ranks through
ten, and asserts nothing negative about rank eleven or larger. A failed
sufficient bound is not a counterexample to either (U) or the target.
