# Verified native save replacement
November 11, 2026. Source checkpoint adf4c3512dd21de57b335c7761c04d9031605a6d, not deployed.

## Reproduced limitation
A disposable Linux process with a 64-byte file-size limit silently truncated options, stats and a four-piece journey. FileAccess.get_error remained OK after store and flush. Existing documentation explicitly excluded post-open failure detection. No real player data or browser failure was observed.

## Change
Native save paths write a sibling .pending file, close it, read back the exact UTF-8 bytes and rename it over the prior target only on a match. Failure returns through the existing save caution handler. The prior target is never deliberately removed first. Web retains its existing direct virtual-filesystem writes and synchronous localStorage backups. No keys, schemas, loaders, migration, gameplay or reward changes.

## Verification
- Candidate and clean reconstruction from a175f9e plus the four changed source/test files: documented fetch-assets.py restoration, import, all 69 isolated suites, separate Linux truncation regression and release Web export pass. The reconstruction is not an untouched committed archive. One combined recovery/test command timed out during tests; a new full run then completed 69/69.
- New test_verified_save.gd covers success, exact Unicode/empty/repeated bytes, blocked pending-file creation, failed destination rename and three real save paths. tools/test_verified_save_fault.py runs the actual three save functions in a bounded isolated Linux process: each warns, preserves prior bytes exactly and removes partial pending data. It never uses the normal profile. Run with `python3 tools/test_verified_save_fault.py --godot /path/to/godot` after import.
- Candidate ordinary release uses a copy of the genuinely earned Shadow/Bridge4 profile: discard confirmation changes no backups; confirmed discard records once; reload restores the same checkpoint and exact post-discard backups. Actual 390px browser reload and controlled native failure-caution pixels inspected. No page errors or release QA bridge.
- Warm local Linux 20KB writes, 100 repetitions per ABBA sample: direct 44.21/44.82 microseconds; verified 73.35/62.15. Local filesystem/cache evidence only, not device or browser FPS.

## Limits
This is not an fsync, power-loss, crash-proof atomicity or universal storage-recovery guarantee. Fixed pending names assume the current single synchronous writer. No concurrent-writer or Windows rename validation. Cleanup can itself fail. Orphan pending files are not loaded as recovery data. A prior already-invalid save is not repaired. Browser asynchronous filesystem durability is unchanged and unverified. No public deployment, physical-device, listening, human-fun or full natural campaign clearance.

Official contracts read:
https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
https://docs.godotengine.org/en/stable/classes/class_diraccess.html

## Untouched committed-source check
Untouched runtime archive adf4c3512dd21de57b335c7761c04d9031605a6d restored only through fetch-assets.py, imported cleanly, passed all 69 isolated suites and the separate actual-three-save truncation regression, and exported release Web. All four runtime/test files match the tested candidate byte-for-byte. A duplicate new-file scripts subdirectory was corrected by rename before the runtime was wired; no duplicate helper remains.
