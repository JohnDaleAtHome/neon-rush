#!/usr/bin/env python3
"""Restore original generated path data using only the Python standard library."""
from pathlib import Path
import base64,hashlib
root=Path(__file__).resolve().parents[1]
data=base64.b64decode(''.join((root/'tools/path_cells.png.b64').read_text().split()),validate=True)
if hashlib.sha256(data).hexdigest()!='16f49915c50ad9335d77d52290a30ba8c1c94fadabf0a36b30a61970393b8a21':raise SystemExit('Path data checksum mismatch; nothing written')
dest=root/'assets/visuals/meadow/path_cells.png'
dest.parent.mkdir(parents=True,exist_ok=True)
if not dest.exists() or dest.read_bytes()!=data:dest.write_bytes(data)
print('Original generated path data verified and restored')
