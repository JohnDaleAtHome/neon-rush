# Popup input ownership - November 10, 2026

Source checkpoint: `a0588ab1741ab777d974ff9dac016dc756e907bf`. Not deployed.

## Reproduced problem and bounded change

In the ordinary release, opening Settings left its background opener focused. Enter reopened Settings behind the first panel, so closing once left another panel visible. Stats used the same unguarded helper. Credits already had its own guard.

The common popup helper now suspends existing control focus, puts a transparent pointer blocker behind the new popup, focuses CLOSE, and restores the previous focus when the popup exits. A popup stack keeps gameplay shortcuts from acting behind a popup and makes Escape close only the top panel. Credits uses that shared guard rather than a duplicate implementation. Content, layout, options, gameplay, save format and default settings are unchanged.

## Native and archive checks

All 63 isolated native suites passed for the private candidate, then again from an untouched runtime-checkpoint archive after documented asset recovery and clean import. The new popup suite covers menu/paused Settings and Stats, repeated one-accept closure, background focus isolation, gameplay shortcut isolation, nested credits Escape, original focus restoration and unchanged game/options/stats state when merely opening/closing. The existing credits suite was adjusted for the shared blocker node.

Release Web export passed. The PCK has 200 production paths and is 7,688,988 bytes. No QA/test/fixture/oracle paths are included. HAN-HOUSE-LICENSE.txt retains SHA-256 `0a67a874293828d744bf25bd958cb8da918d3cadc083e84a93a700c434a7a78d`.

## Ordinary browser checks and inspected pixels

No fixtures, seeded progress or debug hook were used in these checks.

- Settings and Stats each close on one Enter at 390x844, 320x568, 844x390 and 1280x720. Actual top/closed pixels were inspected; existing popup layout was preserved.
- A naturally started Story run stays paused when P is pressed behind Settings. Nested credits Escape returns to Settings, and a second Escape returns to the still-paused run.
- At desktop size, clicking visible background Sound/Begin controls while Settings is open does not change sound or start a run. Closing returns to the ordinary menu.
- Changing High contrast HUD through its visible switch survives closing, browser reload and reopening Settings.
- Fresh archive export ordinary 390x844 checks confirmed Settings/Stats one-Enter closure, visible focus return, Story start and pause. No browser page errors; `window.neonQA` was undefined.

## Limits

This does not establish physical-device FPS, listening quality, human fun, full natural campaign completion or deployment approval. The earlier earned Sea/Bridge3 checkpoint remains the bounded natural-play result. No public game files were changed.
