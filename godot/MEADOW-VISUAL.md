# Meadow visual candidate

Scoped to level 0 (Neon Meadow), with Light quality off. It adds a calmer path,
varied plants/stones, distant treeline, banks, fireflies, sky/fog and a contact
shadow. This is a WIP visual direction, not finished environment art.

## Files and integration

- `scripts/visuals/meadow_visual.gd` owns the scene module.
- `scripts/visuals/meadow_terrain.gdshader` owns textured terrain, fog and fade.
- `assets/visuals/meadow/` contains original procedurally authored PNG art.
- Main calls `bind` after scenery creation, lets the module build props after
  freeing the old props, and calls `apply` after restoring the base world.
- Props use the existing scroll/wrap/free lifecycle. Horizon/shadow nodes are
  created once and hidden outside the active theme. Light changes reapply the
  current world, so Settings can remove and restore the module immediately.

The underlay extends beneath the entire visible field, rather than beginning
behind a transparent terrain fade. It uses the same lit terrain shader as the
banks, with geometry fading disabled. This removes the former sky-through gap
and strong diagonal colour wedge in the inspected desktop view. The contact
shadow follows the player; no gameplay collision changes are introduced.

## Combined lighting

Main uses direct-light energy 0.85 for the full Meadow candidate and 1.7 for
other worlds/Light mode. Meadow ambient energy is 0.45; leaving the module
restores the previous ambient values. Fur emission is zero with low rim and
restrained eye emission, so white face form remains visible in the combined
scene instead of clipping to a featureless white shape.

## Verification and limits

See `VISUAL-CHECKPOINT.md` for the final integration evidence. Portrait
390x844 and desktop1280x800 actual Web captures were inspected. Light quality
on/off restores the minimal/full scene without duplicate props. A focused
regression tests50Meadow props, cleanup, restored lighting, other-world/endless
transitions and an opaque Settings/Stats panel.

The treeline remains graphic and flat, with a visible horizontal tonal region.
Moons and near banks still need art review. This milestone does not settle
physical-device performance, full-campaign art or human visual acceptance.
