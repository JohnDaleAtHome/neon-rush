# Godot rewrite work in progress

This is a native Godot 4 project, not the completed replacement. The hosted legacy game has not been replaced. No Three.js code is included.

## Run
Open project.godot in Godot 4.7.2, import resources, then run. GDScript and Compatibility rendering. Export preset Web uses single-threaded WebAssembly/WebGL 2.

Command line:
```
godot --headless --path godot --editor --import
godot --headless --path godot --script res://test_port.gd
godot --headless --path godot --script res://test_systems.gd
godot --headless --path godot --script res://test_campaign.gd
godot --headless --path godot --export-release Web ./build/index.html
```
Install matching web export templates first. Serve build over HTTP(S), not file://. Debug web exports expose read-only neonQA test state; release exports do not.

## Implemented, with evidence limits
Six-level finite Story, five ordered bridge pieces, kindness interactions, short unlock crossings, guardian/reunion text, validated whole-level checkpoint saves. Chill/Classic/Rush/Chase/Mission, keyboard/touch controls, pause/menu, shields/chains/magnet, local stats/history/JSON+CSV exports, settings and generated WAV music/cues exist. Sphere/diamond alternative runners are implemented. Existence and automated checks do not establish finished feature parity or human fun acceptance.

### Current review evidence
- Immutable public v29 review build: source 1612c7fd269d19db4e0685b7d16c7de49ef3b06c. Independent ordinary-input desktop review completed L1-4 naturally, including firefly/turtle interactions; L5 reached 22/28 seconds on one attempt. L5 completion, L6 guardian and reunion were not naturally verified on this build. Older baseline/v2 reunion runs are separate evidence, not current acceptance.
- Independent persistent-browser review verified the checkpoint across reload and separate browser sessions, reaching persisted L4/Bridge3 of5. An earlier nonpersistent test-session checkpoint loss was not a demonstrated game defect. Whole-level retry resets elapsed/dew/health, not partial-level progress. Earlier apparent progress/health inconsistency was withdrawn after source clarification.
- Own current release checks cover portrait/landscape menu, start/jump/pause/resume and Settings/Stats layout. Moon/button settings persisted across reload. Emulated touch horizontal swipes and touch Pause worked; physical-device performance and vertical-gesture animation remain unverified. Own local v31 screenshot-observed ordinary-input run reached L2 naturally; it does not fill late-campaign gaps.
- Synthetic fixtures verified old-data migration, controlled checkpoint/storage restores, score feedback and populated exports. Actual JSON/CSV downloads parsed correctly from a populated fixture. These do not prove naturally accumulated data correctness. Same-origin legacy import remains separate from staging.
- Through v32, 26 headless suites pass. Deterministic scripted campaign visits all six levels in 8911 frames with zero deaths. This is synthetic test evidence, not natural browser acceptance.

### Recent source-only fixes after frozen v29
Stats now label independent best score/longest distance/most treats/longest time separately from attempt counts; Story records level attempts, not complete journeys. CSV retains Story level/outcome after its original six columns with CSV escaping. Retry resets duck/fire timers and touch gesture state. The transient input reset defect is distinct from the withdrawn progress/health concern. These changes are committed but not deployed over immutable v29 or the official legacy game.

## Legacy migration
Old localStorage stays untouched. First engine use maps valid legacy control/visual preferences; saved engine preferences win on later visits. Unsupported runner shape is not silently mapped. Classic and Chill scores stay distinct. Legacy numeric history timestamps convert from epoch milliseconds to UTC date text. Invalid checkpoint piece order is rejected, and an engine checkpoint is never overwritten by the old one. This migration was tested with synthetic browser storage fixtures, not naturally accumulated user stats. Same-origin access is required; alternate staging domains cannot read the official site's storage.

## Remaining before replacing the hosted game
- Latest natural L5 completion, L6 guardian and reunion acceptance remain open. Desktop cloud input latency limited reviewer coverage; it neither proves a game defect nor proves latency is the sole cause of deaths. Do not retune based on that alone.
- Story mechanics are simplified. Most obstacles reuse low/tall/beam variants, rather than all authored pits/serpents/shadow bolts/eclipse-ring mechanics in STORYLINE.md. Gates and footprints are simple markers.
- Tide Pearl slows only its short crossing, not a continuing wave/arch encounter. Eclipse Key gates entry through the five-piece assertion, but does not currently change Guardian HP/timing compared with standalone Mission. The stronger story unlock descriptions are not fully realized mechanics.
- Environment/NPC/guardian art remains simplified. Animated Quaternius Bunny is a placeholder, not a finished match to the user's rabbit reference. Chang'e/Wu Gang/mooncake reunion is text, not a finished character scene. No final-art approval is implied.
- Browser audio listening, physical-device performance/gesture review and human fun acceptance remain open. Automated and emulated-touch checks do not replace them.
- Totals import legacy runs/distance/treats, then track new attempts; active seconds start with this engine update. Missing older engine attempts are not fabricated from rolling history. Historical field names can differ from newer attempt labels.
- Source binaries are recovered through the checksum manifest/bootstrap, with an explicit network dependency on preserved staging source-assets URLs. The source tree is not a self-contained binary asset archive.

The hosted legacy game has not been replaced. Do not call this WIP a completed rewrite. Story canon remains STORYLINE.md. Requirements remain GAME-REQUIREMENTS.md and TECHNICAL-REQUIREMENTS.md. Asset credits remain in assets/ASSET-LICENSES.txt; no paid assets.

## New scoped visual checkpoint (1 November 2026)
Mochi has a WIP derived model with jacket/boots/cyan details, combined with a
level0 Meadow module and moon-themed HUD. Lighting preserves face form; this
is still not a finished match to the concept. Level0 scenery is a review
candidate, not final environment art or a pass on other levels. See
VISUAL-CHECKPOINT.md for remaining character/treeline and acceptance gaps.
The source tracks exact new visual bytes in an ASCII sourcepack, not native
PNG/GLB Git blobs. Run `python3 godot/fetch-assets.py` before import: the12new
visual assets restore offline from trackedchunks with SHA256checks; original28
baseline assets still use the preserved checksum network recovery workflow. Official and immutable review builds
are unchanged by source integration.
