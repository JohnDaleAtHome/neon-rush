# Grove Light garden identity, November 6 2026

Light previously dropped all garden architecture and trees. It now reuses the accepted pavilion, paving and terrain-following foundation, both existing terrain banks and every second distant tree card. Meshes and materials are shared. No bushes, rocks, walls, near live foliage or understory are drawn in Light. No new external asset, license or recovery step. Full geometry and normal-quality moon placement are unchanged. Only compact-landscape Light raises its small moon above the horizon.

The first flat-ground copy visibly floated. It was replaced by the accepted banks and exact grounded prop transforms, rather than guessed flat-ground offsets. Native actual frames at 390x844,1280x800,844x390 were inspected. Full is pixel-identical at all three sizes to the preceding Palace Light runtime. Light keeps a clear playable corridor and a visible pavilion; distant bank silhouette edges remain simple.

Five final isolated suites pass: new Grove Light, existing Grove geometry/foundation, campaign (8911 deterministic frames), reference environment and preferences backup. The first new test incorrectly equated a tree card's AABB center position with the tree's terrain sampling origin; it failed and was corrected to check the exact accepted source transform. Tests cover off-lane cards, no scenery collision, bank/pavilion presence, quality/world ownership and four resize cases. This is not a fresh all-suite pass.

Clean release Web was inspected at 390x844 and844x390 after ordinary start from a deliberately seeded Grove checkpoint with persisted Light. No QA hook, page exception or game error; first page had a local favicon404 only. This is not a natural browser campaign or actual-device validation. Native quit texture warnings remain from the prior runtime.

PCK is 7,326,064 bytes vs7,325,568, +496 bytes. Light draws more scenery than its empty prior state; there is no frame-rate or device-performance claim. No public deployment.
