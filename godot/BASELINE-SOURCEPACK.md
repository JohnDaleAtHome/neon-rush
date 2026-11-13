# Exact baseline assets

These 38 base64 chunks encode a gzip-compressed JSON map of the 28 original baseline asset paths to base64 content. index.json records the format, ordered chunk hashes and byte lengths, aggregate encoded hash and length, assets-manifest.json hash and decompressed JSON length. Restore with `python3 godot/fetch-assets.py` from the repository root. No network is needed for baseline recovery.

The helper validates the complete pack and destination paths before writing assets. It never writes scripts. Each file is replaced through a temporary file; the overall restore is not a multi-file transaction. Stop the build on any error and rerun after fixing the cause. Do not edit the chunks by hand. Restore code and sourcepack metadata are excluded from the release resources.

Bunny: Quaternius, Ultimate Monsters, CC0, https://poly.pizza/m/irZjWFARyl . Moon texture/height: Poly Haven moon_01, CC0, https://polyhaven.com/a/moon_01 . Moon normal is derived from the height map. Ground/side/sky/sprite textures and WAV audio are original game assets. The embedded ASSET-LICENSES.txt and existing project notices remain authoritative for attribution. Other visual packs, including the separately licensed Han house, are restored separately.
