# Retry input reset

Based on committed v31 HEADae982a0189144a438121622513678fca8be6941d.

Focused test reproduced transient input state leaking across start_level: slide_time0.65, fire_time0.3 and active gesture flags survived retry. Reset duck/fire timers and touch origin/flags alongside the existing jump/buffer reset. Whole-level checkpoint progress/pieces/hearts semantics unchanged. No difficulty, spawn, collision or narrative tuning.

New test covers heart death, shadow death and confirmed restart; stale touch release cannot jump after restart; first Guardian fire is available. All26 headless suites pass including campaign8911steps/zero deaths. Release export succeeds. Actual emulated-touch ordinary start/horizontal swipes/Pause smoke has no QA state or page errors; actual390x844 left-lane and pause pixels inspected. Not physical-device or full-campaign acceptance. Frozen v29 and all public hosts unchanged. Natural latest L5 completion/L6/guardian/reunion, final art, device/audio/fun gaps remain open.
