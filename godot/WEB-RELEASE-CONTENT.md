# Web package content check, November 6 2026

The tracked Web preset now excludes `qa_*,test_*`. This records the filter already used by recent clean comparison builds, instead of requiring an untracked local preset edit. Source test scripts remain in the repository and still run natively. Both Web release and debug exports use this preset filter. The debug-only in-game QA state remains available in debug exports and absent from release exports.

Verified using Godot4.7.2 and fresh f97b271 source restored only with fetch-assets.py. Mounted each generated PCK in a separate audit project and enumerated actual pack paths. Unfiltered source-default release had291 entries. Filtered release had191: exactly50 root test scripts and their50 remaps removed, no new paths. The filtered path set matches the immediately preceding private clean release. No broad exclusions for licenses, recovery data or required runtime resources were added.

Fresh unfiltered PCK7,433,108bytes; filtered7,326,192bytes, saving106,916bytes. Previous clean release was7,326,208bytes. This is package-content parity, not byte reproducibility: fresh imported scenes and UID serialization differ. A shared-entry hash comparison found only exported main-scene and UID-cache differences between the two fresh packages; runtime script/shader/asset entries were retained. No gameplay source or art change.

Actual390x844 and844x390 filtered release Web frames inspected after ordinary Dunes start from a deliberately seeded checkpoint with persisted Light. QA undefined, no page exceptions/game errors, first local favicon404 only. Debug build at the same sizes returned the expected QA object. Source native campaign and preference-backup suites pass. Earlier90ba9c0 fresh49-suite result remains distinct. No natural browser campaign, device-performance clearance or public deployment.

Godot export filter documentation: https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
