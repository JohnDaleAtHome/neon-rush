#!/usr/bin/env python3
"""Restore exact visual binaries from tracked ASCII chunks. Offline, stdlib only."""
from pathlib import Path, PurePosixPath
import base64, gzip, hashlib, json

ROOT = Path(__file__).resolve().parent
PACK = ROOT / 'visual-sourcepack'
manifest = json.loads((PACK / 'manifest.json').read_text())
encoded = ''.join(p.read_text().strip() for p in sorted(PACK.glob('*.b64')))
items = json.loads(gzip.decompress(base64.b64decode(encoded, validate=True)))
if set(items) != set(manifest):
    raise SystemExit('Visual sourcepack manifest mismatch; no files written')
validated = []
for rel, entry in items.items():
    path = PurePosixPath(rel)
    if path.is_absolute() or '..' in path.parts or '\\' in rel:
        raise SystemExit('Unsafe visual asset path; no files written')
    data = base64.b64decode(entry['data'], validate=True)
    expected = manifest[rel]
    if len(data) != expected['bytes'] or hashlib.sha256(data).hexdigest() != expected['sha256']:
        raise SystemExit('Visual asset validation failed: ' + rel + '; no files written')
    validated.append((rel, data))
for rel, data in validated:
    dest = ROOT / 'assets' / 'visuals' / rel
    if dest.is_file() and dest.read_bytes() == data:
        print('verified visual', rel)
        continue
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_name(dest.name + '.tmp')
    tmp.write_bytes(data)
    tmp.replace(dest)
    print('restored visual', rel)
print('All', len(validated), 'visual assets are exact (offline sourcepack).')
