# v51 material integration and eye/groom checkpoint

WIP based on b22f60e251213f8588506e38f6dcd3b04e51dad1 (v50).
Not concept acceptance or deployment. Public v29 remains unchanged.

## Separate integration fix

main.gd apply_bunny_tint previously duplicated every StandardMaterial3D source
surface into an override. That erased jacket/scarf ShaderMaterial overrides set
by MochiVisual. Thus v50 source-exact recovery did not prove its native cloth/
scarf material survived ordinary game option application. The focused fix only
replaces Bunny_Secondary and Eye_White, the two intended tint categories.
Unlocked gold eyes also stop multiplying cyan vertex colors, which otherwise
made gold look green. Gold-off restores original cyan vertex-color behavior.
Unlock requirements and option meanings are unchanged.

test_mochi_material_options.gd fails against v50 and passes after this fix. It
checks ShaderMaterial object identity for jacket/scarf across mint/violet/rose,
gold on/off and actual apply_options/light changes, plus tint color values.
Controlled close-up game-scene pixels show mint ears/cyan eyes and violet ears/
yellow gold eyes with cloth/scarf preserved. Camera movement in that fixture is
not ordinary gameplay framing. Normal release 390/1280 gameplay was also checked.

## Modest eye/groom changes

Fitted eye geometry has a gently angled almond edge and fine radial cyan iris
colors. Fur normal strength is reduced; small edge locks are narrower. The
single fur-shell shader/pass and geometry counts remain unchanged. An attempt
to bias ear weights to the root made tips curl more, so it was rejected; final
ears retain v50 weights. These are modest refinements, not solved likeness.
Generic face, solid-looking groom, flat inner ear patches, strong authored ear
curls, short fur grain, simple costume and repeated procedural scenery remain.
World/HUD/gameplay/settings schemas are unchanged; only material application in
the shared script differs. The diff for that function is separately identified
from the builder/runtime-normal changes.

## Validation

- Final GLB 2215428 bytes, SHA256
  237011a0eb639b59e9ccbec50988eac1f9de56c24512983165f709c1c558f763.
  Builder reproduces it byte-exact after offline recovery of all12visual assets.
  24chunks00..23. No preview scenes ship.
- Original14animation objects/sampler bytes and skin/inverse binds match, four
  previously documented rest scales retain their factors. Finite geometry,
  normalized weights, batched materials and oval lens checks pass.
- 42 native animation samples inspected, plus native three-quarter/run/jump/duck
  and controlled real-game option close-ups. No obvious detachment in fixtures;
  small clipping/art issues are not excluded. Native driver exit warnings are
  separate from clean import/export/tests.
- All29suites pass on clean recovery, including the new regression. Synthetic
  campaign8911steps/zero deaths/all six levels/reunion. Clean import/release
  export have no errors/warnings. Recovered390duck/1280run pixels inspected;
  browser page errors zero, release QA absent. Natural late-campaign, audio,
  human fun/art and physical-device acceptance remain open.

## Render-cost caveat

Same Chrome/ANGLE Vulkan SwiftShader software renderer; two reversed-order runs
per viewport,350mswarmup/6500mssampling, no concurrent import/tests. WebGL counts
are submissions, not GPU time. Raw records in v51-browser-render-measurements.json.

|View|Version|Frames|Mean interval|Draws/frame|Triangles/frame|
|---|---|---:|---:|---:|---:|
|390|v50|26|475.0ms|881.2|301424|
|390|v51|28|446.4ms|881.5|302491|
|1280|v50|12|988.9ms|1163|361589|
|1280|v51|12|1062.5ms|1163|361589|

Same desktop draws/triangles; mobile sampling phase varies slightly. Mean
software intervals are6.0%lower on390but7.4%worse on1280. Preserving the intended
cloth/scarf shader has cost; no speed, playable FPS or device claim is made.
This is a recoverable source checkpoint with an integration bug fixed, not a
completed visual overhaul, art acceptance, paid work or public replacement.
