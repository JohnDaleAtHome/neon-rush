# Guardian feedback and reunion menu

- Preserves four HP, 4.8-second cycle, 2.4-second green window, two hits per window, shot speed and fire cooldown.
- Spent green windows turn amber and say TWO HITS - WAIT FOR NEXT GREEN. Closed and active windows have separate text. Applies to Story and Mission.
- A hit briefly reports remaining HP and uses the existing coin cue. Shield-closed, exhausted-window and alignment misses have separate feedback.
- Reunion shows one NEW JOURNEY action. The separate reset-journey button is hidden there, restored when choosing another mode or returning to a normal menu.
- test_guardian_feedback.gd verifies two-hit cap, next-window reset, four hits to reunion and duplicate-action hiding.
- Headless campaign remains 8911 frames with zero retries; control-option and review-fix regressions pass.
- Actual browser visual test used a separate, temporary palace-start fixture, not a natural full-campaign playthrough. Normal keyboard inputs reached reunion, no browser errors. Inspected 390x844 amber/cue and single-action reunion pixels. The unmodified v2 baseline also reached reunion through a natural six-level browser replay before this patch.

Art remains simplified. No claim of critic-device latency resolution or complete feature parity.
