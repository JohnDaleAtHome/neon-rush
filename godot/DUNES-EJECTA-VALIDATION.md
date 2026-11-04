# Silver Dunes ejecta trails

## Study and incorporation
Studied the actual NASA LRO image Exposed Boulders in the Aitken Mare and Journey desert composition. Unequal boulder trails at slope bases contrast with open smooth regolith. Original scenery takes that grouping principle, not image pixels or copied models.

Sources:
- https://science.nasa.gov/photojournal/exposed-boulders-in-the-aitken-mare/
- https://assets.science.nasa.gov/content/dam/science/psd/photojournal/pia/pia13/pia13997/PIA13997.jpg
- https://mattnava.com/Journey-10th-Anniversary-Behind-the-Scenes-Retrospective

## Implementation
Replaced 18 regularly spaced existing CC0 rocks with six unequal off-lane trails: 12 existing CC0 hero rocks and 84 original low-poly pebbles. All are baked into one static surface. Darker directional stone material distinguishes the fragments from regolith. No imported assets, collisions, lane changes, gameplay, story, saves or encounter changes. Light mode restores original lightweight environment.

## Validation
39 local Godot suites pass, including complete six-level campaign, corridor bounds, Light/world restoration and four aspect layout checks. Exported Web pixels inspected at 390x844, 1280x800, 360x640 and 844x500, plus later play. Lane, JUMP and dew remain readable. Existing short-landscape moon framing is not fixed by this change.

390x844 software-render ABBA baseline 51.687/50.371ms vs candidate 52.079/52.611ms, around 2.6% higher mean. Draw calls 97 to 83; primitives 73,122 to 75,634. These are noisy software comparisons, not device performance clearance. Initial 96-full-CC0-rock version was rejected at roughly 12% higher software cost. Fixed mixed indexed/nonindexed assembly that hid procedural pebbles before final measurements.

Terrain and rocks remain stylized/coarse and the path remains straight. No claim of finished environment art, deployment or actual-device verification.
