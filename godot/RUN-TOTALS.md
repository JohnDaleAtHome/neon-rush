# Cumulative totals

Stats and JSON export include cumulative runs, distance, treats and engine-tracked seconds. Each recorded Story attempt or other completed run adds once. Legacy totals import runs/distance/orbs once and remain separate from per-mode records. Reload preserves the totals backup and does not re-add legacy totals.

Scope is explicit: legacy totals + new engine attempts, or tracked from this update when no trustworthy old baseline exists. Earlier engine attempts cannot be reconstructed as lifetime totals from rolling20-run history. Legacy never stored active-second totals, so seconds are labeled engine-tracked rather than all-time.

New unit checks import, duplicate-attempt protection, backup restore and missing baseline. Browser synthetic30legacy runs/5000m/120treats + one normal-input discarded Story attempt reloads31runs/5003m/120treats. Actual390x844 stats pixels inspected. Schema/review/systems/campaign regressions pass; campaign8911frames zero retries. No public deployment.
