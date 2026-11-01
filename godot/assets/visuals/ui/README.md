# Moon HUD interface art

Generated in-repo for the v34 moon-themed HUD (no third-party assets, no
downloads; drawn procedurally, so licensing matches the project's original
game content).

- `moon_chip.png` - 28px crescent icon used on the primary menu button.
- `toggle_on.png` / `toggle_off.png` - 56x32 moon-pill toggle art for the
  settings CheckButtons.

Styling code lives in `scripts/visuals/hud_theme.gd`. Authoring method:
PIL, supersampled 4x, palette sampled from
`docs/concept-art/mochi-main-character.webp` (cyan #67e8f9, navy #070e1e,
moon gold #ffd97a).
