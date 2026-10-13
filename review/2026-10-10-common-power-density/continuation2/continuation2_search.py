"""Bounded, structured actual-root two-cover experiment. No global proof claim.

Modes: freeze, sample, optimize. All inputs and per-cell results are retained.
Only ordered target tuples are admitted. A cover candidate is distinct from
an original-target candidate; exact signs are reported separately.
"""
import argparse,hashlib,json,math,sys,time
from fractions import Fraction
from functools import lru_cache
from pathlib import Path
import numpy as np
from scipy.optimize import minimize
from continuation2_sign_engine import (law_data,actual_root,rational_vector,base_poly,
 defect_poly,boundary_float,exact_certificate,evaluate,color_records)

PREFIX='continuation2_'

def write_json(name,x):Path(PREFIX+name+'.json').write_text(json.dumps(x,indent=2)+'\n')
def read_json(name):return json.loads(Path(PREFIX+name+'.json').read_text())
def filehash(name):return hashlib.sha256(Path(name).read_bytes()).hexdigest()
def fracs(xs):return tuple(Fraction(v)for v in xs)
def fstr(xs):return [str(v)for v in xs]

def freeze():
    laws=[('supplied_half',['1/2','1/2','1/2','-1/2']),
          ('one_star_face',['3/4','1/4','1/4','-1/4']),
          ('two_star_face',['1/2','1/2','1/4','-1/4']),
          ('opposite_star_face',['1/2','1/4','1/4','-1/2']),
          ('asymmetric_interior',['9/20','2/5','7/20','-3/10']),
          ('attenuated_half',['17/40','17/40','17/40','-17/40']),
          ('skew_star_face',['4/5','1/5','1/10','-1/10'])]
    lrecords=[]
    for name,t in laws:
        d=law_data(fracs(t));lrecords.append({'name':name,'t':t,'states':len(d['states']),'mu_denominator':d['mu_denominator']})
    patterns=[{'name':'supplied_spectrum','lambda':fstr((Fraction(1,2**64),Fraction(1,32),Fraction(1,4),Fraction(1,8),Fraction(1,16),Fraction(1,8)))}]
    integer_patterns=[('near_equal',[37,39,43,47,53,59]),('geometric',[1,2,4,8,16,32]),
      ('steep',[1,4,16,64,256,1024]),('permuted_steep',[1,256,16,64,4,1024]),
      ('signed_near_equal',[37,-39,43,-47,53,-59]),('signed_steep',[-1,4,-16,64,256,-1024]),
      ('mild_separation',[1,1,1,2,3,5])]
    rng=np.random.default_rng(20261012)
    for j in range(8,16):
        a=(2**rng.integers(0,11,size=6))*rng.choice([1,3,5,7],size=6)
        if j%2:a*=rng.choice([-1,1],size=6)
        if j>=12:a[(j-12)%6]=0
        if j==15:a[0]=0
        integer_patterns.append((f'seeded_{j}',list(map(int,a))))
    for name,nums in integer_patterns:
        den=4*sum(abs(v)for v in nums);patterns.append({'name':name,'lambda':fstr([Fraction(3*v,den)for v in nums]),'integer_direction':nums})
    tuples=[(1,1,1,1,1),(2,1,2,1,1),(2,2,1,1,1),(3,2,3,2,1),
      (1,1,3,3,1),(4,4,1,1,8),(8,4,1,1,8),(16,4,1,1,8),
      (3,1,2,1,3),(3,2,5,3,7),(1,1,1,1,16),(4,4,2,2,1)]
    sources=['continuation2_sign_engine.py','continuation2_search.py','continuation2_engine_checks.py']
    cfg={'schema':'actual-sign-two-cover/v1','seed':20261012,'tuple_order':['k','u','r','l','h'],
      'tuples':tuples,'laws':lrecords,'patterns':patterns,'root_modes':['interior','boundary'],
      'two_cover_bits':[1,2,3,4,5,6,7],'planned_host_tuple_evaluations':7*16*2*12,
      'planned_cover_comparisons':7*16*2*12*7,
      'optimization_cap':{'starts':12,'iterations_per_start':80,'log_bounds':[-50,2],'ftol':1e-13,'gtol':1e-10,'maxls':30},
      'credible_normalized_negative_threshold':-1e-10,'source_sha256':{p:filehash(p)for p in sources},
      'relaxed_tuples_tested':False}
    assert len(patterns)==16
    write_json('config',cfg);print('CONFIG_FROZEN',filehash(PREFIX+'config.json'),flush=True)

@lru_cache(maxsize=None)
def prepared(t_strings,tpl,bits):
    if bits==0:
        rows,c=base_poly(tpl);keep=np.any(rows!=0,axis=1);rows=rows[keep];c=c[keep]
    else:rows,c=defect_poly(tpl,bits)
    t=np.array([float(Fraction(v))for v in t_strings]);coeff=c*np.prod(t[None,:]**rows[:,:4],axis=1)
    keep=coeff!=0;coeff=coeff[keep];p=rows[keep,4:]
    return np.log(np.abs(coeff)),np.sign(coeff),p

def scaled_eval(prep,lam,gradient=False):
    logs,sgn,p=prep;lam=np.asarray(lam);nz=lam!=0;ll=np.zeros(6);ll[nz]=np.log(np.abs(lam[nz]));lt=logs+p@ll
    if not np.all(nz):lt=np.where(np.any(p[:,~nz]>0,axis=1),-np.inf,lt)
    shift=float(np.max(lt))
    if not np.isfinite(shift):
        if gradient:return 0.,np.zeros(6),{'value':0.,'log_abs_sum':None,'normalized':0.,'zero_polynomial_at_point':True}
        return {'value':0.,'log_abs_sum':None,'normalized':0.,'zero_polynomial_at_point':True}
    terms=sgn*np.exp(lt-shift);val=float(np.sum(terms));ab=float(np.sum(np.abs(terms)));ratio=val/ab
    value=math.exp(shift)*val if shift>-745 else 0.
    info={'value':value,'log_abs_sum':shift+math.log(ab),'normalized':ratio,'zero_polynomial_at_point':False}
    if not gradient:return info
    dv=np.zeros(6);da=np.zeros(6);dv[nz]=(terms@p[:,nz])/lam[nz];da[nz]=(np.abs(terms)@p[:,nz])/lam[nz]
    return ratio,(dv*ab-val*da)/(ab*ab),info

def current_hashes():return {p:filehash(p)for p in ['continuation2_sign_engine.py','continuation2_search.py','continuation2_engine_checks.py']}

def sample():
    cfg=read_json('config');assert cfg['source_sha256']==current_hashes();start=time.time();records=[];cells=[];best_cover=None;best_target=None;certificates=[]
    for li,law in enumerate(cfg['laws']):
        t=fracs(law['t']);ln=0;minnorm=math.inf;minF=math.inf
        for pi,pat in enumerate(cfg['patterns']):
            initial=fracs(pat['lambda'])
            for mode in cfg['root_modes']:
                d=actual_root(t,initial,boundary=mode=='boundary');lam=d['lambda']
                for ti,tpl0 in enumerate(cfg['tuples']):
                    tpl=tuple(tpl0);tv=scaled_eval(prepared(tuple(law['t']),tpl,0),lam);F=1+tv['value'];cover_records=[]
                    rec={'id':[li,pi,mode,ti],'law':law['name'],'pattern':pat['name'],'tuple':tpl,'root_mode':mode,
                         't':law['t'],'lambda_numerators':d['lambda_numerators'],'lambda_denominator':d['lambda_denominator'],
                         'state_count':len(d['states']),'root_minimum':str(d['min_root']),'root_maximum':str(d['max_root']),
                         'F_approx':F,'target_defect':tv,'target_candidate_numeric':tv['normalized']<cfg['credible_normalized_negative_threshold']}
                    for bits in cfg['two_cover_bits']:
                        q=scaled_eval(prepared(tuple(law['t']),tpl,bits),lam)
                        cr={'bits':bits,'cover_defect_F2_minus_Z':q,'cover_ratio_approx':1-q['value']/(F*F),
                            'cover_candidate_numeric':q['normalized']<cfg['credible_normalized_negative_threshold']}
                        cover_records.append(cr)
                        if best_cover is None or q['normalized']<best_cover['cover_defect_F2_minus_Z']['normalized']:
                            best_cover={**cr,'record_id':rec['id']}
                        minnorm=min(minnorm,q['normalized'])
                        if cr['cover_candidate_numeric']or rec['target_candidate_numeric']:
                            exact_lam=tuple(Fraction(v,d['lambda_denominator'])for v in d['lambda_numerators'])
                            cert=exact_certificate(t,exact_lam,tpl,bits);cert.update({'source_record_id':rec['id'],'numeric_cover_normalized_defect':q['normalized']})
                            certificates.append(cert);write_json('sample_certificates',certificates)
                            print('EXACT_CANDIDATE_CHECK',rec['id'],bits,'target',cert['target_violation'],'cover',cert['cover_violation'],flush=True)
                    rec['covers']=cover_records;records.append(rec);ln+=1;minF=min(minF,F)
                    if best_target is None or tv['normalized']<best_target['target_defect']['normalized']:best_target={'record_id':rec['id'],'target_defect':tv,'F_approx':F}
        row={'law':law['name'],'state_count':law['states'],'host_tuple_evaluations':ln,'cover_comparisons':ln*7,'minimum_normalized_cover_defect':minnorm,'minimum_F_approx':minF};cells.append(row)
        write_json('samples',{'schema':cfg['schema'],'config_sha256':filehash(PREFIX+'config.json'),'source_sha256':cfg['source_sha256'],
          'host_tuple_evaluations':len(records),'cover_comparisons':len(records)*7,'records':records,'cells':cells,'best_cover':best_cover,'best_target':best_target,
          'elapsed':time.time()-start,'candidate_certificates':len(certificates),'target_exact_violations':sum(c['target_violation']for c in certificates),'cover_exact_violations':sum(c['cover_violation']for c in certificates)})
        print('CELL_DONE',json.dumps(row),'seconds',round(time.time()-start,3),flush=True)
    assert len(records)==cfg['planned_host_tuple_evaluations']
    # Freeze twelve diverse, explicit boundary starts: one per law, then best remaining.
    pool=[]
    for rec in records:
        if rec['root_mode']!='boundary':continue
        for c in rec['covers']:pool.append({'record':rec,'bits':c['bits'],'starting_normalized_defect':c['cover_defect_F2_minus_Z']['normalized']})
    pool.sort(key=lambda x:x['starting_normalized_defect']);selected=[];seen=set()
    for law in cfg['laws']:
        pick=next(x for x in pool if x['record']['law']==law['name']);selected.append(pick);seen.add((tuple(pick['record']['id']),pick['bits']))
    for pick in pool:
        key=(tuple(pick['record']['id']),pick['bits'])
        if key not in seen:selected.append(pick);seen.add(key)
        if len(selected)==12:break
    write_json('optimizer_starts',selected);print('SAMPLE_DONE',len(records),len(records)*7,'selected_starts',len(selected),flush=True)

def optimize():
    cfg=read_json('config');assert cfg['source_sha256']==current_hashes();starts=read_json('optimizer_starts');settings=cfg['optimization_cap'];assert len(starts)<=settings['starts'];out=[];start=time.time();certificates=[]
    for j,seed in enumerate(starts):
        rec=seed['record'];t=fracs(rec['t']);tpl=tuple(rec['tuple']);bits=seed['bits'];ld=law_data(t);lam0=np.array(rec['lambda_numerators'],dtype=float)/rec['lambda_denominator'];active=lam0!=0;sign=np.sign(lam0[active]);raw0=lam0/np.max(np.abs(lam0));x0=np.log(np.abs(raw0[active]));calls=0;best_seen=None
        assert np.all(x0>=settings['log_bounds'][0])and np.all(x0<=settings['log_bounds'][1])
        prep=prepared(tuple(rec['t']),tpl,bits)
        def raw_of(x):
            raw=np.zeros(6);raw[active]=sign*np.exp(x);return raw
        def obj(x):
            nonlocal calls,best_seen
            calls+=1;raw=raw_of(x);lam,J,_=boundary_float(raw,ld['products'],True);val,g,info=scaled_eval(prep,lam,True);gx=(J.T@g)[active]*raw[active]
            if best_seen is None or val<best_seen['normalized_defect']:best_seen={'normalized_defect':val,'raw':raw.tolist(),'call':calls}
            return val,gx
        res=minimize(obj,x0,jac=True,method='L-BFGS-B',bounds=[tuple(settings['log_bounds'])]*len(x0),options={'maxiter':settings['iterations_per_start'],'ftol':settings['ftol'],'gtol':settings['gtol'],'maxls':settings['maxls']})
        raw=raw_of(res.x);lam,_=boundary_float(raw,ld['products']);dv=scaled_eval(prep,lam);tv=scaled_eval(prepared(tuple(rec['t']),tpl,0),lam);F=1+tv['value']
        rr={'run':j,'seed_record_id':rec['id'],'law':rec['law'],'t':rec['t'],'tuple':tpl,'bits':bits,'raw_endpoint':raw.tolist(),'boundary_lambda_endpoint':lam.tolist(),
            'iterations':res.nit,'objective_calls':calls,'success':bool(res.success),'status':int(res.status),'message':str(res.message),'starting_normalized_defect':seed['starting_normalized_defect'],
            'cover_defect_F2_minus_Z':dv,'target_defect':tv,'F_approx':F,'cover_ratio_approx':1-dv['value']/F**2,'best_objective_point':best_seen,
            'cover_candidate_numeric':best_seen['normalized_defect']<cfg['credible_normalized_negative_threshold'],'target_candidate_numeric':tv['normalized']<cfg['credible_normalized_negative_threshold']}
        if rr['cover_candidate_numeric']or rr['target_candidate_numeric']:
            which=best_seen['raw']if rr['cover_candidate_numeric']else raw
            rf=tuple(Fraction(float(v))for v in which);norm=2*sum(abs(v)for v in rf);d=actual_root(t,tuple(v/norm for v in rf),boundary=True)
            exact_lam=tuple(Fraction(v,d['lambda_denominator'])for v in d['lambda_numerators']);cert=exact_certificate(t,exact_lam,tpl,bits);cert.update({'optimization_run':j,'raw_float_direction_as_exact_dyadics':fstr(rf)})
            certificates.append(cert);write_json('optimization_certificates',certificates);rr['exact_target_violation']=cert['target_violation'];rr['exact_cover_violation']=cert['cover_violation']
            print('EXACT_OPTIMIZATION_CHECK',j,cert['target_violation'],cert['cover_violation'],flush=True)
        out.append(rr);write_json('optimizations',{'schema':cfg['schema'],'config_sha256':filehash(PREFIX+'config.json'),'starts_sha256':filehash(PREFIX+'optimizer_starts.json'),
          'source_sha256':cfg['source_sha256'],'settings':settings,'runs':out,'elapsed':time.time()-start,'candidate_certificates':len(certificates),
          'target_exact_violations':sum(c['target_violation']for c in certificates),'cover_exact_violations':sum(c['cover_violation']for c in certificates)})
        print('OPT_DONE',j,'normdefect',dv['normalized'],'nit',res.nit,'calls',calls,'success',res.success,'seconds',round(time.time()-start,3),flush=True)

if __name__=='__main__':
    sys.set_int_max_str_digits(0)
    ap=argparse.ArgumentParser();ap.add_argument('mode',choices=['freeze','sample','optimize']);args=ap.parse_args();globals()[args.mode]()
