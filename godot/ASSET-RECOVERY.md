# Asset recovery

From a fresh clone, run `python3 godot/fetch-assets.py` before opening `godot/project.godot` in Godot 4.7.2.

The command verifies and restores the 28 baseline assets and then applies the tracked offline restore helpers for the visual sourcepack, Meadow assets, generated path, Chinese pavilion, pagoda, Han house, Dunes sand, Meadow hay-bale texture and Sea turtle model. The helpers preserve current tracked scripts rather than replacing them with an older embedded version. All binary content is checked against its recorded byte length and SHA256 hash before being written.

The baseline assets still depend on the companion staging site in `assets-manifest.json`. This checkout is not fully self-contained or guaranteed to build offline from an empty folder. The newer sourcepacks restore their own contents offline, but that does not remove the baseline network dependency.

If any download or validation fails, stop before opening the project. Do not treat a partial restore as a completed build. Re-running the command is safe: already-correct files are verified and retained.

The Han house is CC BY-SA 3.0. Other asset notices and exact recovery details are kept with their respective sourcepacks and validation documents. No paid service or secret is needed.
