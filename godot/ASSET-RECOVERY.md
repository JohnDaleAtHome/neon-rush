# Asset recovery

From a fresh clone, run `python3 godot/fetch-assets.py` before opening `godot/project.godot` in Godot 4.7.2.

The command verifies and restores the 28 baseline assets from the tracked offline baseline sourcepack, then applies the other tracked offline restore helpers for the visual sourcepack, Meadow assets, generated path, Chinese pavilion, pagoda, Han house, Dunes sand, Meadow hay-bale texture, Sea turtle model and Meadow bee model. The helpers preserve current tracked scripts rather than replacing them with an older embedded version. Binary content is checked against its recorded byte length and SHA256 hash before being written.

Asset recovery no longer requires the companion staging site's baseline URLs. assets-manifest.json retains those original URLs as provenance and compatibility fallback information; the normal bootstrap restores the offline baseline first and stops on any sourcepack failure. Python 3's standard library is sufficient. Godot 4.7.2 and matching Web export templates must still be installed separately. Offline asset recovery does not mean the game can be launched by opening an exported HTML file directly; serve the Web build over HTTP(S).

If any helper, filesystem operation or validation fails, stop before opening the project. Do not treat a partial restore as a completed build. All baseline content is validated before writes, but replacement of multiple files is not a single transaction. Re-running is safe: already-correct baseline files are verified and retained. Do not run concurrent restores against one checkout.

The baseline pack metadata and chunks are excluded from Web release resources. See BASELINE-SOURCEPACK.md for format and license notes. The Han house is CC BY-SA 3.0. Other notices and exact recovery details are kept with their respective sourcepacks and validation documents. No paid service or secret is needed.
