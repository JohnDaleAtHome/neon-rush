# Guardian material allocation guard

V22's color update created two new StandardMaterial3D resources every guardian frame, although closed/open/exhausted state changes only occasionally. Cache that state on each guardian and update materials only when it changes. Same colors and timing; no gameplay or visual layout change. This removes redundant allocation, not a measured device-performance claim.

Guardian test now verifies120same-state updates preserve both material instances, followed by unchanged4HP/two-window reunion. Full deterministic campaign8911steps zero retries and systems suite pass. Existingv22live smoke/pixels remain the visual baseline; this chunk does not change appearance. Frozenv22review/v14/v2/official unchanged.
