# Guard paused run changes

Pause exposes RESTART RUN and DISCARD RUN / MAIN MENU. First press asks to discard; KEEP RUN resumes without changing progress. A second press on the same destination confirms. Choosing another destination changes the question instead of discarding immediately. Resuming clears the pending choice.

Story restart returns to the same level and preserves bridge pieces. A discarded Story attempt records once, including restart; normal menus retain NEW JOURNEY's reset behavior. HP, progression, scoring and guardian timing are unchanged.

Tests: test_pause_guard.gd checks keep, checkpoint restart, menu and attempt counts. Existing migration/guardian/control/review/campaign/port tests pass. Actual390x844 browser start/pause/restart-question/KEEP RUN/resume/restart-confirmed passed, zero errors, one discarded attempt. Inspected confirmation pixels. No public deployment.
