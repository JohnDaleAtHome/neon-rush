"""Build mochi.glb from bunny.glb: WIP concept-directed materials + skinned accessories.
Keeps skeleton, all 14 animations, mesh/skin structure, and material names
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
for sign in [-1,1]:
    for z,dx,dz in [(0.0205,1,-0.15),(0.0194,0.9,-0.45),(0.0214,1,0.2)]:
        fur_tuft(np.array([sign*0.0045,-0.0028,z]),[sign*dx,0,dz],0.00065,0.0013)
for x,z,d in [(-0.0015,0.026,[0.4,0,1]),(0,0.0262,[-0.4,0,1]),(0.0015,0.0259,[0.8,0,0.8])]:
    fur_tuft(np.array([x,-0.0006,z]),d,0.0008,0.0018)

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
Vv,Nn,Ff = crescent(cxy, height*0.046, height*0.016, [0,0,1])
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

import os
os.makedirs(os.path.dirname(DST), exist_ok=True)
save(DST, js, binb)
print("wrote", DST, os.path.getsize(DST), "bytes;", len(js['accessors']), "accessors;", len(prims), "bunny prims")
