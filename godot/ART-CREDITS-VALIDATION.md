# Release art credits - November 9, 2026

Source-only improvement. No deployment, device performance, listening or natural full-campaign clearance.

## Gap and change

The Han house source notice was tracked in this project, but it was absent from the ordinary release PCK and there was no in-game credits path. `export_presets.cfg` now includes the unchanged `HAN-HOUSE-LICENSE.txt`. Settings opens ART CREDITS with the author, attribution website, license URL, adaptation summary and complete original notice. The adapted house remains CC BY-SA 3.0; this does not relicense independent game code.

The same page acknowledges the other recorded reused CC0 art: Quaternius, Poly Haven, VVayToyek, Innerscene, Pixor and Mish7913, with source links. This is a release-readiness repair, not a legal verdict on an earlier public build. No new art, level mechanics, save formats, scoring or option defaults were added.

Credits uses a scroll panel with top and bottom close buttons. Its own layout responds to viewport changes; a transparent input blocker prevents clicks on Settings underneath. Closing removes the blocker and size-change callback. Credits takes keyboard focus, temporarily removes background controls from keyboard focus traversal, then restores their original focus modes and the previous focused control on close. Existing general popup positioning is not rewritten.

## Checks

- All 62 isolated native suites passed on the private candidate, including `test_art_credits.gd`.
- Focused regression checks complete notice/contributors and export inclusion, Settings entry, resize bounds/reversibility at 390x844, 320x568, 844x390 and 1280x720, top/footer close, repeated-open connection cleanup, and unchanged menu/paused-run state.
- Actual ordinary-release browser pixels inspected at all four sizes, both top and scrolled bottom. Initial credits resize clipping was found and fixed before integration. Software browser screenshots establish layout, not actual-device performance.
- Untouched source archive `821cc8fa5472c49def1fd1e9a03912f49ea83b2e`: documented `fetch-assets.py` recovery, clean import, all 62 isolated suites and Web release export passed. All six changed source files were byte-exact against the candidate; the temporary duplicate editor path was removed by a tracked rename before runtime hookup.
- Fresh production PCK: 200 paths, 7,688,188 bytes, no QA/test/fixture/oracle paths. The included Han notice SHA-256 is `0a67a874293828d744bf25bd958cb8da918d3cadc083e84a93a700c434a7a78d`, identical to source.
- Fresh ordinary export, 390x844: Settings, credits top and bottom, footer close back to Settings, close Settings, Story start and jump inspected. No browser page errors; no QA API present. Additional ordinary candidate checks opened credits after resize at all four sizes and returned through the footer; no page errors.
- An additional ordinary Enter-key check then found duplicate credits panels because the underlying Settings button retained keyboard focus. The follow-up focus repair passed all62 candidate suites, a new ui_accept regression and actual ordinary Enter/Tab/close browser pixels. The current module suspends/restores background focus and focuses the top close button. Fresh source follow-through must include this repair; the earlier821cc8f archive proof alone is not keyboard clearance.
- Final documentation-only follow-through does not alter runtime. Source-complete does not mean deployed or natural full-campaign complete.

## Provenance

Existing project notices/provenance are the art inventory. Han primary references:

- https://github.com/0ad/0ad/blob/master/binaries/data/mods/public/art/LICENSE.txt
- https://creativecommons.org/licenses/by-sa/3.0/
- https://creativecommons.org/licenses/by-sa/3.0/legalcode

No deployment permission is implied by these checks.
