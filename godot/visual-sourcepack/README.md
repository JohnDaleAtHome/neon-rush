# Offline visual asset sourcepack

The12new visual binary assets are stored as ASCII base64 chunks of a gzip JSON
archive because the available repository binary-upload route failed. These are
tracked exact source bytes, not native PNG/GLB blobs in Git history. No external
hosting, credentials, third-party package or network is needed to restore them.

Run `python3 godot/fetch-assets.py` before Godot import. It first runs
`restore-visual-assets.py` to recover these12assets, verifying length/SHA256
against manifest.json before writing any file. It then runs the original
checksum-verified network recovery for28baseline assets. To restore only the
new visual assets offline, run `python3 godot/restore-visual-assets.py`.

Chunks are ordered00.b64 through10.b64. The JSON archive carries relative asset
paths, byte counts, checksums and base64data. The decoder checks the manifest,
blocks path traversal and writes atomically after all entries validate.

Changes to visual binaries require regenerating the chunks and manifest. Do
not edit a chunk by hand or mistake a bare checkout for a ready-to-import binary
asset archive. Assets/visuals README files remain ordinary tracked text.
