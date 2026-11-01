# Mochi WIP character asset

Run `python3 godot/fetch-assets.py` from repository root before importing.
The exact GLB is recovered offline from trackedASCII sourcepackchunks with
SHA256verification, not stored as a native binary Git blob.

`mochi.glb` is derived from the Quaternius Bunny (Ultimate Monsters), CC0.
Original source: https://poly.pizza/m/irZjWFARyl
License: https://creativecommons.org/publicdomain/zero/1.0/
Base recovery/provenance is recorded in `../../ASSET-LICENSES.txt` and the
project's checksum asset manifest. The tracked concept reference is
`docs/concept-art/mochi-main-character.webp` at repository root.

Original project additions include a dark jacket, boots, cyan accents and a
crescent accessory. The base skeleton and14animation clips are preserved.
`tools_build/build_mochi.py` plus `glbutil.py` regenerate the GLB from recovered
`godot/assets/bunny.glb` using Python3 and NumPy. Runtime material adjustments
are in `scripts/visuals/mochi_visual.gd` and are separate from baked materials.
The game still supports its costume tint and gold-eye unlock material names.
The checked-in builder reproduces the GLB byte-for-byte from its original
base asset (verified during integration).

This is not a finished match to the concept: eye artifacts/expression, black inner ears, cyan mouth spot, fluffy silhouette
and pendant readability remain acceptance gaps. Actual Godot/Web motion is
the reference for deformation, not a separate software-rendered preview.
