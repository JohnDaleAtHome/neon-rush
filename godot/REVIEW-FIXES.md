# Review fixes after initial Godot WIP

- Meadow advances at six Dew. Removed the unannounced minimum-time gate.
- Later timed paths show piece progress; crossings show their progress.
- Story level attempts now record stats on level completion, checkpoint retry and discard, with duplicate protection. Reunion records its final attempt.
- Desktop uses the available canvas rather than a narrow portrait pillarbox. Landscape has compact centered menu layout. Menu/run pixels checked at 1280x713, 390x844, 320x568 and 844x390; normal start works at all four sizes.
- Campaign test fixes float-lane rounding, sets a repeatable RNG seed, and exits nonzero instead of hanging on failed completion. It reaches reunion with zero retries for this seed. This does not guarantee every random path or human fun.

The baseline real-time browser campaign also reached reunion using visible UI and normal keyboard actions, with checkpoints retained between sessions and no browser errors. No official replacement deployment yet. Still WIP: simplified environments/NPCs/guardian and placeholder animated rabbit; final reference fidelity and full parity audit remain.
