extends Node3D
## MeadowVisual - isolated world/atmosphere overhaul for level 0 ("Neon Meadow").
##
## Integration contract (godot/MEADOW-VISUAL.md):
##   _ready():        meadow_visual = load("res://scripts/visuals/meadow_visual.gd").new()
##                    add_child(meadow_visual); meadow_visual.bind(self)
##   apply_world():   last line -> if meadow_visual: meadow_visual.apply(index)
##   build_level_props(): after the existing clear + light check ->
##                    if meadow_visual and meadow_visual.build_props(self, index): return
##
## The module owns only theme 0. It reads (never writes) main's fields via bind:
## options, scene_props, camera, env_world, ground, side_planes, moons, moon_glows,
## player. Props it builds are appended to main's scene_props so the existing
## scroll / wrap / free logic in main is reused unchanged.

const THEME_INDEX := 0
const ASSET_DIR := "res://assets/visuals/meadow/"

var game = null
var player_ref: Node3D
var camera_ref: Camera3D
var shadow: MeshInstance3D
var shadow_mat: StandardMaterial3D
var horizon_layers: Array[MeshInstance3D] = []
var horizon_root := Node3D.new()
var active := false
var saved_ambient_color := Color.BLACK
var saved_ambient_energy := 1.0
var ambient_saved := false

const MEADOW_FOG := Color("14352e")
const MOON_GLOW_ALPHA := 0.30


func bind(main_node) -> void:
	game = main_node
	player_ref = game.player
	camera_ref = game.camera
	_build_shadow()
	_build_horizon()


func handles_props(index: int) -> bool:
	return index == THEME_INDEX and not game.options.get("light", false)


func build_props(main_node, index: int) -> bool:
	if not handles_props(index):
		return false
	_build_plants(main_node)
	return true


func apply(index: int) -> void:
	# Runs at the end of main's apply_world, after main has restored its own
	# base materials/fog/sky. Actively hide and reset everything of ours when
	# leaving Meadow or when light mode is on; never leave residue visible.
	var light: bool = game != null and game.options.get("light", false)
	if index != THEME_INDEX or light:
		active = false
		if shadow: shadow.visible = false
		_set_horizon_visible(false)
		_restore_ambient()
		return
	active = true
	var environment: Environment = game.env_world.environment
	# Atmosphere: coordinated fog and sky so the horizon reads as one scene.
	environment.fog_enabled = true
	environment.fog_mode = Environment.FOG_MODE_DEPTH
	environment.fog_depth_begin = 26.0
	environment.fog_depth_end = 120.0
	environment.fog_depth_curve = 1.25
	environment.fog_light_color = MEADOW_FOG
	environment.fog_light_energy = 1.0
	environment.fog_sky_affect = 0.35
	if not ambient_saved:
		saved_ambient_color = environment.ambient_light_color
		saved_ambient_energy = environment.ambient_light_energy
		ambient_saved = true
	environment.ambient_light_color = Color("a8b0e8")
	environment.ambient_light_energy = 0.45
	# Sky gradient tuned to the same teal-to-indigo ramp as the fog.
	var sky := Sky.new()
	var sky_material := ShaderMaterial.new()
	sky_material.shader = load("res://scripts/sky.gdshader")
	sky_material.set_shader_parameter("camera_forward", -camera_ref.global_basis.z)
	sky_material.set_shader_parameter("camera_up", camera_ref.global_basis.y)
	sky_material.set_shader_parameter("vertical_tangent", tan(deg_to_rad(camera_ref.fov) / 2.0))
	sky_material.set_shader_parameter("sky_gradient", load(ASSET_DIR + "sky.png"))
	sky.sky_material = sky_material
	environment.sky = sky
	environment.background_mode = Environment.BG_SKY
	# Calmer path and banks: module terrain shader, same scroll contract.
	_apply_terrain()
	# Moons stay where layout_moons puts them; lift their glow into the scene.
	for i in range(game.moons.size()):
		game.moon_glows[i].modulate.a = MOON_GLOW_ALPHA
	_set_horizon_visible(true)


func _apply_terrain() -> void:
	var ground_mat := ShaderMaterial.new()
	ground_mat.shader = load("res://scripts/visuals/meadow_terrain.gdshader")
	ground_mat.set_shader_parameter("terrain_texture", load(ASSET_DIR + "path.png"))
	ground_mat.set_shader_parameter("terrain_tint", Color.WHITE)
	ground_mat.set_shader_parameter("uv_scale", Vector2(1.0, 6.0))
	ground_mat.set_shader_parameter("fog_color", MEADOW_FOG)
	game.ground.material_override = ground_mat
	for side in game.side_planes:
		var side_mat := ShaderMaterial.new()
		side_mat.shader = load("res://scripts/visuals/meadow_terrain.gdshader")
		side_mat.set_shader_parameter("terrain_texture", load(ASSET_DIR + "meadow_side.png"))
		side_mat.set_shader_parameter("terrain_tint", Color.WHITE)
		side_mat.set_shader_parameter("uv_scale", Vector2(5.0, 20.0))
		side_mat.set_shader_parameter("fog_color", MEADOW_FOG)
		side.material_override = side_mat


func _restore_ambient() -> void:
	if not ambient_saved or game == null:
		return
	var environment: Environment = game.env_world.environment
	environment.ambient_light_color = saved_ambient_color
	environment.ambient_light_energy = saved_ambient_energy


func _build_shadow() -> void:
	# Soft contact shadow grounding Mochi; follows the player in _process.
	shadow = MeshInstance3D.new()
	var quad := QuadMesh.new()
	quad.size = Vector2(1.5, 1.5)
	quad.orientation = QuadMesh.FACE_Y
	shadow.mesh = quad
	shadow_mat = StandardMaterial3D.new()
	shadow_mat.albedo_texture = load(ASSET_DIR + "contact_shadow.png")
	shadow_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shadow_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shadow_mat.no_depth_test = false
	shadow.material_override = shadow_mat
	shadow.position = Vector3(0, 0.015, 0)
	shadow.visible = false
	add_child(shadow)
	horizon_root.visible = false


func _build_horizon() -> void:
	# horizon_root groups everything far-field so one toggle controls it.
	add_child(horizon_root)
	# Fog-colour underlay beneath the entire visible field (starts under the
	# banks at z=+10, hidden inside their 0.1-thick boxes until their alpha
	# fade reveals it, then continues to z=-570): the meadow never visibly
	# ends and no sky can show through the banks' fade wedges.
	var far := MeshInstance3D.new()
	var far_mesh := PlaneMesh.new()
	far_mesh.size = Vector2(900, 580)
	far.mesh = far_mesh
	# Match the bank's lit terrain instead of placing flat fog-colour paint
	# beyond its outer edge. Continuous material hides the diagonal join.
	var far_mat := ShaderMaterial.new()
	far_mat.shader = load("res://scripts/visuals/meadow_terrain.gdshader")
	far_mat.set_shader_parameter("terrain_texture", load(ASSET_DIR + "meadow_side.png"))
	far_mat.set_shader_parameter("uv_scale", Vector2(187.5, 77.333))
	far_mat.set_shader_parameter("fog_color", MEADOW_FOG)
	far_mat.set_shader_parameter("fade_geometry", false)
	far.material_override = far_mat
	far.position = Vector3(0, -0.14, 10 - 290)
	horizon_root.add_child(far)
	# Rolling berms break up the flat banks at mid distance.
	var berm_mat := StandardMaterial3D.new()
	berm_mat.albedo_color = Color("1a3d30")
	berm_mat.roughness = 1.0
	var brng := RandomNumberGenerator.new()
	brng.seed = 9917
	for i in range(6):
		var berm := MeshInstance3D.new()
		var sphere := SphereMesh.new()
		sphere.radius = 1.0
		sphere.height = 2.0
		berm.mesh = sphere
		var side := -1 if i % 2 == 0 else 1
		berm.scale = Vector3(3.0 + brng.randf() * 2.5, 0.7 + brng.randf() * 0.5, 2.0 + brng.randf() * 1.5)
		berm.position = Vector3(side * (8.0 + brng.randf() * 5.0), -0.35, -35.0 - i * 17.0 - brng.randf() * 8.0)
		berm.material_override = berm_mat
		horizon_root.add_child(berm)
	# Treeline silhouettes: wide enough for landscape viewports, bottoms sunk
	# below the ground plane, texture fades out at both horizontal ends.
	var layers := [
		{"z": -100.0, "width": 520.0, "height": 24.0, "tint": Color("1b3630"), "bottom": -2.0},
		{"z": -125.0, "width": 660.0, "height": 30.0, "tint": Color("265047"), "bottom": -2.5},
	]
	for spec in layers:
		var band := MeshInstance3D.new()
		var quad := QuadMesh.new()
		quad.size = Vector2(spec["width"], spec["height"])
		band.mesh = quad
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = load(ASSET_DIR + "hills.png")
		mat.albedo_color = spec["tint"]
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		band.material_override = mat
		band.position = Vector3(0, spec["bottom"] + spec["height"] * 0.5, spec["z"])
		horizon_root.add_child(band)
		horizon_layers.append(band)


func _set_horizon_visible(visible: bool) -> void:
	horizon_root.visible = visible


func _plant_material(texture_path: String) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = load(texture_path)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	mat.alpha_scissor_threshold = 0.35
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.emission_enabled = true
	mat.emission = Color(1, 1, 1)
	mat.emission_texture = mat.albedo_texture
	mat.emission_energy_multiplier = 0.22
	return mat


func _build_plants(main_node) -> void:
	var prng := RandomNumberGenerator.new()
	prng.seed = 20261101
	var textures := [ASSET_DIR + "plant_a.png", ASSET_DIR + "plant_b.png", ASSET_DIR + "plant_c.png"]
	var materials := []
	for t in textures:
		materials.append(_plant_material(t))
	# Varied plants replace the 30 identical grass cards.
	for i in range(34):
		var side := -1 if i % 2 == 0 else 1
		var plant := MeshInstance3D.new()
		var quad := QuadMesh.new()
		var scale_factor := 0.8 + prng.randf() * 1.0
		quad.size = Vector2(1.7 * scale_factor, 1.4 * scale_factor)
		plant.mesh = quad
		plant.material_override = materials[i % materials.size()]
		plant.position = Vector3(
			side * (4.9 + prng.randf() * 3.4),
			0.7 * scale_factor - 0.04,
			-6.0 - i * 4.1 - prng.randf() * 2.4)
		plant.rotation.y = prng.randf_range(-0.3, 0.3)
		main_node.add_child(plant)
		main_node.scene_props.append(plant)
	# A few cool moonlit stones for ground shape.
	for i in range(8):
		var side := -1 if i % 2 == 0 else 1
		var rock := MeshInstance3D.new()
		var mesh := SphereMesh.new()
		mesh.radius = 0.28 + prng.randf() * 0.3
		mesh.height = mesh.radius * 1.1
		mesh.radial_segments = 8
		mesh.rings = 5
		rock.mesh = mesh
		rock.scale = Vector3(1.0, 0.55, 1.0)
		rock.position = Vector3(side * (4.7 + prng.randf() * 2.6), 0.06, -10.0 - i * 15.0 - prng.randf() * 6.0)
		var rock_mat := StandardMaterial3D.new()
		rock_mat.albedo_color = Color("7f86a8")
		rock_mat.roughness = 1.0
		rock.material_override = rock_mat
		main_node.add_child(rock)
		main_node.scene_props.append(rock)
	# Drifting fireflies: shared glow sprite, low alpha, cyan and magenta.
	var glow_texture: Texture2D = load("res://assets/textures/sprite_glow.png")
	for i in range(8):
		var fly := Sprite3D.new()
		fly.texture = glow_texture
		fly.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		fly.pixel_size = 0.005
		fly.shaded = false
		var cyan := i % 2 == 0
		fly.modulate = Color(0.55, 1.0, 0.88, 0.38) if cyan else Color(1.0, 0.62, 0.95, 0.32)
		var side := -1 if i % 2 == 0 else 1
		fly.position = Vector3(side * (5.4 + prng.randf() * 3.0), 0.8 + prng.randf() * 1.6, -14.0 - i * 16.0)
		main_node.add_child(fly)
		main_node.scene_props.append(fly)


func _process(_dt: float) -> void:
	if not active or game == null or not is_instance_valid(player_ref):
		if shadow: shadow.visible = false
		return
	var running: bool = game.running and not game.paused
	shadow.visible = running
	if not running:
		return
	shadow.position.x = player_ref.position.x
	shadow.position.z = player_ref.position.z
	var jump: float = clampf(player_ref.position.y / 2.2, 0.0, 1.0)
	var spread: float = 1.0 + jump * 0.5
	shadow.scale = Vector3(spread, 1.0, spread)
	shadow_mat.albedo_color = Color(1, 1, 1, 1.0 - jump * 0.55)
