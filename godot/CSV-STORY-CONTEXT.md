# CSV Story context

Based on committed v30 HEAD8707c4d8098394ddbef9da11672a5cc7a3f27b5d.

CSV previously dropped Story level and outcome, which JSON and visible history preserve. Append story_level and outcome after the original six columns. Non-Story rows have blank story_level. Escape commas, quotes, CR and newlines as CSV quoted fields. No save/accounting/gameplay changes. JSON remains format_version2 and unchanged.

Verification:25 headless suites pass including new CSV escaping/context/nonmutation test and campaign8911steps/zero deaths. Release export succeeds. Actual normal UI Export JSON/CSV downloads in a separate populated release fixture parse correctly; both Story level2 rows retain their distinct level-complete/checkpoint-retry outcomes and unchanged numeric/date leading columns. Fixture evidence is synthetic, not natural campaign acceptance. No live hosting changes: v29/official/frozen builds unchanged. Latest natural L5 completion/L6/guardian/reunion, physical-device/audio/fun gaps remain open.
