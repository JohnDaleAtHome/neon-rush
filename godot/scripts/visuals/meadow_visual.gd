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
var import_materials: Dictionary = {}
var rolling_banks: Array[MeshInstance3D] = []
var saved_ambient_color := Color.BLACK
var saved_ambient_energy := 1.0
var ambient_saved := false

const MEADOW_FOG := Color("244752")
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
		for edge in game.track_edges: edge.visible = true
		if shadow: shadow.visible = false
		_set_horizon_visible(false)
		_restore_ambient()
		game.layout_moons(game.get_viewport().get_visible_rect().size)
		return
	active = true
	for side in game.side_planes: side.visible = false
	for edge in game.track_edges: edge.visible = false
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
	environment.ambient_light_color = Color("c5d8ef")
	environment.ambient_light_energy = 0.72
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
	# Low foothills connect the open clearing to the distant silhouette.
	for side in [-1.0,1.0]:
		var land=MeshInstance3D.new();var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
		for row in range(30):
			for col in range(24):
				var points=[]
				for q in [Vector2(col,row),Vector2(col+1,row),Vector2(col+1,row+1),Vector2(col,row+1)]:
					var x=side*(42.0+q.x*6.5);var z=18.0-q.y*8.0
					var rise=smoothstep(42.0,85.0,absf(x))*smoothstep(-20.0,75.0,-z)
					var y=-0.14+rise*(5.0+3.0*sin(x*0.045+z*0.025)+2.0*sin(z*0.06))
					points.append(Vector3(x,y,z))
				for k in ([0,2,1,0,3,2] if side>0 else [0,1,2,0,2,3]):st.add_vertex(points[k])
		st.generate_normals();land.mesh=st.commit();var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/meadow_bank.gdshader");mat.set_shader_parameter("fog_color",MEADOW_FOG);land.material_override=mat;horizon_root.add_child(land)

	# Three-dimensional overlapping hills, not a vertical skyline strip.
	var hrng := RandomNumberGenerator.new()
	hrng.seed = 230011
	for layer in range(2):
		for i in range(11):
			var hill := MeshInstance3D.new()
			var mesh := SphereMesh.new()
			mesh.radius = 1.0
			mesh.height = 2.0
			mesh.radial_segments = 7
			mesh.rings = 4
			hill.mesh = mesh
			hill.scale = Vector3(hrng.randf_range(22,38),hrng.randf_range(12,26),hrng.randf_range(24,40))
			var hill_x := -190.0+i*38.0+hrng.randf_range(-6,6)
			var center_recede := (1.0-smoothstep(25.0,90.0,absf(hill_x)))*85.0
			hill.position = Vector3(hill_x,-4.0,-105.0-layer*45.0-center_recede+hrng.randf_range(-12,12))
			var hm := ShaderMaterial.new()
			hm.shader = load("res://scripts/visuals/meadow_ridge.gdshader")
			hm.set_shader_parameter("grass_low",Vector3(0.04,0.10,0.065))
			hm.set_shader_parameter("grass_high",Vector3(0.06,0.14,0.09))
			hm.set_shader_parameter("ridge_color",Vector3(0.055,0.13,0.17) if layer==0 else Vector3(0.10,0.19,0.23))
			hill.material_override = hm
			horizon_root.add_child(hill)
			horizon_layers.append(hill)
	# A staggered left foothill line closes the flat underlay horizon without
	# rebuilding a full-height trough around the player.
	for spec in [[-66.0,-78.0,35.0,8.0,24.0],[-95.0,-112.0,45.0,12.0,28.0],[-34.0,-110.0,20.0,6.0,22.0],[71.0,-121.0,38.0,10.0,30.0]]:
		var hill=MeshInstance3D.new();var mesh=SphereMesh.new();mesh.radius=1.0;mesh.height=2.0;mesh.radial_segments=9;mesh.rings=5
		hill.mesh=mesh;hill.scale=Vector3(spec[2],spec[3],spec[4]);hill.position=Vector3(spec[0],-4.0,spec[1])
		var material=ShaderMaterial.new();material.shader=load("res://scripts/visuals/meadow_ridge.gdshader");material.set_shader_parameter("ridge_color",Vector3(0.055,0.16,0.17));hill.material_override=material;horizon_root.add_child(hill)
	# Reference study: grouped foliage, rocky side landforms and a quiet central vista.
	# Actual CC0 Quaternius meshes replace the old primitive crown trees.
	var rng := RandomNumberGenerator.new()
	rng.seed = 771203
	for i in range(20):
		var side := -1.0 if i%2==0 else 1.0
		var z: float = [-24,-39,-51,-68,-72,-88,-99,-110,-118,-130,-135,-139,-28,-45,-57,-75,-91,-102,-114,-124][i]+rng.randf_range(-3,3)
		var x := side*(15.0+rng.randf_range(0,15)+float(i%3)*3.0)+sin(i*2.7)*4.0
		var name: String = ["CommonTree_3","CommonTree_3","CommonTree_5"][i%3]
		var tree = load("res://assets/visuals/nature_cc0/"+name+".gltf").instantiate()
		tree.position=Vector3(x,_bank_height(x,z),z)
		tree.scale=Vector3.ONE*rng.randf_range(1.0,2.0)
		tree.rotation.y=rng.randf_range(-PI,PI)
		_tint_import(tree,Color("82baa6"))
		horizon_root.add_child(tree)
	for i in range(14):
		var side := -1.0 if i%2==0 else 1.0
		var z := -18.0-float(i/2)*17.0
		var x := side*(10.0+rng.randf_range(0,23))
		var name: String = ["Rock_Medium_1","Rock_Medium_2","Rock_Medium_3"][i%3]
		var rock = load("res://assets/visuals/nature_cc0/"+name+".gltf").instantiate()
		rock.position=Vector3(x,_bank_height(x,z)-0.3,z)
		rock.scale=Vector3(2.0,1.6,1.8)*rng.randf_range(0.8,1.6)
		rock.rotation.y=rng.randf_range(-PI,PI)
		_tint_import(rock,Color("7a9eab"))
		horizon_root.add_child(rock)
	for i in range(12):
		var side := -1.0 if i%2==0 else 1.0
		var z := -12.0-float(i/2)*19.0+rng.randf_range(-5,5)
		var x := side*(8.0+rng.randf_range(0,19))
		var bush = load("res://assets/visuals/nature_cc0/Bush_Common.gltf").instantiate()
		bush.position=Vector3(x,_bank_height(x,z),z)
		bush.scale=Vector3.ONE*rng.randf_range(1.0,1.8)
		_tint_import(bush,Color("88b69d"))
		horizon_root.add_child(bush)

	# Asymmetric broken bluff. Low inner contact, clustered mass on the right.
	for spec in [[13,-28,14,5.5,18],[20,-42,22,9,24],[31,-58,28,15,28],[15,-70,15,7,22],[30,-92,25,12,26],[-19,-67,15,6,18],[-30,-84,22,10,24],[-40,-105,25,14,24]]:
		var cliff=load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(1+int(abs(spec[1]))%3)+".gltf").instantiate()
		cliff.position=Vector3(spec[0],0,spec[1]);_size_import(cliff,Vector3(spec[2],spec[3],spec[4]));cliff.rotation.y=0.18*sin(float(spec[1]))
		_tint_import(cliff,Color("91abc0"));cliff.set_meta("clearing_bluff",true);horizon_root.add_child(cliff)

	# Reference-informed focal grouping: one old moon-dew tree on a rocky shoulder.
	# This is scenery, not a replacement objective, gate or bridge-piece reward.
	var landmark=load("res://assets/visuals/nature_cc0/CommonTree_3.gltf").instantiate()
	landmark.position=Vector3(-6.0,4.0,-175.0)
	landmark.scale=Vector3.ONE
	_size_import(landmark,Vector3(36.0,40.0,30.0))
	landmark.rotation.y=0.7
	_tint_import(landmark,Color("a0bec3"))
	_landmark_haze(landmark)
	horizon_root.add_child(landmark)
	landmark.set_meta("distant_landmark",true)
	var knoll=MeshInstance3D.new()
	var knoll_mesh=SphereMesh.new()
	knoll_mesh.radius=1.0;knoll_mesh.height=2.0;knoll_mesh.radial_segments=24;knoll_mesh.rings=12
	knoll.mesh=knoll_mesh;knoll.position=Vector3(-6.0,-3.5,-175.0);knoll.scale=Vector3(28.0,8.0,22.0)
	var knoll_mat=ShaderMaterial.new();knoll_mat.shader=load("res://scripts/visuals/meadow_ridge.gdshader")
	knoll_mat.set_shader_parameter("ridge_color",Vector3(0.08,0.19,0.20));knoll.material_override=knoll_mat
	horizon_root.add_child(knoll)
	for spec in [[-39.0,-138.0,27.0,30.0,22.0],[39.0,-150.0,30.0,25.0,25.0]]:
		var stone=load("res://assets/visuals/nature_cc0/Rock_Medium_1.gltf").instantiate()
		stone.position=Vector3(spec[0],_bank_height(spec[0],spec[1])-0.7,spec[1])
		stone.scale=Vector3.ONE
		_size_import(stone,Vector3(spec[2],spec[3],spec[4]))
		stone.rotation.y=0.3
		_tint_import(stone,Color("8aa1a6"))
		horizon_root.add_child(stone)

	for model in horizon_root.get_children():
		if model.scene_file_path.begins_with("res://assets/visuals/nature_cc0/"):
			var box=_import_bounds(model,Transform3D.IDENTITY)
			var bottom=INF
			var world_box=model.transform*box
			for corner in range(8):bottom=minf(bottom,(model.transform*box.get_endpoint(corner)).y)
			var support=INF
			for sample in range(9):
				var px=world_box.position.x+world_box.size.x*float(sample%3)/2.0
				var pz=world_box.position.z+world_box.size.z*float(sample/3)/2.0
				support=minf(support,_bank_height(px,pz))
			var rock="Rock" in model.scene_file_path
			model.position.y+=(4.0 if model.has_meta("distant_landmark") else support if rock else _bank_height(model.position.x,model.position.z))-bottom-(0.3 if rock else 0.15)
			if model.has_meta("clearing_bluff"):
				model.position.y=0
				model.position.y=_bank_height(signf(model.position.x)*5.5,model.position.z)-(model.transform*box).position.y-2.2


	# Distant tree silhouettes use authored model renders, keeping the same layout
	# and visual density without processing every leaf triangle at tiny screen size.
	var replacements=[]
	for model in horizon_root.get_children():
		if model.scene_file_path.contains("CommonTree") and model.position.z < -68.0 and not model.has_meta("distant_landmark"):
			replacements.append(model)
	for model in replacements:
		var box=model.transform*_import_bounds(model,Transform3D.IDENTITY)
		var name=model.scene_file_path.get_file().get_basename()
		var size=9.8022 if name=="CommonTree_3" else 7.28649
		var plane=MeshInstance3D.new();var quad=QuadMesh.new()
		quad.size=Vector2.ONE*size*model.scale.y;plane.mesh=quad
		plane.position=Vector3(box.get_center().x,box.get_center().y,model.position.z)
		var material=ShaderMaterial.new();material.shader=load("res://scripts/visuals/nature_impostor.gdshader")
		material.set_shader_parameter("tree_texture",load("res://assets/visuals/nature_cc0/"+name+"_impostor.png"));plane.material_override=material
		plane.set_meta("tree_impostor",true);plane.set_meta("source_bounds",box);horizon_root.add_child(plane)
		horizon_root.remove_child(model);model.queue_free()

func _landmark_haze(node:Node)->void:
	if node is MeshInstance3D:
		for i in range(node.mesh.get_surface_count()):
			var mat=node.get_surface_override_material(i).duplicate()
			mat.set_shader_parameter("fog_end",340.0)
			mat.set_shader_parameter("tint",Vector3(0.52,0.72,0.63) if mat.get_shader_parameter("foliage") else Vector3(0.65,0.73,0.68))
			node.set_surface_override_material(i,mat)
	for child in node.get_children():_landmark_haze(child)

func _import_bounds(node:Node,base:Transform3D) -> AABB:
	var result=AABB()
	var found=false
	for child in node.get_children():
		var transform:Transform3D=base*child.transform if child is Node3D else base
		if child is MeshInstance3D:
			var box: AABB=transform*child.get_aabb()
			result=result.merge(box) if found else box
			found=true
		var nested=_import_bounds(child,transform)
		if nested.size.length()>0:
			result=result.merge(nested) if found else nested
			found=true
	return result

func _size_import(node:Node3D,target:Vector3)->void:
	var box=_import_bounds(node,Transform3D.IDENTITY)
	node.scale=target/box.size

func _tint_import(node: Node, tint: Color) -> void:
	if node is MeshInstance3D:
		for i in range(node.mesh.get_surface_count()):
			var mat = node.mesh.surface_get_material(i)
			if mat is StandardMaterial3D:
				var key: String = mat.albedo_texture.resource_path+str(tint)
				if import_materials.has(key):
					node.set_surface_override_material(i,import_materials[key])
					continue
				var copy = ShaderMaterial.new()
				copy.shader=load("res://scripts/visuals/nature_moonlit.gdshader" if "Leaves" in mat.resource_name else "res://scripts/visuals/nature_opaque.gdshader")
				copy.set_shader_parameter("base_texture",mat.albedo_texture)
				var is_leaf: bool = "Leaves" in mat.resource_name
				copy.set_shader_parameter("foliage",is_leaf)
				copy.set_shader_parameter("tint",Vector3(0.16,0.44,0.34) if is_leaf else Vector3(tint.r,tint.g,tint.b))
				import_materials[key]=copy
				node.set_surface_override_material(i,copy)
	for child in node.get_children():_tint_import(child,tint)


func _bank_height(x: float,z: float) -> float:
	var edge=smoothstep(4.0,12.0,absf(x))
	var rear=1.0-smoothstep(112.0,144.0,-z)
	var outer=1.0-smoothstep(44.0,53.8,absf(x))
	var low=0.65+0.45*sin(z*0.06+x*0.10)
	var bluff=0.0
	if x>0:
		bluff=3.0*exp(-pow((x-23.0)/16.0,2.0)-pow((z+54.0)/48.0,2.0))
	return -0.14+edge*rear*outer*(low+bluff)

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
		var drift := int(i/4)
		plant.position = Vector3(side*(6.0+float(i%4)*2.7+prng.randf()*2.0),0,-8.0-float(drift)*15.5-float(i%4)*0.7)
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
		# Dense meadow drifts: many narrow tapered blades, not sparse broad shards.
		for blade in range(72):
			var angle := prng.randf()*TAU
			var radius := sqrt(prng.randf())*1.65
			var base := Vector3(cos(angle)*radius,0,sin(angle)*radius)
			var turn := angle+prng.randf_range(-1.0,1.0)
			var across := Vector3(cos(turn),0,sin(turn))*prng.randf_range(0.025,0.055)
			var bend := Vector3(sin(turn),0,cos(turn))*prng.randf_range(0.10,0.25)
			var height := prng.randf_range(0.25,0.65)*(1.0-radius*0.22)
			for section in range(3):
				var points: Array[Vector3] = []
				for q in [Vector2(section,-1),Vector2(section,1),Vector2(section+1,1),Vector2(section+1,-1)]:
					var t: float = q.x/3.0
					var width := (1.0-t)*0.85+0.02
					points.append(base+bend*t*t+Vector3.UP*height*t+across*width*q.y)
				for k in [0,2,1,0,3,2]:
					st.set_normal((Vector3.UP*0.65+across.normalized()*0.35).normalized())
					st.set_color(Color(0.10,0.23,0.23,0.4).lerp(Color(0.24,0.42,0.39,0.4),float(section)/3.0))
					st.add_vertex(points[k])

		shrub.mesh = st.commit()
		shrub.scale = Vector3.ONE*1.45
		shrub.material_override = shrub_material
		var side := -1 if i%2==0 else 1
		var drift := int(i/6)
		var tier := i%6
		shrub.position = Vector3(side*(6.2+float(tier%3)*5.0+sin(drift*1.7)*1.8),0,-5.0-float(drift)*17.0-float(tier/3)*4.0-prng.randf()*4.0)
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
				var lobe := 1.0+0.14*sin(theta*5.0+seed_id)*sin(phi*4.0)+0.08*cos(phi*7.0+theta*3.0)
				points.append(normal*radius*lobe*Vector3(1.0,0.78,1.0))
			for k in [0,2,1,0,3,2]:
				st.set_normal(points[k].normalized())
				st.add_vertex(points[k])
	return st.commit()


func layout_moons(size: Vector2) -> void:
	if not active:return
	# One dominant partly framed moon plus quiet distant companions, not a row.
	var landscape := size.x>size.y
	var locations := [Vector2(0.25,0.31),Vector2(0.84,0.31),Vector2(0.73,0.35)] if landscape else [Vector2(0.12,0.30),Vector2(0.84,0.31),Vector2(0.70,0.35)]
	for i in range(game.moons.size()):
		var point: Vector2 = locations[i]*size
		point.y=maxf(244.0,point.y)
		var depth := 60.0+i*15.0
		game.moons[i].scale=Vector3.ONE*[0.88,0.42,0.28][i]
		var provisional := camera_ref.project_position(point,depth)
		var radius:float=game.moons[i].mesh.radius*game.moons[i].scale.x
		var projected_top := camera_ref.unproject_position(provisional+camera_ref.global_basis.y*radius)
		point.y=maxf(point.y,225.0+point.y-projected_top.y)
		game.moons[i].position=camera_ref.project_position(point,depth)
