# Neon Rush

A browser-based 3D runner. The current development version introduces MOCHI, a moon rabbit gathering treats across three moons.

## Run locally

Serve this folder with a static web server, for example:

```sh
python3 -m http.server 8000
```

Open http://localhost:8000 in a browser. No build step is required.

## Controls

Arrow keys or A/D change lanes. Space jumps. Down slides in Chase and Mission. F fires during the Mission guardian fight. P or Escape pauses. On phones, use the touch buttons or swipe controls.

Sound is off by default. Enable SOUND to hear the original synthesized music and action feedback.

## Development status

This is a development snapshot, not a claim that the same version is deployed. Mission gameplay and the moon-rabbit art are being playtested. Scores/settings are stored only in the current browser.

## Assets

Moon 01 diffuse and displacement textures: https://polyhaven.com/a/moon_01 (CC0, https://polyhaven.com/license). This repository snapshot loads Three.js and textures from their public CDNs; the deployed game uses local copies. Lunar textures are CC0 assets from Poly Haven. Three.js is MIT licensed; see https://github.com/mrdoob/three.js/blob/r160/LICENSE. The rabbit, mochi and synthesized audio are original game content.
