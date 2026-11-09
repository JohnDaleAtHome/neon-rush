# Browser stats and checkpoint saves

Normal-input audit reproduced a discarded Story attempt disappearing after reload with engine-file-only saving. Stats/history and journey now also write synchronous same-origin engine backup keys, leaving legacy keys untouched. Engine files remain fallback. Loaded records/history validate metrics and mode; checkpoints require exact canon piece order. An existing backup prevents repeated legacy score import from replacing current stats when an engine marker was lost.

Actual normal browser Story start/pause/confirmed menu discard recorded one attempt; reload retained its exact best/distance/run count with the backup. Separate controlled checkpoint fixture executed a crossing/save to Silver Dunes; same-origin reload into the production build restored level2 and Moon Dew Vial.390x844 resumed gameplay pixels inspected, no browser errors. The checkpoint test is a controlled fixture, not a full natural campaign replay. Temporary fixture files removed and production scene restored.

New schema test rejects invalid rows/metrics. Preferences/migration/review/systems/campaign regressions pass; campaign8911frames zero retries. Browser storage can still be cleared or unavailable; storage is not a guarantee of recovery. No cross-origin transfer or public deployment.

## Timely failure warning - November 10, 2026

Runtime `aac848ec485008267d099b823d46911f79ca1978` makes existing detected write failures visible at a safe moment. The prior warning was only shown when Settings/Stats was constructed, and its instruction to export stats could be read as preserving journey progress. The new caution says saving may not persist after closing, journey progress and preferences may reset, and stats exports preserve records only, not journey progress.

The caution updates an already-open Settings/Stats panel. A shared SAVE WARNING acknowledgment appears once per session only while stopped or paused, waits for another popup to close, and does not interrupt running movement. Closing it preserves pause and returns focus through the existing shared-modal behavior. A failure remains visible in Settings/Stats after acknowledgment. The warning does not prove that every storage path failed, retry failed writes, or guarantee recovery. No keys, data schema, migration rules or gameplay were changed. At that checkpoint, FileAccess failure detection coverage was not expanded. The follow-up below closes two missing open-failure branches.

All 66 isolated native suites pass in the candidate and in an untouched source archive after documented bootstrap and clean import. Release Web export passes. The production PCK contains 202 paths; no QA/test/fixture/oracle paths, and the full Han-house notice is unchanged.

Controlled browser quota-failure simulation, not a naturally occurring user-storage failure, verified the initial stopped notice at 320x568, 390x844, 844x390 and 1280x720. Actual pixels were inspected. Dynamic failure in open Settings updates the warning; closing Settings opens the single acknowledgment, then Escape/Enter restores Settings focus. A fresh ordinary release menu shows no warning on successful writes. A separate fresh release check enables the simulated failure immediately before visible Begin: one failed write occurs, gameplay starts with no modal, manual pause opens the caution, and closing it leaves the run paused. Actual fresh pixels inspected; no page errors or debug QA hook. Native tests also cover live deferral, once-only display and open Stats updates.

These checks do not prove browser durability, older-user migration, physical-device performance or full natural campaign acceptance. Source only; no deployment.

## Native file-open detection parity

Runtime `6166c1c9802dc909b5624c1f0b66a0aff8c522f7` adds the same caution when the checkpoint or preferences file cannot be opened for writing. Stats already had this branch. The change is two calls to the existing warning handler; successful writes, data keys/schema, browser backups and gameplay remain unchanged.

A disposable Linux user-data audit reproduced the gap: directories named options.json and journey.json cause open error 12 without a warning in the prior source, while stats.json already warns. Expanded test_storage_warning.gd now verifies all three failed opens warn and later successful writes do not. It requires the isolated test runner's disposable user-data path before touching the fixtures. Candidate and untouched archive bootstrap/import/all 66 suites/release Web export pass. Production pack: 202 paths, 7,691,568 bytes, unchanged full Han-house notice, no QA/test/fixture/oracle paths.

Actual fresh native 390x844 pixels after a controlled options-file obstruction and explicit save were inspected: the shared caution is readable. The native check uses Linux software rendering and dummy audio, not device or listening proof. Fresh release browser success menu, simulated failure at visible Begin with live deferral, manual pause caution and paused close-return were checked separately, with no page errors or debug QA hook. Neither fixture uses real user data.

Detection remains limited: this is not a check for failures after a file was opened, or for asynchronous browser filesystem persistence errors. It adds no retries, recovery guarantee or deployment.
