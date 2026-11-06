# Skipped-band contact fix - November 6, 2026

Rush at38m/s could move a hazard or treat across the entire +/-1.1m contact band in one100ms frame. Endpoint-only detection missed it. The same controlled case worked at30/60Hz. This was reproduced in isolated tests, not reported on a user's device.

The fallback checks only full skipped bands. It intersects longitudinal, relative lateral and height intervals between actual frame endpoints. It tests the whole interval, not just its center. Low/tall contacts, beam slide expiry, pickups and magnet widths preserve their thresholds. Jump-clear and near-miss flags retain the existing departure checks and once-only20/15 bonuses. Normal endpoint frames, clocks, spawning, entity order, guard/shield convention, saves and Guardian shots are unchanged. This does not claim equivalence to multiple60Hz frames: the existing movement integrator is unchanged.

Validated before commit:24 original reproduction cases;2,000 independent interval-oracle cases; strict-boundary/dodge/slide/magnet/bonus cases; all55 existing isolated suites. The committed regression is self-contained, with11 hand oracle cases and16 focused edge/bonus checks. Ordinary60Hz state/entity traces matched over1,500 frames after normalizing instance-ID-dependent tall sway in that fixture. Uncontrolled sway parity across processes is not claimed.

Untouched source archive1a5cbbc plus documented fetch-assets.py:56/56 isolated suites passed, including campaign8911steps/0deaths/all6worlds/reunion, unchanged pause-guard and Guardian tests. Import/export had no errors. Fresh release pack7633936bytes,195paths, no tests/QA/fixture/oracle payloads. Solver script/remap included. Ordinary390 release browser start inspected with no page errors and no QA hook. A separate local Web fixture called one100ms Rush update and confirmed low hazard ends the run and treat collects1; actual paused Rush pixels inspected. The fixture is not in the repository or release pack. This is controlled Web behavior, not natural human or device testing.

A20-entity logic-only A-B-B-A microbenchmark added about.015ms per update (roughly11% of that small logic test). No FPS or device-performance inference. No assets, scene layout, story text, reward order or save schema changed. No public deployment.

Two discarded approaches are not included: broad frame subdivision changed exact elapsed-time semantics; center-only crossing interpolation missed early lane contact and jump bonus. The accepted interval implementation does neither.
