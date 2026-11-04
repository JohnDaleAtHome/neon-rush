# Palace scenic destination, November 5 2026

Adds an original far gate with two roofed towers and five cream lights. Study carried forward Sky/Journey destination framing and the existing five-light MoonBridge story objective, with earlier palace roof/photo study. No reference media copied. Not an authentic architectural reconstruction.

Purely decorative, beyond the track at z=-145. No gameplay, collision, story, save or deployment changes. Does not animate the gate, implement a new lock, or imply the gate can be approached. Five lights are scenic, not an additional progress display.

Static equal-material gate geometry is batched into nine draw calls instead of 29. Adds 1308 primitives. 39 local regression scripts pass. Geometry test permits central geometry only if beyond z=-130 and above y=9; other scenic vertices remain outside lanes. Light mode and world ownership are tested. Actual Web phone/desktop/small-phone/short-landscape and later gameplay inspected: Guardian, cues and controls readable, gate roof below moons. Existing side pavilion/moon overlap in wide desktop remains; coarse architecture and straight empty approach remain.

Same-run ABBA software OpenGL 390x844: baseline 66.522/67.983ms, batched candidate 68.154/64.503ms, about 1.4% lower mean, within noise. Draws 285 to 294, primitives 82106 to 83414. Unbatched prototype rejected (29 added draws, about 3.3% higher mean). Software renderer only, not physical-device evidence. Two preexisting native shutdown texture leaks persist. No deployment or actual-device clearance.

References carried forward:
- https://store.steampowered.com/app/2325290/Sky_Children_of_the_Light/
- https://mattnava.com/Journey-1
- http://en.pgm.org.cn/photos.html
- https://hpcbristol.net/visual/Hv10-026
