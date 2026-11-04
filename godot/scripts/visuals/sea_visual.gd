extends Node3D
## Scenic sea only. No collision, encounter, story or lane changes.
var game
var landscape:=Node3D.new()
var active:=false
var edge_materials:Array=[]
var water_material:ShaderMaterial
func bind(main_node)->void:
 game=main_node;add_child(landscape)
 for edge in game.track_edges:edge_materials.append(edge.material_override)
 var water=ShaderMaterial.new();water.shader=load("res://scripts/visuals/sea_water.gdshader");water_material=water
 for side in [-1.0,1.0]:
  var surface=MeshInstance3D.new();var mesh=PlaneMesh.new();mesh.size=Vector2(240,360);mesh.subdivide_width=80;mesh.subdivide_depth=90;surface.mesh=mesh;surface.position=Vector3(side*123.5,-0.42,-150);surface.material_override=water;landscape.add_child(surface)
 # Deliberate gaps and unequal silhouettes frame the open forward channel.
 for spec in [[-15.0,-37.0,3.4,3.1], [17.0,-58.0,4.0,4.5],[-39.0,-104.0,5.8,8.0],[68.0,-153.0,9.0,10.0],[-111.0,-230.0,13.0,7.0],[151.0,-270.0,14.0,11.0]]:
  var rock=load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(1+landscape.get_child_count()%3)+".gltf").instantiate();landscape.add_child(rock)
  # Source rocks are roughly 2m across; bury the lower half below sea level.
  rock.scale=Vector3(spec[2],spec[3],spec[2]*0.8);rock.position=Vector3(spec[0],-spec[3]*0.35,spec[1]);rock.rotation.y=spec[0]*0.13;_rock_material(rock)
 landscape.visible=false
func apply(index:int)->void:
 active=index==3 and not game.options.get("light",false)
 landscape.visible=active
 if not active:
  for i in range(game.track_edges.size()):game.track_edges[i].material_override=edge_materials[i]
  return
 water_material.set_shader_parameter("animate",not game.options.get("motion",false))
 game.env_world.environment.fog_light_color=Color("102c3e")
 game.env_world.environment.fog_depth_begin=25.0
 game.env_world.environment.fog_depth_end=170.0
 for side in game.side_planes:side.visible=false
 for edge in game.track_edges:
  edge.visible=true
  edge.material_override=game.material(Color("568a94"))
 var water=ShaderMaterial.new();water.shader=load("res://scripts/visuals/sea_water.gdshader");water.set_shader_parameter("path_surface",true);game.ground.material_override=water
 var rings=StandardMaterial3D.new();rings.albedo_color=Color("477b88");rings.roughness=0.9
 for prop in game.scene_props:
  prop.material_override=rings
  prop.visible=false
func _rock_material(node:Node)->void:
 if node is MeshInstance3D:
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/sea_rock.gdshader");node.material_override=mat
 for child in node.get_children():_rock_material(child)
