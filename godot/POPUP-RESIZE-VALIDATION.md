# Popup resize reachability - November 10, 2026

Tested runtime: `2e19dbfeebd11e63d32d7ad3ab48a6ac11ba596c`. Not deployed.

## Ordinary release defect

Open Settings or Stats at 390x844, then resize to 844x390. The popup kept its portrait height and position. At maximum scroll, the lower controls and Settings DONE footer remained below the canvas. Escape still worked, but the lower controls could not be reached by pointer. Actual clipped pixels were inspected before editing.

## Bounded repair

The common popup helper now recalculates panel width, height, centered position and scroll minimum size when the viewport changes. It disconnects that callback when the panel exits. Credits now uses that shared layout callback rather than its previous separate one. Popup content, option values/defaults, focus/pointer ownership, gameplay, saves and asset content are unchanged.

## Verification

- Private candidate: all 63 isolated native suites pass.
- Untouched runtime archive: documented asset recovery, clean import, all 63 isolated native suites and release Web export pass.
- Existing popup suite extended with reversible 844x390, 320x568, 1280x720 and 390x844 bounds for menu and paused-run Settings/Stats, stable callback count and cleanup after closing. Existing credits bounds/lifecycle tests still pass.
- Ordinary fresh release: portrait-to-landscape Settings DONE and lower controls are visible at maximum scroll; clicking DONE closes Settings. Stats export/history controls are visible inside the canvas at maximum scroll. Actual pixels inspected.
- Ordinary fresh nested credits: inspected at 320x568, 844x390, 1280x720 and returned390x844. Escape restores Settings focus; Enter reopens credits. Subsequent ordinary Story start/jump/pause inputs work. No fixtures or seeded progress used; no browser page errors and `window.neonQA` undefined.
- Production PCK: 200 paths, 7,688,540 bytes; no QA/test/fixture/oracle paths. Complete Han notice retains SHA-256 `0a67a874293828d744bf25bd958cb8da918d3cadc083e84a93a700c434a7a78d`.

This is source verification only. Physical-device FPS, listening, human fun and full natural campaign completion remain open. Public hosted game unchanged.
