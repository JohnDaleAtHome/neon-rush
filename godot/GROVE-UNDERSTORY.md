# Grove understory checkpoint, November 5, 2026

Original clustered grass, dimensional fern leaves and ground leaf litter in one batched decorative mesh.44clusters, denser near foreground; quieter simpler path shader. All transformed scenic vertices outside3.65m; no collision. Preserves story, saves, inputs, encounter geometry and Light/world restoration. Existing tree models unchanged.

Actual same-source six-world phone comparison identified Grove's bare brown foreground. Inspected nine official Sky gameplay trailer frames and three official Steam screenshots for clustered detail, quiet broad masses and layered depth. Reference only, no media reuse. https://store.steampowered.com/app/2325290/Sky_Children_of_the_Light/ . Journey artist/interview sources support restraint and art-directed color: https://mattnava.com/Journey-1 ; https://www.cgw.com/Publications/CGW/2012/Volume-35-Issue-4-June-July-2012/Mysterious-Journey.aspx ; https://www.gamedeveloper.com/art/journeys-art-director-just-broke-down-the-title-s-timeless-aesthetic-in-glorious-detail . Existing CC0 tree/rock models retained, no new binary dependencies.

Rejected tall broad grass because it read as spikes. Dense fern trial added19,800primitives and ~14.7%software mean cost; reduced first to8,424, then3,736added primitives, one draw call. Dropped costly dapple/leaf-hash shader. Final ABBA software native mobile baseline59.265/65.017ms vs62.056/68.182ms candidate (~4.8%higher mean),97to98calls/68,174to71,910primitives. Timing drift means directional only, not deviceFPS or device clearance.

39full final local suites pass. Grove regression updated61children and bounded batched mesh, no collision/finite/safety margin/Light/world/fouraspect/moons. FourWebaspects actualpixels inspected after final reduction, later hazard/pickup checks refreshed, no pageerrors. Two pre-existing native texture shutdown leaks remain. Final source integration/recovery verification tracked separately, not assumed from local tests.

Limits: still sparse/bare/straight track. Small incremental foreground improvement, not finished art. Source-only, no deployment or actual-device performance clearance.
