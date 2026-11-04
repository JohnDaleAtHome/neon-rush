# Shadow Comet environment study - 5 November 2026

This is an incremental source checkpoint, not deployment, finished art acceptance or actual-device performance clearance.

## Changes
- Fourteen unequal nine-point fractured stone plates with tapered undersides form separated angular shoulders. Rim vertices are clamped beyond the lane boundary.
- Four distant tilted existing CC0 rock shards and eight detached chunks add scale layers without scenic collisions.
- Original dark-violet stone/path shader, faint uneven cracks and restrained depth fog. Pink decorative edges and old repeated props are hidden in this world only.
- Gameplay, lane geometry, hazards, pickups, story and save schemas unchanged. Light mode and other worlds restore their usual visuals.

## References studied
Official Solar Ash developer page and four actual screenshots: https://www.heartmachine.com/solar-ash . Interpreted separated silhouettes and value hierarchy, not copying media or assets.
Open-model alternative checked: https://quaternius.com/packs/ultimatespacekit.html . No models imported from that pack. Uses the already licensed CC0 nature rocks subset.

## Verification
37 headless suites pass including new Comet ownership, Light restoration, four-aspect state, finite geometry, no-collision and all scenic vertices beyond 3.65m from center checks.
Web export and actual gameplay pixels checked at390x844,1280x800,360x640,844x500; later phone21%/desktop12% progression retains readable hazard/orb/guide sight lines. Zero Web page errors. Source-exact remote verification is recorded separately after integration.
Software-renderer matched mobile ABBA30frame samples: baseline56.35/55.46ms; candidate49.91/49.59ms, about11%lower mean. Draw calls77to68; primitives40310to42773. These are not physical phone FPS. Existing native shutdown texture leak diagnostics remain.

## Limits
The scene is still sparse and the track a plain straight rectangle. This improves broken silhouettes over bare planes/repeated boulders but is not close reference fidelity. No public redeployment.

Short-landscape moon regression: shared265pxminimum had placed celestial bodies below the horizon on844x500. Comet-only short-landscape override places smaller moons at outer sky edges; actualWebpixels rechecked and projected-bottom/horizon/objective-side assertions added.
