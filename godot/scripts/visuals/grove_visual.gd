extends Node3D
## Chinese garden study. Decoration only; CC0 pavilion and nature models.
var game
var landscape:=Node3D.new()
var active:=false
func bind(main_node)->void:
 game=main_node;add_child(landscape)
 # Unequal clusters, not matched avenue rows. Leave central sky and all lanes open.
 var trees=[[-8.5,-16.0,0.9],[9.5,-32.0,1.0],[-9.0,-51.0,0.85],[8.5,-83.0,1.0],[-9.5,-108.0,1.0],[9.0,-150.0,1.1],[-23.0,-8.0,1.8],[28.0,-30.0,2.2],[-36.0,-55.0,2.5],[34.0,-101.0,2.1],[-39.0,-128.0,2.5],[43.0,-182.0,3.0],[-12.0,9.0,1.4], [15.0,-5.0,1.6],[-17.0,-27.0,1.8],[12.0,-43.0,1.25],[-10.0,-67.0,1.1],[22.0,-75.0,2.0],[-26.0,-90.0,1.7],[13.0,-116.0,1.4],[-18.0,-142.0,1.6],[28.0,-161.0,2.2],[-33.0,-185.0,2.4],[16.0,-208.0,1.8]]
 for i in range(trees.size()):
  var spec=trees[i]
  if i==14:continue # Near left tree is replaced by the pavilion, not layered behind it.
  var tree=load("res://assets/visuals/nature_cc0/"+["CommonTree_3","CommonTree_3","CommonTree_5"][i%3]+".gltf").instantiate()
  landscape.add_child(tree);tree.position=Vector3(spec[0],0,spec[1])
  var bounds=_bounds(tree,Transform3D.IDENTITY)
  tree.scale=Vector3(5.5,10.0,5.5)/bounds.size*spec[2]
  tree.rotation.y=i*1.73
  var box=tree.transform*_bounds(tree,Transform3D.IDENTITY)
  var nearest=box.position.x if tree.position.x>0 else box.end.x
  if absf(nearest)<4.2:tree.position.x+=signf(tree.position.x)*(4.2-absf(nearest))
  box=tree.transform*_bounds(tree,Transform3D.IDENTITY)
  tree.position.y=_height(tree.position.x,tree.position.z)-box.position.y
  if tree.position.z < -42.0:
   box=tree.transform*_bounds(tree,Transform3D.IDENTITY)
   var plane=MeshInstance3D.new();var quad=QuadMesh.new();quad.size=Vector2(box.size.x,box.size.y);plane.mesh=quad;plane.position=box.get_center()
   var material=ShaderMaterial.new();material.shader=load("res://scripts/visuals/grove_impostor.gdshader")
   material.set_shader_parameter("tree_texture",load("res://assets/visuals/nature_cc0/"+["CommonTree_3","CommonTree_3","CommonTree_5"][i%3]+"_impostor.png"));plane.material_override=material
   landscape.remove_child(tree);tree.queue_free();landscape.add_child(plane)
  else:_tint(tree)
 for i in range(12):
  var side=-1.0 if i%2==0 else 1.0
  var rock=load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(i%3+1)+".gltf").instantiate();landscape.add_child(rock);rock.position=Vector3(side*(6.2+(i%4)*2.5),-0.25,-12.0-i*13.0);rock.position.y=_height(rock.position.x,rock.position.z)-0.25;rock.scale=Vector3(1.8+(i%3)*0.7,1.2+(i%2)*0.8,2.1);rock.rotation.y=i*1.2
  var rb=rock.transform*_bounds(rock,Transform3D.IDENTITY)
  var nearest=rb.position.x if rock.position.x>0 else rb.end.x
  if absf(nearest)<4.2:rock.position.x+=signf(rock.position.x)*(4.2-absf(nearest))
  _tint(rock)
 for i in range(22):
  var bush=load("res://assets/visuals/nature_cc0/Bush_Common.gltf").instantiate();landscape.add_child(bush)
  var side=-1.0 if i%2==0 else 1.0
  bush.position=Vector3(side*(7.0+float((i*7)%8)*2.2),0,-5.0-i*9.0)
  bush.position.y=_height(bush.position.x,bush.position.z)-0.12
  bush.scale=Vector3.ONE*(0.8+float(i%3)*0.4);bush.rotation.y=i*1.73;_tint(bush)
 var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/grove_ground.gdshader")
 for side in [-1.0,1.0]:
  var bank=MeshInstance3D.new();bank.mesh=_bank(side);bank.material_override=mat;landscape.add_child(bank)
 var understory=MeshInstance3D.new();understory.name="AmberUnderstory";understory.mesh=_understory()
 var under_mat=ShaderMaterial.new();under_mat.shader=load("res://scripts/visuals/grove_understory.gdshader");understory.material_override=under_mat;landscape.add_child(understory)
 _garden_architecture()
 landscape.visible=false
func apply(index:int)->void:
 active=index==2 and not game.options.get("light",false);landscape.visible=active
 if index!=2:return
 game.scenery.visible=false
 for p in game.scene_props:p.visible=false
 for p in game.side_planes:
  p.visible=not active
  if not active:
   var side_mat=ShaderMaterial.new();side_mat.shader=load("res://scripts/visuals/grove_ground.gdshader");p.material_override=side_mat
 for e in game.track_edges:e.visible=false
 game.env_world.environment.fog_light_color=Color("453223")
 var pathmat=ShaderMaterial.new();pathmat.shader=load("res://scripts/visuals/grove_ground.gdshader");pathmat.set_shader_parameter("path_surface",true);game.ground.material_override=pathmat
 game.env_world.environment.fog_depth_end=155.0
 var sky_mat=game.env_world.environment.sky.sky_material
 sky_mat.shader=load("res://scripts/visuals/garden_sky.gdshader")
 game.sky_stars.visible=false
 game.env_world.environment.fog_light_color=Color("6b7370")
 game.world_sun.light_energy=0.95
 game.layout_moons(game.get_viewport().get_visible_rect().size)
func _tint(node:Node)->void:
 if node is MeshInstance3D:
  node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
  for i in range(node.mesh.get_surface_count()):
   var src=node.mesh.surface_get_material(i)
   if src is StandardMaterial3D:
    var mat=ShaderMaterial.new()
    var foliage=src.resource_name.to_lower().contains("leave")
    mat.shader=load("res://scripts/visuals/nature_moonlit.gdshader" if foliage else "res://scripts/visuals/nature_opaque.gdshader")
    mat.set_shader_parameter("base_texture",src.albedo_texture)
    mat.set_shader_parameter("foliage",foliage)
    mat.set_shader_parameter("tint",Vector3(0.40,0.25,0.08) if foliage else Vector3(0.45,0.34,0.23))
    mat.set_shader_parameter("fog_color",Vector3(0.27,0.19,0.13))
    mat.set_shader_parameter("fog_end",155.0)
    node.set_surface_override_material(i,mat)
 for child in node.get_children():_tint(child)
func _bank(side:float)->ArrayMesh:
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
 for row in range(30):
  for col in range(6):
   var vertices=[]
   for q in [Vector2(col,row),Vector2(col+1,row),Vector2(col+1,row+1),Vector2(col,row+1)]:
    var x=3.8+q.x*7.0;var z=25.0-q.y*9.0
    var y=-0.2+smoothstep(3.8,16.0,x)*(1.0+2.0*sin(z*0.025+side*1.5)+0.5*cos(x*0.14+z*0.08))
    vertices.append(Vector3(side*x,y,z))
   for k in ([0,1,2,0,2,3] if side>0 else [0,2,1,0,3,2]):st.add_vertex(vertices[k])
 st.generate_normals();return st.commit()
# End of grove visual study.

func _height(x:float,z:float)->float:
 return -0.2+smoothstep(3.8,16.0,absf(x))*(1.0+2.0*sin(z*0.025+signf(x)*1.5)+0.5*cos(absf(x)*0.14+z*0.08))

func layout_moons(size:Vector2)->void:
 if game.visual_world_index!=2:return
 for i in range(game.moons.size()):
  game.moons[i].scale=Vector3.ONE*(0.25 if i==0 else 0.001)
  game.moons[i].position=game.camera.project_position(Vector2(size.x*0.78,maxf(245.0,size.y*0.29)),60.0+i*15.0)

func _bounds(node:Node,base:Transform3D)->AABB:
 var result=AABB();var found=false
 for child in node.get_children():
  var transform:Transform3D=base*child.transform if child is Node3D else base
  if child is MeshInstance3D:
   var box=transform*child.get_aabb();result=result.merge(box) if found else box;found=true
  var nested=_bounds(child,transform)
  if nested.size.length()>0:result=result.merge(nested) if found else nested;found=true
 return result

func _understory()->ArrayMesh:
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
 var rng=RandomNumberGenerator.new();rng.seed=210511
 # Clusters with gaps, not a corridor of evenly spaced blades.
 for clump in range(44):
  var side=-1.0 if clump%2==0 else 1.0
  var cx=side*(5.1+float((clump*7)%9)*1.1)
  var cz=12.0-float(clump)*5.6
  if clump>=32:
   cx=side*(5.2+float(clump%3)*0.8);cz=4.0-float(clump-32)*2.8
  for blade in range(22 if clump>=32 else 12):
   var x=cx+rng.randf_range(-1.0,1.0);var z=cz+rng.randf_range(-2.4,2.4)
   x=side*maxf(absf(x),4.35)
   var y=_height(x,z)+0.03;var h=rng.randf_range(0.30,0.85)
   var w=rng.randf_range(0.025,0.055);var angle=rng.randf()*TAU;var offset=Vector3(cos(angle)*w,0,sin(angle)*w)
   var base=Vector3(x,y,z);var bend=Vector3(sin(angle),0,cos(angle))*rng.randf_range(0.12,0.30)
   var tip=base+bend+Vector3(0,h,0)
   var middle=base+bend*0.28+Vector3(0,h*0.62,0)
   var color=Color("665128").lerp(Color("8f7137"),rng.randf())
   for v in [base-offset,base+offset,middle+offset*0.6,base-offset,middle+offset*0.6,middle-offset*0.6,middle-offset*0.6,middle+offset*0.6,tip]:st.set_color(color);st.add_vertex(v)
  for frond in range(2 if clump>=32 else 0):
   var angle=float(frond)*TAU/5.0+float(clump)*1.7
   var direction=Vector3(cos(angle),0,sin(angle));var across=Vector3(-sin(angle),0,cos(angle))
   var center_base=Vector3(cx,_height(cx,cz)+0.03,cz)
   for pair in range(4):
    var t=0.18+float(pair)*0.20
    var center=center_base+direction*1.15*t+Vector3.UP*0.95*sin(t*PI*0.7)
    var length=(1.0-t)*0.42+0.08
    for sign_x in [-1.0,1.0]:_leaf(st,center,across*sign_x+direction*0.45+Vector3.UP*0.55,length,Color("68582e"))
   _leaf(st,center_base+direction*0.98+Vector3.UP*0.9,direction,0.32,Color("8b7339"))
  for leaf in range(10 if clump>=32 else 4):
   var x=cx+rng.randf_range(-1.4,1.4);var z=cz+rng.randf_range(-3.0,3.0);x=side*maxf(absf(x),4.35)
   var y=_height(x,z)+0.035;var l=rng.randf_range(0.10,0.30);var angle=rng.randf()*TAU
   var axis=Vector3(cos(angle),0,sin(angle))*l;var cross=Vector3(-axis.z,0,axis.x)*0.45;var center=Vector3(x,y,z)
   var color=Color("6d4321").lerp(Color("a56c32"),rng.randf())
   for v in [center-axis,center+cross,center+axis,center-axis,center+axis,center-cross]:st.set_color(color);st.add_vertex(v)
 st.generate_normals();return st.commit()
# End of clustered understory geometry.

func _leaf(st:SurfaceTool,base:Vector3,direction:Vector3,length:float,color:Color)->void:
 var forward=direction.normalized();var across=Vector3(-forward.z,0,forward.x)
 for section in range(3):
  var points=[]
  for q in [Vector2(section,-1),Vector2(section,1),Vector2(section+1,1),Vector2(section+1,-1)]:
   var t=q.x/3.0;var width=sin(t*PI)*length*0.30
   points.append(base+forward*length*t+across*width*q.y+Vector3.UP*sin(t*PI)*0.035)
  for k in [0,2,1,0,3,2]:st.set_color(color);st.add_vertex(points[k])
# End of dimensional fern leaves.

func _garden_architecture():
 var pavilion=load("res://assets/visuals/chinese_pavilion_cc0/pavilion.glb").instantiate()
 pavilion.name="ChinesePavilion";landscape.add_child(pavilion);pavilion.scale=Vector3.ONE*0.27;pavilion.position=Vector3(-10.4,0.2,-48);pavilion.rotation.y=0.25
 _pavilion_materials(pavilion)
 for side in [-1.0,1.0]:
  for i in range(3):
   var at=Vector3(side*(10.0+float(i)*1.4),2.0,-68.0-float(i)*25)
   _garden_box(Vector3(0.45,4.0,25),at,Color("8e9383"))
   _garden_box(Vector3(0.9,0.22,25.5),at+Vector3(0,2.1,0),Color("38413c"))
   for end in [-1,1]:
    _garden_box(Vector3(0.8,4.4,0.8),at+Vector3(0,0,end*12.5),Color("737c70"))
 _garden_batch_walls()
 var base=Vector3(-10.4,0,-48)
 _garden_box(Vector3(11.2,0.4,11.2),base,Color("656f66"))
func _garden_box(size:Vector3,at:Vector3,color:Color):
 var mesh=MeshInstance3D.new();var box=BoxMesh.new();box.size=size;mesh.mesh=box;mesh.position=at
 var mat=StandardMaterial3D.new();mat.albedo_color=color;mat.roughness=0.95;mesh.material_override=mat;mesh.set_meta("garden_wall",true);landscape.add_child(mesh)

func _pavilion_materials(node:Node):
 if node is MeshInstance3D:
  for i in range(node.mesh.get_surface_count()):
   var src=node.mesh.surface_get_material(i)
   if src is StandardMaterial3D:
    var mat=src.duplicate();var c=mat.albedo_color
    if c.r>0.6 and c.r>c.g*1.5:mat.albedo_color=Color("784435")
    elif c.r<0.30:mat.albedo_color=Color("384641")
    mat.roughness=0.95;node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF;node.set_surface_override_material(i,mat)
 for child in node.get_children():_pavilion_materials(child)

func _garden_batch_walls():
 var batches={}
 var nodes=[]
 for child in landscape.get_children():
  if child is MeshInstance3D and child.get_meta("garden_wall",false):
   var color=child.material_override.albedo_color;var key=str(color)
   if not batches.has(key):batches[key]=[SurfaceTool.new(),child.material_override];batches[key][0].begin(Mesh.PRIMITIVE_TRIANGLES)
   batches[key][0].append_from(child.mesh,0,child.transform);nodes.append(child)
 for node in nodes:landscape.remove_child(node);node.queue_free()
 for key in batches:
  var mesh=MeshInstance3D.new();mesh.mesh=batches[key][0].commit();mesh.material_override=batches[key][1];landscape.add_child(mesh)
