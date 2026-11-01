# v46 visual checkpoint validation

This is a recoverable visual draft, not final concept-art acceptance. No public
site is changed. The frozen publicv29 build remains separate.

## Integrated changes

Mochi has flatter oval eye lenses following the face angle, dark thin rims,
small attached head-fur tufts and a quiet normal-map fiber treatment. Navy scarf
and cyan seams use shared root-to-tip UVs for time-based bending, not cloth
simulation. All 14 animation channels/sampler values and inverse binds are exact;
the same four explicit rest-scale adjustments remain. New accessory/fur meshes
are batched to 17 surfaces rather than 104, without merging different materials.
Rejected floating fur/glint experiments are not included. Native 42 pose pixels
and three fixed-pose scarf-time images show attachments staying with the rig.
The face remains generic and fur too smooth compared with the tracked concept.

Meadow banks have stronger rolling relief with CPU/GPU anchoring kept in sync.
Understory has curved, broader leaves with interpolated normals and varied
width/height. An initial 362,880 vertex dense pass was rejected after visual and
render-cost review. The final 48 fern/cover meshes contain 2376 vertices each,
114,048 total. Each of 252 irregular canopy volumes has 576 vertices. These replace
the smooth ellipsoids and dense draft's 1200 vertex volumes. Counts remain 34 hills,
98 props and 36 trees. Corridor clearance remains 4.25 units. Blue-teal fog, darker
bank tones, restrained slate path joints/shoulder glow and cloud-veiled lunar
shading tie the scene together. Three-moon positions/options are unchanged.
HUD fromv45 is unchanged. Ground cover still reads angular/repeated, near patches
are sparse, and the moons still read detached. Density was not treated as art
acceptance. Other themes, mechanics, collisions, score/save schemas are unchanged.

## Regression and recovery

All 28 headless suites pass from a clean recovered source tree. Extended checks
cover canopy finite bounds/vertex budget, cover corridor bounds, scarf UV root/
tip range, eye aspect/depth bounds and character batching. Builder output is
byteexact across two runs. Offline sourcepack restores 12 visual binaries;
network checksum recovery restores 27 baseline binaries plus the license text
(28 manifest entries). The 39 binary files match the reviewed source exactly.
Clean Godot 4.7.2 import and Web export have no errors or warnings. Preview-only
scenes were removed before export. Actual browser pixels were inspected at 320,
390,844 and 1280 width: menu, play and pause. Pause click coordinates were corrected
in the validation harness for content scaling. Light-quality on/off and restored
Meadow, jump/duck, and 390/1280 scroll views were inspected. Browser tests report
zero page errors and no window.neonQA hook.

## Browser render-cost comparison

Same installed Chrome, ANGLE Vulkan SwiftShader software renderer, same launch
settings, sequential sessions with reversed order on repeat. New browser
contexts start fresh, enter Story Meadow, warm up 350 ms and sample 6500 ms.
Instrumentation counts WebGL draw submissions and submitted triangle instances;
requestAnimationFrame intervals are wall-clock cadence, not GPU timer queries.
JavaScript draw-call submission timings are noisy and do not measure GPU cost.
Instrumentation is injected only into the test session, not shipped in the game.
Raw per-run aggregate records are in v46-browser-render-measurements.json.

| View | Version | Samples | Mean frame interval | Mean draws/frame | Mean submitted triangles/frame |
|---|---|---:|---:|---:|---:|
| 390 | v45 | 32 | 389.6 ms | 955.0 | 303,768 |
| 390 | v46 | 32 | 398.4 ms | 871.4 | 295,378 |
| 1280 | v45 | 14 | 883.3 ms | 1245.9 | 365,420 |
| 1280 | v46 | 14 | 929.7 ms | 1153.4 | 351,517 |

The final draft reduces draw submissions by about 8.8%/7.4% and submitted triangles
by 2.8%/3.8% at 390/1280. Mean frame intervals are still about 2.3%/5.3% worse in
this software-rendered sample. Both builds are far below playable cadence here;
these timings cannot establish real-device FPS. Variation, few desktop samples,
software rendering and instrumentation overhead limit any causal conclusion.
The rejected dense draft was substantially worse, around 519 k/624 ktriangles.
Physical-device browser/WebGL performance remains an open acceptance gate.

This checkpoint does not prove natural full-campaign L5/L6/reunion play, audio,
human fun, physical-device compatibility or final-art quality. No paid assets,
account changes or deployment are included.
