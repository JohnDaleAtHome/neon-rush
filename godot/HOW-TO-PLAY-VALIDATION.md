# How to Play guidance, November 10, 2026

Runtime checkpoint: de01a5063bab5afe9ff46cdfb98b6595718aed64. Source-only, not a deployment.

## Why
The ordinary release had movement buttons and short level hints, but no in-game reference for keyboard alternatives, swipe directions, pause/sound shortcuts or the limits of local stats exports. In particular, hiding movement buttons did not teach gestures.

## Change
Settings now has HOW TO PLAY below ART CREDITS. The scrollable read-only panel uses the existing shared popup for focus, pointer isolation, resize and close behavior. Four sections explain keyboard controls, touch controls, Story/checkpoints/data and track/Guardian cues. Mappings, mode-limited slide and Guardian-only fire were checked against the current input handlers. It does not add an overlay to running gameplay or change difficulty, timings, rewards, save schema or art.

Only main.gd, scripts/visuals/how_to_play.gd and test_how_to_play.gd changed in the runtime milestone. The new native suite checks content, Settings access, nested focus, close/reopen, resize bounds/callback cleanup and unchanged state in menu and paused Story. An initial test assumed focus had been on the Settings opener without setting it; the test setup was corrected before final verification. A repository editor path quirk was corrected by rename before the verified runtime, with no duplicate module left.

## Proof
- Candidate and untouched runtime archive: all64 isolated native suites passed.
- Untouched archive: documented fetch-assets recovery, clean import and release Web export passed.
- Production PCK:202 paths,7,691,088 bytes; help script present, no QA/test/fixture/oracle paths. Full Han notice SHA256 remains0a67a874293828d744bf25bd958cb8da918d3cadc083e84a93a700c434a7a78d.
- Ordinary candidate release: Settings access, top and bottom actual pixels at390x844,320x568,844x390,1280x720; bottom action inside the canvas. Escape returned to Settings, Enter reopened Help, then closing both returned to the ordinary menu.
- Fresh untouched export: ordinary390x844 Help top/bottom actual pixels inspected. Browser page errors absent; debug helper absent.

## Separate ordinary checks preceding this change
A safe copy of the existing naturally earned Story profile produced actual JSON and CSV downloads through visible Stats buttons. All8history records matched field-for-field, including level/outcome/completion text. Totals matched8attempts/2247m/38treats/185s; independent Story records matched1007pts/372m/8treats/31s. Five/eight-run displayed averages matched rounding. No claim is made about older-user migration or missing history.

A fresh ordinary390x844 mobile/touch context started Meadow and used up/down swipes. Initial one-shot screenshots missed the animations; browser screencast pixels then showed airborne rise/fall, lowered duck posture and upright recovery. No app-state injection or fixture. This is initial-Meadow emulation evidence, not real-device timing or gesture clearance.

## Limits
No deployment approval, physical-device/FPS, listening, human-fun or full-natural-campaign clearance. Chinese-theme and story art remains WIP. The controlled campaign and native suites remain separate from natural play. No new art study is implied by this guidance change.
