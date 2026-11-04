# Temporary crossing rails, November 5, 2026

The five existing five-second story crossings now use original pale-cyan side rails instead of the floating, rising green bar. This is scenery only, not a new level or a physical bridge. The center stays open. Existing route, collisions, transition timing, Meadow jump, Dunes footprints, story rewards and saves remain unchanged.

## Reference study

Inspected the actual Sky: Children of the Light player screenshot at https://i.redd.it/ie2c2586zzr31.jpg, linked from https://www.reddit.com/r/SkyChildrenOfLight/comments/dgn621/i_made_it_to_the_rainbow_bridge_d/ . The useful composition is a quiet center framed by light at the outer edges. This implementation is original procedural geometry, not a copied model, texture or screenshot. It does not reproduce Sky's rainbow surface.

## Implementation

One temporary Node3D owns one batched mesh with two slim horizontal bands and 18 posts on each side. All vertices are beyond x=+/-3.65, outside the playable lanes. It has no collisions and stays at ground height. Existing gate cleanup removes it at the level change, menu return and other existing cleanup paths. Nothing is added during ordinary running.

## Local verification

- 41 isolated headless suites pass, including a new all-five-crossing geometry, five-second timing, piece reward and menu/level cleanup test.
- Actual native pixels inspected for all five crossings at 390x844, plus Storm Sea 360x640 and 844x500.
- Actual Web export pixels inspected for all five crossings at 390x844; Sea also 360x640, 844x500, 1280x800 and Light/reduced-motion 390x844.
- Web crossing captures use a local-only deterministic fixture appended to a separate project copy. The fixture is not part of committed runtime source. It pauses at 46% crossing to compare the same moment. Ordinary production Web startup and full native campaign are separate checks.

This is local verification, not actual-device performance clearance. No deployment is included. Native GL texture cleanup warnings remain under investigation. Earlier checkpoint logs showed two; the matched baseline and candidate campaign command in this study each produced four. The count is not stable and this is not a clean-shutdown claim.
