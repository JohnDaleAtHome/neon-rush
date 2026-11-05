extends Node3D
## Chinese courtyard study. Decorative, no gameplay collision.
var game
var landscape:=Node3D.new()
var active:=false
func bind(main_node)->void:
 game=main_node;add_child(landscape)
 for spec in [[-16.0,-34.0,0.30]]:
  var pavilion=load("res://assets/visuals/chinese_pavilion_cc0/pavilion.glb").instantiate()
  landscape.add_child(pavilion);pavilion.position=Vector3(spec[0],0.0,spec[1]);pavilion.scale=Vector3.ONE*spec[2];pavilion.rotation.y=0.2
  _pavilion_materials(pavilion)
  _box(pavilion,Vector3(41.0,1.2,41.0),Vector3(0,-0.6,0),Color("686d66"))
 for spec in [[23.0,-73.0,0.37],[-33.0,-124.0,0.42]]:
  var far=Node3D.new();landscape.add_child(far);far.position=Vector3(spec[0],0,spec[1]);far.scale=Vector3.ONE*spec[2]
  var sprite=MeshInstance3D.new();var quad=QuadMesh.new();quad.size=Vector2(52,52);sprite.mesh=quad;sprite.position=Vector3(0,17.5,0);sprite.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/pavilion_far.gdshader");mat.set_shader_parameter("facade",load("res://assets/visuals/chinese_pavilion_cc0/pavilion_far.png"));sprite.material_override=mat;far.add_child(sprite)
  _box(far,Vector3(41.0,1.2,41.0),Vector3(0,-0.6,0),Color("686d66"))
 # Side terraces and low balustrades leave the central lane sight line open.
 for side in [-1.0,1.0]:
  var terrace=MeshInstance3D.new();var floor_mesh=BoxMesh.new();floor_mesh.size=Vector3(52,0.5,235);terrace.mesh=floor_mesh;terrace.position=Vector3(side*30.0,-0.55,-90);var paving=ShaderMaterial.new();paving.shader=load("res://scripts/visuals/palace_stone.gdshader");terrace.material_override=paving;landscape.add_child(terrace)
  for i in range(17):
   _box(landscape,Vector3(0.45,0.8,0.45),Vector3(side*5.1,0.1,12.0-i*13.0),Color("8b8e80"))
  _box(landscape,Vector3(0.20,0.18,221),Vector3(side*5.1,0.55,-92),Color("a2a58f"))
 var gate=Node3D.new();gate.name="MoonlightGate";landscape.add_child(gate);gate.position=Vector3(0,0,-145);gate.scale=Vector3(1.05,0.65,1.0)
 for side in [-1.0,1.0]:
  var tower=Node3D.new();gate.add_child(tower);tower.position=Vector3(side*15.0,0,0)
  _box(tower,Vector3(10,1.2,12),Vector3(0,0,0),Color("76778f"))
  _box(tower,Vector3(8.8,1.0,10.8),Vector3(0,1.0,0),Color("9390a4"))
  for x in [-3.3,3.3]:
   for z in [-4.0,4.0]:_box(tower,Vector3(0.75,17,0.75),Vector3(x,10,z),Color("673853"))
  _box(tower,Vector3(5.8,14.5,7.2),Vector3(0,9.0,0),Color("5d526d"))
  _box(tower,Vector3(1.6,9.5,0.2),Vector3(0,10.0,3.7),Color("847392"))
  _box(tower,Vector3(8,0.7,9),Vector3(0,18.0,0),Color("b8a77f"))
  for tier in range(2):
   var roof=MeshInstance3D.new();roof.mesh=_roof(7.0-float(tier)*1.3,6.0-float(tier)*1.2,18.5+float(tier)*2.7);roof.material_override=_material(Color("35435b"));roof.material_override.cull_mode=BaseMaterial3D.CULL_DISABLED;tower.add_child(roof)
 _box(gate,Vector3(22,1.0,3),Vector3(0,18.0,0),Color("c8b88e"))
 var central_roof=MeshInstance3D.new();central_roof.mesh=_roof(12.0,4.8,18.7);central_roof.material_override=_material(Color("35435b"));central_roof.material_override.cull_mode=BaseMaterial3D.CULL_DISABLED;gate.add_child(central_roof)

 for i in range(5):
  var light=MeshInstance3D.new();var sphere=SphereMesh.new();sphere.radius=0.8;sphere.height=1.6;sphere.radial_segments=12;sphere.rings=6;light.mesh=sphere;light.position=Vector3(-6.4+float(i)*3.2,16.4,2.3);var light_mat=_material(Color("e4d6a6"));light_mat.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED;light.material_override=light_mat;gate.add_child(light)
 _batch_gate(gate)
 _courtyard_edges()
 landscape.visible=false
func apply(index:int)->void:
 active=index==5 and not game.options.get("light",false);landscape.visible=active
 if index!=5:return
 game.scenery.visible=false
 for side in game.side_planes:
  side.visible=not active
  if not active:
   var side_mat=ShaderMaterial.new();side_mat.shader=load("res://scripts/visuals/palace_stone.gdshader");side.material_override=side_mat
 for edge in game.track_edges:edge.visible=false
 var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/palace_stone.gdshader");game.ground.material_override=mat
 game.env_world.environment.fog_light_color=Color("606c69")
 game.world_sun.light_energy=0.95
 game.env_world.environment.fog_depth_end=220.0
 var sky_mat=game.env_world.environment.sky.sky_material;sky_mat.shader=load("res://scripts/visuals/garden_sky.gdshader")
 game.sky_stars.visible=false
 game.layout_moons(game.get_viewport().get_visible_rect().size)
func _material(color:Color)->StandardMaterial3D:
 var mat=StandardMaterial3D.new();mat.albedo_color=color;mat.roughness=0.85;return mat
func _box(parent:Node3D,size:Vector3,at:Vector3,color:Color)->void:
 var node=MeshInstance3D.new();var mesh=BoxMesh.new();mesh.size=size;node.mesh=mesh;node.position=at;node.material_override=_material(color);parent.add_child(node)
func _roof(width:float,length:float,y:float)->ArrayMesh:
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
 # A simple hipped roof with lifted corner tips, not a box or pyramid.
 var rings=[]
 var outline=[Vector2(-1,-1),Vector2(0,-1),Vector2(1,-1),Vector2(1,0),Vector2(1,1),Vector2(0,1),Vector2(-1,1),Vector2(-1,0)]
 for ring in range(3):
  var points=[]
  for k in range(8):
   var q:Vector2=outline[k]
   var x=q.x*width*[0.24,0.68,1.0][ring]
   var z=q.y*length*[0.04,0.68,1.0][ring]
   var corner=absf(q.x*q.y)
   points.append(Vector3(x,y+[1.65,0.30,0.0][ring]+(0.55*corner if ring==2 else 0.0),z))
  rings.append(points)
 for row in range(2):
  for i in range(8):
   var next=(i+1)%8
   for v in [rings[row][i],rings[row+1][next],rings[row+1][i],rings[row][i],rings[row][next],rings[row+1][next]]:st.add_vertex(v)
 # Thickness along outer eaves makes the upturned perimeter read as a roof.
 for i in range(8):
  var next=(i+1)%8;var a:Vector3=rings[2][i];var b:Vector3=rings[2][next]
  var low_a=a-Vector3(0,0.18,0);var low_b=b-Vector3(0,0.18,0)
  for v in [a,low_b,b,a,low_a,low_b]:st.add_vertex(v)
 st.generate_normals();return st.commit()
func layout_moons(size:Vector2)->void:
 if game.visual_world_index!=5:return
 var short_landscape=size.x>size.y and size.y<650
 for i in range(3):
  landscape.get_child(i).position.x=[-16.0,23.0,-33.0][i]*(1.7 if short_landscape else 1.8 if size.x>size.y else 1.0)
 for i in range(game.moons.size()):
  game.moons[i].scale=Vector3.ONE*(0.4 if i==0 else 0.001)
  game.moons[i].position=game.camera.project_position(Vector2(size.x*0.88,size.y*0.29 if short_landscape else maxf(245.0,size.y*0.30)),60.0+i*15.0)
# End of palace visual study.

func _batch_gate(gate:Node3D)->void:
 # Static scenic geometry only. Merge equal materials to avoid tiny far draw calls.
 var batches={}
 _collect_gate(gate,Transform3D.IDENTITY,batches)
 for child in gate.get_children():gate.remove_child(child);child.queue_free()
 for key in batches:
  var entry=batches[key];var mesh=MeshInstance3D.new()
  mesh.mesh=entry[0].commit();mesh.material_override=entry[1];gate.add_child(mesh)
 gate.set_meta("light_count",5)
func _collect_gate(node:Node3D,transform:Transform3D,batches:Dictionary)->void:
 if node is MeshInstance3D:
  var mat=node.material_override
  var key=str(mat.albedo_color)+":"+str(mat.shading_mode)+":"+str(mat.cull_mode)
  if not batches.has(key):
   var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES);batches[key]=[st,mat]
  for i in range(node.mesh.get_surface_count()):batches[key][0].append_from(node.mesh,i,transform)
 for child in node.get_children():
  if child is Node3D:_collect_gate(child,transform*child.transform,batches)

func _pavilion_materials(node:Node):
 if node is MeshInstance3D:
  node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
  for i in range(node.mesh.get_surface_count()):
   var src=node.mesh.surface_get_material(i)
   if src is StandardMaterial3D:
    var mat=src.duplicate();var c=mat.albedo_color
    if c.r>0.6 and c.r>c.g*1.5:mat.albedo_color=Color("633b40")
    elif c.r<0.30:mat.albedo_color=Color("34464a")
    mat.roughness=0.95;node.set_surface_override_material(i,mat)
 for child in node.get_children():_pavilion_materials(child)

func _courtyard_edges():
 var edges=Node3D.new();edges.name="CourtyardBoundary";landscape.add_child(edges)
 for side in [-1.0,1.0]:
  for i in range(4):
   var at=Vector3(side*39.0,1.6,2.0-float(i)*52.0)
   _box(edges,Vector3(0.7,4.0,50.0),at,Color("8c9281"))
   _box(edges,Vector3(1.2,0.3,50.5),at+Vector3(0,2.0,0),Color("3a4945"))
  for i in range(3):
   var at=Vector3(side*(11.0+float(i)*4.0),-0.1,-16.0-float(i)*40.0)
   _box(edges,Vector3(3.8,0.9,8.0),at,Color("626f62"))
   var bush=load("res://assets/visuals/nature_cc0/Bush_Common.gltf").instantiate();landscape.add_child(bush);bush.position=at+Vector3(0,0.4,0);bush.scale=Vector3(2.2,1.2,4.0)
   _plant_material(bush)
 _batch_gate(edges)
func _plant_material(node:Node):
 if node is MeshInstance3D:
  node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
  var mat=StandardMaterial3D.new();mat.albedo_color=Color("374f36");mat.roughness=1.0;node.material_override=mat
 for child in node.get_children():_plant_material(child)
