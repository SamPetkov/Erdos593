# Weighted examples for the two channel contractions

These are exact illustrations of the restricted theorems in
[continuation2_markov.md](continuation2_markov.md) and
[continuation2_signed_channel.md](continuation2_signed_channel.md).
The unrestricted common-power target remains unresolved. The accompanying
[rational verifier](continuation2_weighted_channels_verify.py) writes every
entry of each bounded host and its original measure to
[continuation2_weighted_channels_checks.json](continuation2_weighted_channels_checks.json).

## 1. A signed channel beyond the prior density and mixing tests

On three coarse states put

\[
\pi=(1/2,1/3,1/6),\qquad
\mathrm{Id}(i,j)=\mathbf1_{i=j}/\pi_i,\qquad \Pi(i,j)=1,
\]

and define the relative kernels

\[
S=\frac78\mathrm{Id}+\frac18\Pi,
\qquad
H=\frac18(\mathrm{Id}-\Pi)
+\frac{a_i}{\pi_i}\mathbf1_{i=j},
\qquad a=(1/64,1/32,0).
\tag{1}
\]

Thus

\[
S=\begin{pmatrix}15/8&1/8&1/8\\1/8&11/4&1/8\\1/8&1/8&43/8\end{pmatrix},
\qquad
H=\begin{pmatrix}5/32&-1/8&-1/8\\-1/8&11/32&-1/8\\-1/8&-1/8&5/8\end{pmatrix}.
\]

Every matrix product here uses the original weights `pi`.
We have `|H(i,j)|<=S(i,j)` and

\[
S^2=\frac{49}{64}\mathrm{Id}+\frac{15}{64}\Pi.
\]

On the six states `(0,-),(0,+),(1,-),(1,+),(2,-),(2,+)` use

\[
\mu=(1/4,1/4,1/6,1/6,1/12,1/12),\qquad
T((i,a),(j,b))=S(i,j)+H(i,j)ab.
\]

This is an actual nonnegative self-adjoint Markov root. Its maximum is six,
so `p=1/6` and the following is its admissible bounded host:

\[
W=\begin{pmatrix}
65/192&55/192&0&1/24&0&1/24\\
55/192&65/192&1/24&0&1/24&0\\
0&1/24&33/64&77/192&0&1/24\\
1/24&0&77/192&33/64&1/24&0\\
0&1/24&0&1/24&1&19/24\\
1/24&0&1/24&0&19/24&1
\end{pmatrix}.
\tag{2}
\]

Every original-`mu` weighted row sum in (2) is `1/6`. By the signed-channel
theorem,

\[
F(T;n)\ge F(S;n)\ge1
\tag{3}
\]

for all six independent positive exponents, including every requested tuple.

### The channel-square sign condition fails

Direct original-measure multiplication gives

\[
H^2=\begin{pmatrix}
41/2048&-11/512&-9/512\\
-11/512&51/1024&-5/256\\
-9/512&-5/256&5/64
\end{pmatrix}.
\tag{4}
\]

All three off-diagonal entries are negative. Their triangle product is
negative and is unchanged by replacing `H^2(i,j)` with
`epsilon_i H^2(i,j) epsilon_j`. Therefore no diagonal sign gauge makes (4)
entrywise nonnegative. This example is covered by the global signed-channel
proof despite failing the pointwise channel-square criterion in this
specified binary-fiber representation.

### Spectral values and the compensation gap

The channel operator matrix on `L^2(pi)` is similar to the symmetric matrix

\[
\operatorname{diag}(1/8+a_i)-\tfrac18 vv^T,
\qquad v_i=\sqrt{\pi_i}.
\]

It is positive definite: it is the sum of
`(Id-Pi)/8`, a PSD operator whose nullspace is the constants, and the
nonnegative multiplication operator `diag(a_i)`, whose quadratic form is
strictly positive on every nonzero constant. The diagonal values
`1/8,9/64,5/32` are distinct and every `v_i` is nonzero. The rank-one secular
equation is strictly monotone between its poles and gives one simple
eigenvalue in each of

\[
(0,1/8),\qquad (1/8,9/64),\qquad (9/64,5/32).
\]

Equivalently its characteristic polynomial is

\[
z^3-\frac{19}{64}z^2+\frac{149}{6144}z-\frac{11}{32768}.
\]

The full actual square therefore has four distinct positive values on the
centered space: `49/64` with multiplicity two, and the squares of these three
simple channel eigenvalues. No channel value can equal `49/64` because each
channel root eigenvalue is less than `5/32<7/8`.

The exact maximum square-kernel entry is

\[
\max A=\frac{157}{32}>4.
\]

At `(k,u,r,l,h)=(3,1,1,1,1)`, the prior two-diamond threshold is `1/4`.
Thus both its density test and its maximum-kernel mixing test fail:

\[
p=1/6<1/4,\qquad \tfrac14\max A=157/128>1.
\]

No exclusion from every earlier local-neighborhood or other theorem is
asserted. The point of this example is to verify a signed-channel certificate
in a region not covered by those two compensation tests.

At that tuple the exact check records

\[
F(T;n)=
\frac{19181387913295046377823315660819}
{2139160387885137115025686659072},
\qquad
F(S;n)=\frac{80765156576677493}{9007199254740992},
\]

with a strictly positive difference. The general inequality comes from (3),
not this single finite evaluation.

### Zeros, strict positivity, and a disconnected endpoint

Setting `a=0` in (1) leaves the actual root admissible and gives the complete
centered spectral-value list

\[
49/64,\quad 1/64,\quad 0.
\]

These are three values on the entire centered space. This is not silently
treated as the earlier two-value situation.

For a strictly positive variant use `T_tau=Pi+tau(T-Pi)` with `tau=99/100`.
Its coarse root still has a square of the required form and its channel is
`tau H`. The exact bounded normalization is

\[
p=20/119,\qquad \min W=1/595,\qquad \max A=12361/2560>4.
\]

The signed-channel theorem still applies, and the two old compensation tests
still fail at the displayed tuple.

The verifier also checks the genuinely disconnected endpoint `S=Id` with
the same original `pi` and
`H(i,j)=b_i 1_{i=j}/pi_i`, where `b=(1/2,-1/3,0)`. On a connected `K4`,
all four coarse colors must then agree. The original factor is exactly

\[
F(T;n)=\sum_i\pi_i^{-2}F(1+b_i ab;n),
\]

because four vertex weights and six relative-kernel factors contribute
`pi_i^{4-6}`. At the displayed tuple, this is
`106884785881/2176782336`, strictly greater than the coarse density
`sum_i pi_i^{-2}=49`. The constant root is checked separately to give
equality `F=1`.

## 2. Three interacting character channels, unequal weights, and a negative root eigenvalue

Let the coarse probability be `pi=(1/3,2/3)`, and use the uniform four-state
fiber `G=(Z/2)^2`. Write its three nontrivial real characters as
`chi_1,chi_2,chi_3=chi_1 chi_2`. Put `B_0=S=Pi` and take the relative kernels

\[
B_1=\frac18\begin{pmatrix}1&1\\1&2\end{pmatrix},\quad
B_2=\frac1{16}\begin{pmatrix}2&1\\1&1\end{pmatrix},\quad
B_3=\frac1{32}\begin{pmatrix}1&2\\2&1\end{pmatrix}.
\]

Define the actual root

\[
T((i,a),(j,b))=1+\sum_{\alpha=1}^3
B_\alpha(i,j)\chi_\alpha(a)\chi_\alpha(b),
\qquad \mu(i,a)=\pi_i/4.
\tag{5}
\]

The precise bounds are `23/32<=T<=43/32`. Consequently

\[
p=32/43,\qquad W=pT,\qquad 23/43\le W\le1
\]

gives an actual strictly positive eight-state host, with four original masses
`1/12` and four masses `1/6`. Each displayed channel is entrywise positive,
so its original-`pi` square is entrywise positive. The character cubic moments
are zero or one, with

\[
\mathbb E\chi_1\chi_2\chi_3=1.
\]

The general channel theorem therefore gives density at least one for every
finite graph and every choice of positive even edge powers. This is a genuine
three-channel interaction; the vertex expansion is not limited to one
binary channel's cycles. Distinct coarse channels are not assumed to commute,
and here `B_1 B_2 != B_2 B_1` under the original `pi` product.

The three coarse channel operators have eigenvalues

\[
\frac{5\pm\sqrt{17}}{48},\qquad
\frac{2\pm\sqrt2}{48},\qquad
\frac{3\pm\sqrt{33}}{192}.
\]

The last pair contains a negative value. The root is nevertheless entrywise
strictly positive as already checked; its square has the six distinct
positive squared values above and one additional centered zero value. The
zero comes from the centered coarse direction annihilated by `S=Pi`.
Rational isolating intervals in the certificate verify the six distinctions.

For `(k,u,r,l,h)=(1,1,1,1,1)`, direct original-measure calculation gives

\[
F=1+\frac{70770353502685163}{709154811724267782144}>1.
\]

This last example already satisfies the older density criterion. It is
included to check the nonuniform normalization, interacting cubic moments,
additional zero band, and negative eigenvalue of an actual root, not to claim
new base-density coverage from that finite evaluation.
