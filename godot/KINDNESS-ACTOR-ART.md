# WIP kindness actor silhouettes

With v26's clear encounter layout in place, replace the three primitive NPC placeholders with small Godot mesh assemblies: firefly body/light/wings between leaning vines, turtle shell/head/feet/eyes/ridge, and a soft shadow rabbit with ears/eyes/arms. All parts live under one encounter actor so resize and cleanup stay consistent. No binary asset, gameplay, choice or timing change.

Kindness-art, encounter-layout, systems and deterministic full campaign tests pass (8911 steps, zero retries). Actual fixture release pixels inspected for all3 encounters at390x819 and844x390, zero browser errors. These are seeded visual previews, not a natural campaign. Existing production meshes are still WIP, not reference-character approval or finished art. Main rabbit remains the authored Quaternius model.

Based on committed cc7bbe7548d8. No hosting changes; frozen reviews and official game unchanged. The earlier rejected experiment is integrated only after the separate presentation fix.
