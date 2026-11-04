# Meadow valley source checkpoint

Validated November 4, 2026. Source-only incremental environment checkpoint. Public v84 is unchanged. Not final art or real-device performance clearance.

This offline sourcepack preserves 36 exact files, including the CC0 Quaternius mesh subset, textures, model-derived distant-tree renders, source, tests, reference study, license and validation notes. Binary web upload was unavailable, so ASCII chunks provide a durable repository-contained recovery route. Thirteen chunks00 through12 are required. The first chunk's historical commit message predates the final13part split.

To use the checkpoint from repository root:

```
python3 godot/fetch-assets.py
```

This command restores baseline assets, then calls meadow-sourcepack/restore.py to verify every packed file before applying this Meadow source checkpoint. It writes only repository-relative manifest paths. The Meadow restore step does not download anything. Running it again is safe. Do not run the older visual restoration afterward, because it may overwrite baseline visual files.

Then open godot/project.godot with Godot4.7.2 or export Web. Full checks:32test scripts pass; synthetic campaign8911steps0deaths; Web390x844/1280x800/laterphone checked,0pageerrors. See restored docs/MEADOW-VALLEY-VALIDATION.md and docs/ENVIRONMENT-REFERENCE-STUDY.md for exact scope and performance caveats.

The tracked fetch-assets.py activates this checkpoint after baseline recovery. The sourcepack includes both code and assets to apply them together, rather than leaving a half-integrated project. Raw tracked runtime files remain the baseline until recovery is run. No deployment is implied.

## Source visibility follow-up

The validated runtime code, tests, study, validation and bake script are now also tracked as normal files. restore.py still validates every archived file but only writes godot/assets paths, so recovery does not overwrite later source fixes. The archived code is historical recovery evidence, not an automatic rollback. The new asset subset is offline and hash checked.
