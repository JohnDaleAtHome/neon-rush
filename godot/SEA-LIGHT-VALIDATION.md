# Storm Sea Light-mode continuity

Light quality keeps the Full scene's quiet sky, restrained single moon and stone path. The older wave-painted blue lane and pink neon edges are no longer the fallback. Expensive subdivided water, rocks, surf and causeway rail geometry stay hidden. Two existing flat side planes use an inexpensive static, texture-free sea material. No collision, lane width, actor, story, save, controls or gameplay changes. This intentionally sparse fallback is not complete Chinese scene art.

Verification:
- Actual baseline/candidate native frames inspected at 390x844, 1280x800 and 844x390. Full frames are pixel-identical at all three sizes.
- Dedicated test covers four sizes, repeated Light/Full toggles, paving/sky/moon state, hidden scenic geometry and other-world restoration. Sea suite: zero failures. Campaign: 8,911 steps, zero deaths, all six worlds and reunion.
- Clean release Web at three Light aspects plus phone Full: actual pixels inspected, zero page errors, no QA bridge. Seeded Sea checkpoint, ordinary start action; not a full clean browser campaign.
- Private release PCK 7,284,568 bytes versus 7,283,896, +672 bytes. Software-renderer samples are diagnostic, not actual-phone performance evidence.
- Native shutdown texture warnings persist from the baseline. Light's far plane edges remain flat and visible; there are no authored rocks or rail details in Light.

No public deployment or actual-device clearance.

Matched stopped-scene software samples, 390x844, six seeded waves, five warm-up/60 samples each, A1/B1/A2/B2 mean ms: 62.76117 / 59.19798 / 63.58075 / 56.85560. Draws 100 to 98, primitives 83,326 to 83,302. This small diagnostic is noisy and does not establish a device speedup.
