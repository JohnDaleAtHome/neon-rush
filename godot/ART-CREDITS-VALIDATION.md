# Release art credits - November 9, 2026

Source-only improvement. No deployment, device performance, listening or natural full-campaign clearance.

## Gap and change

The Han house source notice was tracked in this project, but it was absent from the ordinary release PCK and there was no in-game credits path. `export_presets.cfg` now includes the unchanged `HAN-HOUSE-LICENSE.txt`. Settings opens ART CREDITS with the author, attribution website, license URL, adaptation summary and complete original notice. The adapted house remains CC BY-SA 3.0; this does not relicense independent game code.

The same page acknowledges the other recorded reused CC0 art: Quaternius, Poly Haven, VVayToyek, Innerscene, Pixor and Mish7913, with source links. This is a release-readiness repair, not a legal verdict on an earlier public build. No new art, level mechanics, save formats, scoring or option defaults were added.

Credits uses a scroll panel with top and bottom close buttons. Its own layout responds to viewport changes; a transparent input blocker prevents clicks on Settings underneath. Closing removes the blocker and size-change callback. Existing general popup positioning is not rewritten.

## Checks

- All 62 isolated native suites passed on the private candidate, including `test_art_credits.gd`.
- Focused regression checks complete notice/contributors and export inclusion, Settings entry, resize bounds/reversibility at 390x844, 320x568, 844x390 and 1280x720, top/footer close, repeated-open connection cleanup, and unchanged menu/paused-run state.
- Actual ordinary-release browser pixels inspected at all four sizes, both top and scrolled bottom. Initial credits resize clipping was found and fixed before integration. Software browser screenshots establish layout, not actual-device performance.
- Fresh source archive recovery, complete suites, production export and ordinary-release checks are required again after source integration. Candidate evidence is not substituted for those results.

## Provenance

Existing project notices/provenance are the art inventory. Han primary references:

- https://github.com/0ad/0ad/blob/master/binaries/data/mods/public/art/LICENSE.txt
- https://creativecommons.org/licenses/by-sa/3.0/
- https://creativecommons.org/licenses/by-sa/3.0/legalcode

No deployment permission is implied by these checks.
