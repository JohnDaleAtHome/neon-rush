# Canceled touch validation

Runtime integration: `593f3bc0e53b0a06cce70af6636639d709eb4696`.
Runtime plus restored native regression: `7a1c4ca9cea45f97f66eb5b730b7606cb8841128`.
Checked November 11-12, 2026. Source checkpoint only, no public deployment.

## Change

A canceled touch clears the current touch gesture without generating a tap. This does not reverse a lane change, jump or slide already performed before cancellation. Normal taps and gestures keep their existing mappings. Saves, Story progression, assets and layout are unchanged.

Native builds use `InputEventScreenTouch.canceled`. The tested Godot 4.7.2 Web template maps DOM `touchcancel` and `touchend` to the same uncanceled engine release. A native-only guard therefore did not fix the browser behavior.

`web_touch_cancel.gd` preserves the distinction with passive capture listeners on the canvas. A per-identifier FIFO records each DOM release before the engine's bubble listener. The matching engine release consumes one entry. Consumption happens even while stopped or paused, preventing those releases from leaking into later gestures. Explicit string values cross JavaScriptBridge. No engine/export-template patch, polling, DOM event suppression or gameplay-state hook is used.

The helper installs at main scene readiness and removes its listeners and queue at scene exit. It assumes the single live main scene used by this project. Concurrent main scenes are unsupported. Actual browser scene exit/re-entry has not been demonstrated; page reload and isolated listener disposal/reinstallation are separate checks, not a substitute.

## Checks

- Before repair, a controlled native canceled touch and an ordinary Web cancellation both generated a jump. The initial native-only guard passed its native regression but still jumped in the browser. Neither was treated as a browser fix.
- Passing candidate: all 70 isolated native suites, documented asset restoration/import and release Web export passed. Native regression covers canceled taps, moved/idle/stale releases, stopped/paused gesture cleanup, next normal tap, and preservation of existing jump/slide state.
- Browser listener unit test extracts the exact JavaScript from the GDScript source. FIFO ordering, identifier matching, unmatched consumption, stale-queue cleanup on reinstall, duplicate-listener removal and idempotent disposal pass.
- Separate instrumented Web fixtures checked menu/paused cancellation, drag then cancel, immediate same-ID cancel then tap, end then cancel without another buffered jump, and unmatched cancel followed by a valid tap. Rapid sequences used synchronous synthetic DOM TouchEvents; these are controlled tests, not natural play.
- Ordinary release Chromium touch emulation at 390x844 showed the baseline jump on cancellation. The candidate remained grounded on cancellation and jumped on the next normal tap, including after page reload. Actual retained gameplay pixels were inspected, not only event logs.
- An untouched archive of `7a1c4ca` completed documented restoration/import, all 70 isolated native suites in two bounded 35-suite runs, the source-listener test and release export. The four source/test files match the passing candidate exactly.
- The fresh accepted release repeated the ordinary cancellation/next-tap check. All retained cancellation frames stayed grounded; the following tap's airborne posture and separated ground shadow were inspected. No page errors or debug QA hook were present.
- A separate fresh ordinary release used a disposable copy of the genuinely earned Shadow Comet / Bridge 4 profile. Discard confirmation changed no backups; final discard added one newest history row, retaining the previous nine exactly. Reload preserved all three backup values and the exact four-piece journey. The actual paused Shadow / Bridge 4 screen was inspected. The original profile was not changed.
- Direct PCK directory parsing and entry-digest verification found 210 entries / 7,737,795 resource bytes. The complete Han-house notice matches source exactly; no QA, test, fixture, oracle or audit resources are packed. Earlier mounted-resource walks included files from the audit project's own directory and are not authoritative pack counts.

## Reproduce the source regressions

From the repository root, after the documented asset recovery:

```
python3 godot/tools/run_tests.py --godot /path/to/godot --logs /tmp/neon-touch-tests-1
node godot/tools/test_web_touch_cancel.cjs
```

Use a new logs directory. The native runner isolates Linux user data. Node.js is needed only for the listener unit test, not to run the game. Export a release Web build with the matching 4.7.2 templates and serve it over HTTP for browser checks.

## Limits

Chromium emulation is not physical-device, iOS/Safari, other-browser or performance acceptance. Multi-finger gesture ownership is unchanged and remains a separate issue. This does not guarantee handling of malformed outside event interception or multiple concurrent main scenes. Full natural campaign completion, listening quality and human fun acceptance remain open. No deployment or spending occurred.

API references:
- https://docs.godotengine.org/en/stable/classes/class_inputeventscreentouch.html
- https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
