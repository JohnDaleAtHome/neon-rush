# Irregular Meadow path - November 5, 2026

Source-only incremental material change, not a deployment. Flat irregular fitted stones and moss joints replace the rectangular grid. Playable footprint, collisions, three lanes, guides, scrolling and saves are unchanged.

The original generated cell-data texture is recovered offline by tools/restore_path.py from checksum-verified base64. tools/bake_path.py reproduces it with Python, NumPy and Pillow. Its SHA256 is16f49915c50ad9335d77d52290a30ba8c1c94fadabf0a36b30a61970393b8a21. No external art license is needed for this original data. Existing CC0 model provenance remains unchanged. fetch-assets.py restores the path after existing visual and Meadow assets.

34 headless suites pass. Exact Web phone390x844, desktop1280x800, smallphone360x640, landscape844x500 and later phone with dew/bale were inspected, zero page errors. Software mobile ABBA clearing117.55/114.89ms versus path115.68/117.32ms, effectively level (0.2% difference). Not actual-device FPS. The rejected runtime neighbourhood shader cost3.4% more; it is not used here.

The straight footprint and coarse scenery remain art limitations. Public v84 stays unchanged. Native shutdown texture-leak diagnostics remain.
