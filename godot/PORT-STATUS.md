# Godot rewrite work in progress

This is a native Godot 4 project, not the completed replacement. The hosted legacy game has not been replaced. No Three.js code is included.

## Run
Run `python3 godot/fetch-assets.py` from the repository root, then open godot/project.godot in Godot 4.7.2, import resources and run. GDScript and Compatibility rendering. Export preset Web uses single-threaded WebAssembly/WebGL 2.

Command line:
```
godot --headless --path godot --editor --import
python3 godot/tools/run_tests.py --godot /path/to/godot --logs /tmp/neon-tests-1
mkdir -p build
godot --headless --path godot --export-release Web "$PWD/build/index.html"
```
Install matching web export templates first. Serve build over HTTP(S), not file://. Debug web exports expose read-only neonQA test state; release exports do not.

## Current source checkpoint - November 6, 2026

This status describes source35949a2, not the hosted game. All57 isolated native suites passed from an untouched35949a2 archive restored with the documented asset bootstrap. Import and release Web export succeeded; ordinary portrait release start was visually inspected with no page errors or debug QA hook. The deterministic campaign remains8911 fixed steps, zero deaths, all six worlds and reunion. This is automated evidence, not human or physical-device acceptance.

Recent source changes add a full-skipped-band contact fallback for long frames and bounded hazard action-cue scaling across distance/resize. They do not rebalance gameplay. See SKIPPED-CONTACT-VALIDATION.md and CUE-SCALE-VALIDATION.md for exact contracts and limitations.

## Implemented, with evidence limits
Six-level finite Story, five ordered bridge pieces, kindness interactions, short unlock crossings, guardian/reunion text, validated whole-level checkpoint saves. Chill/Classic/Rush/Chase/Mission, keyboard/touch controls, pause/menu, shields/chains/magnet, local stats/history/JSON+CSV exports, settings and generated WAV music/cues exist. Sphere/diamond alternative runners are implemented. Existence and automated checks do not establish finished feature parity or human fun acceptance.

### Historical review evidence, with separate later checks
- Immutable public v29 review build: source 1612c7fd269d19db4e0685b7d16c7de49ef3b06c. Independent ordinary-input desktop review completed L1-4 naturally, including firefly/turtle interactions; L5 reached 22/28 seconds on one attempt. L5 completion, L6 guardian and reunion were not naturally verified on this build. Older baseline/v2 reunion runs are separate evidence, not current acceptance.
- Independent persistent-browser review verified the checkpoint across reload and separate browser sessions, reaching persisted L4/Bridge3 of5. An earlier nonpersistent test-session checkpoint loss was not a demonstrated game defect. Whole-level retry resets elapsed/dew/health, not partial-level progress. Earlier apparent progress/health inconsistency was withdrawn after source clarification.
- Own current release checks cover portrait/landscape menu, start/jump/pause/resume and Settings/Stats layout. Moon/button settings persisted across reload. Emulated touch horizontal swipes and touch Pause worked; physical-device performance and vertical-gesture animation remain unverified. Own local v31 screenshot-observed ordinary-input run reached L2 naturally; it does not fill late-campaign gaps.
- Synthetic fixtures verified old-data migration, controlled checkpoint/storage restores, score feedback and populated exports. Actual JSON/CSV downloads parsed correctly from a populated fixture. These do not prove naturally accumulated data correctness. Same-origin legacy import remains separate from staging.
- Through v32,26 suites passed. Current source coverage is57 isolated suites as stated above. The same deterministic campaign is synthetic evidence, not natural browser acceptance.
- A later November6 debug Web event-loop campaign reached all six levels and reunion across four browser phases with two retries, using read-only engine state for automated lane decisions. It is not a release-only natural human run.
- Current release pause/resize and browser-process restart checks preserve ordinary options/stats. Separate controlled same-origin Grove collection and production-release reload restored Storm Sea/Bridge3. These are controlled save checks, not proof of a naturally earned current release campaign checkpoint. Bounded release-only visual-controller attempts did not earn the first checkpoint; no difficulty defect was inferred.

### Recent source-only fixes after frozen v29
Stats now label independent best score/longest distance/most treats/longest time separately from attempt counts; Story records level attempts, not complete journeys. CSV retains Story level/outcome after its original six columns with CSV escaping. Retry resets duck/fire timers and touch gesture state. The transient input reset defect is distinct from the withdrawn progress/health concern. These changes are committed but not deployed over immutable v29 or the official legacy game.

## Legacy migration
Old localStorage stays untouched. First engine use maps valid legacy control/visual preferences; saved engine preferences win on later visits. Unsupported runner shape is not silently mapped. Classic and Chill scores stay distinct. Legacy numeric history timestamps convert from epoch milliseconds to UTC date text. Invalid checkpoint piece order is rejected, and an engine checkpoint is never overwritten by the old one. This migration was tested with synthetic browser storage fixtures, not naturally accumulated user stats. Same-origin access is required; alternate staging domains cannot read the official site's storage.

## Remaining before replacing the hosted game
- Latest natural L5 completion, L6 guardian and reunion acceptance remain open. Desktop cloud input latency limited reviewer coverage; it neither proves a game defect nor proves latency is the sole cause of deaths. Do not retune based on that alone.
- Story mechanics are simplified. Most obstacles reuse low/tall/beam variants, rather than all authored pits/serpents/shadow bolts/eclipse-ring mechanics in STORYLINE.md. Gates and footprints are simple markers.
- Tide Pearl slows only its short crossing, not a continuing wave/arch encounter. Eclipse Key gates entry through the five-piece assertion, but does not currently change Guardian HP/timing compared with standalone Mission. The stronger story unlock descriptions are not fully realized mechanics.
- Environment/NPC/guardian art remains simplified. The playable rabbit is a derived, animated Quaternius-based WIP with concept-directed jacket, boots, eyes, ears and fur treatment, not accepted final reference fidelity. Palace has complete authored Han house street edges; Storm Sea has an original stone causeway; Meadow, Dunes, Grove and Comet have separate scoped visual modules and Light fallbacks. Comet retains its story-required celestial identity and remains a theme/coherence gap.
- The ending shows an original generated static illustration of Chang'e, Mochi and Wu Gang sharing mooncake/tea beneath a flowering branch. Grove's stopped firefly beat separately shows an original illustrated Wu Gang witness with axe at rest, matching the ending design. Neither is an animated/live3D NPC. Guardian has an original eclipse-mask treatment; the turtle uses a licensed3D model. See GROVE-WITNESS-VALIDATION.md, REUNION-CARD-VALIDATION.md, HAN-STREET-VALIDATION.md and SEA-CAUSEWAY-VALIDATION.md. These scoped improvements are not final campaign-art acceptance.
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

## Earlier November 6 source follow-through (historical)

The native test runner isolates user data on Linux and reports script errors/timeouts. At the earlier5463190 checkpoint, all51 isolated suites passed from a restored fresh archive. Current57-suite evidence is recorded at the top of this document. At that earlier point, branch-frame and reunion-people changes had targeted card/campaign/save/guardian checks, not a newer full-suite run. That historical evidence has since been supplemented by the current57-suite fresh-archive check above. See NATIVE-TESTS.md and REUNION-CARD-VALIDATION.md. No deployment or physical-device clearance is implied.


## November6 evening: selected story-piece payoff
The Tide Pearl now has the selected short playable Sea exit: two authored hazards at7m/s for five seconds, one continuously clear lane, ordinary movement/contact and no random pickups or exit bonuses. Bridge4/5 is saved only after completion; death/retry retains the prior Sea checkpoint. Eclipse Key starts Story Guardian at3HP with a3-point display; Mission stays4HP. Both keep the existing two-hit window and shield timing.

All58 isolated suites pass locally and on an untouched7eeb434 source archive after documented asset restore. Controlled campaign now8892steps/zero deaths/reunion, not the previous8911-step fixture. Production Web startup and separate labeled Sea release-fixture pause/resize/resume pixels checked. See PEARL-KEY-VALIDATION.md for exact limits. Public deployment, natural full-browser campaign, human balance/listening and physical-device acceptance remain open.
