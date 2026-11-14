# Original opening menu illustration

November 14, 2026. Source checkpoint, not public deployment or a completed rewrite.

## What changed
The main menu now shows an original static illustration of Mochi holding the bell, the shattered Moon Bridge, and Chang'e waiting at Guanghan Palace. It uses the game's original reunion illustration as its sole character/style reference. No third-party reference artwork was copied. The image is storytelling art, not a live 3D scene or a replacement for unfinished Story hazards.

The complete image is kept uncropped. Portrait places it between the existing words and controls; landscape separates image and controls into two columns. Existing menu words, buttons, actions, control targets and mode choices remain. There is no extra mandatory story screen. Pause, retry, kindness encounters, crossings and reunion retain their existing presentation. The illustration ignores mouse input and is hidden before play.

## Recovery and size
The menu module embeds a 720x480 WebP (59,582 bytes) as base64. No runtime network or new asset bootstrap dependency is introduced. This is one static texture with 345,600 pixels, not a performance benchmark. Its source module is about 81kB; no full-size generation image enters the release.

## Validation
- The candidate passes all 74 isolated native suites, including the new six-mode opening lifecycle/layout test. The existing controlled campaign still reaches reunion in 8,892 fixed steps with zero deaths. This is synthetic evidence, not natural play or human fun acceptance.
- Clean Web release export passes. Direct pack inspection verifies every entry MD5 and excludes tests, QA, fixtures and the baseline sourcepack payload. Two pre-existing small Meadow/visual manifest JSON files remain in the pack; this change does not add a general sourcepack filter.
- Actual native and Web menus inspected at 390x844, 320x568, 844x390 and 1280x800. The final compressed texture is readable at these sizes. The Settings popup remains above the illustration.
- An exact disposable copy of the genuinely earned Shadow/Bridge4 profile retains all three backup strings at Web startup. No progress was newly earned by this check; original saves were untouched. Release QA helper is absent and page errors are empty.
- An early layout regression found overlap with the taller return-menu paragraph, and a 1.3px compact landscape control-box overlap. The picture now sizes below the actual portrait words and leaves a separate landscape column. These were fixed before source integration; failed checks were not weakened.

## Limits
No public deployment, physical-device/performance, audio listening, new natural late-campaign or human-fun clearance. Remaining Story mechanics and scene/art limitations in PORT-STATUS.md stay open. The separate private reviewer kit still refers to the earlier accepted build, not automatically to this source checkpoint.

Embedded WebP SHA256: `af74977b32d1c9f078551be11323458c2b674edc79557e8717d57c4e8157d835`.

Untouched committed source `2cd5c8f` also completed full offline asset recovery with sockets denied and zero network attempts, clean import, all 74 suites and Web export. Its pack has 214 resources and 7,803,449 resource bytes; each MD5 verifies. Reimported scene/cache bytes are not claimed byte-identical to the earlier private candidate.
