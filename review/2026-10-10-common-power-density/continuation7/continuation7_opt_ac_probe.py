"""Fixed-list adversarial ac-mode probe; no optimization or target claim."""
import os
os.environ['OPENBLAS_NUM_THREADS']='1'
os.environ['OMP_NUM_THREADS']='1'
from pathlib import Path
import importlib.util,itertools,json,hashlib
from fractions import Fraction
import numpy as np

ROOT=Path(__file__).resolve().parent
OLD=ROOT/'erdos593-density-continuation/review/2026-10-10-common-power-density/continuation6/continuation6_cover_moments_verify.py'
TUPLES=((3,1,1,1),(4,4,1,1),(1,1,2,1),(8,1,2,1),(2,1,4,1),(4,1,8,1),
        (8,4,1,1),(4,2,4,1),(8,2,4,2),(2,2,8,1),(4,4,8,2),(8,8,8,1))

def main():
    spec=importlib.util.spec_from_file_location('signhost',OLD)
    old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
    states,phi,M=old.build()
    active=[]
    for modes in itertools.product(range(7),repeat=6):
        i,j,k,l,m,n=modes
        coeff=M.get((i,j,k),0)*M.get((i,l,m),0)*M.get((j,l,n),0)*M.get((k,m,n),0)
        if coeff:active.append((modes,coeff))
    exact=[]
    for k,u,r,l in TUPLES:
        coeff=[Fraction() for _ in range(7)]
        for modes,c in active:
            for edge,power in ((0,k),(2,u),(3,r),(4,u),(5,l)):
                c*=old.THETA[modes[edge]]**power
            coeff[modes[1]]+=c
        exact.append({'tuple_without_h':[k,u,r,l],
          'ac_coefficients':[{'numerator':str(c.numerator),'denominator':str(c.denominator)} for c in coeff],
          'negative_active_modes':[i for i,c in enumerate(coeff) if c<0]})
    oldruns=json.loads((ROOT/'continuation7_opt_highrank_results.json').read_text())
    diagnostics=[]
    for case in oldruns['cases']:
        mu=np.array(case['retained']['pi']);P=np.array(case['retained']['P']);n=len(mu)
        B=P@P;sym=np.sqrt(mu[:,None])*B/np.sqrt(mu[None,:])
        theta,U=np.linalg.eigh((sym+sym.T)/2)
        kernels={j:np.linalg.matrix_power(P,2*j)/mu[None,:] for j in (1,2,3,4,8)}
        for k,u,r,l in TUPLES[:6]:
            F=(kernels[k][:,:,None]*kernels[u][:,None,:]).reshape(n,n*n)
            H=(kernels[r][:,:,None]*kernels[l][:,None,:]).reshape(n,n*n)
            wt=(mu[:,None]*mu[None,:]*kernels[u]).reshape(-1)
            D=(F*wt[None,:])@H.T
            E=np.sqrt(mu[:,None]*mu[None,:])*D
            ds=np.einsum('ai,ab,bi->i',U,E,U,optimize=True)
            scale=max(1.,float(np.linalg.norm(E,ord=2)))
            active_modes=np.where(theta>1e-14)[0]
            negatives=[int(i) for i in active_modes if ds[i]<-1e-9*scale]
            diagnostics.append({'case':case['index'],'tuple_without_h':[k,u,r,l],
               'square_eigenvalues':theta.tolist(),'ac_coefficients':ds.tolist(),
               'operator_scale':scale,'strict_negative_active_modes':negatives,
               'minimum_active_coefficient':float(min(ds[active_modes])),
               'minimum_scaled_active_coefficient':float(min(ds[active_modes])/scale)})
    out={'source_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
         'exact_sign_host_cases':exact,'numeric_saved_root_cases':diagnostics,
         'status':'fixed-list probe only; any negative coefficient is a sufficient-lemma failure, not F<1'}
    (ROOT/'continuation7_opt_ac_probe_results.json').write_text(json.dumps(out,indent=2)+'\n')
    print('sign negatives',[(x['tuple_without_h'],x['negative_active_modes']) for x in exact if x['negative_active_modes']])
    print('numeric negatives',[(x['case'],x['tuple_without_h'],x['strict_negative_active_modes']) for x in diagnostics if x['strict_negative_active_modes']])
    print('minimum numeric scaled coefficient',min(x['minimum_scaled_active_coefficient'] for x in diagnostics))

if __name__=='__main__':main()
