# Compact Dunes and Sea sky correction

Integrated six-world gameplay screenshots exposed a composition gap at short landscape heights: the general 265px moon-center floor placed Dunes and Sea moons behind the terrain. Projection diagnostics confirmed this was terrain occlusion, not clipping above the viewport.

Reuse the existing small outer-sky layout from Grove/Comet/Palace only for detailed Dunes and Sea at landscape heights below 650px. No change to portrait, larger desktop, Light mode, other worlds, geometry counts, collisions, story, saves or gameplay. No new media or assets. Meadow retains its separate framing.

40 local suites pass, including a new test across 844x500,812x375,1024x600 for horizon clearance, objective-column clearance, resize idempotence and portrait restoration. Actual exported Web pixels inspected at 844x500,812x375 and390x844 in both affected worlds, zero page errors. Satellites are deliberately small on short screens; this is a regression fix, not finished environment art. No actual-device performance clearance and no public deployment.
