# WIP bridge crossing option restore

Beginning a bridge crossing used controls.show unconditionally and did not reapply active-gameplay moon visibility after a story beat. Use apply_options instead: crossings respect the on-screen buttons setting, restore moons only when enabled, and preserve current accessibility options. No timing or progression change.

Encounter regression checks hidden controls across both moon preference states and visible moons when enabled. Encounter-layout, control-options, scene-art and full deterministic campaign suites pass (8911 steps, zero retries). Actual seeded crossing release pixels inspected at390x819 and844x390: controls remain hidden, moons return on portrait and story text stays clear. Fixture code outside production project, not natural playthrough evidence.

Based on committed772c24120a23. No hosting changes; frozen reviews and official game unchanged.
