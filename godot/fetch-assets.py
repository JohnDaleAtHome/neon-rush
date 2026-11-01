#!/usr/bin/env python3
"""Recover exact Godot assets from the companion stage. No third-party packages."""
from pathlib import Path
from urllib.request import urlopen
import hashlib,json,sys,runpy
ROOT=Path(__file__).resolve().parent
runpy.run_path(str(ROOT/'restore-visual-assets.py'),run_name='__main__')
manifest=json.loads((ROOT/'assets-manifest.json').read_text())
for rel,entry in manifest.items():
    dest=ROOT/'assets'/rel
    if dest.is_file() and hashlib.sha256(dest.read_bytes()).hexdigest()==entry['sha256']:
        print('verified',rel)
        continue
    with urlopen(entry['url'],timeout=60) as response:
        data=response.read(entry['bytes']+1)
    if len(data)!=entry['bytes'] or hashlib.sha256(data).hexdigest()!=entry['sha256']:
        sys.exit('Asset validation failed: '+rel+'; no file written')
    dest.parent.mkdir(parents=True,exist_ok=True)
    temp=dest.with_name(dest.name+'.tmp')
    temp.write_bytes(data)
    temp.replace(dest)
    print('downloaded and verified',rel)
print('All',len(manifest),'assets are exact. Open project.godot in Godot 4.7.2.')
