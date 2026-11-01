"""Minimal GLB parse/write helpers (numpy only)."""
import json, struct
import numpy as np

COMP = {5120:'b',5121:'B',5122:'h',5123:'H',5125:'I',5126:'f'}
CSIZE = {5120:1,5121:1,5122:2,5123:2,5125:4,5126:4}
NCOMP = {'SCALAR':1,'VEC2':2,'VEC3':3,'VEC4':4,'MAT4':16}
RCOMP = {v:k for k,v in COMP.items()}

def load(path):
    data = open(path,'rb').read()
    clen, ctype = struct.unpack('<II', data[12:20])
    js = json.loads(data[20:20+clen])
    boff = 20+clen
    binb = b''
    if boff < len(data):
        blen, btype = struct.unpack('<II', data[boff:boff+8])
        binb = bytearray(data[boff+8:boff+8+blen])
    return js, binb

def accessor(js, binb, i):
    a = js['accessors'][i]
    bv = js['bufferViews'][a['bufferView']]
    off = bv.get('byteOffset',0)+a.get('byteOffset',0)
    n = NCOMP[a['type']]; dt = np.dtype(COMP[a['componentType']])
    count = a['count']
    stride = bv.get('byteStride')
    if stride and stride != n*dt.itemsize:
        out = np.zeros((count,n), dtype=dt)
        for k in range(count):
            out[k] = np.frombuffer(binb, dtype=dt, count=n, offset=off+k*stride)
        arr = out
    else:
        arr = np.frombuffer(binb, dtype=dt, count=count*n, offset=off).reshape(count,n)
    arr = arr.copy()
    if a.get('normalized'):
        if dt.kind in 'ub': arr = arr.astype(np.float32)/np.iinfo(dt).max
        elif dt.kind in 'bh': arr = np.maximum(arr.astype(np.float32)/np.iinfo(dt).max, -1.0)
    return arr.reshape(count,n) if n>1 else arr

def add_accessor(js, binb, arr, type_, target=None, normalized=False):
    arr = np.asarray(arr)
    if arr.ndim == 1: flat = arr
    else: flat = arr.reshape(len(arr), -1)
    dt = flat.dtype
    comp = RCOMP[np.dtype(dt).char]
    while len(binb) % 4: binb.append(0)
    off = len(binb)
    binb.extend(flat.tobytes())
    js.setdefault('bufferViews',[]).append({'buffer':0,'byteOffset':off,'byteLength':flat.nbytes, **({'target':target} if target else {})})
    acc = {'bufferView':len(js['bufferViews'])-1,'componentType':comp,'count':len(flat),'type':type_}
    if normalized: acc['normalized'] = True
    if type_=='VEC3' and flat.dtype==np.float32:
        acc['min']=[float(x) for x in flat.min(0)]; acc['max']=[float(x) for x in flat.max(0)]
    js.setdefault('accessors',[]).append(acc)
    return len(js['accessors'])-1

def save(path, js, binb):
    js['buffers'] = [{'byteLength':len(binb)}]
    jb = json.dumps(js, separators=(',',':')).encode()
    while len(jb)%4: jb += b' '
    while len(binb)%4: binb.append(0)
    out = struct.pack('<III', 0x46546C67, 2, 12+8+len(jb)+8+len(binb))
    out += struct.pack('<II', len(jb), 0x4E4F534A) + jb
    out += struct.pack('<II', len(binb), 0x004E4942) + bytes(binb)
    open(path,'wb').write(out)

def quat_mat(q):
    x,y,z,w = q
    return np.array([
        [1-2*(y*y+z*z), 2*(x*y-z*w), 2*(x*z+y*w)],
        [2*(x*y+z*w), 1-2*(x*x+z*z), 2*(y*z-x*w)],
        [2*(x*z-y*w), 2*(y*z+x*w), 1-2*(x*x+y*y)]])

def node_local(n):
    if 'matrix' in n: return np.array(n['matrix']).reshape(4,4).T
    m = np.eye(4)
    R = quat_mat(n['rotation']) if 'rotation' in n else np.eye(3)
    S = np.diag(n['scale']) if 'scale' in n else np.eye(3)
    m[:3,:3] = R @ S
    if 'translation' in n: m[:3,3] = n['translation']
    return m

def globals_(js):
    n = len(js['nodes']); g = [None]*n
    def walk(i, parent):
        g[i] = parent @ node_local(js['nodes'][i])
        for c in js['nodes'][i].get('children',[]): walk(c, g[i])
    for r in js['scenes'][0]['nodes']: walk(r, np.eye(4))
    return g
