# Tide Pearl and Eclipse Key payoff

## Selected contract
The Sea reward crossing is a short playable, fallible section. It keeps its five seconds and7m/s speed, with the existing wave at z=-18 in the left lane and arch at z=-28 in the right lane. The center is always clear. Existing movement, jump, slide, collision, hearts and guard apply through the same ordinary update path. No random generation, pickups or jump-clear/near-miss bonuses run in this section.

Bridge remains3/5 until crossing completion. Completion appends Tide Pearl once and saves the existing next-level checkpoint. Death, reload or discard before completion retains the prior Sea checkpoint and three pieces. Retry restarts Sea, not the exit. No save schema or migration changes.

The Eclipse Key starts Story Guardian at3HP and displays3/3. Mission stays4HP/4max. Closed/open phases remain2.4seconds each, with at most two hits in an open window. Both fights still require two windows. Retry derives the health maximum from mode and level, so the effect cannot stack or be consumed. Entry explains the broken light; combat feedback replaces that entry message to prevent overlap.

Other crossings retain their existing safe input-disabled paths. Core six-world order, piece names, kindness interactions, ordinary spawning, save formats, modes, scenery and reunion remain.

## Controlled validation
-58 isolated local suites passed, including all57 preceding suites with intentional old-contract updates.
- New test_pearl_key covers two authored hazards, no random additions or early reward, pause/input/resize freeze, Full/Light and explicit motion preferences, clear-lane completion, once-only record, prior checkpoint reload, fatal wave/retry, jumping without bonuses, sliding and arch damage, guard/movement, discard cleanup, Story3/retry maximum and Mission4/two-hit windows/completion.
- Existing Guardian regression now expects Story3 to1 after the first two hits, then reunion in the second window. Scaffold now expects3. HUD test uses a valid3/3 state. Encounter layout expects the two authored Sea hazards instead of an empty array. Crossing visual regression now advances through the ordinary frame update, including Sea contacts.
- Controlled campaign:8892 fixed steps, zero deaths, all six worlds and reunion. This supersedes the earlier8911-step fixture count; it is not natural or human balance acceptance.
- Actual native390x844 and844x390 Sea approaches/damage, fatal retry, Story3 entry, first window and reunion inspected. First visual pass found crossing progress leaking onto the retry menu and stale entry HUD in the fixture. The phase reset and immediate start HUD refresh were fixed and inspected again. Retry/restart also removes its temporary rails.
- Local ordinary production Web startup has no page errors and no debug interface. Seeded checkpoint startup verified the existing three-piece Sea payload; this is a fixture, not earned progression. Timed keyboard play did not reach the exit and is not proof of browser exit acceptance.

No public deployment, physical-device, audio listening, human difficulty/fun, or ordinary-browser full-campaign clearance is implied. Fresh remote recovery and release-fixture results are recorded separately when complete.

## Remote recovery and release checks
Untouched7eeb434 archive plus only documented fetch-assets.py restore: all58 isolated suites pass; clean import and release export. This archive includes all eight changed paths byte-identical to the tested local project. Clean production PCK has195 actual indexed paths and7635344bytes; no test, QA or fixture paths. Ordinary fresh release390px gameplay screenshot inspected, no page errors, debug interface undefined.

A separate, explicitly labeled release fixture enters the actual Sea exit, pauses, resizes390x844 to844x390, resumes via keyboard and shows moving wave/arch cues with Bridge3/5 still pending. Actual active/paused pixels inspected, no page errors, debug interface undefined. The fixture's setup file is not in the clean production PCK. This is browser phase compatibility evidence, not a naturally earned checkpoint or a phone performance test.

Native captures also show correct3/3 Story entry,1/3 after two first-window hits, and reunion after the second window. A focused Mission test separately verifies4HP, two hits per window and completion in the second window. The inherited native renderer emits two texture-leak warnings on shutdown; no new in-play script error was observed.
