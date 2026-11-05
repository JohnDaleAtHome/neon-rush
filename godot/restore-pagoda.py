#!/usr/bin/env python3
"""Restore the CC0 pagoda derivative without network or third-party packages."""
from pathlib import Path
import base64,gzip,hashlib
root=Path(__file__).resolve().parent
data=gzip.decompress(base64.b64decode(''.join((root/'pagoda.glb.gz.b64').read_text().split()),validate=True))
if hashlib.sha256(data).hexdigest()!='4b16e0ed1f23b01c47884ccefa30324cf2ba6cb597f2750973c51682a2c40c24':raise SystemExit('Pagoda checksum mismatch; no file written')
dest=root/'assets/visuals/chinese_pagoda_cc0/pagoda.glb'
dest.parent.mkdir(parents=True,exist_ok=True)
if not dest.exists() or dest.read_bytes()!=data:dest.write_bytes(data)
print('CC0 pagoda verified and restored')
