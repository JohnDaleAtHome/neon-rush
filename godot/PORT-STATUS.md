# Godot rewrite work in progress

This is a native Godot 4 project, not a completed rewrite. This document describes development source, separately from the public hosted checkpoint. No Three.js code is included.

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

## Verified source checkpoint - November 10, 2026

The latest verified runtime checkpoint is `aac848ec485008267d099b823d46911f79ca1978`. An untouched archive completed documented asset bootstrap, clean import, all 66 isolated native suites and release Web export. Its production PCK has 202 paths and 7,691,616 bytes, including the unchanged complete Han-house notice, with no QA/test/fixture/oracle paths. Fresh ordinary 390x844 release menu and Begin-click gameplay pixels were inspected, with no page errors or debug QA hook.

Detected save failures now update open Settings/Stats and show one shared acknowledgment per session at a stopped/paused moment, never interrupting running movement or stacking over an existing popup. The caution distinguishes stats exports from journey backups. Controlled quota-failure pixels at four sizes, dynamic Settings updates/focus return, and fresh ordinary success/live-deferral/manual-pause pixels were inspected. Storage reliability and detection coverage are not guaranteed. Save schema and gameplay are unchanged. See BROWSER-SAVES.md.

Base and Meadow setup now reuse the scene-owned Sky. Matched rendered native menu and five-instance cleanup checks no longer show the prior two-texture retention per scene; five post-cleanup readings stay at 3,502,662 bytes rather than rising by 699,048 bytes per scene. A settled controlled campaign is also clean, but immediate synchronous campaign cleanup still reports two matching warnings. This is a bounded Linux software-rendering resource result, not a general leak-free, browser-memory or device-performance claim. Candidate ordinary release pixels at four sizes and controlled full/Light six-theme sky continuity were inspected. See SKY-RESOURCE-LIFECYCLE.md.

Settings now includes read-only HOW TO PLAY using the shared modal. Keyboard/touch mappings and mode limits match the input handlers. The text explains whole-level checkpoints, treats versus pieces, and that stats exports are not restorable journey backups. Actual ordinary release pixels were inspected at 390x844, 320x568, 844x390 and 1280x720, including bottom-close reachability and nested Escape/Enter reopening. Gameplay, settings, save schema and existing story progression are unchanged. See HOW-TO-PLAY-VALIDATION.md.

Settings, Stats and nested credits now share modal focus and pointer isolation, with Escape closing only the top popup. Ordinary release checks also verified background Sound/Begin clicks do not act through Settings, and a changed contrast option survives reload. A subsequent bounded layout repair recalculates popup bounds and scroll area on resize, keeping lower Settings/Stats controls reachable after rotation. Contents and options are unchanged. See POPUP-FOCUS-VALIDATION.md and POPUP-RESIZE-VALIDATION.md.

Latest source adds Settings ART CREDITS with the Han author/license/adaptation/full notice and existing CC0 art contributors. Credits responds to resize and blocks background pointer and keyboard activation. A late ordinary Enter check found stacked panels; the fix suspends/restores background focus and focuses credits close. The final archive includes that fix, the ui_accept regression, and ordinary Enter/Tab close verification. See ART-CREDITS-VALIDATION.md.

Earlier November 9 source adds the original static Shadow kindness offering illustration, gesture-only Guardian FIRE access and Shadow capture retry bell parity. Both quality options and four screen sizes were inspected for the illustration. Its words/action and running 3D remain unchanged. See SHADOW-OFFER-VALIDATION.md, GESTURE-FIRE-VALIDATION.md and SHADOW-BELL-VALIDATION.md.

Ordinary unseeded release play earned Storm Sea / Bridge 3 of 5 and recovered that earned checkpoint across fresh browser processes. It reached the turtle action and entered the Tide Pearl exit, but did not complete the exit, Shadow Comet, Guardian or reunion. Full natural campaign acceptance remains open. The controlled campaign's 8,892 fixed steps / zero deaths / six worlds and reunion is separate automated evidence. Neither establishes physical-device performance, listening quality or human fun acceptance.

These are source checks, not a new deployment. Later documentation-only commits do not by themselves change the tested runtime.

## Implemented, with evidence limits
Six-level finite Story, five ordered bridge pieces, kindness interactions, short unlock crossings, guardian/reunion text, validated whole-level checkpoint saves. Chill/Classic/Rush/Chase/Mission, keyboard/touch controls, pause/menu, shields/chains/magnet, local stats/history/JSON+CSV exports, settings and generated WAV music/cues exist. Sphere/diamond alternative runners are implemented. Existence and automated checks do not establish finished feature parity or human fun acceptance.

### Selected story-piece payoffs
The approved Tide Pearl payoff is a five-second playable Sea exit at 7m/s, with an authored left wave, right arch and continuously clear center. Bridge 4 saves only after exit completion; retry retains the prior Sea checkpoint. The approved Eclipse Key payoff makes Story Guardian 3HP while Mission remains 4HP; phase and hit-window timing are unchanged. These selected mechanics are implemented and tested, not remaining omissions. See PEARL-KEY-VALIDATION.md. The broader obstacle variety described in STORYLINE.md remains simplified as noted above.

### Historical review evidence, with separate later checks
- Immutable public v29 review build: source 1612c7fd269d19db4e0685b7d16c7de49ef3b06c. Independent ordinary-input desktop review completed L1-4 naturally, including firefly/turtle interactions; L5 reached 22/28 seconds on one attempt. L5 completion, L6 guardian and reunion were not naturally verified on this build. Older baseline/v2 reunion runs are separate evidence, not current acceptance.
- Independent persistent-browser review verified the checkpoint across reload and separate browser sessions, reaching persisted L4/Bridge3 of5. An earlier nonpersistent test-session checkpoint loss was not a demonstrated game defect. Whole-level retry resets elapsed/dew/health, not partial-level progress. Earlier apparent progress/health inconsistency was withdrawn after source clarification.
- Earlier ordinary release checks cover portrait/landscape menu, start/jump/pause/resume and Settings/Stats layout. Moon/button settings persisted across reload. Emulated touch horizontal swipes and touch Pause worked; physical-device performance remains unverified. A later November 10 ordinary release emulation check inspected actual up-swipe airborne posture, down-swipe duck posture and upright recovery at initial Meadow. This is not physical-device gesture or timing clearance. Own local v31 screenshot-observed ordinary-input run reached L2 naturally; it does not fill late-campaign gaps.
- Synthetic fixtures verified old-data migration, controlled checkpoint/storage restores, score feedback and populated exports. Actual JSON/CSV downloads parsed correctly from a populated fixture. A later November 10 ordinary release check used a safe copy of the naturally earned Story profile: both visible export buttons downloaded successfully, all eight JSON/CSV history rows matched field-for-field, and totals, independent bests and rounded displayed averages matched. This does not prove older-user migration or records outside that profile. Same-origin legacy import remains separate from staging.
- Through v32,26 suites passed. That was historical coverage; the verified November 10 checkpoint has 66 isolated suites as stated above. The same deterministic campaign is synthetic evidence, not natural browser acceptance.
- A later November6 debug Web event-loop campaign reached all six levels and reunion across four browser phases with two retries, using read-only engine state for automated lane decisions. It is not a release-only natural human run.
- Earlier release pause/resize and browser-process restart checks preserve ordinary options/stats. Separate controlled same-origin Grove collection and production-release reload restored Storm Sea/Bridge3. These earlier checks were controlled save evidence, not naturally earned progress. The later November 9 ordinary release-only run earned and recovered Sea / Bridge 3 as recorded above; it does not prove later campaign completion. Screenshot/OCR controller delays limited that run, and no game difficulty defect was established.

### Recent source-only fixes after frozen v29
Stats now label independent best score/longest distance/most treats/longest time separately from attempt counts; Story records level attempts, not complete journeys. CSV retains Story level/outcome after its original six columns with CSV escaping. Retry resets duck/fire timers and touch gesture state. The transient input reset defect is distinct from the withdrawn progress/health concern. These changes were committed after the frozen v29 review checkpoint. Deployment status is separate from source history; source commits do not overwrite a frozen build.

## Legacy migration
Old localStorage stays untouched. First engine use maps valid legacy control/visual preferences; saved engine preferences win on later visits. Unsupported runner shape is not silently mapped. Classic and Chill scores stay distinct. Legacy numeric history timestamps convert from epoch milliseconds to UTC date text. Invalid checkpoint piece order is rejected, and an engine checkpoint is never overwritten by the old one. This migration was tested with synthetic browser storage fixtures, not naturally accumulated user stats. Same-origin access is required; alternate staging domains cannot read the official site's storage.

## Remaining acceptance and scope gaps
- Latest natural L5 completion, L6 guardian and reunion acceptance remain open. Desktop cloud input latency limited reviewer coverage; it neither proves a game defect nor proves latency is the sole cause of deaths. Do not retune based on that alone.
- Story mechanics are simplified. Most obstacles reuse low/tall/beam variants, rather than all authored pits/serpents/shadow bolts/eclipse-ring mechanics in STORYLINE.md. Gates and footprints are simple markers.
- Environment/NPC/guardian art remains simplified. The playable rabbit is a derived, animated Quaternius-based WIP with concept-directed jacket, boots, eyes, ears and fur treatment, not accepted final reference fidelity. Palace has complete authored Han house street edges; Storm Sea has an original stone causeway; Meadow, Dunes, Grove and Comet have separate scoped visual modules and Light fallbacks. Comet retains its story-required celestial identity and remains a theme/coherence gap.
- The ending shows an original generated static illustration of Chang'e, Mochi and Wu Gang sharing mooncake/tea beneath a flowering branch. Grove's stopped firefly beat separately shows an original illustrated Wu Gang witness with axe at rest, matching the ending design. Neither is an animated/live3D NPC. Guardian has an original eclipse-mask treatment; the turtle uses a licensed3D model. See GROVE-WITNESS-VALIDATION.md, REUNION-CARD-VALIDATION.md, HAN-STREET-VALIDATION.md and SEA-CAUSEWAY-VALIDATION.md. These scoped improvements are not final campaign-art acceptance.
- Browser audio listening, physical-device performance/gesture review and human fun acceptance remain open. Automated and emulated-touch checks do not replace them.
- Totals import legacy runs/distance/treats, then track new attempts; active seconds start with this engine update. Missing older engine attempts are not fabricated from rolling history. Historical field names can differ from newer attempt labels.
- Source binaries are recovered through the checksum manifest/bootstrap, with an explicit network dependency on preserved staging source-assets URLs. The source tree is not a self-contained binary asset archive.

Source integration does not update the hosted game. Do not call this WIP a completed rewrite. Story canon remains STORYLINE.md. Requirements remain GAME-REQUIREMENTS.md and TECHNICAL-REQUIREMENTS.md. Asset credits remain in assets/ASSET-LICENSES.txt; no paid assets.

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

The native test runner isolates user data on Linux and reports script errors/timeouts. At the earlier5463190 checkpoint, all51 isolated suites passed from a restored fresh archive. The current 63-suite checkpoint is recorded at the top of this document. At that earlier point, branch-frame and reunion-people changes had targeted card/campaign/save/guardian checks, not a newer full-suite run. That historical evidence has since been supplemented by the later fresh-archive checks above. See NATIVE-TESTS.md and REUNION-CARD-VALIDATION.md. No deployment or physical-device clearance is implied.


## November6 evening: selected story-piece payoff
The Tide Pearl now has the selected short playable Sea exit: two authored hazards at7m/s for five seconds, one continuously clear lane, ordinary movement/contact and no random pickups or exit bonuses. Bridge4/5 is saved only after completion; death/retry retains the prior Sea checkpoint. Eclipse Key starts Story Guardian at3HP with a3-point display; Mission stays4HP. Both keep the existing two-hit window and shield timing.

All58 isolated suites pass locally and on an untouched7eeb434 source archive after documented asset restore. Controlled campaign now8892steps/zero deaths/reunion, not the previous8911-step fixture. Production Web startup and separate labeled Sea release-fixture pause/resize/resume pixels checked. See PEARL-KEY-VALIDATION.md for exact limits. Public deployment, natural full-browser campaign, human balance/listening and physical-device acceptance remain open.

## November9: gesture-only Guardian access
With movement buttons hidden, Guardian FIRE remains available as the only on-screen action. Movement gestures and keyboard mappings, Story3HP/Mission4HP, timing and save schema are unchanged. Settings names the movement-button option and explains the exception. All59 isolated native suites and controlled production-release browser touch/pause checks pass; actual390/844/1280pixels inspected. See GESTURE-FIRE-VALIDATION.md. Not deployed; no real-phone or unassisted-play clearance.

Vic changed routine updates to one changelog every30days on November9, replacing twice-daily summaries. Authorized improvement work continues between updates; deployment remains separately gated.

## November9: closed studies and source-only kindness illustration
The extracted kagami-mochi trial read as a ring/plate and the Sea-wave mesh trial read as pale scallops without a clarity gain. Both were rejected, discarded intermediate assets/fixtures/exports removed, and compact comparison evidence retained. Neither is a delivered improvement. The accepted original Shadow illustration has a solid rice cake on Mochi's palm and a reaching violet shadow; it appears only in the stopped single-action beat. Public hosting is unchanged. No deployment, physical-device, natural full-campaign, listening or human-fun clearance.


## November 9: release art credits

Settings now has ART CREDITS. The ordinary release includes the unchanged full Han-house notice and readable attribution/license/adaptation summary, plus the existing CC0 art contributors and source links. Credits-only responsive layout, input blocking and top/footer close preserve the paused/menu state. Candidate and untouched821cc8f source archive all62 isolated suites passed; documented recovery/import/Web export and fresh390 ordinary Settings/credits/close/Story/jump pixels passed. Production200paths7688188B includes byte-identical Han notice, noQA/tests/fixture/oracle. Four-size actual candidate pixels passed. See ART-CREDITS-VALIDATION.md for proof and limits. Source-only, not deployed; no new device/FPS/listening/natural-full-campaign clearance.

Credits keyboard follow-through: an ordinary Enter check exposed stacked panels from the still-focused Settings button. Fixed by temporarily suspending background focus modes, focusing credits close, and restoring focus on exit. Added ui_accept and focus-restore regression. Untouched final25568d2 archive includes the repair and passes all62 suites, documented recovery/import/export and ordinary touch/keyboard checks. Its PCK is200paths/7688684B. Earlier821cc8f archive proof above precedes the focus repair. No deployment.
