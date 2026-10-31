# Preserve old preferences and dates

First engine use imports validated legacy quality, handed controls, button size/visibility, contrast, tap/swipe, accent, gold equipment, guides, stars, compact HUD, guidance and explicit reduced-motion preferences. Existing engine preferences always win. Legacy cyan maps to pink because the old rabbit material used pink for that label. Sphere/diamond and system-motion defaults remain open parity work, not claimed migrated.

Old localStorage is neither changed nor removed. The migration marker is separate from the earlier score import so current engine users receive numeric history-date cleanup without having their chosen options replaced. Numeric epoch milliseconds become UTC timestamps. Old checkpoints require exact piece order and do not overwrite an engine checkpoint. Gold unlock is merged rather than downgraded.

Tests: test_legacy_migration.gd covers mapping, bad values, timestamps, checkpoints. A synthetic browser fixture imported distinct Classic12345/Chill456, left-handed/large/mint/contrast/light options, gold, and level3 checkpoint. Reload after changing old localStorage retained engine options, old score key unchanged, no browser errors. Actual1280x713 gameplay pixels confirmed imported control layout/HUD/guides/quality. Existing control, guardian, review-fix and deterministic campaign regressions pass.
