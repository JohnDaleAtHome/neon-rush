# WIP hazard cue readability

Low hazards rotate their cylindrical body90 degrees, which also rotated the old UP label. Counter-rotate the label and transform its position from a world-upright offset into hazard-local space. Low-hazard labels sit slightly above the bale; all labels remain in front of their hazard. Replace UP/DOWN/X with JUMP/SLIDE/DODGE and reduce font size to fit the longer words. Same hazard meshes, spawning, movement and collision rules.

New test checks all three cue words, upright global rotation and intended world placement for normal and sea-wave low hazards. Hazard-cue, jump-buffer, systems and deterministic full campaign suites pass (8911 steps, zero retries). Local production release normal-input start/pause/resume/jump smoke has zero browser errors. Actual390x819 and1280x800 release pixels inspected; separate fixture-only preview places all three hazards at7m for legibility inspection. Fixture code is outside the project and excluded from this patch/export. These checks are not a natural campaign or device-performance certification.

Based on committed d4fee5f82c52. No hosting changes; frozen reviews and official game unchanged. Primitive hazard art remains WIP.
