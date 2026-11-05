# Neon Rush: Mochi and the Moon Bridge

A browser-first 3D runner built with Godot 4. Mochi, Chang'e's moon rabbit, gathers five bridge pieces across a six-level Story journey. Chill, Classic, Rush, Chase and Mission modes are also in the project.

This repository is an active development source checkpoint, not a claim that the same version is hosted or that the rewrite/art is finished. Source commits do not publish the game.

## Open the current project

Requirements: Python 3 and Godot 4.7.2 with matching Web export templates for browser builds.

From the repository root:

```sh
python3 godot/fetch-assets.py
godot --headless --path godot --editor --import
godot --path godot
```

Replace `godot` with your executable path if needed. Or open `godot/project.godot` in the editor after asset recovery.

Recovery verifies assets before writing them. Baseline files still need the staging URLs recorded in the manifest: this is not a fully offline, self-contained asset archive. See [Asset recovery](godot/ASSET-RECOVERY.md). Do not continue after a failed or partial restore.

## Test and build for the browser

On Linux, run suites with temporary user data so tests neither inherit nor overwrite your ordinary preferences and saves:

```sh
python3 godot/tools/run_tests.py --godot /path/to/godot --logs /tmp/neon-tests-1
```

The logs directory must be new. See [Native tests](godot/NATIVE-TESTS.md) for selections, timeout handling and platform limits.

To export and serve a release build from the repository root:

```sh
mkdir -p build
godot --headless --path godot --export-release Web "$PWD/build/index.html"
python3 -m http.server 8000 --directory build
```

Open http://localhost:8000. Serving the repository root does not build or run this Godot project. The Web preset is single-threaded WebAssembly/WebGL 2. Debug exports expose test state; release exports do not.

## Controls and local data

Arrow keys or A/D change lanes. Space jumps. Down slides. F fires in the guardian fight. P or Escape pauses. Phones have on-screen buttons and swipe controls. Sound is off by default.

Scores, settings and Story checkpoints are local to the current browser/origin. Native runs use Godot user data. A different hosted origin cannot read the previous site's data. Classic, Chill and Rush records stay separate.

## Current scope and evidence

- Story order and dialogue: [STORYLINE.md](STORYLINE.md).
- User requirements: [GAME-REQUIREMENTS.md](GAME-REQUIREMENTS.md) and [TECHNICAL-REQUIREMENTS.md](TECHNICAL-REQUIREMENTS.md).
- Build/acceptance caveats: [Godot port status](godot/PORT-STATUS.md).
- Recent environment/UI work: the `godot/*VALIDATION.md` notes distinguish native tests, rendered scenes and browser fixtures from natural play and device tests.
- The ending has an original generated static illustration of Chang'e, Mochi and Wu Gang sharing mooncake/tea beneath a flowering branch: [reunion validation](godot/REUNION-CARD-VALIDATION.md). These are ending-only2D depictions, not live NPCs or final-art approval. Grove still lacks a Wu Gang actor.

Native scripted campaign checks and browser fixtures do not establish natural full-campaign acceptance, physical-device speed, audio quality or finished art. Several story mechanics remain simplified; see port status rather than treating the story specification as fully implemented.

## Asset credits

The game uses original work and credited open assets. Check `godot/assets/ASSET-LICENSES.txt` after recovery, sourcepack notices and the relevant validation documents. These are not all under one license. In particular, the Han house is CC BY-SA 3.0; see [its license notice](godot/HAN-HOUSE-LICENSE.txt). Do not treat the entire repository as CC0 or redistribute credited source art without its terms.
