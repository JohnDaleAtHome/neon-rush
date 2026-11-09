# Canonical moon names - November 10, 2026

## Scope
STORYLINE.md says to name the Silver Moon, Cinnamon Moon and Storm Moon in-game. The existing level titles remain Silver Dunes, Cinnamon Grove and Storm Sea. Their opening hints now name the moon before the existing control advice. Settings > HOW TO PLAY maps those level titles to their moons and places the Meadow on Earth.

This is a text-only change to `scripts/visuals/hud_theme.gd` and `scripts/visuals/how_to_play.gd`. No progression, save schema, difficulty, collision, HUD dimensions, music, art assets or licenses change. `test_moon_names.gd` checks the names in hints/help, each opening message, unchanged level titles and a four-size line-count bound.

## Validation
- The candidate passed all 68 isolated native suites and release Web export.
- A fresh archive of checkpoint `2d00c0c1522553b887dd1febc1306cad4a9d3394` completed documented asset recovery, clean import, all 68 isolated native suites and release Web export. The three changed source/test files match the candidate byte-for-byte.
- Actual controlled native pixels were inspected at 320x568, 390x844, 844x390 and 1280x800. All three opening hints were checked with Full and Light quality: 24 views. Text stays within the existing message area without covering the runner, near track or progress label.
- Scrollable Story help was inspected at all four sizes. Moon names and level associations are readable. Portrait views include the reachable lower DONE button; landscape Story text can scroll further to it.
- The fresh archive's ordinary 390x844 release loaded a copy of the genuinely earned Meadow-completion profile at the same local origin. Normal Begin showed Silver Dunes / Bridge1 and the Silver Moon hint. Normal Pause > Settings > HOW TO PLAY scrolling showed all three moon names and the lower DONE button. Two Escapes returned to the paused run. No page errors or debug QA hook were observed.

## Limits
The later-level opening views are controlled layout fixtures, not natural progression. The ordinary release check starts from a copy of an actually earned checkpoint, not a new Meadow playthrough. It does not complete Dunes or later worlds. No new full-campaign, physical-device, human-balance or performance acceptance is claimed. Nothing was deployed; the public game remains a separate older checkpoint.
