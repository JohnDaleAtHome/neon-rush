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
Six-level finite story, five ordered bridge pieces, kindness interactions, five short unlock crossings, guardian/reunion, validated checkpoint saves. Chill/Classic/Rush/Chase/Mission modes, keyboard/touch lane/jump/slide/fire, pause/menu, shields/chains/magnet, local stats/history/JSON+CSV exports, settings, WAV music/cues. Same-origin legacy best-score import keeps Classic separate from Chill/Rush. Animated Quaternius Bunny remains a placeholder; the newly supplied character reference is visual direction, not a claimed finished model.

Headless game-action campaign reaches reunion; six modes start/pause/resume/menu through normal mobile browser UI; source parser and web export pass. These checks are not human fun acceptance.

## Remaining before replacing the hosted game
Real-time browser full campaign, desktop and smaller mobile layout review, settings/export persistence coverage, browser audio listening, complete feature-parity audit, visual polish and independent review. Environments and NPCs remain simplified. Some older UI convenience settings may still be missing. Do not claim this WIP is a completed rewrite.

Story canon remains the repository's STORYLINE.md. Requirements remain GAME-REQUIREMENTS.md and TECHNICAL-REQUIREMENTS.md. Assets are bundled with credits in assets/ASSET-LICENSES.txt; no paid assets.
