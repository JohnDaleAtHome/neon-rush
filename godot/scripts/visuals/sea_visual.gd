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
 var surf=MeshInstance3D.new();surf.name="StackSurf";surf.mesh=_surf()
 var surf_mat=ShaderMaterial.new();surf_mat.shader=load("res://scripts/visuals/sea_surf.gdshader");surf.material_override=surf_mat;landscape.add_child(surf)
 var causeway=MeshInstance3D.new();causeway.name="StoneCauseway";causeway.mesh=_causeway()
 var stone=ShaderMaterial.new();stone.shader=load("res://scripts/visuals/sea_causeway.gdshader");stone.set_shader_parameter("stone",load("res://assets/visuals/nature_cc0/Rocks_Diffuse.png"));causeway.material_override=stone;landscape.add_child(causeway)
 landscape.visible=false
func apply(index:int)->void:
 if index==3:game.sky_stars.visible=false
 active=index==3 and not game.options.get("light",false)
 landscape.visible=active
 if not active:
  for i in range(game.track_edges.size()):game.track_edges[i].material_override=edge_materials[i]
  return
 water_material.set_shader_parameter("animate",not game.options.get("motion",false))
 landscape.get_node("StackSurf").material_override.set_shader_parameter("animate",not game.options.get("motion",false))
 var sky=game.env_world.environment.sky;var sky_mat=ShaderMaterial.new();sky_mat.shader=load("res://scripts/visuals/sea_sky.gdshader")
 sky_mat.set_shader_parameter("camera_forward",-game.camera.global_basis.z);sky_mat.set_shader_parameter("camera_up",game.camera.global_basis.y);sky_mat.set_shader_parameter("vertical_tangent",tan(deg_to_rad(game.camera.fov)/2.0));sky.sky_material=sky_mat;game.env_world.environment.sky=sky
 game.env_world.environment.fog_light_color=Color("102c3e")
 game.env_world.environment.fog_depth_begin=25.0
 game.env_world.environment.fog_depth_end=170.0
 for side in game.side_planes:side.visible=false
 for edge in game.track_edges:
  edge.visible=true
  edge.material_override=game.material(Color("568a94"))
 var paving=ShaderMaterial.new();paving.shader=load("res://scripts/visuals/sea_causeway.gdshader");paving.set_shader_parameter("path_surface",true);game.ground.material_override=paving
 var rings=StandardMaterial3D.new();rings.albedo_color=Color("477b88");rings.roughness=0.9
 for prop in game.scene_props:
  prop.material_override=rings
  prop.visible=false
func _rock_material(node:Node)->void:
 if node is MeshInstance3D:
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/sea_rock.gdshader");node.material_override=mat
 for child in node.get_children():_rock_material(child)

func _surf()->ArrayMesh:
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
 # Unequal broken shore ribbons around off-track stacks, never in playable lanes.
 var specs=[[-15.0,-37.0,4.6,3.8],[17.0,-58.0,5.5,4.6],[-39.0,-104.0,7.6,6.5],[68.0,-153.0,11.2,9.4],[-111.0,-230.0,15.5,11.4],[151.0,-270.0,16.5,12.8]]
 for stack in range(specs.size()):
  var spec=specs[stack]
  for band in range(2):
   for i in range(56):
    if (i+stack*3+band)%7>4:continue
    var points=[]
    for q in [Vector2(i,0),Vector2(i,1),Vector2(i+1,1),Vector2(i+1,0)]:
     var angle=q.x*TAU/56.0;var irregular=1.0+0.09*sin(angle*5.0+stack)+0.05*cos(angle*3.0)
     var radius=irregular*(1.0+float(band)*0.22+q.y*0.055)
     points.append(Vector3(spec[0]+cos(angle)*spec[2]*radius,-0.36,spec[1]+sin(angle)*spec[3]*radius))
    for k in [0,2,1,0,3,2]:st.add_vertex(points[k])
 st.generate_normals();return st.commit()
# End of original off-track surf ribbons.

func layout_moons(size:Vector2)->void:
 # One restrained lunar landmark. World index also keeps Light mode coherent.
 for i in range(3):game.moons[i].scale=Vector3.ONE*(0.34 if i==0 else 0.001)
 game.moons[0].position=game.camera.project_position(Vector2(size.x*0.81,size.y*0.30),60.0)

# Original low coping and posts, one surface and no collision. Lane is unchanged.
func _causeway()->ArrayMesh:
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
 for side in [-1.0,1.0]:
  _box(st,Vector3(side*3.84,-.30,-125),Vector3(.48,.7,300))
  for i in range(30):_box(st,Vector3(side*3.84,.15,20-i*10),Vector3(.66,.85,.66))
 return st.commit()
func _box(st:SurfaceTool,center:Vector3,size:Vector3)->void:
 var mesh=BoxMesh.new();mesh.size=size
 var a=mesh.get_mesh_arrays();var verts=a[Mesh.ARRAY_VERTEX];var normals=a[Mesh.ARRAY_NORMAL];var indices=a[Mesh.ARRAY_INDEX]
 for i in indices:
  st.set_normal(normals[i]);st.add_vertex(verts[i]+center)
