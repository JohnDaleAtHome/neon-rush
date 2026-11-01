# v48 concept-directed scene checkpoint

Recoverable visual WIP, not concept-art acceptance or a public deployment.
Validated v47 remains the comparison baseline. Public v29 is unchanged.

## Whole-scene changes and judgment

The tracked target is docs/concept-art/mochi-main-character.webp. This pass
combines character surface/costume and Meadow composition rather than treating
an accessory list as concept likeness. A single clipped fur-shell pass on the
main white surface softens its contour; it is short plush-like grain, not the
target's long flowing fur. Eye regions are masked to avoid obscuring cyan eyes.
Ears sweep farther back through skinned geometry, the jacket opening is narrower,
curved navy lapels have colored seams, and boots cover lower legs. The face and
costume remain generic and much simpler than the target. Seventeen material
surfaces remain; animation channels and collision/gameplay are unchanged.

Meadow has grouped grass/flower drifts and varied crown proportions, with slate
slabs and quiet joints replacing the stretched-looking path grain. Each fern/
grass mesh remains 2376 vertices, 114048 across48meshes:72tapered three-section
blades replace the previous rounded leaf cover within the same geometry budget.
The grass emission is restrained after a bright-stroke candidate was rejected.
The corridor remains clear. Clumps and groves are still visibly repeated and
procedural. Moons/sky/HUD retain v47's treatment, not a newly accepted art style.

Rejected character candidates:1400long skinned fiber ribbons read as spikes;
2800shorter ribbons read as speckles. Three-shell and two-shell fur candidates
added too much submitted geometry. The retained single shell is a bounded
compromise, still requiring physical-device review. Flattened wide canopies
looked like pancakes and were replaced before this checkpoint.

## Validation

- Original GLB14animation objects and sampler input/output bytes match; inverse
  bind matrices/skin match; four documented rest scales unchanged. Finite indexed
  geometry and normalized skin weights pass. Final GLB2412788bytes,
  SHA2563a558fb7663b7eb10c436ca7e766478e1de094135d5d81114b82e42f74252ac0.
- All28headless suites pass after clean sourcepack restoration/import, including
  one-pass fur-chain cap and six half-period scenery-wrap cycles. A new wrap
  assertion caught two far flowers outside the145unit initial loop; flower drift
  spacing was corrected before final recovery. No gameplay scroll logic changed.
- Actual pixels inspected: native three-quarter,42animation samples (14clips at
  10/50/90%),390portrait jump/duck/run,1280desktop gameplay, and four recycled
  scenery samples through292world units. No obvious detached boot/lapel pieces
  or corridor foliage intrusions in these fixtures. Tiny clipping/art quality
  is not fully excluded. Recycle preview is a deterministic visual fixture, not
  natural campaign play. Native proof exit reports driver texture cleanup leaks
  and unsupported VSync; clean headless import/export/suites do not.
- Twelve sourcepack binaries restore offline exactly. The current pack is24chunks
  00..23. Preview scripts are not shipped. Light quality still bypasses Meadow;
  theme transitions restore original moons and props. Full browser startup has
  no pageerrors; absence of neonQA in release is expected, not a failure.

## Final render-cost comparison

Same installed Chrome, ANGLE Vulkan SwiftShader software renderer, two runs in
reversed version order per viewport,350ms warmup and6500ms sampling. WebGL
instrumentation counts submissions, not GPU time. Final1280pair was taken without
parallel Godot import/tests; an earlier contended pair was excluded and retained
locally for diagnostics. Raw final records: v48-browser-render-measurements.json.
Frame-weighted aggregates:

| View | Version | Frames | Mean interval | Draws/frame | Triangles/frame |
|---|---|---:|---:|---:|---:|
|390|v47|29|440.2ms|865.5|290788|
|390|v48|27|463.6ms|878.4|302669|
|1280|v47|12|975.0ms|1153.0|351441|
|1280|v48|12|988.9ms|1160.0|362281|

Submitted triangles increase4.1%/3.1%, draws1.5%/0.6%. Mean software intervals
are5.3%/1.4%worse. Earlier scouts varied in both directions, so there is no speed
claim. Physical-device browser/WebGL performance remains an open acceptance gate.

No final concept fidelity, natural full-campaign play, audio, human fun, deployment,
paid tools/assets, account changes or physical-device compatibility is claimed.
