#!/usr/bin/env python3
"""Restore the validated Meadow valley checkpoint. Offline, standard library only."""
from pathlib import Path, PurePosixPath
import base64,gzip,hashlib,json
PACK=Path(__file__).resolve().parent
ROOT=PACK.parent.parent
manifest=json.loads((PACK/'manifest.json').read_text())
encoded=''.join(''.join(p.read_text().split()) for p in sorted(PACK.glob('*.b64')))
items=json.loads(gzip.decompress(base64.b64decode(encoded,validate=True)))
if set(items)!=set(manifest):raise SystemExit('Checkpoint manifest mismatch; no files written')
validated=[]
for rel,encoded in items.items():
 path=PurePosixPath(rel)
 if path.is_absolute() or '..' in path.parts or chr(92) in rel:raise SystemExit('Unsafe checkpoint path; no files written')
 data=base64.b64decode(encoded,validate=True);expected=manifest[rel]
 if len(data)!=expected['bytes'] or hashlib.sha256(data).hexdigest()!=expected['sha256']:raise SystemExit('Checkpoint validation failed: '+rel+'; no files written')
 validated.append((rel,data))
for rel,data in validated:
 if not rel.startswith('godot/assets/'):
  continue
 dest=ROOT/rel;dest.parent.mkdir(parents=True,exist_ok=True)
 if dest.is_file() and dest.read_bytes()==data:continue
 temp=dest.with_name(dest.name+'.tmp');temp.write_bytes(data);temp.replace(dest)
 print('restored',rel)
print('All',len(validated),'packed files validated; Meadow assets restored. Tracked source files are preserved.')
