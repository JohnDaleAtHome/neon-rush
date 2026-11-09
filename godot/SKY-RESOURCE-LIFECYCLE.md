# Scene-owned sky lifecycle

Verified runtime: `7fdbaf6b380b4fd0596cfad5fd6b7124ed3e07ff`, November 10, 2026. Source only, not deployed.

## Change

Base theme setup and Meadow atmosphere now reuse the Environment's Sky, creating one only when absent. Materials, shaders, camera parameters and theme-specific setup still update normally. This extends the earlier Sea reuse pattern without changing art assets, gameplay, timing, rewards, controls or save schema. `test_sky_resource_lifecycle.gd` checks identity across six themes and full/Light/full cycles.

## Matched rendered evidence

Linux Godot 4.7.2 Compatibility, Mesa llvmpipe software rendering, isolated user data. This is not physical-device or browser memory evidence.

| Check | Prior runtime de01a50 | Current runtime |
| --- | --- | --- |
| Ordinary native menu, 100 rendered frames then quit | Two 349,524-byte texture warnings | None |
| Five scene instances, each rendered then freed with 20 settling frames | Retained texture memory: 4,201,710 bytes initially, then +699,048 per cycle; ten final warnings | 3,502,662 bytes after every cycle; no warnings |
| Controlled campaign, 20 rendered settling frames before cleanup | Two matching warnings | None |
| Original synchronous campaign with immediate cleanup | Four matching warnings | Two matching warnings |

The campaign still reaches all six worlds and reunion in 8,892 fixed steps with zero deaths. That is controlled automation, not natural play. The immediate-cleanup warnings remain unresolved; this change does not claim every native shutdown is clean.

A minimal external reproduction distinguishes resource replacement from merely using a sky: one custom Sky, fog and a lit mesh did not warn; replacing Sky three times before the first rendered frame produced two matching warnings. Reusing that Sky while replacing its material did not. This narrows the trigger but is not an upstream engine diagnosis.

## Independent source and release checks

An untouched runtime archive completed documented asset recovery, clean import, all 65 isolated native suites and release Web export. The PCK has 202 production paths and 7,691,088 bytes, with no QA/test/fixture/oracle paths. The complete Han notice remains byte-identical, SHA256 `0a67a874293828d744bf25bd958cb8da918d3cadc083e84a93a700c434a7a78d`.

Actual candidate ordinary release menu and Begin-click gameplay pixels were inspected at 390x844, 320x568, 844x390 and 1280x720. A separate controlled full/Light six-theme image set was inspected for sky and scene continuity. Fresh release 390x844 menu/Begin pixels were also inspected, with no page errors and no debug QA hook. These checks do not establish all-level natural gameplay, listening quality, human fun, FPS or physical-device performance. Public hosted content is unchanged.
