#!/usr/bin/env python3
"""Restore the CC0 pavilion runtime GLB with checksum verification."""
from pathlib import Path
import base64,gzip,hashlib
root=Path(__file__).resolve().parent
data=gzip.decompress(base64.b64decode(''.join((root/'tools/tools/pavilion.glb.gz.b64').read_text().split()),validate=True))
if hashlib.sha256(data).hexdigest()!='3795a2f47dcb523b3a7207d300ca0f047316389d0d3ff7a5969b296caf50668e':raise SystemExit('Pavilion checksum mismatch; no file written')
dest=root/'assets/visuals/chinese_pavilion_cc0/pavilion.glb'
dest.parent.mkdir(parents=True,exist_ok=True)
if not dest.exists() or dest.read_bytes()!=data:dest.write_bytes(data)
print('CC0 pavilion verified and restored')
