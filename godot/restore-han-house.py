#!/usr/bin/env python3
"""Restore the adapted CC BY-SA 3.0 Han house from exact offline bytes."""
from pathlib import Path
import base64,gzip,hashlib
root=Path(__file__).resolve().parent
data=gzip.decompress(base64.b64decode(''.join(p.read_text().strip() for p in sorted((root/'han-house-sourcepack').glob('*.b64'))),validate=True))
if hashlib.sha256(data).hexdigest()!='b3624a5a36fffc2d25d07346b95c40804a0d081cd6bab680d432b4424eb3f3d0':raise SystemExit('Han house checksum mismatch; no file written')
dest=root/'assets/visuals/han_house_ccbysa/house.glb'
dest.parent.mkdir(parents=True,exist_ok=True)
if not dest.exists() or dest.read_bytes()!=data:dest.write_bytes(data)
print('CC BY-SA 3.0 Han house verified and restored')
