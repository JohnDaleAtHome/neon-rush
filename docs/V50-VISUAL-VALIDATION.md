# v50 head, groom and costume reconstruction checkpoint

Recoverable visual WIP based on committed v48, source
7e82a9c602a284d3f396dd8752d1a2dc80cf9b07. Not concept acceptance or deployment.
The private v49 parameter experiment was not checkpointed. Public v29 is unchanged.

## Changed and unchanged

The upper ear mesh is replaced by closed curved volumes and separate front grids,
weighted continuously to the existing three ear joints on each side. Small swept
locks break the ear edge. A smaller muzzle, small upper eyelids, swept crown/cheek
locks, longer open jacket, position-welded hem boundary, cloth/circuit shader,
backpack straps and wider trailing scarf form one character candidate. Material
batching leaves 18 surfaces, versus 17 in v48. No animation, hierarchy, inverse
bind, collision, physics, levels, save contracts or other gameplay changes.
World, moons, HUD and their wrap behavior are byte-unchanged from v48.

Actual pixel judgment: the silhouette and smaller face are more intentional, but
this is still a simple generic rabbit. Ear curls are strong in several authored
poses; small groom locks look solid rather than flowing fiber. The inner ear is
a flat tintable patch, the costume is much simpler than the concept, and the
single shell reads as grain, not long soft fur. These remain acceptance gaps.
The checkpoint is not a claim that the concept has been matched.

Rejected drafts included a duplicated-ring inner patch that flickered, parallel
ear tubes, tall comb-like crown spikes, and incorrectly wound edge locks. The
retained grid has one front face, and the locks have outward winding. No invalid
zero-count GLB primitive remains. Builder reproduces the recovered GLB exactly.

## Evidence

- GLB 2215416 bytes, SHA256
  abe50fe50418a4ca2e1f35188ac6147c0153581b98b7bbb667f2ec65d566fad2.
- All 14 animation objects and sampler input/output bytes match the source;
  skin/inverse binds match. Four documented rest scales retain the v48 factors.
  Finite indexed geometry, normalized weights and material batching pass.
- 42 native samples cover all 14 animations at 10/50/90 percent. Native run,
  three-quarter, jump and duck pixels were inspected. No detached accessory was
  visible in these samples; small clipping is not fully excluded. Native driver
  exit reports VSync/texture cleanup warnings, not a clean-device performance pass.
- All 28 suites pass on clean recovery. The scripted campaign visits all six
  levels in 8911 steps with zero deaths and reaches reunion. This is synthetic,
  not natural full-campaign acceptance. Import and release export have no errors
  or warnings. Release 390/1280 jump/duck/run pixels were inspected after recovery,
  with zero page errors; neonQA is absent as expected.
- All 12 visual assets restore offline exactly from 24 chunks, 00..23. Original
  baseline asset recovery/provenance is unchanged. Preview scripts are excluded
  from the shipping tree. New geometry/material work uses no paid assets/tools.

## Render-cost comparison and limits

Same Chrome/ANGLE Vulkan SwiftShader software renderer, two runs in reversed
version order, 350ms warmup and 6500ms sampling, no concurrent import/tests.
Instrumentation counts WebGL submissions, not GPU time. Raw records are in
v50-browser-render-measurements.json. Frame-weighted values:

| View | Version | Frames | Mean interval | Draws/frame | Triangles/frame |
|---|---|---:|---:|---:|---:|
|390|v48|26|480.1ms|878.1|302048|
|390|v50|29|444.2ms|881.9|303078|
|1280|v48|11|1021.2ms|1160|362281|
|1280|v50|12|1001.4ms|1163|361589|

Draws increase 0.43%/0.26%; submitted triangles change +0.34%/-0.19%.
Mean software intervals are lower by 7.5%/1.9%, but small noisy samples and a
software renderer do not establish a speed improvement or playable performance.
Physical-device browser/WebGL performance remains an open gate.

Natural late-campaign play, audio listening, human fun/art feedback, final
concept fidelity and physical-device compatibility remain open. No acceptance,
public deployment or official replacement is implied.
