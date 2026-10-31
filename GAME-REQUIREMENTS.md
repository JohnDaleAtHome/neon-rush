# Neon Rush game requirements

- Rewrite the entire game in Godot 4.
- All future game updates must be made in the game engine.
- The game must remain browser first.
- Keep this game requirements document in the Git repository so future work follows these requirements.

## Story and existing scope

- Preserve the six-level story, five ordered bridge pieces, kindness interactions, checkpoints and reunion described in STORYLINE.md. Visual work does not replace or waive those requirements.
- Preserve the existing modes, controls, settings, local saves, stats and export behavior. Keep unfinished mechanics and acceptance gaps visible in godot/PORT-STATUS.md.

## Visual direction approved 1 November 2026

Vic approved the priorities below after inspecting the current game and the concept already tracked at `docs/concept-art/mochi-main-character.webp`. This is new scoped work after the previous sprint ended, not an extension of its recurring improvement loop.

1. **Mochi's identity first.** Translate the concept's recognizable face and ear silhouette, cyan eyes, dark neon-trim jacket and moon pendant into the playable character. Replace the generic metallic/plastic finish with soft matte white shading and a restrained luminous edge. A tint change alone does not meet this requirement. Use browser-appropriate stylized fur treatment rather than promising the illustration's full rendering complexity.
2. **Rebuild the runway surroundings.** Calm the noisy track surface, replace obvious repeated grass cards and empty flat sides with shaped terrain, rocks and varied plants, remove the dark Meadow blotches, and ground Mochi with a soft contact shadow. Preserve clear lanes, hazards, pickups and jump/slide cues.
3. **Unify light and atmosphere.** Coordinate sky, terrain, fog and moon lighting, soften the horizon and add distant silhouettes to create depth. Existing fog/gradients are a starting point, not acceptance. Higher-resolution moon textures alone are insufficient.
4. **Restyle the HUD after the scene.** Use a consistent moon-themed interface rather than default-looking buttons and large blocks of white text. Shorten persistent instructions and give Mochi more visual space without shrinking touch targets or removing information needed to play.

### First visual milestone

- Produce one coherent playable Meadow scene with the revised Mochi, world and HUD together. Review actual mobile-size and desktop gameplay pixels, not isolated assets or code assertions alone.
- Establish the look in Meadow before carrying it through the other five levels. A successful Meadow preview is not acceptance of the entire campaign or a completed rewrite.
- Keep the concept's identity while adapting its dark lunar palette to the story's Meadow setting; do not silently replace the six distinct story environments with one moon biome.
- New art must be original or compatible with the repository's licenses. No paid tools, assets or services are authorized.
- Keep official legacy and frozen review builds intact. New source work does not authorize overwriting the public game; publish review artifacts separately when coordinated.

See VISUAL-IMPLEMENTATION.md for ownership, integration and acceptance steps.
