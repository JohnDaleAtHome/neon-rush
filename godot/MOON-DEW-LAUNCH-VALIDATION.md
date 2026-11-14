# Moon Dew launch light

Source-only improvement, November 14, 2026. No hosted game update or device/performance clearance.

## Scope

STORYLINE.md promises that a full Moon Dew Vial lights the launch pad. Previously the Meadow reward displayed words and the same generic side rails as later crossings. The existing automatic hop was already implemented.

An original soft six-lobed pool of moonlight now blooms beneath Mochi before that hop. A quieter light wash extends along the safe Meadow crossing. This is light on the existing textured ground, not another physical prop, hazard or collectible. It is deliberately limited to this launch crossing. The separate first-dark-stretch promise is not claimed complete, and there is no persistent light in Dunes.

The visual is one two-triangle PlaneMesh with an original additive shader, no textures, point lights, shadows or collisions. It is owned by the temporary crossing node and freed with it. Shader phase comes from the existing active crossing clock, not wall time. Pause freezes it. Reduced motion starts at the steady fully lit state instead of adding a bloom animation. The already-existing automatic hop remains unchanged. Light rendering keeps this small story cue visible.

## Preserved behavior

No movement, input, hitbox, lane, spawn, RNG, score, five-second duration, hop velocity/timing, bridge-piece order, checkpoint, mode or storage-key changes. Other four reward crossings have no new light. No menu, HUD or scenery replacement. The source change is one preload, one Meadow-only attachment and an update from the existing crossing clock.

## Evidence

- 75 native suites passed with a fresh disposable user-data directory per suite. This includes the new light lifecycle/phase/pause/reduced-motion/Light/other-world checks, the adjusted crossing child-count expectation, and unchanged campaign/Pearl-Key tests.
- The scripted campaign still completes in 8,892 steps with zero deaths. It is controlled test evidence, not natural play.
- Actual native pixels inspected:24 views covering 390x844,844x390,1280x800, normal/Light, full/reduced motion, just before and after the existing hop. A separate six-second 390 px fixed-step 12 fps recording shows the bloom, hop and removal at Dunes entry. This is not a frame-rate benchmark.
- Separate controlled release-Web fixture displayed the real unchanged candidate runtime at 1.35 seconds through the crossing. Actual phone, landscape and desktop pixels were inspected. The fixture is static/seeded, not an ordinary browser crossing or earned campaign. Console/page errors were empty in the completed checked batches. An initial long harness hit its execution timeout after producing five images; it was split into bounded batches rather than reported as a completed full-browser run.
- Ordinary release startup retained all three exact previously earned backup strings in a new disposable browser context; page/console errors were empty and window.neonQA was undefined. The original browser profile was not touched.
- Candidate release pack: 216 resources, 7,805,411 resource bytes, all entry MD5 values verified. No tests, QA, fixtures or baseline sourcepack payload. Two pre-existing small meadow/visual sourcepack manifests remain. This is not a bit-identical export guarantee.

## Limits

No new natural Meadow completion, full natural campaign, human fun, audio/listening, physical-device, frame-rate or public-deployment claim. The earlier independent reviewer kit remains a separate older build. Fresh committed-source recovery/build verification is recorded separately after the source is tracked.
