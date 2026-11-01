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
## The module owns only theme 0. Through bind it reads scene state and updates
## its theme materials, visibility and moon presentation. Main resets moon scales
## and layout on leaving this theme. Shared fields:
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
var rolling_banks: Array[MeshInstance3D] = []
var saved_ambient_color := Color.BLACK
var saved_ambient_energy := 1.0
var ambient_saved := false

const MEADOW_FOG := Color("152b39")
const MOON_GLOW_ALPHA := 0.14


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
		for side in game.side_planes: side.visible = true
		if shadow: shadow.visible = false
		_set_horizon_visible(false)
		_restore_ambient()
		game.layout_moons(game.get_viewport().get_visible_rect().size)
		return
	active = true
	for side in game.side_planes: side.visible = false
	var environment: Environment = game.env_world.environment
	# Atmosphere: coordinated fog and sky so the horizon reads as one scene.
	environment.fog_enabled = true
	environment.fog_mode = Environment.FOG_MODE_DEPTH
	environment.fog_depth_begin = 26.0
	environment.fog_depth_end = 120.0
	environment.fog_depth_curve = 1.25
	environment.fog_light_color = MEADOW_FOG
	environment.fog_light_energy = 1.0
	environment.fog_sky_affect = 0.0
	if not ambient_saved:
		saved_ambient_color = environment.ambient_light_color
		saved_ambient_energy = environment.ambient_light_energy
		ambient_saved = true
	environment.ambient_light_color = Color("a8b0e8")
	environment.ambient_light_energy = 0.45
	# Sky gradient tuned to the same teal-to-indigo ramp as the fog.
	var sky := Sky.new()
	var sky_material := ShaderMaterial.new()
	sky_material.shader = load("res://scripts/visuals/meadow_sky.gdshader")
	sky_material.set_shader_parameter("camera_forward", -camera_ref.global_basis.z)
	sky_material.set_shader_parameter("camera_up", camera_ref.global_basis.y)
	sky_material.set_shader_parameter("vertical_tangent", tan(deg_to_rad(camera_ref.fov) / 2.0))
	sky_material.set_shader_parameter("sky_gradient", load(ASSET_DIR + "sky.png"))
	sky.sky_material = sky_material
	environment.sky = sky
	environment.background_mode = Environment.BG_SKY
	# Calmer path and banks: module terrain shader, same scroll contract.
	_apply_terrain()
	# Preserve celestial layout and moon option; veil their high contrast in Meadow haze.
	for i in range(game.moons.size()):
		game.moon_glows[i].modulate.a = MOON_GLOW_ALPHA
		var moon_mat: ShaderMaterial = game.moons[i].material_override
		moon_mat.shader = load("res://scripts/visuals/meadow_moon.gdshader")
		moon_mat.set_shader_parameter("haze_color",MEADOW_FOG)
		moon_mat.set_shader_parameter("camera_forward",-camera_ref.global_basis.z)
		moon_mat.set_shader_parameter("camera_up",camera_ref.global_basis.y)
		moon_mat.set_shader_parameter("camera_right",camera_ref.global_basis.x)
		moon_mat.set_shader_parameter("vertical_tangent",tan(deg_to_rad(camera_ref.fov)/2.0))
	_set_horizon_visible(true)
	game.layout_moons(game.get_viewport().get_visible_rect().size)


func _apply_terrain() -> void:
	var ground_mat := ShaderMaterial.new()
	ground_mat.shader = load("res://scripts/visuals/meadow_terrain.gdshader")
	ground_mat.set_shader_parameter("fog_color", MEADOW_FOG)
	game.ground.material_override = ground_mat


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
	# Continuous ground below the banks, with the same world-space material.
	# Bank height tapers onto it at the rear and outer edges.
	var far := MeshInstance3D.new()
	var far_mesh := PlaneMesh.new()
	far_mesh.size = Vector2(900, 580)
	far.mesh = far_mesh

	var far_mat := ShaderMaterial.new()
	far_mat.shader = load("res://scripts/visuals/meadow_bank.gdshader")
	far_mat.set_shader_parameter("fog_color", MEADOW_FOG)
	far.material_override = far_mat
	far.position = Vector3(0, -0.14, 10 - 290)
	horizon_root.add_child(far)
	# Rolling banks stay outside the lane corridor; distant ridges have actual shape.
	for side in [-1.0, 1.0]:
		var bank := MeshInstance3D.new()
		bank.mesh = _rolling_bank(side)
		var mat := ShaderMaterial.new()
		mat.shader = load("res://scripts/visuals/meadow_bank.gdshader")
		mat.set_shader_parameter("fog_color",MEADOW_FOG)
		bank.material_override = mat
		horizon_root.add_child(bank)
		rolling_banks.append(bank)
	# Three-dimensional overlapping hills, not a vertical skyline strip.
	var hrng := RandomNumberGenerator.new()
	hrng.seed = 230011
	for layer in range(2):
		for i in range(17):
			var hill := MeshInstance3D.new()
			var mesh := SphereMesh.new()
			mesh.radius = 1.0
			mesh.height = 2.0
			mesh.radial_segments = 20
			mesh.rings = 10
			hill.mesh = mesh
			hill.scale = Vector3(hrng.randf_range(22,38),hrng.randf_range(7,17),hrng.randf_range(24,40))
			var hill_x := -210.0+i*26.0+hrng.randf_range(-6,6)
			var center_recede := (1.0-smoothstep(25.0,90.0,absf(hill_x)))*40.0
			hill.position = Vector3(hill_x,-4.0,-105.0-layer*45.0-center_recede+hrng.randf_range(-12,12))
			var hm := ShaderMaterial.new()
			hm.shader = load("res://scripts/visuals/meadow_bank.gdshader")
			hm.set_shader_parameter("grass_low",Vector3(0.04,0.10,0.065))
			hm.set_shader_parameter("grass_high",Vector3(0.06,0.14,0.09))
			hm.set_shader_parameter("fog_color",MEADOW_FOG)
			hill.material_override = hm
			horizon_root.add_child(hill)
			horizon_layers.append(hill)
	# Overlapping moonlit groves give the skyline depth and varied organic crowns.
	var grove_rng := RandomNumberGenerator.new()
	grove_rng.seed = 771203
	var leaf_mats: Array[ShaderMaterial] = []
	for col in [Color("2a5549"),Color("21453e"),Color("3b6352")]:
		var lm := ShaderMaterial.new()
		lm.shader = load("res://scripts/visuals/meadow_foliage.gdshader")
		lm.set_shader_parameter("base_color",Vector3(col.r,col.g,col.b))
		lm.set_shader_parameter("fog_color",MEADOW_FOG)
		leaf_mats.append(lm)
	var bark := StandardMaterial3D.new()
	bark.albedo_color = Color("263337")
	for i in range(36):
		var side := -1.0 if i%2==0 else 1.0
		var x := side*grove_rng.randf_range(15.0,48.0)
		var z := grove_rng.randf_range(-125.0,-52.0)
		if i<8:
			x=side*grove_rng.randf_range(13.0,22.0)
			z= -26.0-float(i)*6.0
		var height := grove_rng.randf_range(5.0,10.0)
		var tree := Node3D.new()
		tree.position = Vector3(x,_bank_height(x,z),z)
		var trunk := MeshInstance3D.new()
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = 0.14
		cylinder.bottom_radius = 0.35
		cylinder.height = height*0.7
		cylinder.radial_segments = 9
		trunk.mesh = cylinder
		trunk.position.y = height*0.35
		trunk.material_override = bark
		tree.add_child(trunk)
		for branch in range(3):
			var twig := MeshInstance3D.new()
			var branch_mesh := CylinderMesh.new()
			branch_mesh.top_radius = 0.045
			branch_mesh.bottom_radius = 0.14
			branch_mesh.height = height*0.30
			branch_mesh.radial_segments = 6
			twig.mesh = branch_mesh
			twig.position = Vector3(0,height*(0.42+branch*0.09),0)
			twig.rotation = Vector3(0,branch*2.1,0.7 if branch%2==0 else -0.7)
			twig.material_override = bark
			tree.add_child(twig)
		for crown in range(7):
			var leaf := MeshInstance3D.new()
			var sphere := SphereMesh.new()
			sphere.radius = height*grove_rng.randf_range(0.20,0.28)
			sphere.height = sphere.radius*1.55
			sphere.radial_segments = 14
			sphere.rings = 7
			leaf.mesh = _canopy_mesh(sphere.radius,i*7+crown)
			var angle := crown*2.4
			var reach := height*(0.19 if crown<5 else 0.08)
			leaf.position = Vector3(cos(angle)*reach,height*(0.58+0.055*crown),sin(angle)*reach)
			leaf.rotation.y = angle
			leaf.scale = Vector3(1.2,1.0,0.86)
			leaf.material_override = leaf_mats[(i+crown)%leaf_mats.size()]
			tree.add_child(leaf)
		horizon_root.add_child(tree)


func _bank_height(x: float,z: float) -> float:
	var edge := smoothstep(4.0,12.0,absf(x))
	var rear := 1.0-smoothstep(112.0,144.0,-z)
	var outer := 1.0-smoothstep(44.0,53.8,absf(x))
	return -0.14+edge*rear*outer*(2.4+1.35*sin(z*0.055+x*0.14)+0.80*sin(z*0.12-x*0.19))


func _rolling_bank(side: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for iz in range(52):
		for ix in range(20):
			var corners: Array[Vector3] = []
			for q in [Vector2(ix,iz),Vector2(ix+1,iz),Vector2(ix+1,iz+1),Vector2(ix,iz+1)]:
				var x: float = side*(3.8+q.x*2.5)
				var z: float = 12.0-q.y*3.0
				corners.append(Vector3(x,_bank_height(x,z),z))
			var order := [0,2,1,0,3,2] if side>0 else [0,1,2,0,2,3]
			for k in order:
				var v := corners[k]
				st.set_uv(Vector2(absf(v.x)/50.0,(12-v.z)/156.0))
				var dx := (_bank_height(v.x+0.1,v.z)-_bank_height(v.x-0.1,v.z))/0.2
				var dz := (_bank_height(v.x,v.z+0.1)-_bank_height(v.x,v.z-0.1))/0.2
				st.set_normal(Vector3(-dx,1,-dz).normalized())
				st.add_vertex(v)
	return st.commit()


func _set_horizon_visible(visible: bool) -> void:
	horizon_root.visible = visible


func _build_plants(main_node) -> void:
	var prng := RandomNumberGenerator.new()
	prng.seed = 20261101
	var flower_material := ShaderMaterial.new()
	flower_material.shader = load("res://scripts/visuals/meadow_foliage.gdshader")
	flower_material.set_shader_parameter("vertex_colors",true)
	flower_material.set_shader_parameter("sway",0.055)
	flower_material.set_shader_parameter("fog_color",MEADOW_FOG)
	# Solid stems, leaves and flower heads replace the original flat cards.
	for i in range(34):
		var side := -1 if i % 2 == 0 else 1
		var plant := MeshInstance3D.new()
		plant.mesh = _flower_clump(i%3,prng)
		plant.material_override = flower_material
		plant.position = Vector3(side*(4.9+prng.randf()*3.4),0,-6.0-i*4.1-prng.randf()*2.4)
		plant.set_meta("bank_clearance",0.0)
		plant.position.y = _bank_height(plant.position.x,plant.position.z)
		plant.rotation.y = prng.randf_range(-PI,PI)
		main_node.add_child(plant)
		main_node.scene_props.append(plant)
	# Mid-ground fern/shrub clumps fill the banks with dimensional foliage.
	var shrub_material := ShaderMaterial.new()
	shrub_material.shader = load("res://scripts/visuals/meadow_foliage.gdshader")
	shrub_material.set_shader_parameter("vertex_colors",true)
	shrub_material.set_shader_parameter("sway",0.08)
	shrub_material.set_shader_parameter("fog_color",MEADOW_FOG)
	for i in range(48):
		var shrub := MeshInstance3D.new()
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		for frond in range(5):
			var angle := frond*TAU/5.0 + prng.randf()*0.3
			var direction := Vector3(cos(angle),0,sin(angle))
			var across := Vector3(-sin(angle),0,cos(angle))
			var high := prng.randf_range(0.55,0.95)
			var reach := prng.randf_range(0.45,0.85)
			for pair in range(4):
				var t := 0.18+pair*0.20
				var center := direction*reach*t + Vector3.UP*high*sin(t*PI*0.7)
				var length := (1.0-t)*0.22+0.035
				for sign_x in [-1.0,1.0]:
					_append_fern_leaf(st,center,across*sign_x+direction*0.45+Vector3.UP*0.55,length,Color("3e725a"))
			_append_fern_leaf(st,direction*reach*0.84+Vector3.UP*high*0.95,direction,0.18,Color("527f65"))
		# Broad curved ground-cover leaves, clustered across the rolling banks.
		for tuft in range(4):
			var angle := prng.randf()*TAU
			var radius := sqrt(prng.randf())*4.1
			var base := Vector3(cos(angle)*radius,0,sin(angle)*radius)
			for blade in range(3):
				var turn := angle+blade*2.1
				var across := Vector3(cos(turn),0,sin(turn))*prng.randf_range(0.10,0.17)
				var bend := Vector3(sin(turn),0,cos(turn))*prng.randf_range(0.25,0.48)
				var height := prng.randf_range(0.08,0.21)
				for section in range(3):
					for arc in range(6):
						var points: Array[Vector3] = []
						var normals: Array[Vector3] = []
						for q in [Vector2(section,arc),Vector2(section+1,arc),Vector2(section+1,arc+1),Vector2(section,arc+1)]:
							var t: float = q.x/3.0
							var angle_leaf: float = q.y*TAU/6.0
							var width := pow(sin(t*PI),0.65)*0.95+0.015
							var center := base+bend*t+Vector3.UP*sin(t*PI*0.7)*height
							points.append(center+across*width*cos(angle_leaf)+Vector3.UP*width*sin(angle_leaf)*0.045)
							normals.append((across.normalized()*cos(angle_leaf)*0.45+Vector3.UP*sin(angle_leaf)).normalized())
						for k in [0,2,1,0,3,2]:
							st.set_normal(normals[k])
							st.set_color(Color(0.17,0.34,0.29,0.4) if blade%2==0 else Color(0.12,0.27,0.25,0.4))
							st.add_vertex(points[k])

		shrub.mesh = st.commit()
		shrub.scale = Vector3.ONE*1.45
		shrub.material_override = shrub_material
		var side := -1 if i%2==0 else 1
		shrub.position = Vector3(side*prng.randf_range(5.0,24.0),0,-4.0-i*2.9)
		shrub.position.y = _bank_height(shrub.position.x,shrub.position.z)
		# Anchor only the new short grass to sloped banks and protect the corridor.
		var arrays := shrub.mesh.surface_get_arrays(0)
		var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
		for k in range(1080,vertices.size()):
			var v := vertices[k]
			var world_x := shrub.position.x+v.x*1.45
			world_x = maxf(4.25,world_x) if side>0 else minf(-4.25,world_x)
			v.x = (world_x-shrub.position.x)/1.45
			vertices[k] = v
		arrays[Mesh.ARRAY_VERTEX] = vertices
		var grounded_mesh := ArrayMesh.new()
		grounded_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,arrays)
		shrub.mesh = grounded_mesh
		shrub.set_meta("bank_clearance",0.0)
		main_node.add_child(shrub)
		main_node.scene_props.append(shrub)
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
		rock.set_meta("bank_clearance",rock.position.y+0.12)
		rock.position.y += _bank_height(rock.position.x,rock.position.z)+0.12
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
	for prop in game.scene_props:
		if prop.has_meta("bank_clearance"):
			prop.position.y = float(prop.get_meta("bank_clearance"))+_bank_height(prop.position.x,prop.position.z)
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


func _flower_clump(kind: int, rng: RandomNumberGenerator) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var stem_color := Color("5b927c")
	var leaf_color := Color("427a61")
	var blooms := 3 if kind==0 else 5
	for i in range(blooms):
		var base := Vector3(rng.randf_range(-0.35,0.35),0,rng.randf_range(-0.22,0.22))
		var height := rng.randf_range(0.65,1.45) if kind!=2 else rng.randf_range(0.4,0.85)
		_append_stalk(st,base,height,0.025,stem_color)
		for j in range(2):
			var sign_x := -1.0 if j==0 else 1.0
			_append_oval(st,base+Vector3(sign_x*0.15,height*(0.3+j*0.2),0),Vector3(0.23,0.075,0.09),leaf_color)
		var top := base+Vector3.UP*height
		if kind==0:
			for petal in range(5):
				var angle := petal*TAU/5.0
				_append_oval(st,top+Vector3(cos(angle)*0.14,0,sin(angle)*0.14),Vector3(0.13,0.075,0.13),Color("b67acc"))
			_append_oval(st,top+Vector3.UP*0.05,Vector3(0.075,0.065,0.075),Color("e8cda1"))
		elif kind==1:
			_append_oval(st,top,Vector3(0.065,0.18,0.065),Color("9ad7ca"))
		else:
			_append_oval(st,top,Vector3(0.13,0.12,0.13),Color("79b9b1"))
	return st.commit()


func _append_stalk(st: SurfaceTool, base: Vector3, height: float, radius: float, color: Color) -> void:
	for k in range(6):
		var a := k*TAU/6.0
		var b := (k+1)*TAU/6.0
		var n1 := Vector3(cos(a),0,sin(a))
		var n2 := Vector3(cos(b),0,sin(b))
		var points := [base+n1*radius,base+n2*radius,base+n2*radius*0.6+Vector3.UP*height,base+n1*radius*0.6+Vector3.UP*height]
		for idx in [0,1,2,0,2,3]:
			st.set_color(color)
			st.set_normal(n1 if idx==0 or idx==3 else n2)
			st.add_vertex(points[idx])


func _append_oval(st: SurfaceTool, center: Vector3, radii: Vector3, color: Color) -> void:
	for row in range(4):
		for col in range(6):
			var normals: Array[Vector3] = []
			for q in [Vector2(col,row),Vector2(col+1,row),Vector2(col+1,row+1),Vector2(col,row+1)]:
				var phi: float = q.y*PI/4.0
				var theta: float = q.x*TAU/6.0
				normals.append(Vector3(sin(phi)*cos(theta),cos(phi),sin(phi)*sin(theta)))
			for idx in [0,2,1,0,3,2]:
				var n := normals[idx]
				st.set_normal((n/radii).normalized())
				st.set_color(color)
				st.add_vertex(center+n*radii)


func _append_fern_leaf(st: SurfaceTool, base: Vector3, direction: Vector3, length: float, color: Color) -> void:
	var forward := direction.normalized()
	var across := Vector3(-forward.z,0,forward.x)
	for section in range(4):
		var points: Array[Vector3] = []
		for q in [Vector2(section,-1),Vector2(section,1),Vector2(section+1,1),Vector2(section+1,-1)]:
			var t: float = q.x/4.0
			var width := sin(t*PI)*length*0.30
			points.append(base+forward*length*t+across*width*q.y+Vector3.UP*sin(t*PI)*0.035)
		for k in [0,2,1,0,3,2]:
			st.set_color(color)
			st.set_normal(Vector3.UP)
			st.add_vertex(points[k])


func _canopy_mesh(radius: float, seed_id: int) -> ArrayMesh:
	# Irregular layered foliage volumes rather than identical smooth ellipsoids.
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for row in range(8):
		for col in range(12):
			var points: Array[Vector3] = []
			for q in [Vector2(col,row),Vector2(col+1,row),Vector2(col+1,row+1),Vector2(col,row+1)]:
				var phi: float = q.y*PI/8.0
				var theta: float = q.x*TAU/12.0
				var normal := Vector3(sin(phi)*cos(theta),cos(phi),sin(phi)*sin(theta))
				var lobe := 1.0+0.09*sin(theta*5.0+seed_id)*sin(phi*4.0)+0.06*cos(phi*7.0+theta*3.0)
				points.append(normal*radius*lobe*Vector3(1.0,0.78,1.0))
			for k in [0,2,1,0,3,2]:
				st.set_normal(points[k].normalized())
				st.add_vertex(points[k])
	return st.commit()


func layout_moons(size: Vector2) -> void:
	if not active:return
	# One dominant partly framed moon plus quiet distant companions, not a row.
	var landscape := size.x>size.y
	var locations := [Vector2(0.25,0.31),Vector2(0.82,0.29),Vector2(0.69,0.36)] if landscape else [Vector2(0.12,0.35),Vector2(0.84,0.31),Vector2(0.64,0.36)]
	for i in range(game.moons.size()):
		var point: Vector2 = locations[i]*size
		point.y=maxf(244.0,point.y)
		game.moons[i].position=camera_ref.project_position(point,60.0+i*15.0)
		game.moons[i].scale=Vector3.ONE*[1.55,0.75,0.50][i]
