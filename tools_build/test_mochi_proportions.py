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
  factor=[.96,.74,.96] if a['name'].startswith('Ear1.') else [.78]*3
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
