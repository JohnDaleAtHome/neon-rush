# Meadow Light village identity

The Light scene now shares the existing textured Han house and soil top from Full Meadow. It keeps the original flat side ground and omits the Full terrace skirt. Both copied parts move down 1.28 units so the house and soil meet the Light side ground at y=-0.13. Meshes and materials are shared; no new model, texture or collision is added. Existing house attribution remains in HAN-HOUSE-LICENSE.txt.

## Checks, November 6, 2026

- Actual native Light pixels inspected at 390x844,1280x800 and844x390. House stays left of the playable path, grounded, without hiding objective text.
- Full pixels match the preceding accepted scene at those three sizes.
- Six isolated suites pass: Meadow Light village, Meadow Light, Meadow contact, campaign, reference environment and preferences backup.
- New test checks geometry footprint, flat ground contact, no collision, four viewports (including320x568) and visibility ownership for all six worlds in both quality modes.
- Clean release Web runs inspected at390x844 and844x390. QA absent. No game/page errors; first request included only the usual missing favicon404.
- Clean PCK7,326,400 bytes versus7,326,192 preceding build (+208). Existing shared geometry is now drawn in Light; this is not a measured performance result.

No public deployment or actual-device/FPS clearance is included. Gameplay, story, saves and Full scenery are unchanged. This is a bounded identity addition, not completion of Meadow's broader scene design.
