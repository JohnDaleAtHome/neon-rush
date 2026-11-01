"""Build mochi.glb from bunny.glb: WIP concept-directed materials + skinned accessories.
Preserves hierarchy and all 14 animation channels; adjusts ear/forearm bind scales.
Keeps mesh/skin structure and material names
Bunny_Main/Bunny_Secondary/Eye_White/Eye_Black (game tint compatibility)."""
import json, sys, os
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from glbutil import load, save, accessor, add_accessor, globals_

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'godot/assets/bunny.glb')
DST = os.path.join(ROOT, 'godot/assets/visuals/mochi/mochi.glb')

js, binb = load(SRC)
G = globals_(js)
nodes = js['nodes']
skin = js['skins'][0]
joints = skin['joints']
jnames = [nodes[j].get('name','') for j in joints]
IBM = accessor(js, binb, skin['inverseBindMatrices']).reshape(-1,4,4).transpose(0,2,1)  # column-major -> row-major
JG = np.stack([G[j] @ IBM[k] for k, j in enumerate(joints)])  # joint skinning matrices

bun = js['meshes'][0]
prims = bun['primitives']
def load_prim(p):
    return (accessor(js, binb, p['attributes']['POSITION']).astype(np.float64),
            accessor(js, binb, p['attributes']['NORMAL']).astype(np.float64),
            accessor(js, binb, p['attributes']['JOINTS_0']).astype(int),
            accessor(js, binb, p['attributes']['WEIGHTS_0']).astype(np.float64),
            accessor(js, binb, p['indices']).astype(int).reshape(-1,3))
pos0, nrm0, jix0, wts0, idx0 = load_prim(prims[0])
pos1, nrm1, jix1, wts1, idx1 = load_prim(prims[1])
n0 = len(pos0)
pos = np.concatenate([pos0, pos1])
nrm = np.concatenate([nrm0, nrm1])
jix = np.concatenate([jix0, jix1])
wts = np.concatenate([wts0, wts1])
idx = np.concatenate([idx0, idx1 + n0])

# skinned world positions (bind pose)
def skin_pos(v, j, w):
    out = np.zeros((len(v),4))
    for k in range(4):
        M = JG[j[:,k]]
        vv = np.concatenate([v, np.ones((len(v),1))],1)
        out += w[:,k,None] * np.einsum('nij,nj->ni', M, vv)
    return out[:,:3]

wpos = skin_pos(pos, jix, wts)
dom = jix[np.arange(len(jix)), wts.argmax(1)]
domname = np.array([jnames[d] for d in dom])
print("world bbox", wpos.min(0).round(4), wpos.max(0).round(4))
print("dominant joint names:", sorted(set(domname)))


def shell_from_region(names, offset, mat_idx, tag):
    mask = np.isin(domname, names)
    fmask = mask[idx].all(1)
    faces = idx[fmask]
    vused, inv = np.unique(faces, return_inverse=True)
    # mesh-space offset: world offset / dominant-joint scale
    d = jix[vused, wts[vused].argmax(1)]
    scale = np.cbrt(np.abs(np.linalg.det(JG[d][:, :3, :3])))
    vnew = pos[vused] + nrm[vused]*(offset/scale)[:,None]
    nnew = nrm[vused]
    jnew = jix[vused]; wnew = wts[vused]
    fnew = inv.reshape(-1,3)
    prim = {
        'attributes': {
            'POSITION': add_accessor(js, binb, vnew.astype(np.float32), 'VEC3', 34962),
            'NORMAL': add_accessor(js, binb, nnew.astype(np.float32), 'VEC3'),
            'JOINTS_0': add_accessor(js, binb, jnew.astype(np.uint8), 'VEC4'),
            'WEIGHTS_0': add_accessor(js, binb, wnew.astype(np.float32), 'VEC4'),
        },
        'indices': add_accessor(js, binb, fnew.astype(np.uint32).reshape(-1), 'SCALAR', 34963),
        'material': mat_idx, 'mode': 4,
    }
    prims.append(prim)
    print(tag, "verts", len(vnew), "faces", len(fnew), "offset", offset)
    return vnew, jnew, wnew

def rigid_prim(verts, normals, faces, joint_name, mat_idx, tag):
    """verts given in world bind space; bake into mesh space of a single joint."""
    j = jnames.index(joint_name)
    M = JG[j]
    Mi = np.linalg.inv(M)
    v4 = np.concatenate([verts, np.ones((len(verts),1))],1)
    vm = (Mi @ v4.T).T[:,:3]
    R = Mi[:3,:3]
    nm = (R @ normals.T).T
    nm /= np.linalg.norm(nm, axis=1, keepdims=True)+1e-12
    jn = np.zeros((len(vm),4), np.uint8); jn[:,0] = j
    wn = np.zeros((len(vm),4), np.float32); wn[:,0] = 1.0
    prim = {
        'attributes': {
            'POSITION': add_accessor(js, binb, vm.astype(np.float32), 'VEC3', 34962),
            'NORMAL': add_accessor(js, binb, nm.astype(np.float32), 'VEC3'),
            'JOINTS_0': add_accessor(js, binb, jn, 'VEC4'),
            'WEIGHTS_0': add_accessor(js, binb, wn, 'VEC4'),
        },
        'indices': add_accessor(js, binb, np.asarray(faces,np.uint32).reshape(-1), 'SCALAR', 34963),
        'material': mat_idx, 'mode': 4,
    }
    prims.append(prim)
    print(tag, "verts", len(vm), "faces", len(faces))

def torus(center, axis, R, r, seg=40, tseg=10):
    axis = np.asarray(axis,float); axis/=np.linalg.norm(axis)
    u = np.cross(axis,[0,0,1.0]);
    if np.linalg.norm(u)<0.1: u=np.cross(axis,[0,1.0])
    u/=np.linalg.norm(u); v=np.cross(axis,u)
    V=[];N=[];F=[]
    for i in range(seg):
        a=2*np.pi*i/seg
        ca,sa=np.cos(a),np.sin(a)
        dirr=ca*u+sa*v
        for jj in range(tseg):
            b=2*np.pi*jj/tseg
            p=center+(R+r*np.cos(b))*dirr + r*np.sin(b)*axis
            n=np.cos(b)*dirr+np.sin(b)*axis
            V.append(p);N.append(n)
    V=np.array(V);N=np.array(N)
    for i in range(seg):
        for jj in range(tseg):
            a=i*tseg+jj; b=((i+1)%seg)*tseg+jj; c=((i+1)%seg)*tseg+(jj+1)%tseg; d=i*tseg+(jj+1)%tseg
            F.append([a,b,c]);F.append([a,c,d])
    return V,N,np.array(F)

def crescent(center, R, thick, facing):
    """Pointed crescent from the region between intersecting offset circles."""
    f=np.asarray(facing,float); f/=np.linalg.norm(f)
    up=np.array([0,1.0,0]); right=np.cross(up,f); right/=np.linalg.norm(right)
    up2=np.cross(f,right)
    d=R*0.48; ri=R*0.88
    x=(R*R-ri*ri+d*d)/(2*d); y=np.sqrt(R*R-x*x)
    ao=np.arctan2(y,x); ai=np.arctan2(y,x-d)
    outer=np.linspace(ao,2*np.pi-ao,40)
    inner=np.linspace(ai,2*np.pi-ai,40)
    V=[]; N=[]; F=[]
    for sign in [1,-1]:
        base=len(V)
        for a,b in zip(outer,inner):
            V.extend([center+right*(R*np.cos(a))+up2*(R*np.sin(a))+f*thick/2*sign,
                      center+right*(d+ri*np.cos(b))+up2*(ri*np.sin(b))+f*thick/2*sign])
            N.extend([f*sign,f*sign])
        for i in range(39):
            k=base+i*2
            faces=[[k,k+2,k+1],[k+1,k+2,k+3]]
            if sign<0:faces=[q[::-1] for q in faces]
            F.extend(faces)
    # Side walls use outward geometric normals for correct shading/culling.
    for edge in [0,1]:
        for i in range(39):
            a=i*2+edge;b=(i+1)*2+edge
            pts=[V[a],V[b],V[b+80],V[a+80]]
            n=np.cross(pts[1]-pts[0],pts[2]-pts[0]);n/=np.linalg.norm(n)+1e-12
            k=len(V);V.extend(pts);N.extend([n]*4);F.extend([[k,k+1,k+2],[k,k+2,k+3]])
    return np.array(V),np.array(N),np.array(F)

# scale info
size = wpos.max(0)-wpos.min(0)
print("world size", size.round(4))

# --- new materials ---
mats = js['materials']
def set_pbr(m, base, metal, rough, emis=None, estr=None):
    m['pbrMetallicRoughness'] = {'baseColorFactor':base,'metallicFactor':metal,'roughnessFactor':rough}
    if emis is not None:
        m['emissiveFactor']=emis
        if estr and estr!=1.0:
            m.setdefault('extensions',{})['KHR_materials_emissive_strength']={'emissiveStrength':estr}

set_pbr(mats[0], [0.93,0.94,0.97,1.0], 0.0, 0.85)            # Bunny_Main: soft white fur
set_pbr(mats[1], [0.82,0.88,0.98,1.0], 0.0, 0.6)             # Bunny_Secondary: pale blue-white (tintable)
set_pbr(mats[2], [0.40,0.82,0.92,1.0], 0.0, 0.35, [0.05,0.26,0.32], 0.6)  # Eye_White: cyan, gentle glow
set_pbr(mats[3], [0.02,0.06,0.10,1.0], 0.0, 1.0)             # Eye_Black: deep navy pupil, matte (no specular streak)
MAT_JACKET=len(mats); mats.append({'name':'Bunny_Jacket','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[0.10,0.10,0.18,1.0],'metallicFactor':0.25,'roughnessFactor':0.55}})
MAT_TRIM=len(mats);  mats.append({'name':'Neon_Trim','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[0.13,0.90,1.00,1.0],'metallicFactor':0.0,'roughnessFactor':0.4},'emissiveFactor':[0.10,0.75,0.85],'extensions':{'KHR_materials_emissive_strength':{'emissiveStrength':2.5}}})
MAT_PEND=len(mats);  mats.append({'name':'Pendant_Glow','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[0.49,1.00,0.78,1.0],'metallicFactor':0.0,'roughnessFactor':0.3},'emissiveFactor':[0.30,0.85,0.55],'extensions':{'KHR_materials_emissive_strength':{'emissiveStrength':2.0}}})
ext=js.setdefault('extensionsUsed',[])
if 'KHR_materials_emissive_strength' not in ext: ext.append('KHR_materials_emissive_strength')

# Carrot materials (mats 4,5) untouched; carrot mesh stays (game hides it).

# enlarge eyes toward concept proportions (in-place on eye prims, before accessories)
def prim_components(pos, idx):
    par = list(range(len(pos)))
    def find(a):
        while par[a]!=a: par[a]=par[par[a]]; a=par[a]
        return a
    for f in idx:
        for a,b in ((0,1),(1,2)):
            ra,rb=find(int(f[a])),find(int(f[b]))
            if ra!=rb: par[ra]=rb
    comps={}
    for i in range(len(pos)): comps.setdefault(find(i),[]).append(i)
    return sorted((np.array(v) for v in comps.values()), key=lambda v: pos[v,0].mean())

def write_prim_pos(js, binb, p, ep):
    js['accessors'][p['attributes']['POSITION']]['min'] = [float(x) for x in ep.min(0)]
    js['accessors'][p['attributes']['POSITION']]['max'] = [float(x) for x in ep.max(0)]
    bv = js['bufferViews'][js['accessors'][p['attributes']['POSITION']]['bufferView']]
    off = bv.get('byteOffset',0) + js['accessors'][p['attributes']['POSITION']].get('byteOffset',0)
    binb[off:off+ep.astype(np.float32).nbytes] = ep.astype(np.float32).tobytes()

# eye whites: slightly smaller, less protruding (per prim; eyes symmetric about x=0)
p_w = prims[2]
ew = accessor(js, binb, p_w['attributes']['POSITION']).astype(np.float64)
iw = accessor(js, binb, p_w['indices']).astype(int).reshape(-1,3)
cw0 = ew.mean(0)
ew = cw0 + (ew-cw0)*np.array([1.04, 1.04, 0.98])
write_prim_pos(js, binb, p_w, ew)
# pupils: rebuild as round discs (the original hair-thin slit can only stretch
# into an almond); each eye gets a fresh flattened sphere proud of the iris
def uv_sphere(c, r, nu=12, nv=8):
    V=[]; N=[]; F=[]
    for i in range(nv+1):
        th=np.pi*i/nv
        for j in range(nu):
            ph=2*np.pi*j/nu
            d=np.array([np.sin(th)*np.cos(ph),np.cos(th),np.sin(th)*np.sin(ph)])
            V.append(c+d*r); N.append(d)
    for i in range(nv):
        for j in range(nu):
            a=i*nu+j; b=i*nu+(j+1)%nu; c2=(i+1)*nu+(j+1)%nu; d2=(i+1)*nu+j
            F.append([a,c2,d2]); F.append([a,b,c2])
    return np.array(V),np.array(N),np.array(F)
p_p = prims[3]
ep = accessor(js, binb, p_p['attributes']['POSITION']).astype(np.float64)
ip = accessor(js, binb, p_p['indices']).astype(int).reshape(-1,3)
cjj3 = accessor(js, binb, p_w['attributes']['JOINTS_0'])
cww3 = accessor(js, binb, p_w['attributes']['WEIGHTS_0'])
wcomps = prim_components(ew, iw)
pcomps = prim_components(ep, ip)
Vv=[]; Nn=[]; Ff=[]; jn3=[]; wn3=[]
for wc, pc in zip(wcomps, pcomps):
    bc = ew[wc].mean(0)
    yfront = ew[wc][:,1].min()   # mesh space: -y is the facing direction, z is up
    base=len(Vv) if Vv else 0
    off = sum(len(v) for v in Vv)
    Vc,Nc,Fc = uv_sphere(bc, 0.00095)
    Vc[:,1] = yfront - 0.0003 + (Vc[:,1]-Vc[:,1].mean())*0.35
    Vv.append(Vc); Nn.append(Nc); Ff.append(Fc+off)
    # rigid: whole pupil follows the iris vert nearest its center
    ni = int(((ew[wc]-bc)**2).sum(1).argmin())
    jn3 += [cjj3[wc][ni]]*len(Vc); wn3 += [cww3[wc][ni]]*len(Vc)
Vv=np.concatenate(Vv); Nn=np.concatenate(Nn); Ff=np.concatenate(Ff)
p_p['attributes']['POSITION'] = add_accessor(js, binb, Vv.astype(np.float32),'VEC3',34962)
p_p['attributes']['NORMAL'] = add_accessor(js, binb, Nn.astype(np.float32),'VEC3')
p_p['attributes']['JOINTS_0'] = add_accessor(js, binb, np.asarray(jn3,np.uint8),'VEC4')
p_p['attributes']['WEIGHTS_0'] = add_accessor(js, binb, np.asarray(wn3,np.float32),'VEC4')
p_p['indices'] = add_accessor(js, binb, Ff.astype(np.uint32).reshape(-1),'SCALAR',34963)
p_p['attributes'].pop('TEXCOORD_0', None)  # stale UV count would break Godot's indexed decode
print('eyes reshaped: pupils rebuilt as round discs, centered on iris')
# Preserve Bunny_Secondary inner-ear/nose/mouth components. The disconnected
# pieces above eye height are inner ears, not eye shine strips.
# open the eyelids: recess the fur lid band crossing IN FRONT of the eyes
# (mesh space: -y faces forward, z is up); vertex pull, mesh stays watertight
p_f = prims[0]
fp = accessor(js, binb, p_f['attributes']['POSITION']).astype(np.float64).copy()
lid = (np.abs(fp[:,0])>0.0015)&(np.abs(fp[:,0])<0.0065)&(fp[:,2]>0.0195)&(fp[:,2]<0.0275)&(fp[:,1]<-0.0044)
fp[lid,1] = np.maximum(fp[lid,1], -0.0044)
p_f['attributes']['POSITION'] = add_accessor(js, binb, fp.astype(np.float32), 'VEC3', 34962)
print('recessed eyelid band;', int(lid.sum()), 'fur verts pulled back')

# Split nose, mouth and belly from tintable inner ears without overlapping faces.
sp=prims[1];sv,sn,sj,sw,si=load_prim(sp);remaining=np.ones(len(si),bool)
for comp in prim_components(sv,si):
    if len(comp) not in [59,123,55]:continue
    name,color=('Nose_Pink',[0.9,0.48,0.62,1]) if len(comp)==59 else ('Mouth_Dark',[0.16,0.12,0.18,1]) if len(comp)==123 else ('Belly_Fur',[0.69,0.75,0.83,1])
    if len(comp)==123:sv[comp,2]+=np.abs(sv[comp,0])*0.35
    mat=len(mats);mats.append({'name':name,'pbrMetallicRoughness':{'baseColorFactor':color,'roughnessFactor':0.85}})
    keep=np.isin(si,comp).all(1);remaining &= ~keep
    q=dict(sp);q['attributes']=dict(sp['attributes']);q['indices']=add_accessor(js,binb,si[keep].astype(np.uint32).reshape(-1),'SCALAR',34963);q['material']=mat
    q['attributes']['POSITION']=add_accessor(js,binb,sv.astype(np.float32),'VEC3',34962);prims.append(q)
sp['indices']=add_accessor(js,binb,si[remaining].astype(np.uint32).reshape(-1),'SCALAR',34963)

# Concept silhouette: tapered cheek tufts and forelock.
# Work in the original mesh basis, so the existing skin and animation contract survives.
def fur_tuft(center, direction, width, length):
    direction=np.array(direction,float);direction/=np.linalg.norm(direction)
    ref=np.array([0,1,0.0]);side=np.cross(direction,ref);side/=np.linalg.norm(side)
    cross=np.cross(direction,side)
    vv=[];nn=[];ff=[]
    rings=6;seg=10
    for i in range(rings):
        t=i/(rings-1);rad=width*np.cos(t*np.pi/2)**0.7
        for j in range(seg):
            a=j*2*np.pi/seg;d=side*np.cos(a)+cross*np.sin(a)*0.65
            vv.append(center+direction*(t*length)+d*rad);nn.append(d/np.linalg.norm(d))
    for i in range(rings-1):
        for j in range(seg):
            a=i*seg+j;b=i*seg+(j+1)%seg;c=(i+1)*seg+(j+1)%seg;d=(i+1)*seg+j
            ff.extend([[a,c,b],[a,d,c]])
    vv=np.array(vv);nn=np.array(nn);ff=np.array(ff)
    ni=int(((pos0-center)**2).sum(1).argmin())
    prims.append({'attributes':{
      'POSITION':add_accessor(js,binb,vv.astype(np.float32),'VEC3',34962),
      'NORMAL':add_accessor(js,binb,nn.astype(np.float32),'VEC3'),
      'JOINTS_0':add_accessor(js,binb,np.tile(jix0[ni],(len(vv),1)).astype(np.uint8),'VEC4'),
      'WEIGHTS_0':add_accessor(js,binb,np.tile(wts0[ni],(len(vv),1)).astype(np.float32),'VEC4')},
      'indices':add_accessor(js,binb,ff.astype(np.uint32).reshape(-1),'SCALAR',34963),
      'material':0,'mode':4})
# Layered swept cheek/neck tufts replace the three large outward spikes.
for sign in [-1,1]:
    for i in range(5):
        z=0.0191+i*0.00048
        fur_tuft(np.array([sign*(0.0048+0.00015*np.sin(i)), -0.0020,z]),
                 [sign*0.75,0.55,(i-3)*0.12],0.00053,0.00065+(i%3)*0.00012)
for i in range(5):
    x=(i-2)*0.00065
    fur_tuft(np.array([x,-0.00035,0.0261-abs(x)*0.18]),
             [0.25,0.65,0.7],0.00064,0.0013+(i%2)*0.0003)

# --- accessories (world bind space) ---
height = size[1]
off_boot = height*0.012

shell_from_region(['Foot.L'], off_boot, MAT_JACKET, 'boot_L')
shell_from_region(['Foot.R'], off_boot, MAT_JACKET, 'boot_R')

# Short open jacket follows existing torso anatomy, not a floating circular tube.
torso_mask=np.isin(domname,['Torso','Abdomen','Body','Hips']);allv=wpos
core_mask=np.isin(domname,['Torso','Abdomen','Body']);core=wpos[core_mask]
y_lo,y_hi=np.percentile(core[:,1],[3,97]);NR=14
ys=np.linspace(y_lo,y_hi,NR);centers=[];radii=[]
for y in ys:
    band=core[np.abs(core[:,1]-y)<(y_hi-y_lo)/NR]
    if len(band)<5:band=core
    c=np.array([0,y,band[:,2].mean()]);centers.append(c);radii.append(np.linalg.norm(band[:,[0,2]]-c[[0,2]],axis=1).max())
centers=np.array(centers);radii=np.array(radii);margin=height*0.024
# Clip garment boundaries through triangles, avoiding stair-step missing-face hems.
def clip(poly,axis,bound,greater,space=0):
    out=[]
    for A,B in zip(poly,poly[1:]+poly[:1]):
        da=(A[space][axis]-bound)*(1 if greater else -1);db=(B[space][axis]-bound)*(1 if greater else -1)
        if da>=0:out.append(A)
        if (da>=0)!=(db>=0):
            t=da/(da-db);out.append(tuple(x*(1-t)+y*t for x,y in zip(A,B)))
    return out
V=[];N=[];J=[];W=[];F=[];WP=[]
for f in idx[core_mask[idx].all(1)]:
    poly=[]
    for vi in f:
        weights=np.zeros(len(jnames))
        for j,w in zip(jix[vi],wts[vi]):weights[j]+=w
        poly.append((wpos[vi],pos[vi],nrm[vi],weights))
    poly=clip(clip(poly,2,0.0138,True,1),2,0.0195,False,1)
    if len(poly)<3:continue
    polygons=[poly]
    if np.mean([v[0][2] for v in poly])>-0.29:
        polygons=[clip(poly,0,height*0.055,True),clip(poly,0,-height*0.055,False)]
    for poly in polygons:
        if len(poly)<3:continue
        base=len(V)
        for wp,v,n,weights in poly:
            jsort=np.argsort(weights)[-4:][::-1];ws=weights[jsort];ws/=ws.sum()
            sc=np.cbrt(abs(np.linalg.det(JG[jsort[0]][:3,:3])))
            V.append(v+n*(height*0.012/sc));N.append(n/np.linalg.norm(n));J.append(jsort);W.append(ws);WP.append(wp)
        for k in range(1,len(poly)-1):F.append([base,base+k,base+k+1])
V=np.array(V);N=np.array(N);J=np.array(J);W=np.array(W);WP=np.array(WP);F=np.array(F)
attrs={}
for key,data,typ in [('POSITION',V,'VEC3'),('NORMAL',N,'VEC3'),('JOINTS_0',J,'VEC4'),('WEIGHTS_0',W,'VEC4')]:
    attrs[key]=add_accessor(js,binb,data.astype(np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
prims.append({'attributes':attrs,'indices':add_accessor(js,binb,F.astype(np.uint32).reshape(-1),'SCALAR',34963),'material':MAT_JACKET,'mode':4})
# Cyan piping is clipped to the garment's two exact front edges.
sv=[];sn=[];sj=[];sw=[];sf=[]
for f in F:
    for aa,bb in zip(f,np.roll(f,-1)):
        if abs(abs(WP[aa,0])-height*0.055)>0.0001 or abs(abs(WP[bb,0])-height*0.055)>0.0001:continue
        if WP[aa,0]*WP[bb,0]<0 or np.mean(WP[[aa,bb],2])< -0.29:continue
        cc=next(k for k in f if k not in [aa,bb]);base=len(sv)
        for q,t in [(aa,0),(bb,0),(bb,0.08),(aa,0.08)]:
            sv.append(V[q]*(1-t)+V[cc]*t+N[q]*0.000015);sn.append(N[q]);sj.append(J[q]);sw.append(W[q])
        sf.extend([[base,base+1,base+2],[base,base+2,base+3]])
if sv:
    at={}
    for key,data,typ in [('POSITION',sv,'VEC3'),('NORMAL',sn,'VEC3'),('JOINTS_0',sj,'VEC4'),('WEIGHTS_0',sw,'VEC4')]:
        at[key]=add_accessor(js,binb,np.array(data,dtype=np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
    prims.append({'attributes':at,'indices':add_accessor(js,binb,np.array(sf,np.uint32).reshape(-1),'SCALAR',34963),'material':MAT_TRIM,'mode':4})
print('clipped jacket',len(V),'vertices',len(F),'faces')

# Thin magenta stitched hem follows the clipped garment boundary, not a lathe ring.
MAT_STITCH=len(mats);mats.append({'name':'Jacket_Stitch','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[0.78,0.12,0.51,1],'metallicFactor':0,'roughnessFactor':.6},'emissiveFactor':[.20,.005,.065]})
from collections import Counter
edges=Counter(tuple(sorted((int(a),int(b)))) for f in F for a,b in zip(f,np.roll(f,-1)))
sv=[];sn=[];sj=[];sw=[];sf=[]
for f in F:
 for aa,bb in zip(f,np.roll(f,-1)):
  if edges[tuple(sorted((int(aa),int(bb))))]!=1:continue
  if max(V[aa,2],V[bb,2])>0.0141:continue
  cc=next(k for k in f if k not in [aa,bb]);base=len(sv)
  for q,t in [(aa,0),(bb,0),(bb,.08),(aa,.08)]:
   sv.append(V[q]*(1-t)+V[cc]*t+N[q]*.00004);sn.append(N[q]);sj.append(J[q]);sw.append(W[q])
  sf.extend([[base,base+1,base+2],[base,base+2,base+3]])
if sv:
 at={}
 for key,data,typ in [('POSITION',sv,'VEC3'),('NORMAL',sn,'VEC3'),('JOINTS_0',sj,'VEC4'),('WEIGHTS_0',sw,'VEC4')]:
  at[key]=add_accessor(js,binb,np.array(data,dtype=np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
 prims.append({'attributes':at,'indices':add_accessor(js,binb,np.array(sf,np.uint32).reshape(-1),'SCALAR',34963),'material':MAT_STITCH,'mode':4})

def skinned_prim(verts, normals, faces, ref_pos, mat_idx, tag, ref_mask=None, forced=None):
    """verts in world bind space; copy weights from nearest reference body vert
    (or `forced` per-vert joints/weights), bake to mesh space via dominant joint inverse."""
    jn = np.zeros((len(verts),4),np.uint8); wn=np.zeros((len(verts),4),np.float32)
    vm = np.zeros_like(verts); nmm = np.zeros_like(normals)
    for k in range(len(verts)):
        if forced is not None:
            jn[k]=forced[0][k]; wn[k]=forced[1][k]
        else:
            d2 = ((ref_pos-verts[k])**2).sum(1)
            if ref_mask is not None: d2[~ref_mask] = 1e18
            ni = int(d2.argmin())
            jn[k]=jix[ni]; wn[k]=wts[ni]
        dom=int(jn[k, wn[k].argmax()])
        Mi=np.linalg.inv(np.sum(JG[jn[k]]*wn[k,:,None,None],axis=0))
        vm[k]=(Mi@np.append(verts[k],1.0))[:3]
        nmm[k]=Mi[:3,:3]@normals[k]
    nmm/=np.linalg.norm(nmm,axis=1,keepdims=True)+1e-12
    prim={
     'attributes':{
      'POSITION': add_accessor(js, binb, vm.astype(np.float32),'VEC3',34962),
      'NORMAL': add_accessor(js, binb, nmm.astype(np.float32),'VEC3'),
      'JOINTS_0': add_accessor(js, binb, jn,'VEC4'),
      'WEIGHTS_0': add_accessor(js, binb, wn,'VEC4'),
     },
     'indices': add_accessor(js, binb, np.asarray(faces,np.uint32).reshape(-1),'SCALAR',34963),
     'material': mat_idx,'mode':4,
    }
    prims.append(prim)
    print(tag,'verts',len(vm),'faces',len(faces))

# collar + hem rings at shell ends
for ci, tag in []:
    if tag=='collar':
        # hug the neck base instead of floating around the shoulder-wide torso top
        nmask = np.isin(domname, ['Neck'])
        nv = allv[nmask]
        ny0, ny1 = np.percentile(nv[:,1], [0, 45])
        band = nv[nv[:,1] <= ny1]
        c = np.array([band[:,0].mean(), band[:,1].mean(), band[:,2].mean()])
        r = np.linalg.norm(band[:,[0,2]]-c[[0,2]],axis=1).max()*1.12 + margin*0.4
        rmask = torso_mask | nmask
    else:
        c=centers[ci]; r=radii[ci]+margin*1.4
        rmask = torso_mask
    Vv,Nn,Ff = torus(c,[0,1,0],r,height*0.008)
    skinned_prim(Vv,Nn,Ff, allv, MAT_TRIM, tag+'_ring', rmask)

# --- catchlights: one tiny dot per eye on the iris front ---
MAT_CATCH=len(mats); mats.append({'name':'Eye_Catch','doubleSided':False,'pbrMetallicRoughness':{'baseColorFactor':[1.0,1.0,1.0,1.0],'metallicFactor':0.0,'roughnessFactor':0.2},'emissiveFactor':[1.0,1.0,1.0],'extensions':{'KHR_materials_emissive_strength':{'emissiveStrength':1.5}}})
p_pup = prims[3]
epos = accessor(js, binb, p_pup['attributes']['POSITION']).astype(np.float64)
cjj = accessor(js, binb, prims[2]['attributes']['JOINTS_0'])
cww = accessor(js, binb, prims[2]['attributes']['WEIGHTS_0'])
ebulb = accessor(js, binb, prims[2]['attributes']['POSITION']).astype(np.float64)
def uv_sphere(c, r, nu=10, nv=6):
    V=[]; N=[]; F=[]
    for i in range(nv+1):
        th=np.pi*i/nv
        for j in range(nu):
            ph=2*np.pi*j/nu
            d=np.array([np.sin(th)*np.cos(ph),np.cos(th),np.sin(th)*np.sin(ph)])
            V.append(c+d*r); N.append(d)
    for i in range(nv):
        for j in range(nu):
            a=i*nu+j; b=i*nu+(j+1)%nu; c2=(i+1)*nu+(j+1)%nu; d2=(i+1)*nu+j
            F.append([a,c2,d2]); F.append([a,b,c2])
    return np.array(V),np.array(N),np.array(F)
ipup = accessor(js, binb, p_pup['indices']).astype(int).reshape(-1,3)
Vv=[]; Nn=[]; Ff=[]
for pc in prim_components(epos, ipup):
    cc = epos[pc].mean(0)
    yfront = epos[pc][:,1].min()
    base = sum(len(v) for v in Vv)
    sgn = -1.0 if cc[0]>0 else 1.0
    Vc,Nc,Fc = uv_sphere(cc+np.array([sgn*0.0005,0.0,0.0007]), 0.00045)
    Vc[:,1] = yfront - 0.0002 + (Vc[:,1]-Vc[:,1].mean())*0.5
    Vv.append(Vc); Nn.append(Nc); Ff.append(Fc+base)
Vv=np.concatenate(Vv); Nn=np.concatenate(Nn); Ff=np.concatenate(Ff)
# rigid per sphere: all verts of a sphere share one nearest pupil vert's skinning
jn2=np.zeros((len(Vv),4),np.uint8); wn2=np.zeros((len(Vv),4),np.float32)
nv_per = len(Vv)//len(prim_components(epos, ipup))
for si0 in range(len(Vv)//nv_per):
    seg = Vv[si0*nv_per:(si0+1)*nv_per]
    ni=int(((ebulb-seg.mean(0))**2).sum(1).argmin())
    jn2[si0*nv_per:(si0+1)*nv_per]=cjj[ni].astype(np.uint8)
    wn2[si0*nv_per:(si0+1)*nv_per]=cww[ni].astype(np.float32)
prim={
 'attributes':{
  'POSITION': add_accessor(js, binb, Vv.astype(np.float32),'VEC3',34962),
  'NORMAL': add_accessor(js, binb, Nn.astype(np.float32),'VEC3'),
  'JOINTS_0': add_accessor(js, binb, jn2,'VEC4'),
  'WEIGHTS_0': add_accessor(js, binb, wn2,'VEC4'),
 },
 'indices': add_accessor(js, binb, Ff.astype(np.uint32).reshape(-1),'SCALAR',34963),
 'material': MAT_CATCH,'mode':4,
}
prims.append(prim)
print('catchlights', len(Vv), 'verts')

# pendant on upper chest front
ci = int(NR*0.62)
c = centers[ci]; r=radii[ci]
cxy = c + np.array([0,0,r+margin+height*0.065])
Vv,Nn,Ff = crescent(cxy, height*0.034, height*0.010, [0,0,1])
# rigid charm: every pendant vert uses the weights of the single nearest body
# vert, so the crescent never shears when the torso bends
d2 = ((allv-cxy)**2).sum(1); d2[~torso_mask]=1e18
ni = int(d2.argmin())
Vr = np.tile(jix[ni], (len(Vv),1)); Wr = np.tile(wts[ni], (len(Vv),1))
rigid_prim(Vv,Nn,Ff, 'Torso', MAT_PEND, 'pendant')

# Rounder cheeks, preserving skinning and topology.
for p in prims:
    vv=accessor(js,binb,p['attributes']['POSITION']).astype(np.float64).copy()
    z=vv[:,2];x=vv[:,0]
    cheek=np.exp(-((z-0.0208)/0.0034)**2)
    vv[:,0]*=1+0.13*cheek
    p['attributes']['POSITION']=add_accessor(js,binb,vv.astype(np.float32),'VEC3',34962)

# Boot ankle bands and cyan soles: clipped from the weighted foot shell.
for side in ['L','R']:
    foot=jnames.index('Foot.'+side)
    local=(np.linalg.inv(G[skin['joints'][foot]])@np.concatenate([wpos,np.ones((len(wpos),1))],axis=1).T).T[:,:3]
    region=np.where(domname=='Foot.'+side)[0]
    # World vertical bands preserve the original foot silhouette and skin weights.
    lo,hi=np.percentile(wpos[region,1],[0,100])
    for material,low,high in [(MAT_TRIM,lo,lo+(hi-lo)*.09),(MAT_TRIM,lo+(hi-lo)*.94,hi)]:
        V=[];N=[];J=[];W=[];F=[]
        for face in idx[np.isin(domname[idx],['Foot.'+side]).all(1)]:
            poly=[]
            for vi in face:
                weights=np.zeros(len(jnames))
                for ji,ww in zip(jix[vi],wts[vi]):weights[ji]+=ww
                poly.append((wpos[vi],pos[vi],nrm[vi],weights))
            poly=clip(clip(poly,1,low,True),1,high,False)
            if len(poly)<3:continue
            base=len(V)
            for wp,v,n,weights in poly:
                jsort=np.argsort(weights)[-4:][::-1];ws=weights[jsort];ws/=ws.sum()
                sc=np.cbrt(abs(np.linalg.det(JG[jsort[0]][:3,:3])))
                V.append(v+n*(off_boot*1.16/sc));N.append(n);J.append(jsort);W.append(ws)
            for k in range(1,len(poly)-1):F.append([base,base+k,base+k+1])
        if V:
            at={}
            for key,data,typ in [('POSITION',V,'VEC3'),('NORMAL',N,'VEC3'),('JOINTS_0',J,'VEC4'),('WEIGHTS_0',W,'VEC4')]:
                at[key]=add_accessor(js,binb,np.array(data,dtype=np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
            prims.append({'attributes':at,'indices':add_accessor(js,binb,np.array(F,np.uint32).reshape(-1),'SCALAR',34963),'material':material,'mode':4})

# Wrist cuffs: bands follow the actual lower-arm surface and original skin weights.
MAT_MAGENTA=len(mats);mats.append({'name':'Neon_Magenta','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[0.75,0.12,0.48,1],'metallicFactor':0.0,'roughnessFactor':0.5},'emissiveFactor':[0.32,0.015,0.12]})
for side in ['L','R']:
 arm=jnames.index('LowerArm.'+side)
 local=(np.linalg.inv(G[skin['joints'][arm]])@np.concatenate([wpos,np.ones((len(wpos),1))],axis=1).T).T[:,:3]
 armvertices=np.where(domname=='LowerArm.'+side)[0]
 lo,hi=np.percentile(local[armvertices,1],[0,100])
 # Distal third of the forearm, excluding the fingers. Clipped through triangles.
 bandlo=lo+(hi-lo)*0.62;bandhi=lo+(hi-lo)*0.88
 for cuff_material,bandlo,bandhi in [(MAT_JACKET,bandlo,bandhi),(MAT_MAGENTA,bandlo,bandlo+(bandhi-bandlo)*.15)]:
  V=[];N=[];J=[];W=[];F=[]
  for face in idx[np.isin(domname[idx],['LowerArm.'+side]).any(1)]:
   poly=[]
   for vi in face:
    weights=np.zeros(len(jnames))
    for ji,ww in zip(jix[vi],wts[vi]):weights[ji]+=ww
    poly.append((local[vi],pos[vi],nrm[vi],weights))
   poly=clip(clip(poly,1,bandlo,True),1,bandhi,False)
   if len(poly)<3:continue
   base=len(V)
   for lp,v,n,weights in poly:
    jsort=np.argsort(weights)[-4:][::-1];ws=weights[jsort];ws/=ws.sum()
    V.append(v+n*(0.00015 if cuff_material==MAT_MAGENTA else 0.00012));N.append(n);J.append(jsort);W.append(ws)
   for k in range(1,len(poly)-1):F.append([base,base+k,base+k+1])
  if V:
   at={}
   for key,data,typ in [('POSITION',V,'VEC3'),('NORMAL',N,'VEC3'),('JOINTS_0',J,'VEC4'),('WEIGHTS_0',W,'VEC4')]:
    at[key]=add_accessor(js,binb,np.array(data,dtype=np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
   prims.append({'attributes':at,'indices':add_accessor(js,binb,np.array(F,np.uint32).reshape(-1),'SCALAR',34963),'material':cuff_material,'mode':4})
   print('wrist cuff',side,len(V),len(F))

import os
os.makedirs(os.path.dirname(DST), exist_ok=True)
for n in js['nodes']:
 if n.get('name') in ['Ear1.L','Ear1.R']:
  n['scale']=[v*f for v,f in zip(n.get('scale',[1,1,1]),[0.96,0.74,0.96])]
 if n.get('name') in ['LowerArm.L','LowerArm.R']:
  n['scale']=[v*f for v,f in zip(n.get('scale',[1,1,1]),[0.69,0.73,0.69])]
for p in js['meshes'][0]['primitives']:
 name=js['materials'][p['material']]['name']
 if name=='Nose_Pink':
  v=accessor(js,binb,p['attributes']['POSITION']).astype(float)
  ids=np.unique(accessor(js,binb,p['indices']).astype(int));center=v[ids].mean(0)
  v[ids]=center+(v[ids]-center)*np.array([0.80,0.86,0.80])
  p['attributes']['POSITION']=add_accessor(js,binb,v.astype(np.float32),'VEC3',34962)
 if name=='Mouth_Dark':
  old=accessor(js,binb,p['attributes']['POSITION']);ids=np.unique(accessor(js,binb,p['indices']).astype(int))
  nearest=ids[np.argmin(np.sum((old[ids]-[0,-0.0063,0.020])**2,axis=1))]
  joints=accessor(js,binb,p['attributes']['JOINTS_0'])[nearest];weights=accessor(js,binb,p['attributes']['WEIGHTS_0'])[nearest]
  v=[];n=[];faces=[]
  for step in range(17):
   t=-1+step/8
   center=np.array([0.00145*t,-0.00625+0.0005*t*t,0.0197+0.00058*t*t])
   for ring in range(6):
    angle=2*np.pi*ring/6;normal=np.array([0,np.cos(angle),np.sin(angle)])
    v.append(center+normal*0.000115);n.append(normal)
  for step in range(16):
   for ring in range(6):
    aa=step*6+ring;bb=step*6+(ring+1)%6;cc=bb+6;dd=aa+6
    faces.extend([[aa,bb,cc],[aa,cc,dd]])
  p['attributes']={
   'POSITION':add_accessor(js,binb,np.array(v,np.float32),'VEC3',34962),
   'NORMAL':add_accessor(js,binb,np.array(n,np.float32),'VEC3'),
   'JOINTS_0':add_accessor(js,binb,np.tile(joints,(len(v),1)).astype(np.uint8),'VEC4'),
   'WEIGHTS_0':add_accessor(js,binb,np.tile(weights,(len(v),1)).astype(np.float32),'VEC4')}
  p['indices']=add_accessor(js,binb,np.array(faces,np.uint32).reshape(-1),'SCALAR',34963)
 if name in ['Eye_White','Eye_Black','Eye_Catch']:
  v=accessor(js,binb,p['attributes']['POSITION']).astype(float)
  for side in [-1,1]:
   mask=v[:,0]*side>0
   center=np.array([side*0.0041,-0.0033,0.02277])
   v[mask]=center+(v[mask]-center)*np.array([0.88,0.68,0.9])
  p['attributes']['POSITION']=add_accessor(js,binb,v.astype(np.float32),'VEC3',34962)


# Larger concept-directed costume pass, still an approximation rather than final fur.
# Shoulder shells and small back panels share original weighted body surfaces.
shell_from_region(['UpperArm.L','UpperArm.R'],height*0.014,MAT_JACKET,'shoulder_panels')
# Back scarf ribbons: rooted at the torso, trailing behind instead of a rigid ring.
MAT_SCARF=len(mats);mats.append({'name':'Scarf_Navy','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[.035,.055,.10,1],'metallicFactor':0,'roughnessFactor':.8}})
MAT_SCARF_SEAM=len(mats);mats.append({'name':'Scarf_Seam','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[.13,.9,1,1],'roughnessFactor':.6}})
for side in [-1,1]:
 vv=[];nn=[];ff=[]
 for step in range(13):
  t=step/12
  center=np.array([side*(.08+t*.55),1.49+.10*np.sin(t*4.5),-.29-t*.65])
  width=.07*(1-.35*t)
  for edge in [-1,1]:vv.append(center+np.array([0,edge*width,0]));nn.append(np.array([0,0,1.]))
 for step in range(12):
  a=step*2;ff.extend([[a,a+1,a+3],[a,a+3,a+2]])
 rigid_prim(np.array(vv),np.array(nn),np.array(ff),'Torso',MAT_SCARF,'scarf_ribbon')
 prims[-1]['attributes']['TEXCOORD_0']=add_accessor(js,binb,np.array([[step/12,edge] for step in range(13) for edge in [0,1]],np.float32),'VEC2')
 # Narrow cyan seam follows the same ribbon edge.
 edgev=[];edgen=[];edgef=[]
 for step in range(13):
  t=step/12;c=np.array([side*(.08+t*.55),1.49+.10*np.sin(t*4.5)+.07*(1-.35*t),-.286-t*.65])
  for delta in [0,-.012]:edgev.append(c+np.array([0,delta,0]));edgen.append([0,0,1])
 for step in range(12):
  a=step*2;edgef.extend([[a,a+1,a+3],[a,a+3,a+2]])
 rigid_prim(np.array(edgev),np.array(edgen),np.array(edgef),'Torso',MAT_SCARF_SEAM,'scarf_seam')
 prims[-1]['attributes']['TEXCOORD_0']=add_accessor(js,binb,np.array([[step/12,edge] for step in range(13) for edge in [0,1]],np.float32),'VEC2')

# Soft rectangular equipment pouches echo the concept without front rings.
# Superellipsoid panels stay rigid to torso; scarf tails share that root.
for center,radii,material,tag in [
 ([0,1.43,-.51],[.30,.34,.12],MAT_JACKET,'backpack'),
 ([-.28,1.34,.22],[.10,.13,.045],MAT_JACKET,'jacket_pouch'),
 ([.28,1.34,.22],[.10,.13,.045],MAT_JACKET,'jacket_pouch'),
 ([-.28,1.39,.266],[.075,.018,.012],MAT_MAGENTA,'pouch_trim'),
 ([.28,1.39,.266],[.075,.018,.012],MAT_TRIM,'pouch_trim')]:
 vv,nn,ff=uv_sphere(np.zeros(3),1.0,12,8)
 # Rounded box silhouette instead of egg-like pods.
 vv=np.sign(vv)*np.abs(vv)**.35
 vv=vv*np.array(radii)+np.array(center)
 # Recompute smoothed normals on the deformed surface.
 nn=np.zeros_like(vv)
 for face in ff:
  normal=np.cross(vv[face[1]]-vv[face[0]],vv[face[2]]-vv[face[0]])
  for vi in face:nn[vi]+=normal
 nn/=np.maximum(np.linalg.norm(nn,axis=1,keepdims=True),1e-12)
 rigid_prim(vv,nn,ff,'Torso',material,tag)
# Geometry-only swept ear tips preserve animation channels and rest transforms.
for primitive in prims:
 v=accessor(js,binb,primitive['attributes']['POSITION']).astype(float)
 ji=accessor(js,binb,primitive['attributes']['JOINTS_0']);ww=accessor(js,binb,primitive['attributes']['WEIGHTS_0'])
 ear_weight=np.zeros(len(v))
 for k in range(4):ear_weight+=ww[:,k]*np.array([jnames[int(q)].startswith('Ear') for q in ji[:,k]])
 t=np.clip((v[:,2]-.025)/.009,0,1)*ear_weight
 v[:,1]+=t*t*.0038
 v[:,0]+=np.sign(v[:,0])*t*t*.0015
 primitive['attributes']['POSITION']=add_accessor(js,binb,v.astype(np.float32),'VEC3',34962)


# Oval eye silhouette and smaller pupil retain the proven front surface depth.
for primitive in prims:
 name=mats[primitive['material']]['name']
 if name not in ['Eye_White','Eye_Black','Eye_Catch']:continue
 v=accessor(js,binb,primitive['attributes']['POSITION']).astype(float)
 for side in [-1,1]:
  mask=v[:,0]*side>0
  if not mask.any():continue
  c=v[mask].mean(0)
  v[mask,2]=c[2]+(v[mask,2]-c[2])*1.24
  if name=='Eye_Black':
   v[mask,0]=c[0]+(v[mask,0]-c[0])*.77
   v[mask,2]=c[2]+(v[mask,2]-c[2])*.80
 primitive['attributes']['POSITION']=add_accessor(js,binb,v.astype(np.float32),'VEC3',34962)
# Flatten the eye assembly into layered oval lenses instead of separate eyeballs.
for primitive in prims:
 name=mats[primitive['material']]['name']
 if name not in ['Eye_White','Eye_Black','Eye_Catch']:continue
 v=accessor(js,binb,primitive['attributes']['POSITION']).astype(float)
 for side in [-1,1]:
  mask=v[:,0]*side>0
  if not mask.any():continue
  c=v[mask].mean(0);ext=np.max(np.abs(v[mask]-c),axis=0)
  if name=='Eye_White':
   v[mask,0]=side*.0040+(v[mask,0]-c[0])*.00122/ext[0]
   v[mask,2]=.02275+(v[mask,2]-c[2])*.00162/ext[2]
   v[mask,1]=-.00425+(v[mask,1]-c[1])*.00016/ext[1]+(np.abs(v[mask,0])-.0040)*.50
  elif name=='Eye_Black':
   v[mask,0]=side*.0040+(v[mask,0]-c[0])*.00066/ext[0]
   v[mask,2]=.0227+(v[mask,2]-c[2])*.00116/ext[2]
   v[mask,1]=-.00444+(v[mask,1]-c[1])*.000065/ext[1]+(np.abs(v[mask,0])-.0040)*.50
  else:
   v[mask,0]=side*.00377+(v[mask,0]-c[0])*.00023/ext[0]
   v[mask,2]=.02330+(v[mask,2]-c[2])*.00031/ext[2]
   v[mask,1]=-.00454+(v[mask,1]-c[1])*.000025/ext[1]+(np.abs(v[mask,0])-.0040)*.50
 primitive['attributes']['POSITION']=add_accessor(js,binb,v.astype(np.float32),'VEC3',34962)
# Fit each lens to the sampled front face, including its curvature.
body_primitive=prims[0]
body_points=accessor(js,binb,body_primitive['attributes']['POSITION']).astype(float)
body_faces=accessor(js,binb,body_primitive['indices']).reshape(-1,3)
face_triangles=body_points[body_faces]
face_triangles=face_triangles[(face_triangles[:,:,2].min(1)>.018)&(face_triangles[:,:,2].max(1)<.026)&(face_triangles[:,:,1].mean(1)<-.002)]
def face_depth(x,z):
 hits=[]
 for tri in face_triangles:
  mat=np.stack([tri[1,[0,2]]-tri[0,[0,2]],tri[2,[0,2]]-tri[0,[0,2]]],axis=1)
  if abs(np.linalg.det(mat))<1e-12:continue
  uv=np.linalg.solve(mat,np.array([x,z])-tri[0,[0,2]])
  if min(uv)>=-1e-6 and sum(uv)<=1.000001:hits.append(tri[0,1]+uv[0]*(tri[1,1]-tri[0,1])+uv[1]*(tri[2,1]-tri[0,1]))
 if hits:return min(hits)
 distance=np.sum((body_points[:,[0,2]]-[x,z])**2,axis=1)
 valid=np.where((body_points[:,1]<-.002)&(body_points[:,2]>.018)&(body_points[:,2]<.026))[0]
 return body_points[valid[distance[valid].argmin()],1]
for primitive in prims:
 name=mats[primitive['material']]['name']
 if name not in ['Eye_White','Eye_Black','Eye_Catch']:continue
 vv=[];nn=[];ff=[];jj=[];ww=[]
 for side in [-1,1]:
  cx=side*.00365;cz=.02275
  rx,rz,offset={'Eye_White':(.00122,.00162,.00017),'Eye_Black':(.00048,.00097,.00029),'Eye_Catch':(.00020,.00028,.00043)}[name]
  if name=='Eye_Catch':cx-=.00020;cz+=.00055
  start=len(vv)
  for ring in range(6):
   radius=ring/5
   for k in range(48):
    angle=k*2*np.pi/48;x=cx+np.cos(angle)*rx*radius;z=cz+np.sin(angle)*rz*radius
    y=face_depth(x,z)-offset-(1-radius*radius)*.00004
    vv.append([x,y,z]);normal=np.array([side*.45,-1,.05]);normal/=np.linalg.norm(normal);nn.append(normal)
    vi=int(np.sum((pos0-[x,y,z])**2,axis=1).argmin());jj.append(jix0[vi]);ww.append(wts0[vi])
  for ring in range(5):
   for k in range(48):
    a=start+ring*48+k;b=start+ring*48+(k+1)%48;c=b+48;d=a+48
    ff.extend([[a,c,b],[a,d,c]])
 attributes={}
 for key,data,typ in [('POSITION',vv,'VEC3'),('NORMAL',nn,'VEC3'),('JOINTS_0',jj,'VEC4'),('WEIGHTS_0',ww,'VEC4')]:
  attributes[key]=add_accessor(js,binb,np.array(data,np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
 primitive['attributes']=attributes;primitive['indices']=add_accessor(js,binb,np.array(ff,np.uint32).reshape(-1),'SCALAR',34963)
# Dark fitted eyelid rims sit at the oval edge, not around a protruding sphere.
MAT_LID=len(mats);mats.append({'name':'Eye_Liner','doubleSided':True,'pbrMetallicRoughness':{'baseColorFactor':[.035,.045,.07,1],'roughnessFactor':.85}})
for side in [-1,1]:
 vv=[];nn=[];ff=[]
 for k in range(48):
  t=k*2*np.pi/48
  for size in [1.0,1.06]:
   x=side*.00365+np.cos(t)*.00122*size*.98
   z=.02275+np.sin(t)*.00162*size
   vv.append([x,face_depth(x,z)-.00022,z]);nn.append([side*.45,-1,0])
 for k in range(48):
  a=k*2;b=((k+1)%48)*2;ff.extend([[a,b,a+1],[a+1,b,b+1]])
 v=np.array(vv);n=np.array(nn);ni=int(np.sum((pos0-v.mean(0))**2,axis=1).argmin());prim={'attributes':{},'material':MAT_LID,'mode':4}
 for key,data,typ in [('POSITION',v,'VEC3'),('NORMAL',n,'VEC3'),('JOINTS_0',np.tile(jix0[ni],(len(v),1)).astype(np.uint8),'VEC4'),('WEIGHTS_0',np.tile(wts0[ni],(len(v),1)).astype(np.float32),'VEC4')]:
  prim['attributes'][key]=add_accessor(js,binb,np.asarray(data,dtype=np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
 prim['indices']=add_accessor(js,binb,np.array(ff,np.uint32).reshape(-1),'SCALAR',34963);prims.append(prim)
# Attached head-only fur. Exclude raised hands in the same mesh-height band.
fur_rng=np.random.default_rng(4611)
dom0=np.array(jnames)[jix0[np.arange(len(pos0)),wts0.argmax(1)]]
possible=np.where((pos0[:,2]>.020)&(pos0[:,2]<.0275)&(np.abs(pos0[:,0])<.0065)&(pos0[:,1]>-.0010)&np.isin(dom0,['Head','Ear1.L','Ear1.R']))[0]
fur_rng.shuffle(possible);selected=[]
for vi in possible:
 c=pos0[vi]
 if any(np.linalg.norm(c-pos0[q])<.00055 for q in selected):continue
 selected.append(vi)
 if len(selected)>=55:break
for vi in selected:
 normal=nrm0[vi]/max(np.linalg.norm(nrm0[vi]),1e-9)
 direction=normal*.4+np.array([np.sign(pos0[vi,0])*.12,.6,.2])
 fur_tuft(pos0[vi]-normal*.00012,direction,.00024,float(fur_rng.uniform(.00024,.00042)))
# Short layered cheek fringe follows the actual face surface and sweeps back.
for side in [-1,1]:
 for step in range(7):
  x=side*(.0052+.00008*np.sin(step*2));z=.0199+step*.00047
  y=face_depth(x,z)+.00012
  fur_tuft(np.array([x,y,z]),[side*.45,.9,.15+step*.06],.00022,.00055+(step%3)*.00008)
# Cyan irises have a darker edge and lighter inner ring, not a uniform blue sticker.
for primitive in prims:
 if mats[primitive['material']]['name']!='Eye_White':continue
 v=accessor(js,binb,primitive['attributes']['POSITION']).astype(float);colors=[]
 for q in v:
  side=1 if q[0]>0 else -1
  radial=np.sqrt(((q[0]-side*.00365)/.00122)**2+((q[2]-.02275)/.00162)**2)
  brightness=.60+.40*(1-radial)
  colors.append([brightness*.9,brightness, min(1.0,brightness*1.12),1])
 primitive['attributes']['COLOR_0']=add_accessor(js,binb,np.array(colors,np.float32),'VEC4')
# Batch accessory/fur primitives by material and attribute layout. Preserve skin data.
groups={}
for primitive in prims:
 key=(primitive['material'],tuple(sorted(primitive['attributes'])))
 groups.setdefault(key,[]).append(primitive)
batched=[]
for (material,keys),items in groups.items():
 if len(items)==1:batched.append(items[0]);continue
 merged={key:[] for key in keys};faces=[];offset=0
 for item in items:
  for key in keys:merged[key].append(accessor(js,binb,item['attributes'][key]))
  faces.append(accessor(js,binb,item['indices']).reshape(-1)+offset)
  offset+=len(merged['POSITION'][-1])
 attributes={}
 for key in keys:
  data=np.concatenate(merged[key]);typ={'POSITION':'VEC3','NORMAL':'VEC3','JOINTS_0':'VEC4','WEIGHTS_0':'VEC4','TEXCOORD_0':'VEC2','COLOR_0':'VEC4'}[key]
  attributes[key]=add_accessor(js,binb,data.astype(np.uint8 if key=='JOINTS_0' else np.float32),typ,34962 if key=='POSITION' else None)
 batched.append({'attributes':attributes,'indices':add_accessor(js,binb,np.concatenate(faces).astype(np.uint32),'SCALAR',34963),'material':material,'mode':4})
prims[:]=batched
save(DST, js, binb)
print("wrote", DST, os.path.getsize(DST), "bytes;", len(js['accessors']), "accessors;", len(prims), "bunny prims")
