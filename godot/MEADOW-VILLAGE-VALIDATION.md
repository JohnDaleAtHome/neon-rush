# Meadow village edge, November 5, 2026

Source iteration only. Not a public deployment, full Chinese-theme acceptance, or actual-device performance clearance.

## Scope and provenance

An existing Wildfire Games Han dwelling now anchors a cleared left-bank yard. Eight named deterministic decorative placements are replaced; the distant moon-dew tree and right bank remain. The house uses its existing authored textures, uniform scale .48 and a quarter-turn frontage. The yard has a terrain-following retaining skirt using the existing CC0 Quaternius rock texture. Gameplay, story, saves, hazards, controls and central lane guides are unchanged. Other worlds and Light mode hide the whole group through Meadow's existing horizon ownership.

The Han model remains CC BY-SA 3.0. See HAN-HOUSE-LICENSE.txt and restore-han-house.py for provenance, derivative details and source recovery. No new external model or texture was downloaded for this iteration. The yard/skirt geometry is original.

## Checks

- Inspected actual native 390x844, 1280x800 and 844x390 frames, then actual local browser normal frames in those sizes plus phone Light mode. The dwelling is readable on phone and a small background cue in compact landscape. Light mode remains the unchanged sparse fallback.
- All 3,000 house vertices have minimum absolute x=7.93257m, outside the 4.25m protected corridor. Yard/skirt minimum absolute x=6.5m. No collision bodies.
- Yard top y=1.15m. A 23x25 terrain sample grid reaches y=.960m beneath it; retaining skirt follows the boundary with .12m burial. This corrects the earlier floating slab blockout.
- Meadow collection and bridge-crossing views inspected in all three aspects. Targeted autoplay reaches the next world in 885 steps with zero deaths and awards Moon Dew Vial. Story copy, button, bridge rails and runner remain visible. During jumps the runner can overlap the distant dwelling in screen space, with correct foreground depth.
- Visibility checks cover the other five worlds, Light mode, return to Meadow and no duplicate group.
- 41 regression suites pass, including the revised reference-environment test: 49 retained CC0 placements plus house/yard/skirt, explicit vertex clearance and no collision. Full campaign reaches reunion in 8,911 steps, zero deaths, six worlds.
- Local browser export: no page errors in four checked views. Native exit still emits known texture-leak diagnostics; not claimed error-free.

## Cost and limits

Matched software-renderer phone runs, baseline/candidate/baseline/candidate: 69.7832/69.1595/69.1154/67.6892ms. Mean baseline 69.45ms vs candidate 68.42ms, a 1.48% difference within noise, not a speedup claim. Draw calls 208 to 203; primitives 134,765 to 129,682. Replacing eight decorations offsets the dwelling/yard cost. Web payload increased 4,076 bytes with no new textures.

These are software-renderer results, not phone hardware results. No deployment was performed. The dwelling is one stronger architectural cue, not a claim that Meadow or the full game's Chinese art direction is complete.
