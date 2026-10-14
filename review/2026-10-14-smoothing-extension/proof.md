# Tree-based smoothing with compatible chord payments

14 October 2026. This is a proved extension of the two-star mechanism, not a proof of the unrestricted ordered K4 density. No new original-target exponent region is claimed solely from this extension. All hosts use the original positive law and an actual symmetric nonnegative Markov root. Analytical derivation and finite checks are separate; no independent or Lean review is claimed.

## 1. The exact theorem

Let H=(V,E) be a finite tree with at least two vertices. Give each edge e a positive integer root length L_e. Let

    f(x)=product_{uv in E} T^(L_uv)(x_u,x_v),  nu=mu^V.

Choose nonnegative integers a_v and the actual product Markov kernel

    P=tensor_{v in V} T^(a_v).

Let C be any simple graph on V. For each chord ij in C, let d_ij be the sum of L_e on its unique H-path. Give that chord an integer root length b_ij satisfying

    b_ij >= d_ij,   b_ij-d_ij even.

Then

    Q=E_nu f(x)(P^2 f)(x) product_{ij in C} T^(b_ij)(x_i,x_j)

satisfies

    log Q >= D_nu(Pf)
             + sum_{ij in C} D_{mu^2}(T^((b_ij+d_ij)/2)) >= 0.

For these product kernels P, equality Q=1 holds if and only if T=Pi. Empty C and zero a_v are allowed. The theorem is a kernel identity/inequality; no blanket assertion about arbitrary graph subdivisions is implicit.

## 2. One globally compatible reference law

Pruning leaves and applying the actual row sums proves E_nu f=1. Pruning all branches off the unique i-j path and then composing along that path proves that its exact (i,j) marginal is T^(d_ij). Every pair comes from this one tree law; there is no separately postulated collection of pair tables.

The support-safe logarithmic lemma in ../2026-10-14-two-star/proof.md gives

    E_nu f log(P^2f)=D_nu(Pf)+J_P(f),   J_P(f)>=0.

For each chord use the actual pair operator

    P_ij=T^((b_ij-d_ij)/2) tensor I.

On the existing marginal T^(d_ij), it has midpoint T^((b_ij+d_ij)/2) and square output T^(b_ij). Thus

    E_{mu^2}T^(d_ij)log T^(b_ij)
       =D(T^((b_ij+d_ij)/2))+J_(P_ij)(T^(d_ij)).

The source density is positive only where every required square output is positive. Jensen under f nu now gives the exact paid lower bound

    log Q >= D(Pf)+J_P(f)
              + sum_{ij in C}[D(T^((b_ij+d_ij)/2))
                              +J_(P_ij)(T^(d_ij))].

All credits refer to the same f and are used once. The sum over chords is a sum of actual expectations under f, not an assumption that the chord-weighted distribution retains the old marginals.

## 3. Normalized law on the two tree copies

Write g=P^2f. First sample x with density f. Conditional on x, sample y from

    nu(y) f(y) product_{v in V}T^(2a_v)(x_v,y_v)/g(x).

The conditional denominator is exactly its original-law integral. It is positive on f>0 by the logarithmic lemma. Thus this is a probability without using Q. The target product divided by this joint density is exactly g(x) times the chord product. Its Gibbs variational value is the complete paid expression in Section 2.

Attach distinct path interiors for every positive root length using the actual conditional bridges. A zero rung uses delta_xy/mu(y), identifying the two variables after integration. It is not a constant projection. The entropy chain rule cancels all path factors and yields the same budget. No fractional entrywise-positive kernel, modified host law, or spectral-range projection is used.

For strictness, choose any two distinct vertices i,j. The (i,j) marginal of Pf is T^(a_i+d_ij+a_j), a positive integer power. If D(Pf)=0, this power equals Pi. Self-adjointness then forces every nonconstant eigenvalue of T to vanish, so T=Pi. This keeps extra unit modes, negative root modes and zero modes. The converse is immediate.

## 4. Many-leaf two-star specialization

Let V contain leaves x_1,...,x_m and a hub w, with m>=2. Put L_(i,w)=2s_i, choose p_i>=s_i>=1 and ell>=1, and set a_i=p_i-s_i, a_w=ell. For any leaf graph C choose k_ij>=s_i+s_j and b_ij=2k_ij. Suppressing the copied leaf paths by exact composition yields

    F_m=E_{x_1,...,x_m,w,z} K_ell(w,z)
          product_i K_(s_i)(x_i,w)K_(p_i)(x_i,z)
          product_{ij in C}K_(k_ij)(x_i,x_j).

The bound becomes

    log F_m >= D_{mu^(m+1)}(M)
                +sum_{ij in C}D_{mu^2}(T^(k_ij+s_i+s_j)),

    M(x,w)=E_z T^ell(w,z)product_i T^(p_i+s_i)(x_i,z).

The case m=2 with the sole leaf edge is exactly the two-star theorem. The extra leaf-edge budgets are simultaneously compatible because all their base marginals are those of the same normalized star law.

Every density, midpoint and conditional law factors on a product host equipped with its original product law. Entropies add exactly. Thus this proof is stable under tensor products, without a minimum-kernel threshold.

## 5. What this does not prove

The chord premise is real. The two-star nine-state fixture has b_xy<d_xy and a strictly negative value for the old trial; this theorem must not be applied there. Crossing spoke filters also fail the nonnegative a_v premise. The general K4 target is not represented by these tree/chord data at every ordered tuple. No further transformation is asserted.

The companion short-edge note constructs a different endpoint-calibrated law, with its own explicit entropy accounting. Its unrestricted sign is not a consequence of this theorem. The two ledgers are never added.
