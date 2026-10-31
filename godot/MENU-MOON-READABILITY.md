# WIP menu moon readability

The 390x819 v22 main menu placed narrative text across the dark moon silhouettes. Show celestial meshes only during active, unpaused gameplay, so the menu, narrative beats and pause screens keep a quiet background. Beginning or resuming a run restores the moons when the existing stars preference allows them. Their glow sprites are children and follow visibility. No gameplay, placement, save or asset change.

All 20 headless suites pass, including deterministic six-level campaign (8911 steps, zero retries). Scene-art regression checks preference off/on, menu, world changes during a beat, start, pause and resume. Local release pixels inspected at 390x819, 1280x800 and 844x390 for menu readability. Normal input on the local release verified start, pause, resume and jump; gameplay moons return, pause moons disappear, zero browser errors. Not a natural campaign completion or device-performance claim.

Source patch is based on committed d669ffe003f2. Frozen v22/v14/v2 reviews and official game are unchanged.
