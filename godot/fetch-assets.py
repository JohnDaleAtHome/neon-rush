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
# Apply the validated Meadow code and CC0 assets last, after baseline recovery.
runpy.run_path(str(ROOT/'meadow-sourcepack'/'restore.py'),run_name='__main__')
print('All baseline and Meadow assets are exact. Open project.godot in Godot 4.7.2.')

# Original generated path material; checksum-verified offline recovery.
runpy.run_path(str(ROOT / "tools" / "restore_path.py"), run_name="__main__")

# CC0 Chinese pavilion; geometry only, no runtime scripts overwritten.
runpy.run_path(str(ROOT / "restore-pavilion.py"), run_name="__main__")

runpy.run_path(str(ROOT/'restore-pagoda.py'),run_name='__main__')

# Adapted 0 A.D. Han house, CC BY-SA 3.0, offline exact recovery.
runpy.run_path(str(ROOT / "restore-han-house.py"), run_name="__main__")

# Exact newer visual assets must survive a fresh clone as well.
runpy.run_path(str(ROOT / "restore-dunes-sand.py"), run_name="__main__")
runpy.run_path(str(ROOT / "assets/models/meadow_bale/restore_texture.py"), run_name="__main__")
runpy.run_path(str(ROOT / "assets/models/sea_turtle/restore_model.py"), run_name="__main__")
print("Current visual assets restored, including Dunes sand, Meadow bale and Sea turtle.")
