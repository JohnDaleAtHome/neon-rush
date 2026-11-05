# Meadow hay bale, November 6 2026

Story Meadow low hazards now use Mish7913's CC0 Hay Bale (108 triangles) instead of smooth cylinders. Source: https://opengameart.org/content/hay-bale-0 . Artist provenance and coordinate/texture adaptations are in assets/models/meadow_bale/LICENSE.txt.

Before opening Godot, run `python3 godot/assets/models/meadow_bale/restore_texture.py` after the existing asset-recovery steps. This restores the byte-verified 256px texture from repository-contained base64. The encoded source is used because the web upload route adds filename prefixes; this checkout's other asset recovery requirements still apply. OBJ/MTL are ordinary text source. Runtime resources are shared, one surface, centered 1.4 x 0.8 x 1.2m. All other modes/worlds/hazard types are unchanged. Collision, JUMP cues, saves and story unchanged.

Dedicated test covers 108 mode/world/kind cases and 24 real waves, bounds, mesh/material reuse and upright cues. Cue/integration suites pass. Full native campaign: 8911 steps, zero deaths, six worlds/reunion. Meadow three aspects: 885 steps, zero deaths, Moon Dew Vial and Dunes advance. Actual close-hazard native three aspects and nine story frames inspected. Clean release Web three aspects plus phone Light inspected, no page errors or QA bridge. A real-spawn phone Web frame shows a distant bale. Not a browser campaign or actual-device performance claim.

Clean PCK +48632 bytes. Six-wave software workload: draws 245 unchanged, primitives 185098 to 181138. Sequential A1/B1/A2/B2 means 203.884/210.892/212.757/207.108ms, noisy ~0.33% mean difference, no speed claim. Existing native quit texture warnings remain. No public deployment.
