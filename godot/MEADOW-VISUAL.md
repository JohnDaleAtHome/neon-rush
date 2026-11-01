# Meadow visual candidate

Scoped to level 0 (Neon Meadow), with Light quality off. This is incremental WIP environment art, not style acceptance or a finished campaign.

## Scene and lifecycle

- `scripts/visuals/meadow_visual.gd` owns the module.
- `meadow_terrain.gdshader` keeps the existing textured path.
- `meadow_bank.gdshader` gives banks, underlay and hills an opaque world-space grass color and fragment-computed depth fog.
- Two smooth-normal rolling bank meshes stay outside abs(x) 3.8. Their rear/outer edges taper to the continuous underlay. They replace the six small berms and hide the original side planes only in full Meadow.
- Thirty-four overlapping 3D hills and thirty-six groves replace the two flat ridge quads. Groves remain within the shaped bank footprint.
- Props total 98: 34 solid stem/leaf/flower clumps, 48 dimensional fern/shrub clumps, 8 stones and 8 fireflies. Their existing scroll/wrap/free lifecycle is preserved. Terrain-bound props recalculate their height against the bank as they move.
- Main calls bind after scenery creation, lets the module build props after clearing old props, and applies the module after restoring the base world. Horizon and shadow are created once and hidden outside full Meadow. Light quality changes restore the original side planes and minimal scene.
- Contact shadow follows the player. Collision, level timing and saves are unchanged.

The first rolling-bank draft exposed broad diagonal dark bands from repeating the gradient side texture over the mesh. Controlled replacement with world-space color noise removed those bands in inspected Web screenshots. Removing the alpha output alone had not fixed them. The opaque material and continuous underlay avoid transparent triangle sorting and ground gaps. Fog is computed per fragment rather than interpolating a fog value over large underlay triangles.

## Lighting

Main uses direct-light energy 0.85 for full Meadow and 1.7 elsewhere/Light mode. Meadow ambient energy is 0.45; leaving the module restores prior ambient values. Existing restrained fur/eye emission and coordinated sky/fog remain.

## Verification

The 28 headless suites pass, including expanded visual integration coverage for bank geometry/corridor, far-edge taper, 98 props, height tracking, cleanup, Light restoration and other-world/endless transitions. The campaign fixture reaches all six levels and reunion in 8911 steps with zero deaths. That fixture is synthetic, not natural-play acceptance.

Godot 4.7.2 import and release Web export succeed. Actual Web pixels were inspected at 390x844 and 1280x800 for start, scrolling, ducking and a visible bale/dew encounter. No browser page errors were recorded, and release QA state is undefined. Test labels do not prove a jump occurred: one timed Space capture showed the runner grounded.

## Open limits

The scene has more depth, but distant terrain still reads as a tonal horizon strip and trees/ferns remain simple low-poly forms. Moons and the existing path texture/fade remain visible stylistic seams. Mochi still needs rig-aware proportions/expression work. No physical-device performance, natural full-campaign acceptance, art approval or public deployment is claimed.


## Solid foliage increment

The original34plant cards are replaced by vertex-colored solid mesh clumps, with stems,leaves and three flower/reed variants. Each clump is one ArrayMesh and one material rather than many scene nodes. Oval parts use six radial/four vertical steps; total flower vertex count is bounded under180000 by regression. No new binary assets are required. Existing98prop count,terrain height tracking and lifecycle remain.

Path fog/fade is now computed per fragment to avoid interpolating nonlinear depth fog across the plane triangles. The near path still has a visible tonal boundary from the texture/fade combination; this is not claimed fully solved.

All28suites pass after fixing two initial typed-variable parse errors. Expanded integration checks solid flower meshes,vertex colors,finite coordinates,corridor placement and vertex budget. Fresh release Web actual390/1280scrolling/duck/bale+dew screenshots were inspected with zero page errors and no QA state. No physical-device performance or natural campaign acceptance is implied.

## Path seam isolation

A controlled constant-color path eliminated the moving near horizontal tonal boundary, identifying the repeated path texture as the cause rather than depth fade. The candidate now uses restrained world-space noise with scroll offset instead of the non-seamless repeating texture. Actual390/1280scroll/duck/hazard+dew pixels show the near band removed. Obsolete path/hidden-side texture uniforms and assignments are removed. Existing path.png remains recoverable but unused here. All28suites pass. This fixes the near path band only; distant tonal horizon, simple foliage/moons and character gaps remain. No device/natural-campaign acceptance is implied.
