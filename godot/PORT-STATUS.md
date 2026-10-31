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

## Present and tested
Six-level finite story, five ordered bridge pieces, kindness interactions, five short unlock crossings, guardian/reunion, validated checkpoint saves. Chill/Classic/Rush/Chase/Mission modes, keyboard/touch lane/jump/slide/fire, pause/menu, shields/chains/magnet, local stats/history/JSON+CSV exports, settings, WAV music/cues. Same-origin legacy best-score import keeps Classic separate from Chill/Rush.

Real-time normal-input browser campaign reached reunion on baseline and v2; deterministic headless campaign visits all six levels in 8911 frames with zero retries. Independent desktop review verified kindness events, immediate six-Dew progression, progress display, attempt stats and sampled other modes. Mobile touch/swipe and actual JSON/CSV downloads verified. Layouts inspected at1280x713,390x844,320x568,844x390. Lane guides and handed controls now operate, with actual settings/dropdown/left-control pixels inspected. Guardian feedback preserves timing/HP but reveals exhausted two-hit windows. Reunion no longer duplicates NEW JOURNEY. Pause restart and menu discard require a second confirmation, with KEEP RUN available; Story restart preserves the current checkpoint. Motion offers system/full/reduced, follows browser preference by default, with a synchronous same-origin motion-setting backup. Last selected mode and matching dropdown/start labels persist across reload; NEW JOURNEY explicitly returns to Story. Shown-history averages follow the selected filter, order and count; Story rows show level/outcome. A120ms landing jump buffer is ported; jump-clear bonus requires actually crossing the same-lane hazard and pays once.

## Legacy migration
Old localStorage stays untouched. First engine use maps valid legacy control/visual preferences; saved engine preferences win on later visits. Unsupported runner shape is not silently mapped. Classic and Chill scores stay distinct. Legacy numeric history timestamps convert from epoch milliseconds to UTC date text. Invalid checkpoint piece order is rejected, and an engine checkpoint is never overwritten by the old one. This migration was tested with synthetic browser storage fixtures, not naturally accumulated user stats. Same-origin access is required; alternate staging domains cannot read the official site's storage.

## Remaining before replacing the hosted game
- Full feature-parity work: lifetime totals, alternative sphere/diamond runner settings.
- Near-miss bonus, jump-clear feedback, visible run-goal progress and score breakdown are now ported. Their new browser screenshots use explicit controlled fixtures, not naturally earned scores.
- Environment/NPC/guardian art remains simplified. Animated Quaternius Bunny is a placeholder, not a finished match to the user's rabbit reference.
- Browser audio listening and actual-device performance review are still open. Headless/browser checks are not human fun acceptance.
- Source binaries are recovered through the checksum manifest/bootstrap, with an explicit network dependency on the preserved staging source-assets URLs. The source tree is not a self-contained binary asset archive.

The hosted legacy game has not been replaced. Do not call this WIP a completed rewrite. Story canon remains STORYLINE.md. Requirements remain GAME-REQUIREMENTS.md and TECHNICAL-REQUIREMENTS.md. Asset credits remain in assets/ASSET-LICENSES.txt; no paid assets.
