# Endpoint-calibrated short-edge trial

14 October 2026. This is a proved normalization and budget identity plus a matched-star special case. The general budget sign remains open. It does not prove the unrestricted density theorem.

Use the two-star notation (k,p,q,s,t,ell), with p>=s, q>=t and now 1<=k<=s+t. Define on the original law

    f(x,y,w)=K_s(x,w)K_t(y,w),
    a(x,y)=K_(s+t)(x,y),  c(x,y)=K_k(x,y),
    g(x,y,w)=E_z K_p(x,z)K_q(y,z)K_ell(w,z).

Set

    b(x,y,w)=c(x,y)f(x,y,w)/a(x,y)

where a>0, and zero otherwise. Odd or fractional times do not occur. The support inclusion c>0 implies a>0 because a is obtained from c by the actual nonnegative power A^(s+t-k), whose diagonal is positive. Integrating w gives c exactly, so b is a normalized probability density with original x and y marginals. Its w marginal need not equal mu and is not claimed to do so. All reference expectations and host compositions remain against original mu.

On b>0, f>0 and the existing product-square argument gives g>0. Sample (x,y,w) according to b and then z with conditional density K_p(x,z)K_q(y,z)K_ell(w,z)/g. This is normalized without F. The ratio of the original six-factor product to the constructed density is a(x,y)g(x,y,w). Its exact Gibbs value is

    V_cal=E_{mu^3} b log g + E_{mu^2} c log a.

This cancels, rather than omits, the selection cost. In particular

    D_{mu^3}(b||f)=D_{mu^2}(c||a).

Here D_nu(b||f) means the relative entropy of b nu against f nu. Conditional path bridges can be added exactly as in the preceding two-star proof; all six target factors are positive on this law's support and their actual normalizers cancel in the entropy chain rule.

The pair contribution has the proved sign

    E c log a = D(T^(k+s+t)) + J_(T^(s+t-k) tensor I)(c) >= 0.

The remaining E b log g is not asserted nonnegative in general. The old square lemma applies to f, not automatically to b; silently replacing its input would be invalid. A lower bound on this term sufficient to pay the complete displayed V_cal is still needed.

## Matched-star check with a full proof

When p=s and q=t, define beta_xy(w)=f(x,y,w)/a(x,y) on c>0. It is a probability relative to original mu, and

    g(x,y,.)=a(x,y) A^ell beta_xy.

Apply the support-safe square lemma on the w space with P=T^ell, separately for each sampled pair. Then

    E b log g = E c log a
        + E_{mu^2} c[D_mu(T^ell beta_xy)+J_(T^ell)(beta_xy)].

Thus V_cal>=2 E c log a>=2D(T^(k+s+t))>=0, with equality only for T=Pi. Together with the old long-edge theorem this handles all k in the matched-star setting. It is a calibration of the new reference law, not a claim that the original asymmetric J=r+h target always has matched stars.

## Exact diagnostic on the failed old trial

The checker certifies

    2.13769805608317 < V_cal < 2.13769805608318,
    1.46326379831862 < E b log g < 1.46326379831863.

These endpoints are rational decimal bounds, not floating-point sign tests. It evaluates b and its budget on the same strictly positive nine-state root epsilon Pi+(1-epsilon)T_C9, epsilon=10^(-14), at (k,p,q,s,t,ell)=(2,3,2,2,2,2). It verifies exact normalization, the actual endpoint marginal, and directed-log positivity of V_cal. The retained output and report give the resulting bounds. This repairs that particular trial failure, not every actual root or exponent tuple.
