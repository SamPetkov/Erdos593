# Two-star Markov smoothing: proved exponent ranges

14 October 2026. Analytical proof; finite checks are diagnostics. The unrestricted ordered common-power density theorem remains open. This note does not change the accepted Lean development or any manuscript theorem.

## Contract and result

Let X be finite and nonempty, mu a strictly positive probability, and T a symmetric entrywise nonnegative relative Markov kernel. All compositions, conditional laws and entropies use mu or its original product law. Write K_n=T^(2n); T^0 is the weighted identity. No rank, nonsingularity, mixing, range-projection-sign or irreducibility assumption is imposed.

For positive integers k,p,q,s,t,ell define

    Fcal = E K_k(x,y) K_p(x,z) K_q(y,z)
             K_s(x,w) K_t(y,w) K_ell(z,w).

If p>=s, q>=t and k>=s+t, then

    log Fcal >= D_{mu^3}(M) + D_{mu^2}(T^(k+s+t)) >= 0,

    M(x,y,w)=E_z T^(p+s)(x,z) T^(q+t)(y,z) T^ell(w,z).

Here D_nu(a)=E_nu a log a for a normalized nonnegative density. Equality Fcal=1 holds exactly when T=Pi.

For the original ordered tuple k>=u>=1, r>=l>=1, h>=1, J=r+h, this proves both all-host ranges

    r>=u and k>=2u;
    u>=J and k>=J+r.

The proof below is complete in these ranges; they are not a proof of the unrestricted target.

## 1. Support-safe logarithmic smoothing

Let P be any symmetric entrywise nonnegative Markov kernel on a finite probability space (Y,nu), and let f>=0, E_nu f=1. Set g=Pf and h=P^2 f. For each x with f(x)>0 define

    p_x(y)=nu(y)P(x,y),
    q_x(y)=nu(y)P(x,y)g(y)/h(x).

Both are probabilities. Indeed P^2(x,x)=E_nu P(x,.)^2>=1, hence h(x)>=nu(x)P^2(x,x)f(x)>0. If p_x(y)>0, symmetry gives g(y)>=nu(x)P(y,x)f(x)>0. Thus D(p_x||q_x) is finite and equals

    log h(x) - sum_y p_x(y) log g(y).

Multiplying by nu(x)f(x), summing, and using self-adjointness gives

    E_nu f log(P^2 f) = D_nu(Pf) + J_P(f),
    J_P(f)=sum_{x:f(x)>0}nu(x)f(x)D(p_x||q_x)>=0.

All zero terms are evaluated on their actual support. No PSD assumption on P is needed; no noncommuting-product sign is asserted.

## 2. The two stars

On Y=X^3 set

    f(x,y,w)=K_s(x,w)K_t(y,w),
    g(x,y,w)=E_z K_p(x,z)K_q(y,z)K_ell(w,z).

Both integrate to one. Use the actual product Markov kernel

    P=T^(p-s) tensor T^(q-t) tensor T^ell.

Its exponents are nonnegative integers. Direct composition gives Pf=M and P^2 f=g. The preceding identity pays

    E f log g = D(M)+J_P(f)>=0.

The (x,y) marginal of f is K_(s+t). On X^2 let

    P_e=T^(k-s-t) tensor I.

It is actual Markov and satisfies

    P_e K_(s+t)=T^(k+s+t),
    P_e^2 K_(s+t)=K_k.

Consequently

    E_{mu^2} K_(s+t) log K_k
       =D_{mu^2}(T^(k+s+t))+J_(P_e)(K_(s+t))>=0.

On f>0, both g and K_k are positive by the support argument above. Since Fcal=E f K_k g, Jensen under the single normalized law f mu^3 gives

    log Fcal >= E_f log(K_k g)
       =D(M)+D(T^(k+s+t))+J_P(f)+J_(P_e)(K_(s+t)).

Every term is paid, with the endpoint marginal coming from this same f. No reserve from another density decomposition is added.

## 3. Explicit law and actual path interiors

Sample (x,y,w) with density f. Given those states, sample z with probability

    mu(z)K_p(x,z)K_q(y,z)K_ell(w,z)/g(x,y,w).

This defines tau with density f times the displayed conditional factor. Integrating z gives f and then total mass one; Fcal is not used as a normalizer. The ratio of the target six-factor product to tau's density is exactly K_k g. Thus its Gibbs variational value is the four nonnegative terms above. No simultaneous prescribed pair tables are assumed.

For a branch edge of actual length 2n, complete its disjoint interior by density

    product T(x_j,x_(j+1)) / K_n(endpoint_1,endpoint_2)

relative to the original interior product law. Every denominator is positive on tau's support and composition normalizes the bridge. The entropy chain rule cancels each bridge log density against the root-edge energy, retaining exactly the branch variational value. This proves compatibility on all actual subdivision vertices.

If D(T^(k+s+t))=0, positivity of mu implies T^(k+s+t)=Pi. A complete real eigenbasis of self-adjoint T then makes every nonconstant eigenvalue zero. Hence T=Pi. Conversely that root gives equality. Negative root eigenvalues, additional unit modes, singularity and zero modes are retained.

## 4. Transfer to the ordered target

For r>=u and k>=2u, use (x,y,z,w)=(a,b,c,d) and (p,q,s,t,ell)=(J,r,u,u,l). Then

    log F >= D(M_A)+D(T^(k+2u)),
    M_A(a,b,d)=E_z T^(J+u)(a,z)T^(r+u)(b,z)T^l(d,z).

For u>=J and k>=J+r, use (x,y,z,w)=(a,b,d,c) and (p,q,s,t,ell)=(u,u,J,r,l). Then

    log F >= D(M_B)+D(T^(k+J+r)),
    M_B(a,b,c)=E_z T^(u+J)(a,z)T^(u+r)(b,z)T^l(c,z).

Both transfers preserve every original kernel and mu. Boundary equalities are allowed. Examples inside J-l<u<r+l are (k,u,r,l,h)=(10,4,5,3,1) and (7,5,3,3,1).

## 5. Exact obstruction to deleting the long-edge premise

On Z/9Z with uniform mu, set T0(i,j)=9/2 for adjacent cycle vertices and zero otherwise. Let epsilon=10^(-14) and T=epsilon Pi+(1-epsilon)T0. This is a strictly positive symmetric nonsingular actual root. Use (k,u,r,l,h)=(2,2,2,2,1), hence (k,p,q,s,t,ell)=(2,3,2,2,2,2).

The star inequalities hold, but k<s+t. Since T is positive the same normalized trial exists. Exact rational arithmetic and directed dyadic logarithm enclosures give

    -0.321858 < E_f log g + E_{mu^2}K_4 log K_2 < -0.321857,
    9.475444078443 < F < 9.475444078445.

This refutes only the trial's proposed unrestricted sign, not F>=1. At epsilon=0, K_2(4,0)>0 and K_2(5,0)>0 but K_2(4,5)=0: the base law charges an endpoint pair the shorter edge excludes.

## 6. Evidence and remaining domain

Run `python exact_checks.py`. It writes `exact_certificate.json`; this generated file is intentionally not committed. The retained output reports 687 counted exact assertions. Full-host universality follows from Sections 1-4, not those finite tests. Logarithmic signs use directed 256-bit dyadic enclosures, 100 odd-series terms and a proved remainder bound. Printed floats are display only.

Within the unpaid strip, the complement of the two ranges is

    u<=r and k<2u;
    r<u<J, for any k;
    u>=J and k<J+r.

Intersect this with independently established coverage; do not infer that every remaining tuple is uncovered by every earlier orientation. The first/third cases need another entropy payment for a possibly negative short edge; the middle case has crossing star lengths. The proof does not resolve general k=u. No Lean execution, independent review, novelty clearance or publication-readiness claim is made.

## Context, not proof dependencies

The logarithmic method is related to Li and Szegedy, *On the logarithmic calculus and Sidorenko's conjecture*, https://arxiv.org/abs/1107.1153. No statement from that paper is needed beyond the Jensen/KL facts proved above. Im, Li and Liu, *Sidorenko's conjecture for subdivisions and theta substitutions*, https://arxiv.org/abs/2408.03491, has specific nonuniform-substitution hypotheses; no unconditional mixed-power transfer is invoked here.
