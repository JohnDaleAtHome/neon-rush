# Chinese garden study - November 5, 2026

This source checkpoint changes Cinnamon Grove only. It is not a deployed version or an actual-phone performance acceptance.

## Direction and scope

Gujian 3 screenshots were studied for grounded stone paving, slate eaves, muted red timber, cream walls and planted edges. No reference pixels are reused. Sources: https://gamesdb.launchbox-app.com/games/images/146702-gujian-3 and https://gnn.gamer.com.tw/detail.php?sn=99432 . These are visual/game-design references, not proof of architectural accuracy.

VVayToyek's Chinese four-corner pavilion is imported through Godot and reduced for runtime. Creator/license: https://vvaytoyek.itch.io/chinese-four-corner-pavilion-free . The page states CC0 and no generative AI. Original 70 meshes/76,926 triangles became five material batches/12,632 triangles. The source archive has no standalone license file; creator-page license evidence is recorded in assets/visuals/chinese_pavilion_cc0/PROVENANCE.md. Fine lattice detail is reduced. A checksum-verified offline pack restores only the runtime model, never scripts.

One nearby tree is replaced by the off-lane pavilion. Low wall segments and a plinth are batched. Original slate paving, calmer sky and one small moon replace the glowing track/planet trio in this world. Light quality keeps the path, sky and restrained moon but omits the 3D scenery. Other worlds, gameplay, collision, story, save format and controls are unchanged.

## Validation

- All 41 isolated headless regression scripts pass with fresh settings.
- Full rendered native campaign: 8,911 deterministic steps, all six worlds, five pieces, reunion, zero deaths. Seventeen captures inspected. This is accelerated native play, not a full browser or device run.
- Local release Web at 390x844, 1280x800, 360x640 and 844x500, plus Light/reduced-motion phone: zero JavaScript page errors; actual pixels inspected for path/cue/control readability. Later unscripted samples are not a death-free claim.
- Scenery vertices outside x +/-3.65; no added collision bodies. World return, Light ownership and restrained moon/sky behavior are covered.
- Matched software-renderer normal-quality A/B/B/A, 120 samples each: baseline40.577/41.551ms, candidate41.647/43.137ms, about3.2% higher mean. Draws100to106; primitives72,686to71,236. Not physical-phone FPS or clearance.
- Four native shutdown texture warnings remain, consistent with the unstable matched baseline previously recorded. No clean-shutdown claim.

## Remaining limits

This is a first Chinese garden direction, not finished environment art. Walls are sparse/boxy, trees coarse and the path straight. Light is deliberately bare. The pavilion is stronger in portrait than short landscape. Other worlds still use earlier moon/space scenery. No claim of historical fidelity or full-theme completion.
