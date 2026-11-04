# Meadow valley source checkpoint, November 4, 2026

Source only. The public v84 checkpoint is not changed. This is an incremental art improvement, not final art or actual-device performance clearance.

## Incorporated assets and composition

Quaternius Stylized Nature Megakit Standard subset, CC0, from https://quaternius.com/packs/stylizednaturemegakit.html . The included LICENSE.txt preserves the source license. Original glTF/bin meshes are retained; shared textures are resized to 512px. No paid assets were used. Sky and Omno are visual references only; their copyrighted art is not shipped.

52 nature placements: 20 ordinary trees, 12 bushes, 14 medium rocks, 3 shoulder rocks, a distant focal tree, and 2 far outcrops. Far ordinary trees use transparent orthographic renders made from the included models, preserving positions and density. Near trees and the focal tree remain 3D. tools_build/bake_tree_impostors.gd generates the two renders using the Godot project. Run with the Godot project as --path.

Raised asymmetric side terraces, faceted distant hills, pale tree on a distant knoll, shared moonlit materials, slope shading, moss path shoulders, and soft horizon glow provide depth without adding collision or objectives. The focal tree is scenery on Earth, not the Grove story tree. Imported terrain and foliage stay outside abs(x)=4 in the playable region. Only distant scenery beyond z=-145 may cross the center.

Light mode and other worlds restore their existing scenery and track-edge visibility. Gameplay, scores, saves, story and rewards are unchanged. main.gd only retains the two existing track-edge node references for theme visibility.

## Checks

- 32 headless test scripts pass, zero script errors.
- Synthetic campaign: 8,911 steps, zero deaths, all six levels to reunion.
- Focused checks cover imported and impostor source bounds, no collision objects, shared materials, both material paths, and theme/Light cleanup.
- Exact exported Web inspected at 390x844 and 1280x800; later phone gameplay inspected with a bale and dew visible. Zero page errors in all three browser sessions.
- Native software-renderer ABBA, same scene and phone layout: all-mesh valley 211.60/213.76ms versus distant-impostor valley179.49/180.56ms, about15% faster.
- Fresh baseline comparison: baseline177.37/169.79ms versus candidate181.20/172.23ms, about1.8% slower average. Calls449->197; primitives161754->131354. These are controlled software-renderer results, not actual phone FPS.

## Remaining work

Broad side slopes and the straight corridor still limit the art. Real-device performance is unverified. Native renderer shutdown texture warnings are not cleared by these tests. Do not infer deployment approval from this checkpoint.
