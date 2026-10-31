# Godot sky, lunar relief and distance fade

Uses only existing checksum-recovered images, byte-identical to the supplied art port pack. No new binary asset or download host. Three small Godot shaders: screen-oriented gradient sky via view direction, lunar surface from the existing16-bit height texture, and terrain depth/color/alpha fade. Per-level supplied sky/fog/moon/side palettes; subtle billboard halos and pickup glows.

The existing albedo has low visible contrast and the generated normal image looks nearly flat. The lunar shader samples original height data for contrast and finite-difference normal detail. Moons now show visible crater/maria patterns rather than smooth gray balls. The sky gradient and terrain fade reduce the abrupt background edge, but do not claim finished environment art. Simplified NPCs/guardian/trees and reference-rabbit match remain open. No gameplay timing/collision/difficulty changes.

Verification: all20 headless suites pass, including six-theme shader/material/visibility checks and8911-step zero-retry campaign. Release desktop1280x720 and mobile390x844 actual pixels inspected, zero page/console errors. Allsix level theme screenshots inspected through explicitly seeded saved checkpoints. These are synthetic art previews, NOT natural campaign completion evidence. Frozenv14review and official legacy unchanged; browser audio listening, actual device performance and human fun acceptance remain open.

API references checked:
https://docs.godotengine.org/en/stable/classes/class_environment.html
https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/sky_shader.html
https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html
