# Stats label clarity

Based on committed v29 HEAD1612c7fd269d19db4e0685b7d16c7de49ef3b06c.

The global summary adds recorded attempts. Per-mode score, distance, treats and time are separate maxima and can come from different attempts. They are now explicitly labeled best score, longest distance, most treats and longest time. Attempt counts are separate. Story counts level attempts, not complete six-level journeys. No stored schema, accounting, gameplay or timing changes.

Verification:24 headless suites pass, including new test_stats_labels.gd and campaign8911 steps/zero deaths. New test checks formatted populated metrics, cumulative totals, Story level-attempt wording and no data mutation. Release export succeeds. Separate populated-stats fixture inspected at390x844,844x390,1280x800, readable labels and scrolling panel. Fixture is outside production source and is not natural campaign evidence. Frozen review v29 and official/frozen hosts unchanged. Latest natural evidence covers L1-4 only; L5 completion, L6 guardian and reunion remain unverified, as do physical-device performance/audio/fun acceptance.
