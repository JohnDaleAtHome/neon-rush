# Decorative torus LOD candidate, Nov 4

Source integration only, not deployed. Based on verified v84, cb7809d7ebe0881d75b9a4b62c6396fe4530813f. Four added main.gd lines set rings=24 and ring_segments=12 for 30 Silver Dunes craters and 30 Storm Sea decorative rings. No collisions, hazards, gameplay, rig, materials, dimensions or transforms changed.

29 existing headless suites pass. Focused test_decorative_torus_lod.gd additionally checks 30 props, exact expected radii/positions, 17,280 triangles per affected world, and Light cleanup. Release web export passed before adding the focused test.

Native software-renderer static Storm Sea mobile ABBA means: baseline43.12/40.32ms, candidate34.88/33.59ms, 30 samples per run. Same81draw calls; primitives161086 ->55486. Sand mobile40.77 ->33.11ms; desktop Sea78.84 ->70.61ms, Sand77.33 ->67.88ms, single pairs. These are measured renderer-specific results, not physical-device or general FPS guarantees.

Web software renderer mobile ABBA means: baseline274.35/251.91ms, candidate199.49/195.45ms, 26-33frames per run, errors0. Scene progression differs, so supportive only, not controlled causal evidence.

Actual native desktop/mobile gameplay pixels for both affected worlds, web scrolling phone pixels and paired close-up renders inspected. Closeups show slight24-segment faceting versus dense baseline, especially on Sand outer contour. At ordinary gameplay scale silhouettes read as round and placement is unchanged. This tradeoff is used only for decorative scenery, not character or collision geometry. Not a claim of pixel equivalence or final art acceptance. Closed face/sculpt and bark batching branches untouched.

Native renderer logs retain environment Vsync and shutdown texture-leak warnings. No clean-runtime or leak-fix claim. No new public deployment permission.
