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

## Asset recovery

Before Godot import, run `python3 godot/fetch-assets.py`. The12new visual assets
are tracked as exact encoded source bytes in `visual-sourcepack/`, not native
binary blobs. The stdlib decoder restores/verifies them offline; original28
baseline assets still need the existing checksum network recovery. A bare
checkout without recovery is not ready to import.

## Evidence and remaining gates

Final release-specific evidence is recorded in the accompanying build
provenance/test report, not inferred from module-only previews. Actual desktop
and mobile-size browser pixels were inspected; emulation is not a real phone.
All27headless suites passed in Godot4.7.2 (26existing+new visual integration).
The deterministic synthetic campaign visits all six levels/reunion in8911steps
with0deaths; this does
not complete natural late-campaign acceptance.

The v35 mesh cleanup fixes reversed pupil/catchlight winding, restores inner ears,
removes the misplaced collar/hem rings, and rebuilds the pendant as an offset-circle
crescent. Smaller pupils reveal turquoise irises. Nose, mouth and belly have
separate materials so user ear tint does not recolor the belly. Cheek width,
low-poly cheek tufts and forelock are concept-directed silhouette work. A short
open jacket follows the torso mesh with clipped triangle boundaries instead of a
floating lathe bib. These are concrete fixes, not accepted concept fidelity:
fur, ear/hand proportions, costume detail and expression still differ markedly.
All28suites pass (27previous + geometry/material/finite/skinning checks). Actual
release desktop/mobile-size gameplay and controlled native run/jump/duck previews
were inspected. Native previews are fixtures, not natural gameplay acceptance.
Treeline is flat/graphic, horizon tonal banding remains and
this is not polished landscape art. Other levels/NPCs/guardian/reunion did not
receive a matching final-art pass. Natural L5 completion/L6/reunion, physical
device performance, browser audio listening and human fun/art acceptance remain
open. All previous canon/mechanic simplifications in PORT-STATUS.md still apply.


## v39 character expression/proportion checkpoint (WIP)
The generator now replaces the pinched V-shaped mouth with a small curved smile,
reduces eye projection/width, shortens ear root scales and reduces lower-arm
branches uniformly to0.78. Finger descendants follow those branch transforms.
All14animation channels and inverse bind matrices are unchanged; four named
rest-node scales intentionally differ, so original node JSON equality is no
longer claimed. This is exploratory concept-directed work, not accepted final
art. Bulky fingers, simple fur, jacket detail and round eye forms remain.
42native snapshots sample14animations at10/50/90percent; native fixtures do not
replace actual gameplay, natural campaign, physical-device or human acceptance.


## v40 white-fur/cuff WIP
Runtime main/belly fur albedo is a lighter cool white instead of blue-grey.
Dark wrist cuffs with narrow magenta piping are clipped from the forearm mesh
and preserve its skin weights, rather than floating rigid rings. This is a
small costume increment, not final concept fidelity; fingers, eyes, silhouette,
fur surface and most costume details remain simplified. No mechanic changes.


## v41 batched character refinement (WIP)
Layered shorter cheek tufts and a swept forelock replace the large three-spike
cheeks; lower-arm root scale is now0.69/0.73/0.69, with descendant fingers and
cuffs following the rig. Smaller pink nose, smaller jade-green crescent with
less emission, cyan boot edge/ankle strips and a narrow magenta jacket hem
bring the palette/costume closer to the tracked concept. Animation channels,
inverse binds and hierarchy remain original. Eye recess experiments were
rejected after three-quarter pixels showed face occlusion; accepted eye
geometry remains v39/v40. This is still a generic low-poly approximation,
not final fur/costume, swept-ear silhouette, or accepted concept fidelity.


## v42 Meadow foliage/atmosphere batch (WIP)
Branched trees use overlapping varied crowns rather than three tall blobs.
Paired leaflets replace the nine angular fern blades;48ferns total51,840
vertices. A shared opaque foliage shader adds restrained wind and the same
fragment-depth fog ramp as the banks to flowers/ferns/tree crowns. Scene prop
counts/scroll wrapping, bank height following, light-mode cleanup and other
themes stay unchanged. This is stylized procedural WIP, not final landscape
art: the distant tonal horizon strip, simple trunks, detached moons and
limited ground cover remain. No gameplay, character, asset binary or deploy
changes. Real-device performance and natural campaign/art acceptance remain
open; desktop/mobile browser fixtures are only visual/regression evidence.
