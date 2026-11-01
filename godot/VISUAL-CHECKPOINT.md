# Visual integration checkpoint - 1 November 2026

New scoped implementation after the original sprint ended. Requirements and
plan are at repository root. This is a review candidate, not final-art approval
or a complete Godot rewrite. No paid assets or official-host replacement.

## Implemented

- WIP Mochi model with jacket, boots, cyan details and crescent accessory;
  preserves the original rig and14animations and customization material names.
- Meadow visual module, quieter road, varied plants/stones, far-ground underlay,
  treeline, fog/sky, fireflies and contact shadow. Level0 only.
- Cohesive navy/cyan/moon HUD, shortened hints, moon toggles, readable control
  buttons and opaque Settings/Stats popups. Existing layout/control meanings stay.
- Integrated lighting/material pass keeps face form visible. Shared lit terrain
  on the underlay removes the earlier strong diagonal colour wedge.
- Light-quality changes remove/restore module props, horizon and shadow rather
  than leaving stale scenery. Other worlds retain base direct lighting.

## Evidence and remaining gates

Final release-specific evidence is recorded in the accompanying build
provenance/test report, not inferred from module-only previews. Actual desktop
and mobile-size browser pixels were inspected; emulation is not a real phone.
All27headless suites passed in Godot4.7.2 (26existing+new visual integration).
The deterministic synthetic campaign visits all six levels/reunion in8911steps
with0deaths; this does
not complete natural late-campaign acceptance.

Round pupil geometry replaces the old slits, but cyan C/bar shapes within pupils,
gray outer artifacts, black inner ears and a cyan mouth spot remain visible in
closeup. Character eyes/expression, fluffy silhouette and pendant are short of the
tracked concept. Treeline is flat/graphic, horizon tonal banding remains and
this is not polished landscape art. Other levels/NPCs/guardian/reunion did not
receive a matching final-art pass. Natural L5 completion/L6/reunion, physical
device performance, browser audio listening and human fun/art acceptance remain
open. All previous canon/mechanic simplifications in PORT-STATUS.md still apply.
