# Cinnamon Grove local study - 5 November 2026

Not integrated or deployed. Local incremental study, not finished art or actual-device acceptance.

## Composition
24unequal tree placements from existingCC0nature models, with distant trees replaced by existing baked model impostors.12existingCC0rocks and22shrubs add ground dressing; two low original banks and original quiet warm ground/path shader replace flat bare sides/busy old path. Old16lollipop trees and decorative props hidden. Main apply_options now honors Grove ownership so it cannot restore old scenery after world selection.

Studied actual official Kena shrine and village screenshots at https://emberlab.com/kena/ . Interpretation: layer ground dressing to trees, side framing and open view. No Kena media/assets reused. Artist description at https://kem1995.artstation.com/projects/q98bne?album_id=3124895 reinforces consistent ground-to-canopy dressing. Direct artist image requests returned403; official images actually viewed instead:
http://emberlab.com/wp-content/uploads/sites/2/2020/05/MaskShrine-1.jpg
http://emberlab.com/wp-content/uploads/sites/2/2020/05/VillageWide.jpg

## Local verification
38headless suites pass. NewGrove regression checks60landscapechildren, finite scenic vertices beyond3.65m/noCollision, world isolation, Light restoration, apply_options suppression of old primitive avenue, short-landscape satellite projection above lane horizon. First bound check caught199intruding scenic vertices; transformed tree/rock bounds now clamp nearest edge beyond4.2m.
ActualWeb390x844/1280x800/360x640/844x500 and later phone22%/desktop10% screenshots inspected; readable hazards/orbs/guides, zero pageerrors. Desktop trees partly frame celestial bodies as intended, no below-horizon short-landscape moons.

## Software cost
First all-mesh24tree study around106ms vs59ms baseline was rejected as too costly. Current distant impostors lower matched software ABBA30frame mean baseline57.77/57.49ms vs58.55/59.23ms, about2.2%higher. Calls111to97; primitives55666to68174. Not physicalphoneFPS. Existing native shutdowntextureleaks persist.

## Limits and remaining
Still sparse at phone scale; plain straight track, coarse rocks, near flat leaf shading. No fidelity claim to reference. Need source integration and independent fetch/recovery/exactness/fullsuite/freshexport/pixels verification before checkpoint complete. Publicv84unchanged.
