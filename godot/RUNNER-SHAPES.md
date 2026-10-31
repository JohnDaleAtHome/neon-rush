# Legacy runner choices in Godot

The rabbit remains the default and story character. Settings now offer the legacy Sphere and Diamond choices as optional visual skins, implemented with Godot meshes. They share exactly the same player transform and collision/gameplay logic. Existing color and unlocked Gold apply to the skins.

Browser settings validate/persist shape; a missing shape imports the old same-origin cube/sphere/diamond setting once. Cube maps to Moon Rabbit, matching the final legacy implementation. Existing engine shape wins over old storage. Old storage stays untouched. Disk preferences now use the same supported-value validator as browser backups.

Verification:18 headless tests pass including actual picker callbacks and mesh visibility, validators and old-option mapping. Release browser snapshots show Sphere and faceted Diamond; saved-shape reload and missing-shape legacy import/reload pass with zero page errors. The browser runs used seeded preferences to select skins, not natural playthrough proof. Prior full-campaign proof and independentv14review are unchanged; this is not a completed art or fun review. No production/staging change.
