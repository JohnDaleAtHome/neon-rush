# Required FIRE access with movement buttons hidden
November 9, 2026. Source-only fix, not deployed.

## Reproduced gap
At d54abe59, the On-screen buttons setting hides the whole HBox, including FIRE. Touch taps map only to jump; swipes map to lane/jump/slide. Guardian firing has only the hidden button or keyboard F. A gesture-only touch player has no visible touch firing path in Story Palace or Mission's final phase. Two actual390px browser fixtures reproduced hidden FIRE, working movement gestures and zero shots/unchanged3or4HP. Controlled entry and guard protection isolate the input gap; these are not natural campaign runs or phone-hardware results.

## Fix
Keep movement gestures and keyboard mappings unchanged. Centralize pad visibility: when movement buttons are off, show only FIRE during either Guardian phase. Keep the row hidden in other phases, on pause, after death and in menus. Resume/options/phase transitions share the same rules. A single FIRE control uses a96-unit-wide pad at the existing bottom position and honors left/center/right and Large controls settings. Standard buttons-on layouts remain unchanged. The saved `buttons` key and schema remain unchanged; Settings now calls it Movement buttons and explains the Guardian FIRE exception. No new gesture, difficulty, reward, score or checkpoint rule.

## Validation
- All59 isolated native suites passed locally, including new targeted visibility/bounds/input/options coverage. Existing campaign, Pearl/Key and Guardian mechanics tests remain unchanged.
- Native focused suite covers Story and Mission, movement-off/fire-only and buttons-on layouts, all handed positions at320x700/390x844/844x390/1280x720, pause/resume, non-Guardian modes and menu cleanup.
- Production-release browser fixtures at390x844Story/Mission,844x390right-handed Large and1280x720: actual touchscreen FIRE reduces GuardianHP, pause hides the control and resume restores it. Actual gameplay and390pxSettings pixels inspected; no page errors. Fixture setup/telemetry are separate from production scripts.
- The initial native bounds assertion incorrectly compared virtual Godot coordinates to physical window width; the first landscape browser tap likewise omitted canvas-coordinate conversion. Corrected checks pass without a runtime change for those issues.

## Limits
This closes a specific control-availability defect. It is not proof of natural checkpoint acquisition, final difficulty/fun/audio acceptance or real-phone performance. Public game remains unchanged. Existing native shutdown texture warnings remain. No new deployment approval.
