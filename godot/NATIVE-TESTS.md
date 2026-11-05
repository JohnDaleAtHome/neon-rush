# Repeatable native tests (Linux)

Native tests must not inherit the developer's saved Light quality or other preferences. Some suites intentionally write saves. Use the isolated runner rather than invoking them against normal user data.

After restoring assets (`python3 fetch-assets.py`) and importing the project with Godot 4.7, from `godot/`:

```sh
python3 tools/run_tests.py --godot /path/to/godot --logs /tmp/neon-tests-1
```

The log directory must be new. Godot can also be set with `GODOT_BIN` or found as `godot`/`godot4` on PATH. Default is all root `test_*.gd` suites. To select suites:

```sh
python3 tools/run_tests.py --godot /path/to/godot --timeout 20 --logs /tmp/neon-tests-2 test_dunes_visual.gd test_sea_light.gd test_meadow_light.gd test_campaign.gd
python3 tools/test_run_tests.py
```

Each suite gets fresh temporary XDG data/config/cache directories, removed after the child exits. Runtime and save formats are unchanged. Linux only: other platforms are rejected because this isolation has not been verified there. Asset imports still share the project's `.godot` cache, so import first and do not run another editor/import concurrently.

The runner captures combined output per suite, reports nonzero exits and engine/script errors as failures, and kills a suite after its timeout (60 seconds by default). This matters because a GDScript assertion can stop a coroutine without exiting the engine. It continues to remaining suites and returns failure if any suite failed or timed out. It does not substitute for pixel inspection, browser interaction checks, or device performance testing.

## November 6 verification

- All 46 native suites passed in one isolated run using Godot 4.7.2 on Linux. Campaign reached reunion in 8,911 simulated steps, zero deaths, all six worlds.
- All 188 existing files in the normal native game-data directory had identical SHA-256 contents before and after the runs, including saved preferences and game history.
- Standard-library runner test verifies separate clean directories, cleanup, preservation of a host sentinel, success, script-error-with-zero-exit rejection, nonzero exit, timeout, continued execution, duplicate selection, invalid path rejection and refusal to overwrite log evidence.
- Two old Meadow assertions were stale after the accepted Meadow Light improvement: Light keeps authored moon scales and hides neon edges. Updated only those test expectations to match the dedicated Meadow Light suite and the already inspected scene. No runtime change.
- Headless tests are logic/structure coverage only. Prior full-scene visual evidence remains separate; these tests do not claim new visual or actual-device clearance.
