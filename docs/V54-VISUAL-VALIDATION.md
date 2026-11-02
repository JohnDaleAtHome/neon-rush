# v54 pendant attachment and costume detail checkpoint

Based on committed v51, b0a1f5d075251215512915a08a0269f7fdcdf06e.
Local checkpoint proposal only. No public replacement or visual acceptance.

## Bounded change

Side inspection exposed the crescent pendant floating far forward of the chest.
Its bind-space center is now at world Z .22 instead of about .795, with a small
vertical adjustment. It remains rigidly bound to Torso. Two thin necklace strips
join the collar area to the charm. Side/front pixels show it close to the chest.
The jacket adds an original authored rabbit/crescent badge, narrow zipper and
panel-seam/stitch detail using the existing material, without an extra draw pass.
The badge is visible in close-ups but barely reads at ordinary gameplay scale.
No downloaded assets or paid tools were added.

The generic face, solid curled ears and short grain fur remain unresolved. The
separate rejected ear studies are not part of this checkpoint. World, HUD,
gameplay, options/save schema and main.gd are byte-unchanged from v51. This is
not a claim that the character now matches the concept.

## Verification

- Final GLB 2223128 bytes, SHA256
  694426148aeb6362663d80b030f38abc647b5c785e64378fbf557003d5c45059.
  Builder reproduces it byte-exact after clean offline recovery.
- All 13 visual assets restored from 24 tracked ASCII chunks and verified by
  hash after deletion. Fresh independent baseline recovery downloaded and
  verified all 28 original assets. Recovery still depends on that baseline host.
- Original 14 animation objects/sampler bytes, skin/inverse binds and documented
  rest scales remain unchanged. Indexed finite geometry and normalized weights
  pass. New pendant test checks near-chest rest bounds and rigid Torso weights.
  This numeric test does not replace motion/clipping review.
- All 29 suites pass in clean recovery. Badge binding/resource identity survives
  tint, gold and light/options changes. Campaign result remains 8911 steps,
  zero deaths, six levels and Mooncake of Reunion.
- 42 native animation samples inspected plus front/side views. No obvious new
  detachment at sampled views; exhaustive clipping is not established.
- Preview tools removed before final recovered release export. Clean import and
  final export have no warnings/errors. Actual recovered Web 390px duck and
  1280px run pixels inspected, no page errors, release QA absent. Physical-device,
  natural full-campaign and human art/fun acceptance remain open.

## Render-cost limits

Chrome ANGLE Vulkan SwiftShader only, not a device FPS test. Two opposing-order
runs per viewport, 350ms warmup and 6500ms sampling. Raw records are in
v54-browser-render-measurements.json. A prior longer combined run timed out and
is excluded from this complete-run table. Samples are small and run-to-run
software timing varies substantially.

|View|Version|Frames|Mean interval|Draws/frame|Triangles/frame|
|---|---|---:|---:|---:|---:|
|390|v51|23|542.7ms|881.13|300465|
|390|v54|22|562.9ms|880.95|299774|
|1280|v51|10|1238.3ms|1163|361589|
|1280|v54|10|1183.3ms|1163|361621|

Matched static submission phases add exactly 32 triangles and no draw calls.
Mobile totals differ with sample phase. Aggregate intervals are 3.7% worse on
390 and 4.4% lower on1280, not evidence of a speedup or reliable regression bound.
The previously documented v51 shader cost remains unresolved on physical devices.
