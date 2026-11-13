#!/usr/bin/env python3
"""Restore exact baseline assets offline. Validates all input before any write.
Not a multi-file transaction: stop bootstrap on any write error.
"""
from pathlib import Path, PurePosixPath
import base64,hashlib,json,zlib
ROOT=Path(__file__).resolve().parent
PACK=ROOT/'baseline-sourcepack'
def fail(message):raise SystemExit('Baseline restore: '+message+'; stop bootstrap')
def unique(pairs):
 result={}
 for key,value in pairs:
  if key in result:fail('duplicate JSON key')
  result[key]=value
 return result
def load(data):return json.loads(data,object_pairs_hook=unique)
def digest(data):return hashlib.sha256(data).hexdigest()
def read(path,limit):
 if path.is_symlink() or not path.is_file() or path.stat().st_size>limit:fail('missing, oversized or symlink input '+path.name)
 with path.open('rb') as stream:data=stream.read(limit+1)
 if len(data)>limit:fail('oversized input')
 return data
def safe(rel):
 if not isinstance(rel,str) or not rel or '\\' in rel:fail('unsafe path')
 path=PurePosixPath(rel)
 if path.is_absolute() or '..' in path.parts or str(path)!=rel or ':' in rel:fail('unsafe path')
 return path
if PACK.is_symlink():fail('symlink sourcepack')
meta=load(read(PACK/'index.json',32768))
if meta.get('version')!=1:fail('unsupported version')
manifest_bytes=read(ROOT/'assets-manifest.json',65536)
if digest(manifest_bytes)!=meta['manifest_sha256']:fail('manifest hash mismatch')
manifest=load(manifest_bytes)
if not isinstance(manifest,dict) or len(manifest)!=28:fail('baseline file count mismatch')
for rel in manifest:safe(rel)
parts=meta['parts']
if not isinstance(parts,list) or not 1<=len(parts)<=64:fail('invalid chunk count')
names=[p['name'] for p in parts]
if names!=['part-%03d.b64'%i for i in range(len(parts))]:fail('invalid chunk sequence')
if set(x.name for x in PACK.iterdir())!=set(names+['index.json']):fail('unexpected or missing chunks')
encoded=[]
for part in parts:
 data=read(PACK/part['name'],240001)
 if len(data)!=part['bytes'] or digest(data)!=part['sha256']:fail('chunk integrity mismatch')
 encoded.append(data.strip())
encoded=b''.join(encoded)
if len(encoded)>10000000 or len(encoded)!=meta['encoded_bytes'] or digest(encoded)!=meta['encoded_sha256']:fail('aggregate integrity mismatch')
compressed=base64.b64decode(encoded,validate=True)
if not isinstance(meta['json_bytes'],int) or not 1<=meta['json_bytes']<=10000000:fail('invalid payload limit')
dec=zlib.decompressobj(16+zlib.MAX_WBITS)
raw=dec.decompress(compressed,meta['json_bytes']+1)
if len(raw)!=meta['json_bytes'] or not dec.eof or dec.unused_data or dec.unconsumed_tail:fail('payload length, trailing data or decompression limit')
items=load(raw)
if not isinstance(items,dict) or set(items)!=set(manifest):fail('payload file set mismatch')
validated=[]
for rel,encoded_data in items.items():
 safe(rel);entry=manifest[rel]
 if not isinstance(encoded_data,str) or not isinstance(entry['bytes'],int) or not 0<=entry['bytes']<=8000000:fail('invalid file size')
 if len(encoded_data)>4*((entry['bytes']+2)//3):fail('encoded file too large')
 data=base64.b64decode(encoded_data,validate=True)
 if len(data)!=entry['bytes'] or digest(data)!=entry['sha256']:fail('asset integrity mismatch '+rel)
 dest=ROOT/'assets'/rel;tmp=dest.with_name(dest.name+'.tmp')
 if any(q.is_symlink() for q in [dest,tmp,*dest.parents]):fail('symlink destination')
 if dest.exists() and not dest.is_file():fail('non-file destination')
 if tmp.exists() and not tmp.is_file():fail('non-file temporary destination')
 if any(q.exists() and not q.is_dir() for q in dest.parents):fail('non-directory parent')
 validated.append((dest,tmp,data))
for dest,tmp,data in validated:
 if dest.is_file() and dest.read_bytes()==data:continue
 dest.parent.mkdir(parents=True,exist_ok=True);tmp.write_bytes(data);tmp.replace(dest)
print('BASELINE_OFFLINE_PASS',len(validated),'verified baseline files')
