# Palace environment checkpoint, November 5, 2026

Source-only incremental art study. Not deployment or actual-device performance clearance.

## Reference and interpretation
Inspected current Palace Museum raised-terrace / roof photographs and the historical pavilion photograph at:
- http://en.pgm.org.cn/photos.html
- https://hpcbristol.net/visual/Hv10-026

Original geometry interprets raised terraces, open columns, two-layer hipped roofs, lifted corners and thick eaves. It is a stylized fantasy environment, not an authentic reconstruction. No photo or model reused; the historical photograph is restricted reference material.
Model alternatives checked, not imported because their generic temple forms did not fit better:
- https://quaternius.com/packs/ultimatefantasyrts.html
- https://poly.pizza/m/YrK9bureMV

## Implementation
Three off-track pavilions, two side terraces and low balustrades, original quiet staggered-stone track shader, existing lanterns retained. All decorative, no collisions. All transformed scenic vertices outside the 3.65m central safety margin. Light mode and world transitions restore ownership. Short landscape moves pavilions farther outward to keep the central shield cue clear and positions moons above the horizon. Initial pool trial rejected because it looked like flat plates. Initial pyramid roof trial replaced by hipped rings.

## Validation
39 full local suites pass in a fresh run. An earlier Dunes moon visibility assertion timed out once; two isolated reruns and the fresh full run passed without Dunes source changes. New test covers bounds, finite geometry, no collisions, Light restoration, world ownership, four viewport sizes and short-landscape pavilion / moon placement. Legacy scene-art fixed-height expectation now permits above-horizon placement in short landscape.
Four Web aspects and later fight screenshots inspected; central objective, shield, pickups/hazards and controls readable. Roof/cue proximity found in 844x500 capture, fixed with lateral placement and re-inspected. Zero JavaScript page errors. Native shutdown still reports two pre-existing texture leaks.
Software-rendered ABBA, with five bridge pieces loaded for final level: baseline 117.70/116.97ms, candidate 110.01/112.28ms (~5.3% lower mean cost), 207 to 291 draw calls, 89,850 to 91,074 primitives. Not actual-device FPS. Earlier measurements lacking bridge pieces were discarded.

## Limits
Pavilions are still coarse; terraces are bare and the straight path remains visually simple. This is an incremental source checkpoint, not finished art. Actual-device measurement remains required before a public release decision.
