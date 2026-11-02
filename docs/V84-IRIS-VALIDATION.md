# v84 iris texture checkpoint proposal

Based on committed v54,1a3cbbb0df5c3c82eb47ddc032b6d84364aa24ce.
This is a bounded close-up iris detail change, not final character acceptance.
No public deployment.

## Change
The cyan iris now uses an original deterministic512x512 grayscale radial-fiber
texture and fitted UVs instead of coarse vertex-color rings. Mipmaps reduce
shimmer and visible fine-grain noise. Cyan color remains a material tint, so
the gold unlock can still color the same texture gold. Builder generates both
the GLB and iris texture. No paid/downloaded assets.

Fresh matched native baseline/study front and three-quarter views show more
radial detail without changing eye silhouette. At normal gameplay scale the
change is tiny. It does not fix the generic face, solid curled ears or grainy
fur. Rejected head, fiber and card studies are excluded.

## Verification
- All POSITION/NORMAL/JOINTS/WEIGHTS/indices and material definitions are exactly
  equal to v54. Iris UVs replace COLOR_0. All14 animation objects/sampler bytes,
  skin/inverse binds/rest scales unchanged. Geometry/pendant regression passes.
- Actual native front/three-quarter/duck and gold pixels inspected.42 animation
  samples inspected. Gray texture stays gold rather than multiplying cyan.
- All29 suites pass in clean recovery; strengthened material test verifies the
  iris texture binding/resource path survives tint/gold/options changes.
-14 visual assets deleted then restored byteexact from27 tracked ASCII chunks.
  Clean recovered builder reproduces GLB and iris PNG byteexact. Existing28
  baseline assets unchanged from verified v54; no new network recovery proof.
- Clean recovery omits preview tools and generated cache. Import/export no
  warnings/errors. Actual recovered390px duck and1280px run pixels inspected,
  zero page errors, release QA absent. Campaign suite completes all6 levels,
 8911steps/zero deaths. No physical-device or human art/fun acceptance claim.

## Render cost caveat
Chrome ANGLE Vulkan SwiftShader only. Two opposing-order runs per viewport,
350ms warmup and6500ms sampling;18frames/version at390,8 at1280. No draw/triangle
increase:390mean880.56calls/297345tri,1280mean1163calls/361621tri.
Mean frame interval390:v54677.75ms,v84689.78ms(+1.78%);1280:v541485.35ms,
v841491.60ms(+0.42%). These small low-sample software differences are not a
speedup or reliable device regression bound. Raw8records retained separately.

GLB SHA25638107e3081d596c8aafcc7b63722780430a2e89b2991ec249ad0b8ff70ec27d1.
Iris PNG SHA256ec366077e9185ec556763a2242a656bd0d0158fc9c0dab12787027fcc5866139.
