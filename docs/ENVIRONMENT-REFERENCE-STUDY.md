# Neon Rush environment reference study, 4 November 2026

User intent: nicer scenes and environments; search game videos, screenshots and open-source game models, study and incorporate them. First candidate targets Meadow under existing requirements, not a six-level style replacement.

## Studied visual evidence

- Sky: Children of the Light official Steam gameplay trailer, first90seconds downloaded and sampled visually. Dark stone/bright grass contrast, oversized scenic silhouettes and distance layers create stronger depth than uniform detail. Official screenshots reviewed show quiet blue silhouettes with a few warm luminous accents. Reference only, no Sky media/assets included in game.
  https://store.steampowered.com/app/2325290/Sky_Children_of_the_Light/
- Omno official press screenshot ScreenShot_Green1 and landscape media preview reviewed. Foreground rocks frame a lit middle distance, foliage has varied scale, the horizon is not a flat strip. Reference only; copying game geometry/textures is not authorized.
  https://www.playomno.com/presskit
- Quaternius Nature MegaKit preview reviewed: plants grouped in drifts, large rocks integrated into banks, broad calm ground areas between detailed clusters. Reference preview is richer than importing the models alone.
  https://quaternius.com/packs/stylizednaturemegakit.html

## Reusable assets selected

Quaternius Stylized Nature MegaKit STANDARD, downloaded via Godot Asset Store. Archive License_Standard.txt explicitly CC0. Standard contains68/116models and no Godot project/custom shader setup;116is full-pack count, not free-tier entitlement. No purchase. Selected CommonTree1/3/5, Bush_Common, Rock_Medium1/2/3 glTF with their bin/textures. Resized source textures to512px; custom moonlit shader replaces pack's natural green/red response. Preserve source and license in source control upon acceptance.
https://store.godotengine.org/asset/quaternius/stylized-nature-megakit/
https://creativecommons.org/publicdomain/zero/1.0/

Kenney Nature Kit is an alternative CC0 source, not downloaded or incorporated. Models/terrain variety useful, more block-like appearance less suited to this first Meadow draft. OpenGameArt page includes creator description and independent material-count caution, so low-poly labels alone do not prove low draw cost.
https://kenney.nl/assets/nature-kit
https://opengameart.org/content/nature-kit

Godot documentation recommends glTF2.0 and explains separate data/textures. Browser Compatibility runtime must still be tested; importer support is not shader/performance acceptance.
https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html

## Incorporation, current isolated WIP at 22:13 SGT

49 actual model instances: 20 trees, 14 medium rocks, 12 bushes, three large asymmetrical rock groups. Seven source models retained with their CC0 license and 512px textures. Tree/rock transforms are outside the playable lane corridor, including transformed mesh AABB corners; no imported collisions. Static terrain/trees retain existing world lifecycle. Existing 98 scrolling flower/fern/stone/firefly props remain, with flower/fern spread widened across the banks rather than confined to two rows.

Side banks now have larger rolling landforms; 34 distant ridge meshes use height-dependent haze rather than a broad pale wall. Sky gradient and haze are brighter. Ground uses fine restrained variation and slope-based rock color. The straight playable track is unchanged mechanically. Meadow alone hides the hot-pink edge rails and blends moss along stone shoulders to reduce the artificial racetrack look. Light mode and other worlds restore those rails. Lane guides remain governed by the existing user option.

Actual Web 390x844/1280x800 start/scroll/duck/hazard/dew pixels inspected. Controls, lanes, runner and pickup/hazard visibility remain clear; zero page errors in both final sessions. These timed sessions progress at different speeds on the software renderer and are not matched performance trials. A timed Space input does not establish a visually successful jump; captures show the runner grounded.

All 31 existing scripts plus the focused reference-environment suite pass without errors/assertions. Synthetic campaign reaches reunion in 8,911 steps, zero deaths. The prior three material-null shutdown errors disappeared after shared imported materials were retained. Native renderer shutdown still logs texture-leak errors; not a runtime visual failure, but not claimed fixed.

Performance remains a reason to withhold integration. Original 67-instance/full-lighting draft was about 115.7/217.5ms versus baseline70.9/138.3ms in native software-renderer phone/desktop samples. A sparse35-instance draft reached about71.4/141.4ms but looked too empty. Richer49-instance current composition is visually better but mobileABBA was baseline78.73/72.37ms versus candidate88.13/84.25ms, with current desktop single158-160ms. This is roughly14% slower using those paired mobile means, not actual-device FPS. Draw calls fell449to210 on phone, proving fewer calls is not enough. A MultiMesh attempt rendered offscreen geometry, worsened timings and was reverted. Bark simplification had negligible benefit and was reverted to source meshes, preserving UVs and shapes.

Rejected experiments: bright native green/red asset colors, decorative bridge-fragment comb silhouette, excessive trough slope, noisy broad ground mottling, invisible far scenic trail, sparse foliage as an end goal. None is in the current candidate.

No source commit or public deployment yet. This is not scene-quality acceptance or a six-world overhaul. Remaining: keep richer composition while reducing imported-material/overdraw cost, confirm exact-final Web export after source restoration, then integrate validated work under the existing GitHub instruction. Physical-device performance and natural full-campaign acceptance remain unknown.

## 22:40 follow-up: material cost without removing models
All49instances retained. Opaque bark/rock surfaces now use a backface-culled no-discard shader; leaf surfaces remain two-sided with the engine alpha-scissor output instead of manual discard. Exact Web phone/desktop pixels at22:35-22:36inspected, readable controls/runner/scene,0pageerrors. All32scripts pass and syntheticreunionunchanged. Native within-run mobileABBA oldmaterial206.35/212.08ms versus split/scissor198.12/198.35ms, about5%improvement. Absolute times after the pause are slower across both variants, so cross-run comparisons are invalid. A fresh repository-baselineABBA still shows candidatecost: baseline198.45/196.15ms versus221.38/219.58ms, roughly12%slower. The difference is not erased. No actual-device claim.

Pixel inspection rejects one-sided leaves despite lower cost: their internal richness changes. Two-sided leaves restored. UVsilhouette clipping ballooned leaves1705/1800scale into181500triangles for one tree, discarded outside working candidate. Draped dew-pool experiment looked like a floating tilted ring, removed. No geometryclip, pools or cull-backleaf is in retained source.

Sources for material decisions: Godot spatial shader reference confirms ALPHA_SCISSOR_THRESHOLD and alpha pipeline semantics, and Making Trees guidance recommends two-sided leaves. https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html and https://docs.godotengine.org/en/latest/tutorials/shaders/making_trees.html . Read actual pages, not just search highlights.

Still no integration or deployment. Art direction and performance gap remain open; low draw-call counts are not acceptance.

## 23:04 follow-up: source checkpoint candidate

The historical WIP notes above are retained as a study log, not the final state. The next source checkpoint uses52nature placements, including distant tree renders baked from the CC0 models,22faceted far hills, raised side terraces and a pale central landmark on a far knoll. Nearby trees remain3D. See MEADOW-VALLEY-VALIDATION.md for the final scope,32passing suites, exact Web checks and same-run performance evidence. The distance-asset strategy preserves scenery density and reduces the all-mesh valley cost by about15% in a same-run software-renderer ABBA. Fresh baseline comparison is about1.8% slower average, not actual phone performance clearance. Source-only integration is approved under the existing development scope; deployment remains unapproved.
