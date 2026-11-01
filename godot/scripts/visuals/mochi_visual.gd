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
## Integration API:
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
				"Bunny_Main", "Bunny_Secondary", "Belly_Fur":
					# soft fur: matte finish, subtle luminous edge, no metal
					m.albedo_color = Color("e0e6ef") if String(m.resource_name) in ["Bunny_Main", "Belly_Fur"] else m.albedo_color
					m.metallic = 0.0
					m.roughness = 0.9
					var fiber := NoiseTexture2D.new()
					fiber.width = 128
					fiber.height = 128
					fiber.as_normal_map = true
					fiber.bump_strength = 1.0
					var noise := FastNoiseLite.new()
					noise.seed = 4611
					noise.frequency = 0.32
					fiber.noise = noise
					m.normal_enabled = true
					m.normal_texture = fiber
					m.normal_scale = 0.22
					m.rim_enabled = true
					m.rim = 0.12
					m.rim_tint = 0.25
					m.emission_enabled = true
					m.emission = Color(0.55, 0.75, 0.9)
					m.emission_energy_multiplier = 0.0
					if String(m.resource_name)=="Bunny_Main":
						m.next_pass=null
						var previous: Material = m
						for layer in range(1):
							var coat := ShaderMaterial.new()
							coat.shader=load("res://scripts/visuals/mochi_fur_shell.gdshader")
							coat.set_shader_parameter("layer",float(layer+1))
							previous.next_pass=coat
							previous=coat
				"Bunny_Jacket":
					var cloth := ShaderMaterial.new()
					cloth.shader = load("res://scripts/visuals/mochi_jacket.gdshader")
					mi.set_surface_override_material(i, cloth)
				"Scarf_Navy", "Scarf_Seam":
					var scarf := ShaderMaterial.new()
					scarf.shader = load("res://scripts/visuals/mochi_scarf.gdshader")
					scarf.set_shader_parameter("seam",String(m.resource_name)=="Scarf_Seam")
					mi.set_surface_override_material(i,scarf)
				"Eye_White":
					# cyan glow; gold unlock still recolors albedo via apply_bunny_tint
					m.vertex_color_use_as_albedo = true
					m.emission_enabled = true
					m.emission = Color(0.25, 0.85, 0.95)
					m.emission_energy_multiplier = 0.18
				"Neon_Trim":
					m.emission_enabled = true
					m.emission = Color(0.13, 0.9, 1.0)
					m.emission_energy_multiplier = 1.3
				"Pendant_Glow":
					m.emission_enabled = true
					m.albedo_color = Color(0.23, 0.78, 0.54)
					m.emission = Color(0.18, 0.65, 0.40)
					m.emission_energy_multiplier = 0.65
	for child in node.get_children():
		_enhance(child)
