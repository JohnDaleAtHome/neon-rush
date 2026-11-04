# Storm Sea landscape checkpoint, November5 2026

Source-only incremental art study. No deployment or physical-device clearance.

## Reference study
Official ABZU gallery https://abzugame.com/Gallery and original screenshots visually studied. Image5 at https://freight.cargo.site/t/original/i/32d61097f4275fcd6e73f6df923754953a35f58fd7fcf53a0610ada44e529c73/image5.jpg shows layered rock silhouettes separated by atmospheric color, with an open bright navigation space. This informs unequal rock placement and a clear forward channel, not ABZU's fish/underwater setting or copied assets. Gallery screenshots are research only and not redistributed. Artist provenance https://giantsquidstudios.com/ABZU-Concept-Art .

Technical comparison https://github.com/Chrisknyfe/boujie_water_shader describes Gerstner vertex waves plus refraction,depth foam and other configurable features. This study uses original simpler opaque sine-wave displacement with analytic normals and surface highlights. No borrowed shader code, screen refraction,depth texture or FFT pipeline. Browser Compatibility and gameplay clarity take priority over realistic simulation.

## Changes
Isolated SeaVisual theme3 only: two bounded subdivided opaque water planes,6existingCC0Quaterniusrockinstances, calm blue-green palette and distance haze. Existing decorative ring meshes hidden in this world, not gameplay entities. Flat running surface unchanged, border tint changed from pink to restrained cyan. Module restores border material on every exit/Light transition. Reduced motion freezes water animation. Story, hazards, lanes, physics, saves and checkpoints unchanged. No new binary assets.

## Validation
36headlesssuites pass, including water geometry/ownership/Light/reduced-motion/world and aspect roundtrips. Web390x844/1280x800/360x640/844x500 gameplay pixels inspected, zero pageerrors. Later phone21%/desktop12% gameplay captures show cues/orbs and guides legible, not a full natural campaign playthrough.

Matched paused mobile software ABBA baseline55.32/56.00ms, candidate54.98/54.02ms (~2.1%lower mean cost, near parity).56vs81calls,69638vs55486primitives. Not a physical-deviceFPS claim. Existing two native texture leaks remain at quit. Fresh remote archive, exact recovery and export verification still required before marking integrated.

## Limits
Water feels restrained/calm rather than stormy; still a straight running channel. Scenic rocks sit fixed in the background as before for horizon composition. Not a final environmental-art claim.
