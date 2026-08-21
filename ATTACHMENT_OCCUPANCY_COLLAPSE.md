# Occupancy collapse and real-rootedness of canonical attachment counts

## Scope

This note continues the exact capacity-respecting attachment enumeration for a
fixed labelled list of canonical atoms.  It extracts a stronger closed form and
a complete probability law from the coefficient formula already proved there.

Fix pairwise disjoint labelled canonical atoms

\[
A_1,\ldots,A_k,
\qquad
w_i=|V(A_i)|,
\qquad
P=\prod_{i=1}^k w_i.
\]

All labels on all atom vertices are retained.  An admissible connected
attachment is a quotient equivalence relation whose non-singleton classes use
at most one vertex of each atom and whose atom--shared-point incidence graph is
a tree.  Shared points are not externally labelled.  We count quotient
relations, not sequences of one-point amalgamations, and we do not divide by
atom or hypergraph automorphisms.

Let

\[
v=\sum_{i=1}^k w_i-k+1.
\tag{0.1}
\]

Every connected attachment identifies exactly \(k-1\) pairs of previously
disjoint vertices in the forest-excess sense, so \(v\) is the number of
vertices of every resulting quotient.  Since every canonical atom has at least
three vertices,

\[
v>k-1.
\tag{0.2}
\]

Let \(N_t(\mathbf A)\) be the number of connected attachments having exactly
\(t\) shared points.  The preceding enumeration theorem gives

\[
N_t(\mathbf A)
 =P\,S(k-1,t)\,(v-1)_{t-1},
\qquad 1\le t\le k-1,
\tag{0.3}
\]

where \(S(n,t)\) is a Stirling number of the second kind and \((x)_r\) is a
falling factorial.

The main observation is

\[
(v-1)_{t-1}=\frac{(v)_t}{v}.
\tag{0.4}
\]

This turns the whole attachment theory into a classical occupancy law.

## 1. Exact occupancy collapse

### Theorem 1 — universal occupancy form

For \(k\ge2\),

\[
\boxed{
N_t(\mathbf A)
 =\frac{P}{v}(v)_tS(k-1,t).
}
\tag{1.1}
\]

Consequently, the total number of admissible connected attachments is

\[
\boxed{
N_{\rm conn}(\mathbf A)
 =P\,v^{k-2}.
}
\tag{1.2}
\]

Under the uniform distribution on these quotient attachments, if \(T\) is the
number of shared points, then

\[
\boxed{
\Pr(T=t)=\frac{(v)_tS(k-1,t)}{v^{k-1}}.
}
\tag{1.3}
\]

Thus \(T\) has exactly the same distribution as the number of occupied boxes
when \(k-1\) labelled balls are independently placed uniformly into \(v\)
labelled boxes.

For \(k=1\), there is one attachment, no shared point, and (1.2) is interpreted
separately rather than through the negative exponent.

#### Algebraic proof

Equation (1.1) is (0.3) and (0.4).  The Stirling change-of-basis identity

\[
x^n=\sum_{t=0}^n S(n,t)(x)_t
\tag{1.4}
\]

gives

\[
\sum_{t=1}^{k-1}N_t(\mathbf A)
 =\frac Pv\sum_t(v)_tS(k-1,t)
 =\frac Pv\,v^{k-1},
\]

which is (1.2).  Dividing (1.1) by (1.2) yields (1.3).

#### Normalized Prüfer-code proof

The proof of (0.3) can be normalized as follows.  Choose one anchor vertex in
each atom, giving the factor \(P\).  The remaining port alphabet has

\[
1+\sum_i(w_i-1)=v
\]

symbols: one special symbol and all non-anchor atom vertices.  The bipartite
Prüfer code induces a set partition of \([k-1]\).  The block containing the
first code position receives the special symbol, and the other blocks receive
distinct residual-port symbols.  For exactly \(t\) blocks this gives

\[
S(k-1,t)(v-1)_{t-1}
\]

codes.  Equivalently, it gives a function

\[
f:[k-1]\longrightarrow[v]
\]

whose first value is fixed.  There are \(v^{k-2}\) such normalized functions.
The number of values used by \(f\) is the number of shared points.  Forgetting
which value was fixed recovers the ordinary occupancy distribution in (1.3).

### Corollary 1.1 — dependence only on atom orders

The total connected count depends on the atom list only through

\[
k,\qquad \prod_i w_i,\qquad
v=\sum_iw_i-k+1.
\]

For fixed labelled atom vertex sets, the internal edge structure of the atoms
makes no further contribution to the number of admissible attachment
quotients.

This is not an unlabelled isomorphism statement: automorphisms of the atoms or
of the resulting triple system are not divided out.

## 2. Full shared-point multiplicity law

Let a shared point of multiplicity \(r+1\) have **excess** \(r\).  Write

\[
C_r=\#\{p:\mu(p)-1=r\},
\qquad r\ge1.
\]

Then

\[
\sum_{r\ge1}rC_r=k-1,
\qquad
T=\sum_{r\ge1}C_r.
\tag{2.1}
\]

A profile can be written either as a partition

\[
\lambda=(\lambda_1,\ldots,\lambda_t)\vdash k-1
\]

or by the multiplicities \(c_r=C_r\), where
\(\sum_rc_r=t\) and \(\sum_rrc_r=k-1\).

### Theorem 2 — exact profile probability

For an unordered excess profile
\(\lambda=(\lambda_1,\ldots,\lambda_t)\), let \(m_r\) be the number of parts
equal to \(r\).  Under the uniform attachment measure,

\[
\boxed{
\Pr\bigl(\lambda(F)=\lambda\bigr)
 =
 \frac{(v)_t(k-1)!}
 {v^{k-1}\prod_{j=1}^t\lambda_j!\prod_{r\ge1}m_r!}.
}
\tag{2.2}
\]

Equivalently,

\[
\boxed{
\Pr(C_r=c_r\text{ for all }r)
 =
 \frac{(v)_t(k-1)!}
 {v^{k-1}\prod_{r\ge1}c_r!(r!)^{c_r}}.
}
\tag{2.3}
\]

This is exactly the load-profile law for \(k-1\) labelled balls in \(v\)
labelled boxes.  In particular, the occupancy collapse holds for the complete
multiplicity profile, not only for the number \(T\) of shared points.

#### Proof

The profile-refined attachment theorem gives

\[
N_\lambda(\mathbf A)
 =P(v-1)_{t-1}
  \frac{(k-1)!}
  {\prod_j\lambda_j!\prod_rm_r!}.
\]

Using \((v)_t=v(v-1)_{t-1}\) and dividing by \(Pv^{k-2}\) gives (2.2).
Grouping equal parts gives (2.3).  The right-hand side is the standard direct
count: choose and label the \(t\) occupied boxes, partition the balls into
load classes, and then forget permutations among boxes carrying equal loads.

### Corollary 2.1 — expected multiplicity counts

For every \(r\ge1\),

\[
\boxed{
\mathbb E C_r
 =v\binom{k-1}{r}v^{-r}
  \left(1-\frac1v\right)^{k-1-r}.
}
\tag{2.4}
\]

Indeed, for each of the \(v\) occupancy boxes, choose the \(r\) code positions
mapped to it and require all remaining positions to avoid it.

The expected number of binary shared points is therefore

\[
\mathbb E C_1
 =(k-1)\left(1-\frac1v\right)^{k-2}.
\tag{2.5}
\]

## 3. Exact moments of the number of shared points

Put

\[
a=\left(1-\frac1v\right)^{k-1},
\qquad
b=\left(1-\frac2v\right)^{k-1}.
\]

### Theorem 3 — mean, variance, and factorial moments

The shared-point count satisfies

\[
\boxed{
\mathbb ET=v(1-a),
}
\tag{3.1}
\]

and

\[
\boxed{
\operatorname{Var}(T)
 =va+v(v-1)b-v^2a^2.
}
\tag{3.2}
\]

More generally, for \(j\ge1\),

\[
\boxed{
\mathbb E(T)_j
 =(v)_j
 \sum_{\ell=0}^j(-1)^\ell\binom j\ell
 \left(1-\frac\ell v\right)^{k-1}.
}
\tag{3.3}
\]

#### Proof

Write \(T=\sum_{x=1}^vI_x\), where \(I_x\) indicates that occupancy box \(x\)
is used.  Then

\[
\Pr(I_x=0)=a,
\qquad
\Pr(I_x=I_y=0)=b
\]

for distinct \(x,y\), which gives (3.1) and (3.2).  For (3.3), \((T)_j\)
counts ordered \(j\)-tuples of distinct occupied boxes.  Inclusion--exclusion
for a prescribed \(j\)-tuple gives the displayed sum.

## 4. Real-rooted attachment polynomial

For integers \(h\ge1\) and \(v\ge h\), define the occupancy polynomial

\[
\Omega_{h,v}(z)
 =\sum_{t=1}^h(v)_tS(h,t)z^t.
\tag{4.1}
\]

For the attachment problem, \(h=k-1\), and

\[
\Phi_{\mathbf A}(z)
 =\sum_tN_t(\mathbf A)z^t
 =\frac Pv\,\Omega_{k-1,v}(z).
\tag{4.2}
\]

### Theorem 4 — simple negative zeros and strict interlacing

If \(v\ge h\), then \(\Omega_{h,v}\) has one simple zero at \(0\) and
\(h-1\) simple negative zeros.  For fixed \(v\), the negative zeros of
\(\Omega_{h,v}\) strictly interlace those of \(\Omega_{h+1,v}\) whenever
\(v\ge h+1\).

Consequently, the canonical attachment polynomial
\(\Phi_{\mathbf A}\) has only simple real nonpositive zeros.

#### Proof

The occupancy coefficients satisfy

\[
(v)_tS(h+1,t)
 =t(v)_tS(h,t)+(v-t+1)(v)_{t-1}S(h,t-1).
\]

Hence

\[
\Omega_{h+1,v}(z)
 =vz\Omega_{h,v}(z)+z(1-z)\Omega'_{h,v}(z).
\tag{4.3}
\]

The assertion is immediate for \(h=1\), where
\(\Omega_{1,v}(z)=vz\).  Suppose

\[
0=\rho_0>\rho_1>\cdots>\rho_{h-1}
\]

are the simple zeros of \(\Omega_{h,v}\).  At a negative zero \(\rho_i\),

\[
\Omega_{h+1,v}(\rho_i)
 =\rho_i(1-\rho_i)\Omega'_{h,v}(\rho_i).
\tag{4.4}
\]

The signs alternate at consecutive \(\rho_i\).  The coefficient of \(z\) in
\(\Omega_{h+1,v}\) is positive, so its sign immediately to the left of zero
is negative.  Its leading coefficient is

\[
(v)_{h+1}=(v-h)(v)_h>0
\]

when \(v>h\), giving the opposite sign at negative infinity from the value at
the leftmost old zero.  The intermediate value theorem therefore supplies one
new zero in every interval between consecutive old zeros, one between zero and
the nearest old negative zero, and one to the left of the old leftmost zero.
These are all the zeros and are simple.  The endpoint case \(v=h\) follows by
applying the same induction only through degree \(h\); the final leading
coefficient remains positive.  This proves the theorem.

### Corollary 4.1 — strict ultra log-concavity

Let \(h=k-1\).  For every interior index \(2\le t\le h-1\),

\[
\boxed{
\left(\frac{N_t}{\binom ht}\right)^2
>
\frac{N_{t-1}}{\binom h{t-1}}
\frac{N_{t+1}}{\binom h{t+1}}.
}
\tag{4.5}
\]

Thus the coefficient sequence is not merely strictly log-concave; it is a
Pólya-frequency sequence, and its positive interior coefficients satisfy the
strict Newton inequalities.

### Corollary 4.2 — exact Poisson--binomial representation

There exist numbers \(p_1,\ldots,p_{k-2}\in(0,1)\) and independent Bernoulli
variables \(B_j\sim\operatorname{Bernoulli}(p_j)\) such that

\[
\boxed{
T\ \stackrel{d}=\ 1+\sum_{j=1}^{k-2}B_j.
}
\tag{4.6}
\]

Indeed, factor the normalized probability generating polynomial using its
negative roots.  This is a distributional representation; it does not assert
that physical shared-point incidences are independent.

In particular,

\[
\operatorname{Var}(T)\le\mathbb ET-1,
\tag{4.7}
\]

and the usual Bernoulli-sum concentration bounds apply.  For example, with
\(\sigma^2=\operatorname{Var}(T)\),

\[
\Pr\bigl(|T-\mathbb ET|\ge x\bigr)
\le
2\exp\left(-\frac{x^2}{2(\sigma^2+x/3)}\right).
\tag{4.8}
\]

## 5. Two different asymptotic regimes

The occupancy collapse separates two limits that should not be conflated.

### 5.1 Fixed number of atoms, increasing capacity

Let \(h=k-1\) be fixed and let \(v\to\infty\).  The binary endpoint
\(T=h\) has exact probability

\[
\Pr(T=h)=\frac{(v)_h}{v^h}.
\tag{5.1}
\]

Therefore

\[
\Pr(T=h)
 =1-\frac{\binom h2}{v}
 +\frac{h(h-1)(h-2)(3h-1)}{24v^2}
 +O_h(v^{-3}).
\tag{5.2}
\]

Moreover,

\[
\frac{N_{h-1}}{N_h}
 =\frac{\binom h2}{v-h+1}.
\tag{5.3}
\]

Thus binary attachments dominate when the number of atoms is fixed and their
total port capacity tends to infinity.

### 5.2 Many atoms with proportional quotient order

Now let \(h=k-1\to\infty\) and assume

\[
\frac vh\longrightarrow\gamma\in[1,\infty).
\tag{5.4}
\]

Then

\[
\boxed{
\frac{\mathbb ET}{h}
\longrightarrow
\gamma\bigl(1-e^{-1/\gamma}\bigr),
}
\tag{5.5}
\]

and

\[
\boxed{
\frac{\operatorname{Var}(T)}{h}
\longrightarrow
\gamma e^{-1/\gamma}-(\gamma+1)e^{-2/\gamma}>0.
}
\tag{5.6}
\]

The Poisson--binomial representation and the boundedness of its summands give

\[
\boxed{
\frac{T-\mathbb ET}{\sqrt{\operatorname{Var}(T)}}
\Longrightarrow N(0,1).
}
\tag{5.7}
\]

For every fixed \(r\ge1\), a second-moment calculation for occupancy boxes
gives

\[
\boxed{
\frac{C_r}{h}
\xrightarrow{\Pr}
\frac{e^{-1/\gamma}}{r!\gamma^{r-1}}.
}
\tag{5.8}
\]

Thus the limiting shared-point excess profile is the positive part of a
Poisson load law with mean \(1/\gamma\).

#### Proof sketch

Equations (5.5) and (5.6) follow by substituting \(v/h\to\gamma\) into
(3.1) and (3.2), retaining the first correction in the covariance term.  The
variance is asymptotically linear, so Lindeberg's condition for the independent
Bernoulli representation is automatic.  Formula (2.4) gives the mean in
(5.8).  For two specified boxes, the joint probability of both having load
\(r\) is

\[
\binom{h}{r,r,h-2r}v^{-2r}
\left(1-\frac2v\right)^{h-2r},
\]

which yields \(\operatorname{Var}(C_r)=O(h)\); Chebyshev's inequality completes
the proof.

### Corollary 5.1 — equal-size atoms

If all atoms have the same order \(w\), then

\[
v=k(w-1)+1,
\qquad
\frac v{k-1}\longrightarrow w-1.
\]

Consequently,

\[
\frac Tk
\longrightarrow
(w-1)\left(1-e^{-1/(w-1)}\right)
\quad\text{in probability},
\tag{5.9}
\]

and

\[
\frac{C_r}{k}
\longrightarrow
\frac{e^{-1/(w-1)}}{r!(w-1)^{r-1}}
\quad\text{in probability}.
\tag{5.10}
\]

For a list consisting entirely of single-triple atoms, \(w=3\), so the typical
shared-point density is

\[
2(1-e^{-1/2})\approx0.78694,
\]

while the binary shared-point density is \(e^{-1/2}\approx0.60653\).
Hence binary dominance is a large-capacity, fixed-\(k\) phenomenon; it is not
the typical shape when the number of minimum-size atoms tends to infinity.

## 6. Prescribed connected-component partition

Let \(\pi\) be a prescribed set partition of the atom labels.  For a block
\(B\in\pi\), put

\[
P_B=\prod_{i\in B}w_i,
\qquad
v_B=\sum_{i\in B}w_i-|B|+1.
\]

### Theorem 5 — componentwise total count

The number of attachment quotients whose connected atom components are exactly
the blocks of \(\pi\) is

\[
\boxed{
N_\pi(\mathbf A)
 =\prod_{B\in\pi}P_Bv_B^{|B|-2},
}
\tag{6.1}
\]

where a singleton block contributes \(1\), equivalently
\(P_Bv_B^{-1}=w_i/w_i=1\).

Conditional on this component partition, the attachment structures of the
blocks factor independently, and the shared-point profile in block \(B\) is
the occupancy profile of \(|B|-1\) balls in \(v_B\) boxes.

If only the number \(c\) of connected components is prescribed, the exact
count is

\[
\boxed{
\sum_{\substack{\pi\text{ a set partition of }[k]\\|\pi|=c}}
\prod_{B\in\pi}P_Bv_B^{|B|-2}.
}
\tag{6.2}
\]

No simpler universal closed form is claimed for unequal atom orders.

## 7. What this improves

The preceding attachment-enumeration theorem gave every coefficient
\(N_t\).  The occupancy collapse adds four stronger layers:

1. the total count \(Pv^{k-2}\);
2. the complete random multiplicity-profile law, not merely its support;
3. real-rootedness, strict ultra log-concavity, and a Poisson--binomial
   representation; and
4. a sharp distinction between fixed-\(k\) high-capacity behavior and the
   many-atom proportional-capacity regime.

The result remains an enumerative consequence of the canonical atom theorem.
It does not strengthen the infinitary obligatoriness classification.

## 8. Literature and priority boundary

The balls-into-boxes occupancy law, Stirling identities, real-rootedness
methods, Newton inequalities, and Poisson--binomial consequences are classical.
The contribution proposed here is the exact identification of the canonical
attachment quotient measure with that occupancy model and the resulting closed
forms for the obligatory-system atom forest.  This is presented as a derived
structural-enumerative consequence under review, not as a priority claim for
the classical tools.

## 9. Non-goals

This note does not:

- count unlabelled obligatory-system isomorphism classes;
- quotient by automorphisms of repeated or symmetric atoms;
- identify the Bernoulli parameters in (4.6) in elementary closed form;
- claim independence of physical shared points or atom incidences;
- analyze the maximum shared-point multiplicity in the growing-\(k\) regime;
- alter Theorem A, the avoiding-host construction, or the one-apex lift;
- integrate these enumerative results into the main Problem 593 manuscript; or
- add a Lean theorem.
