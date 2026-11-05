# Han street source checkpoint, November 5, 2026

Source-only. No public deployment or actual-device performance clearance.

Replaces three detached palace pavilions with 28 complete authored Han houses,
using two shared MultiMesh batches. The tiled street edge is grounded and
continuous in actual 390x844, 1280x800 and 844x390 native/Web pixels. Every
transformed house vertex stays beyond 4.25m from the center; nearest is 5.197m.
Five-light distant gate, Guardian, all lanes, HUD and controls remain clear.
No gameplay, story, save, collision or shared main-script changes.

Asset source, attribution, changes and CC BY-SA 3.0 terms are in
HAN-HOUSE-LICENSE.txt. Runtime GLB is 1,114,716 bytes (check recovery for exact
SHA/length); full 1,000 source triangles, one 1024x512 RGB base texture. Run
fetch-assets.py for standard recovery, or restore-han-house.py for this asset.

41 local regression suites pass. Palace also passes rendered transform checks:
headless dummy rendering does not retain MultiMesh transforms, so its source
transform is checked headlessly and stored transforms are cross-checked rendered.
Rendered full campaign: 8,911 steps, zero deaths, six worlds, five pieces, reunion.
Fresh private release Web phone/desktop/landscape and Light phone inspected,
zero page errors and no debug bridge. Light retains the existing bare courtyard.

Quiet software-rendered 1280x800 ABBA: baseline 76.9085/78.3332ms,
candidate 83.2344/84.5202ms, about 8.1% higher mean cost. Calls 270 -> 262,
primitives 99,660 -> 88,988. This is a measured visual/cost tradeoff, not a
performance win or actual-device FPS. Full double-sided 2048 atlas trial was
19.7% slower; backface culling/shadow removal and shared instances were retained.
No further optimization variants are claimed. Shutdown texture warnings remain
2 in campaign / 4 in transition-heavy test, matching prior unstable behavior.

Reference: actual official Han game screenshot inspected from
https://play0ad.com/new-release-0-a-d-alpha-26-zhuangzi/ . No reference pixels
shipped. Remaining limits: repeated simple houses, straight road, plain gate,
bare Light view; this is not finished Chinese-theme acceptance.
