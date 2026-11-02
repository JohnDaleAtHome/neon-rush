"""Run after build_mochi.py. Verifies deliberate rig changes and preserved animation data."""
from pathlib import Path
import numpy as np
from glbutil import load,accessor
ROOT=Path(__file__).resolve().parent.parent
old,ob=load(ROOT/'godot/assets/bunny.glb')
new,nb=load(ROOT/'godot/assets/visuals/mochi/mochi.glb')
assert len(new['animations'])==14
assert new['skins']==old['skins']
assert np.array_equal(accessor(old,ob,old['skins'][0]['inverseBindMatrices']),accessor(new,nb,new['skins'][0]['inverseBindMatrices']))
changed=[]
for a,b in zip(old['nodes'],new['nodes']):
 if a!=b:
  changed.append(a['name'])
  assert {k:v for k,v in a.items() if k!='scale'}=={k:v for k,v in b.items() if k!='scale'}
  factor=[.96,.74,.96] if a['name'].startswith('Ear1.') else [.69,.73,.69]
  assert np.allclose(b['scale'],np.array(a['scale'])*factor)
assert set(changed)=={'Ear1.L','Ear1.R','LowerArm.L','LowerArm.R'}
for a,b in zip(old['animations'],new['animations']):
 assert a==b
 for sampler in a['samplers']:
  for key in ['input','output']:
   assert np.array_equal(accessor(old,ob,sampler[key]),accessor(new,nb,sampler[key]))
 for c in a['channels']:
  assert not (old['nodes'][c['target']['node']]['name'] in changed and c['target']['path']=='scale')
for mesh in new['meshes']:
 for p in mesh['primitives']:
  v=accessor(new,nb,p['attributes']['POSITION']);assert np.isfinite(v).all()
  indices=accessor(new,nb,p['indices']);assert indices.max()<len(v)
  weights=accessor(new,nb,p['attributes']['WEIGHTS_0']);assert np.allclose(weights.sum(1),1,atol=.001)
print('PASS 14animation channels/bytes, inverse binds, four explicit rest scales, finite indexed geometry and normalized skin weights')

materials=new['materials'];primitives=new['meshes'][0]['primitives']
assert len(primitives)<30
for p in primitives:
 name=materials[p['material']]['name']
 if name in ['Scarf_Navy','Scarf_Seam']:
  uv=accessor(new,nb,p['attributes']['TEXCOORD_0']);assert np.isfinite(uv).all();assert np.isclose(uv[:,0].min(),0) and np.isclose(uv[:,0].max(),1)
 if name in ['Eye_White','Eye_Black','Eye_Catch']:
  vertices=accessor(new,nb,p['attributes']['POSITION'])
  for side in [-1,1]:
   q=vertices[vertices[:,0]*side>0];assert np.ptp(q[:,2])>np.ptp(q[:,0]);assert np.ptp(q[:,1])<.0017
print('PASS batched materials, scarf root/tip UV and flattened oval eye bounds')

# Crescent stays by the torso, rather than the old far-forward z~.8 placement.
from glbutil import globals_
G=globals_(new);skin=new['skins'][0]
ibm=accessor(new,nb,skin['inverseBindMatrices']).reshape(-1,4,4).transpose(0,2,1)
jg=np.stack([G[n]@ibm[k] for k,n in enumerate(skin['joints'])])
pendants=[p for p in primitives if materials[p['material']]['name']=='Pendant_Glow']
assert len(pendants)==1
p=pendants[0];a=p['attributes'];v=accessor(new,nb,a['POSITION']);ix=accessor(new,nb,a['JOINTS_0']);w=accessor(new,nb,a['WEIGHTS_0'])
vh=np.c_[v,np.ones(len(v))]
world=sum(np.einsum('nij,nj->ni',jg[ix[:,k]],vh)*w[:,k,None] for k in range(4))[:,:3]
assert world[:,2].min()>.19 and world[:,2].max()<.25
assert world[:,1].min()>1.20 and world[:,1].max()<1.46
assert np.all(ix[:,0]==[new['nodes'][n].get('name') for n in skin['joints']].index('Torso')) and np.allclose(w[:,0],1)
print('PASS pendant rests near chest and remains rigidly attached to Torso')
