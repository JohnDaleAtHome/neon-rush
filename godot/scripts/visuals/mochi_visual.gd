class_name MochiVisual
## WIP concept-directed Mochi character visual (docs/concept-art/mochi-main-character.webp).
## Drop-in replacement for the legacy bunny instance: derived from assets/bunny.glb,
## same skeleton and all 14 animations, and the material names
## Bunny_Main/Bunny_Secondary/Eye_White/Eye_Black are preserved, so the existing
## player color options (Bunny_Secondary tint) and gold eye unlock (Eye_White tint)
## keep working through apply_bunny_tint().
##
## Adds: soft white matte fur with a restrained luminous rim (engine-side),
## cyan glowing eyes, dark navy jacket shell with emissive cyan collar/hem trim,
## dark boots, and a glowing crescent moon pendant (all skinned to the existing
## skeleton, so they deform with every animation).
##
## Contract (agreed with integration owner):
##   var bunny: Node3D = MochiVisual.create()   # then scale 0.55, add to player
## create() returns null and pushes an error if the asset cannot be loaded -
## no silent fallback to the legacy rabbit, so a broken asset cannot pass review.

const MOCHI_SCENE := "res://assets/visuals/mochi/mochi.glb"

static func create() -> Node3D:
	var packed := load(MOCHI_SCENE) as PackedScene
	if packed == null:
		push_error("MochiVisual: failed to load " + MOCHI_SCENE)
		return null
	var node := packed.instantiate() as Node3D
	_enhance(node)
	return node

static func _enhance(node: Node) -> void:
	var mi := node as MeshInstance3D
	if mi and mi.mesh:
		for i in range(mi.mesh.get_surface_count()):
			var m := mi.mesh.surface_get_material(i) as StandardMaterial3D
			if m == null: continue
			match String(m.resource_name):
				"Bunny_Main", "Bunny_Secondary":
					# soft fur: matte finish, subtle luminous edge, no metal
					m.albedo_color = Color("a9b5c5") if String(m.resource_name) == "Bunny_Main" else m.albedo_color
					m.metallic = 0.0
					m.roughness = 0.85
					m.rim_enabled = true
					m.rim = 0.12
					m.rim_tint = 0.25
					m.emission_enabled = true
					m.emission = Color(0.55, 0.75, 0.9)
					m.emission_energy_multiplier = 0.0
				"Eye_White":
					# cyan glow; gold unlock still recolors albedo via apply_bunny_tint
					m.emission_enabled = true
					m.emission = Color(0.25, 0.85, 0.95)
					m.emission_energy_multiplier = 0.18
				"Neon_Trim":
					m.emission_enabled = true
					m.emission = Color(0.13, 0.9, 1.0)
					m.emission_energy_multiplier = 1.3
				"Pendant_Glow":
					m.emission_enabled = true
					m.emission = Color(0.49, 1.0, 0.78)
					m.emission_energy_multiplier = 1.4
	for child in node.get_children():
		_enhance(child)
