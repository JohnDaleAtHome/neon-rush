# v47 composition checkpoint validation

Recoverable visual WIP, not final concept-art acceptance. No public deployment.
The publicv29 build is unchanged.

## Composition and remaining gaps

Eyes are rebuilt as face-conforming oval grids sampled from the actual front
face triangles, with a thinner fitted dark rim, radial cyan iris and smaller
pupil. They no longer read as raised spheres in the inspected three-quarter
view. Short cheek fringe stays attached. A larger fringe/crown experiment was
rejected after pixels showed a comb of spikes. The model still looks generic,
smooth and costume-light next to docs/concept-art/mochi-main-character.webp.
No claim of furry concept likeness is made. Character remains 17 surfaces.

Meadow cover uses rounded six-sided, three-section leaf volumes rather than
flat strips. Four three-leaf tufts per cover mesh replace 24 flat-strip tufts.
Together with the unchanged ferns each mesh is 2376 vertices, 114048 across 48
meshes, exactly the v46 cover budget. A four-section candidate at 134784 total
vertices was rejected after render-cost review. Cover remains sparse/repeated;
tree crowns remain faceted, and the scene is still procedural early art.
Darker grained banks retain v46 relief and corridor bounds. Indigo clouds are
broader. Lunar shading reconstructs the camera ray for matching cloud fields
and includes the sky horizon haze. One dominant moon is framed by left trees,
with smaller quiet companions instead of a row. All three moons remain.
Portrait cropping is intentional, below the objective text in inspected views.
Main resets all scales and positions before the Meadow-only override; leaving
Meadow or enabling light quality restores the original layout. HUD is unchanged
from v45/v46 and remains clear in the inspected menu/play/pause/gameplay views.

## Regression, pixels and recovery

All 28 Godot headless suites pass from a fresh asset-recovered source copy.
The deterministic campaign fixture reaches all six levels and reunion in 8911
steps with zero fixture deaths, not natural human play. Integration checks cover
2376 cover-vertex bounds, finite canopy geometry, moon scale overrides and full
light/theme cleanup/restoration. Rig checks verify 14 animation definitions and
all sampler bytes, inverse binds, normalized weights, finite indexed geometry,
four explicit rest-scale changes only, scarf UV root/tip range and eye bounds.
Two builder runs are byteexact. Offline sourcepack restores 12 visual binaries;
baseline network recovery restores 27 binaries plus license text. All 39 binary
files plus that license match exactly. Clean import and Web export report no
errors or warnings. Preview-only scenes are removed from source and export.

Actual pixels inspected: 42 native animation samples, native three-quarter
character, fixed-pose scarf at three times, 320/390/844/1280 menu/play/pause,
light on/off/restored, jump/duck, recovered 390 duck and 1280 late-scroll views.
Scarf motion is shader bending, not cloth simulation. Browser checks returned
zero page errors and no window.neonQA hook. Visuals still have the gaps above.

## Browser render-cost comparison

Same installed Chrome, ANGLE Vulkan SwiftShader software renderer. Two runs in
opposite version order per viewport, fresh contexts, 350 ms warmup after Story
start and 6500 ms sample window. Test-only WebGL instrumentation counts draw
submissions and submitted triangles; requestAnimationFrame wall-clock intervals
are not GPU timer queries or physical-device FPS. Raw aggregate records are in
v47-browser-render-measurements.json. The 1280 repeat pair was taken after the
390 pair, not simultaneously. No instrumentation ships in the game.

| View | Version | Frames | Mean interval | Mean draws/frame | Mean triangles/frame |
|---|---|---:|---:|---:|---:|
| 390 | v46 | 32 | 401.5 ms | 871.4 | 295329 |
| 390 | v47 | 31 | 407.5 ms | 865.8 | 291604 |
| 1280 | v46 | 12 | 976.3 ms | 1155.0 | 352197 |
| 1280 | v47 | 13 | 943.6 ms | 1152.2 | 351075 |

Submitted triangles fall 1.3%/0.3%, draws fall 0.6%/0.2%. Mean intervals are 1.5%
worse at 390 and 3.4% better at 1280. Variation, few frames, software rendering
and instrumentation overhead prevent a causal speed claim. The rejected
four-section candidate had more submitted triangles and worse intervals.

v46's earlier comparison with v45 is preserved in V46-VISUAL-VALIDATION.md.
Physical-device browser/WebGL performance remains an open acceptance gate.

No final art quality, natural full-campaign play, audio, human fun, deployment,
paid tools/assets, account changes or physical-device compatibility is claimed.
