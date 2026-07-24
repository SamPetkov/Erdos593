from pathlib import Path

TEX = Path('erdos593_obligatory_triple_systems.tex')
NOTE = Path('FINITE_PARAMETER_SPECTRUM.md')


def replace_once(text: str, old: str, new: str, label: str) -> str:
    count = text.count(old)
    if count != 1:
        raise SystemExit(f'{label}: expected one occurrence, found {count}')
    return text.replace(old, new, 1)


tex = TEX.read_text(encoding='utf-8')
tex = replace_once(
    tex,
    'triple systems, together with a Lean formalisation and sharp finite parameter\nconsequences.',
    'triple systems, together with a Lean formalisation of the classification and\nsharp finite parameter consequences.',
    'abstract Lean scope',
)
tex = replace_once(
    tex,
    'system with $m\\ge1$ hyperedges and $c$ connected components has order $n$\nprecisely when',
    'system with $m\\ge1$ hyperedges and $1\\le c\\le m$ connected components has\norder $n$ precisely when',
    'abstract component range',
)

# The current cycle-rank displays are the only tagged equations 10.6 and 10.7.
# Move them before inserting four new tagged displays.
tex = replace_once(tex, r'\tag{10.6}', r'\tag{10.10}', 'cycle-rank equation tag')
tex = replace_once(tex, r'\tag{10.7}', r'\tag{10.11}', 'cycle-rank range tag')
tex = replace_once(
    tex,
    'which gives (10.6).  Substitution of the two endpoints in (10.2) gives\n(10.7),',
    'which gives (10.10).  Substitution of the two endpoints in (10.2) gives\n(10.11),',
    'cycle-rank proof references',
)

tex_insert = r'''\begin{corollary}[Size spectrum at fixed order]
\label{corollary-fixed-order-size-spectrum}
Let $c\ge1$ and $n\ge3c$.  A reduced obligatory triple system with exactly
$n$ vertices, $c$ connected components, and $m$ hyperedges exists if and only
if
\[
\boxed{
\left\lceil\frac{n-c}{2}\right\rceil
\le m\le
n-2c+4-\left\lceil2\sqrt{n-3c+4}\right\rceil.
}
\tag{10.6}
\]
Consequently, a reduced obligatory triple system with exactly $c$ connected
components and $n$ vertices exists if and only if
\[
n=3c,\qquad n=3c+2,\qquad\text{or}\qquad n\ge3c+4.
\tag{10.7}
\]
\end{corollary}
\begin{proof}
The upper-order inequality in (10.2) is equivalent to
$m\ge\lceil(n-c)/2\rceil$.  For the other inequality put
\[
M=m-c+1,\qquad N=n-3c+3.
\]
It becomes
\[
M+\left\lceil2\sqrt M\right\rceil\le N.
\tag{10.8}
\]
For integers $N\ge3$ and $M\ge1$, the largest $M$ satisfying (10.8) is
\[
U=N+2-\left\lceil2\sqrt{N+1}\right\rceil.
\tag{10.9}
\]
Indeed, write $k=\lceil2\sqrt{N+1}\rceil$.  Since
$k^2\ge4(N+1)$,
\[
4U=4N+8-4k\le(k-2)^2,
\]
so $\lceil2\sqrt U\rceil\le k-2$ and
$U+\lceil2\sqrt U\rceil\le N$.  On the other hand,
$(k-1)^2<4(N+1)$ gives
\[
(k-3)^2<4(N+3-k)=4(U+1),
\]
so $\lceil2\sqrt{U+1}\rceil\ge k-2$ and
$(U+1)+\lceil2\sqrt{U+1}\rceil\ge N+1$.  The left side of (10.8) is
strictly increasing in $M$, proving (10.9).  Translating back to $m$ gives
(10.6).

For (10.7), Corollary~\ref{corollary-connected-order-size-spectrum} shows that
a connected reduced obligatory system has order $3$, order $5$, or any order
at least $7$.  The first two statements come from $m=1,2$.  For $m\ge3$, the
connected intervals have no gaps because
$\lceil2\sqrt{m+1}\rceil\le m+1$ for $m+1\ge4$.  Thus every component has
order
\[
3+r,\qquad r\in\{0,2\}\cup[4,\infty).
\]
The sum of $c$ such increments is again $0$, $2$, or any integer at least
$4$: use one nonzero increment and take all remaining increments to be zero.
The increments $1$ and $3$ are impossible.  This proves (10.7).
\end{proof}

'''
tex = replace_once(
    tex,
    r'\begin{corollary}[Exact Levi cycle-rank spectrum]',
    tex_insert + r'\begin{corollary}[Exact Levi cycle-rank spectrum]',
    'fixed-order TeX insertion',
)
TEX.write_text(tex, encoding='utf-8')

note = NOTE.read_text(encoding='utf-8')
note_insert = r'''### Size spectrum at fixed order

For integers `c >= 1` and `n >= 3c`, the possible numbers of hyperedges are
exactly the integers in

\[
\boxed{
\left\lceil\frac{n-c}{2}\right\rceil
\le m\le
n-2c+4-\left\lceil2\sqrt{n-3c+4}\right\rceil.
}
\]

To invert the lower-order inequality, put
`M=m-c+1` and `N=n-3c+3`.  For `N >= 3`, the largest positive integer `M`
with

\[
M+\left\lceil2\sqrt M\right\rceil\le N
\]

is

\[
N+2-\left\lceil2\sqrt{N+1}\right\rceil.
\]

If `k=ceil(2 sqrt(N+1))` and `U=N+2-k`, then
`k^2 >= 4(N+1)` implies `ceil(2 sqrt U) <= k-2`, while
`(k-1)^2 < 4(N+1)` implies `ceil(2 sqrt(U+1)) >= k-2`.  Thus `U` works and
`U+1` does not; monotonicity completes the inversion.

In particular, the possible reduced orders with exactly `c` connected
components are

\[
\boxed{n=3c,\qquad n=3c+2,\qquad\text{or}\qquad n\ge3c+4.}
\]

A connected component has order `3`, order `5`, or any order at least `7`.
After subtracting the baseline `3` per component, the available increments are
`0`, `2`, and every integer at least `4`, whose `c`-fold sum has the same form.
Hence `3c+1` and `3c+3` are the only missing reduced orders for a fixed
component count.

'''
note = replace_once(
    note,
    '### Exact Levi cycle rank\n',
    note_insert + '### Exact Levi cycle rank\n',
    'fixed-order note insertion',
)
NOTE.write_text(note, encoding='utf-8')

print('applied fixed-order spectrum refinement')
