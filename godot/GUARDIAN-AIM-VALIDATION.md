# Story Guardian aimed hazard

Runtime integration: `8a729b9187bbc0d0908db29c992b5166fe1c5e27`.
Runtime plus three new regressions and resource identities: `a6246dfacc83eb1b3f5bf46419c7bf01a6606de8`.
Checked November 12-13, 2026. Source checkpoint only, not deployed.

## Change

Story Palace previously used a random low hazard. Once per closed shield window, the Guardian now snapshots the player's lane, warns for one active second, then launches the existing low hazard body into that lane. Later lane changes do not retarget it. Opening the shield cancels an unlaunched warning and consumes that window. Pause stops the warning clock; level reset clears it.

This replaces Palace's old random hazard creation, not its orb pickups. Original random draws, pickup positions and wave cadence are preserved. Mission keeps its prior behavior. Speeds, hearts, collision rules, Guardian HP, two-hit windows, firing, save schemas and other worlds are unchanged.

The closed-shield HUD names the aimed lane and says move or jump. A released hazard remains dangerous during the start of the open window, so an in-flight banner coexists with the normal align/fire prompt until the hazard passes its contact zone or is removed. Hit feedback and the two-hit limit remain in their existing HUD slots.

The hazard still uses the existing low block and JUMP cue. This implements aimed timing and warning semantics, not finished shadow-bolt art. Rejected dart artwork was not included.

## Checks and limits

- Candidate and fresh origin archive with the exact nine source/test/UID delta files passed documented asset restoration, import, all 73 isolated native suites and release Web export. The native runner used a separate disposable Linux data/config/cache directory per suite. The three new suites cover pause, locked aim, dodge, stay-hit, jump-clear, reset, canceled late warning, pickup RNG parity, Mission parity, feedback priority, the two-hit window and controlled reunion.
- An untouched archive of `a6246df` separately completed documented recovery/import, all 73 isolated native suites and release export. Its direct pack audit found 212 entries / 7,739,694 resource bytes, with every digest checked, exact Han notice and no test/fixture/QA resources.
- All nine files on the runtime/test checkpoint match the tested candidate byte-for-byte. Production project and main scene were not changed. Synthetic entry and freeze scripts stayed in separate test copies.
- Direct release-pack parsing checked every entry digest and the exact full Han-house notice. Candidate: 212 entries / 7,739,684 resource bytes. Fresh reconstructed export: 212 / 7,739,609. Imported binary resources are not claimed byte-deterministic across fresh imports. Neither pack contains QA, tests, fixtures, oracles or audit resources.
- Actual native overlap/clear pixels were inspected at 320x568, 390x844, 844x390 and 1280x720 in Full and Light. The in-flight warning remains readable alongside the fire instruction and clears after the contact zone.
- Separate synthetic Palace-entry release Web copies used normal right-arrow input at all four sizes. Warning, release, open and clear views were inspected. A second labeled copy froze only the first actual shield-open frame to capture the brief overlap reliably. Its four inspected frames show the banner and fire prompt, center hazard, right-lane runner and three hearts. These are controlled transport/layout checks, not natural Palace progress. Web checks used default Full quality; Full/Light evidence above is native.
- Ordinary production release used a disposable copy of the genuinely earned Sea-to-Shadow checkpoint. Discard confirmation left backups unchanged; final discard added exactly one newest history entry, retaining all previous nine. Reload preserved all backup strings and the exact four-piece journey. Actual paused Shadow / Bridge 4 / Time 0 pixels were inspected. The original profile was not changed.
- Completed Web runs had no page, console or network/HTTP errors with the favicon handled explicitly, and no debug QA hook. An earlier unhandled-favicon run logged one unidentified generic 404; it is not used as clean-console evidence.

Software-rendered Chromium and native checks are not physical-device, iOS/Safari, other-browser, performance, human fairness, listening or fun acceptance. Controlled reunion tests do not close natural Shadow, Palace, reunion or fresh-start campaign completion. No spending or public deployment occurred.

## Reproduce native checks

From the repository root, restore assets as ASSET-RECOVERY.md describes, then:

```
python3 godot/tools/run_tests.py --godot /path/to/godot --logs /tmp/neon-guardian-tests
```

Use a new log directory. The full suite includes the three Guardian regressions. Export with matching Godot 4.7.2 Web templates and serve over HTTP for browser testing. Baseline asset restoration still depends on the recorded staging sources; this is not a fully offline checkout.
