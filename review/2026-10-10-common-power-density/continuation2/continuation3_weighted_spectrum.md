# The channel-spectrum contraction with unequal original weights

**Scope.** This extends the signed-channel theorem to a class of unequal
original measures. It is still a restricted contraction theorem and does
not solve the unrestricted target.

Let `(I,pi)` be any finite positive probability space with

\[
d=1/\max_i\pi_i\ge4.
\tag{1}
\]

Write `Id(i,j)=1_{i=j}/pi_i`, `Pi(i,j)=1`, and `P=Id-Pi`. Let `S` be any
nonnegative symmetric Markov kernel, let `H` be symmetric with `|H|<=S`,
and suppose, in **original-pi composition**, that

\[
H^2=\beta\mathrm{Id}+(\alpha-\beta)\Pi,
\qquad 0\le\alpha\le\beta.
\tag{2}
\]

The actual root `T((i,a),(j,b))=S(i,j)+H(i,j)ab` has original law
`mu(i,a)=pi_i/2`. For six independent positive exponents and the seven
nonempty even cycles of `K4`, put `q_C=sum_{e in C}n_e`. Then

\[
\boxed{F(T;n)\ge F(S;n)
+\sum_C\left[\alpha^{q_C}+(d-1)\beta^{q_C}\right].}
\tag{3}
\]

The coefficient `d-1` need not equal the centered dimension. No uniformity
or implicit replacement of the stationary law is used in (3). The uniform
theorem covers its remaining cases of one, two and three coarse points by
the separate arguments in
[continuation3_channel_spectrum.md](continuation3_channel_spectrum.md).

## Exact weighted contractions

The channel power identity, seven-cycle expansion, and mixture

\[
H^{2n}=\beta^n[t_n\mathrm{Id}+(1-t_n)P],
\quad t_n=(\alpha/\beta)^n\in[0,1]
\tag{4}
\]

hold with the original law exactly as in the uniform proof. The case
`beta=0` is immediate. Set `r_i=1/pi_i`, so `r_i>=d`.

An identity tree identifies its vertices with weight
`pi_i^v pi_i^{-(v-1)}=pi_i`; an identity cycle leaves one additional
`r_i`. Also

\[
P(i,i)=r_i-1,\qquad
P(i,j)^2=(r_i-2)\mathrm{Id}(i,j)+1.
\tag{5}
\]

All powers `L_x=S^{2x}` are nonnegative PSD Markov kernels. In particular,
`tr L_x>=1`, `tr(L_xL_y)>=1`, and `L_x(i,i)>=1`. Define

\[
V_i=\mathbb E_j L_x(i,j)L_y(i,j)L_z(i,j),\quad
D_i=L_x(i,i)L_y(i,i).
\]

Here `V_i>=0`, `E_i V_i>=1`, and `D_i>=1`. The bound on the average of
`V_i` is the Schur-product proof in Section 2 of the uniform note; **no
pointwise assertion `V_i>=1` is needed or made**.

For the triangle, the exact weighted versions of the contraction table are:

| Identity cycle edges | Exact value |
|---:|---|
| 0 | `-1+tr(L_xL_y)+tr(L_xL_z)+tr(L_yL_z)+E_i(r_i-3)V_i` |
| 1 | `tr(L_xL_y)+E_i(r_i-2)V_i`, with the paired star edges labeled `x,y` |
| 2 | `E_i(r_i-1)V_i` |
| 3 | `E_i r_i V_i` |

Because `r_i>=d>=4` and `V_i>=0`, the first three rows are at least
`d-1`, and the last is at least `d`.

For a quadrilateral, with complementary diagonal kernels `L_x,L_y`, the
exact values are:

| Identity cycle edges | Exact value |
|---|---|
| None | `-3+2tr L_x+2tr L_y+2tr(L_xL_y)+E_i(r_i-4)D_i` |
| One | `-1+tr L_x+tr L_y+tr(L_xL_y)+E_i(r_i-3)D_i` |
| Two adjacent | `tr L_x+E_i(r_i-2)D_i` (or `tr L_y`) |
| Two opposite | `tr(L_xL_y)+E_i(r_i-2)D_i` |
| Three | `E_i(r_i-1)D_i` |
| Four | `E_i r_i D_i` |

The first five rows are at least `d-1`, and the last is at least `d`.
Every coefficient whose sign is used is explicitly nonnegative by (1).
For each cycle, (4) is a mixture whose all-identity weight is
`prod t_n`. Consequently its integral is at least
`beta^{q_C}[d-1+prod t_n]= (d-1)beta^{q_C}+alpha^{q_C}`.
Summing the seven bounds proves (3).

The atom bound (1) is sufficient for this proof. Nothing here asserts it is
necessary, or that splitting a heavy atom automatically transports (2):
the identity kernel in (2) must be the actual identity for the stated
original measure.

## Exact twelve-state example

Take six coarse states with original law

\[
\pi=(1/5,1/5,1/5,1/5,1/10,1/10),\qquad d=5.
\]

State zero is the center. Define the relative coarse root by

\[
S_0(0,0)=35/8,\quad S_0(0,j)=S_0(j,0)=5/32\ (j>0),
\]

\[
S_0(j,j)=\frac{31}{32\pi_j}\ (j>0),\qquad
S_0(i,j)=0\quad(i,j>0,\ i\ne j).
\]

Its center transition probability is `7/8`, every leaf has transition
probability `1/32` to the center, and each row sums to one under the
original law. Let

\[
S=\frac{63}{64}S_0+\frac1{64}\Pi,
\qquad H=\frac1{128}(\mathrm{Id}-\Pi).
\tag{6}
\]

On the twelve states `(i,a)`, use the original masses `mu(i,a)=pi_i/2` and

\[
\boxed{W((i,a),(j,b))=\frac{1024}{9853}
[S(i,j)+H(i,j)ab],\qquad p=\frac{1024}{9853}.}
\tag{7}
\]

All data are rational. Directly, `|H|<=S`, `min W=8/9853>0`, `max W=1`,
and every original weighted row of `W` is `p`. Here `alpha=0`,
`beta=1/16384`. The square's four distinct centered values are

\[
\left(\frac{1953}{2048}\right)^2\ (\text{multiplicity }4),\quad
\left(\frac{1701}{2048}\right)^2\ (\text{multiplicity }1),\quad
1/16384\ (\text{multiplicity }5),\quad
0\ (\text{multiplicity }1).
\tag{8}
\]

With `y=(1701/2048)^2`, the coarse common-cone bound and (3) give, for all
six independent positive edge exponents,

\[
F(T;n)\ge1+299y^N+4\sum_C16384^{-q_C}.
\tag{9}
\]

The coefficient `299` is `sum_i pi_i^{-2}-1`. At the target tuple
`(k,u,r,l,h)=(3,1,1,1,1)`,

\[
p=1024/9853<1/4,\qquad
\max A=38294287/4194304>4.
\tag{10}
\]

Thus both earlier compensation tests fail. The channel square has three
negative off-diagonal entries around every distinct coarse triple, so it
has no entrywise nonnegative diagonal sign gauge. The proof uses the exact
weighted contractions above, not a uniform approximation. The accompanying
checker includes this host and all 24 weighted cycle/identity contractions.
