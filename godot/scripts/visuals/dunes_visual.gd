extends Node3D
## Silver Dunes scenic terrain. No collisions, lane or encounter changes.
var game
var landscape:=Node3D.new()
var active:=false
func bind(main_node)->void:
 game=main_node
 add_child(landscape)
 for side in [-1.0,1.0]:
  var terrain=MeshInstance3D.new()
  var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES);st.set_smooth_group(0)
  for row in range(52):
   for col in range(40):
    var points=[]
    for q in [Vector2(col,row),Vector2(col+1,row),Vector2(col+1,row+1),Vector2(col,row+1)]:
     var x=side*(3.6+q.x*5.0);var z=22.0-q.y*5.5
     points.append(Vector3(x,height(x,z),z))
    for k in ([0,2,1,0,3,2] if side>0 else [0,1,2,0,2,3]):st.add_vertex(points[k])
  st.generate_normals();terrain.mesh=st.commit()
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/dunes_ripple_sand.jpg"))
  terrain.material_override=mat;landscape.add_child(terrain)
 # Broad dune skyline behind the encounter distance, with overlapping crests.
 for band in range(3):
  var terrain=MeshInstance3D.new();var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES);st.set_smooth_group(0)
  for row in range(10):
   for col in range(52):
    var points=[]
    for q in [Vector2(col,row),Vector2(col+1,row),Vector2(col+1,row+1),Vector2(col,row+1)]:
     var x=-260.0+q.x*10.0;var z=-145.0-band*52.0-q.y*8.0
     var crest=13.0+10.0*sin(x*0.013+band*2.1)+5.0*sin(x*0.026+band)
     var y=-0.14+crest*sin(q.y/10.0*PI)
     points.append(Vector3(x,y,z))
    for k in [0,2,1,0,3,2]:st.add_vertex(points[k])
  st.generate_normals();terrain.mesh=st.commit();var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/dunes_ripple_sand.jpg"));terrain.material_override=mat;landscape.add_child(terrain)
 # Large eroded crater rims and ejecta outside the running corridor.
 for spec in [[-20.0,-34.0,11.0,1.8],[31.0,-69.0,19.0,3.5],[-50.0,-103.0,25.0,4.5],[74.0,-146.0,29.0,6.0]]:
  var rim=MeshInstance3D.new();var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES);st.set_smooth_group(0)
  for ring in range(7):
   for slice in range(64):
    var points=[]
    for q in [Vector2(slice,ring),Vector2(slice+1,ring),Vector2(slice+1,ring+1),Vector2(slice,ring+1)]:
     var a=q.x*TAU/64.0;var r=spec[2]*(0.38+q.y*0.13)
     var x=spec[0]+cos(a)*r;var z=spec[1]+sin(a)*r*0.72
     var lift=spec[3]*exp(-pow((q.y-4.0)/1.2,2.0))*(0.83+0.17*sin(a*5.0))
     points.append(Vector3(x,height(x,z)+lift,z))
    for k in [0,2,1,0,3,2]:st.add_vertex(points[k])
  st.generate_normals();rim.mesh=st.commit();var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/dunes_ripple_sand.jpg"));rim.material_override=mat;landscape.add_child(rim)
 # Ejecta gathers in unequal trails at slope bases, not evenly spaced rows.
 var stones=SurfaceTool.new();stones.begin(Mesh.PRIMITIVE_TRIANGLES)
 var templates=[]
 for i in range(3):templates.append(load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(i+1)+".gltf").instantiate())
 for i in range(96):
  var group=i/16;var k=i%16
  var centers=[Vector2(-7.0,-5),Vector2(8.5,-19),Vector2(-10.0,-39),Vector2(12.5,-65),Vector2(-17.0,-99),Vector2(22.0,-141)]
  var center:Vector2=centers[group]
  var x=center.x+sin(i*2.399)*float(1+k%4)*0.4
  var z=center.y+cos(i*1.71)*float(2+k%7)*1.1
  var size=(0.22+float((i*7)%9)*0.065)*(2.0 if k>2 else 1.3)
  var basis=Basis.from_euler(Vector3(i*0.16,i*1.7,i*0.09)).scaled(Vector3(size,size*0.8,size*1.1))
  var transform=Transform3D(basis,Vector3(x,height(x,z)+0.12,z))
  if k<2:_append_stone(templates[i%3],transform,stones)
  else:_pebble(stones,transform,i)
 for node in templates:node.free()
 var ejecta=MeshInstance3D.new();ejecta.name="DuneEjecta";ejecta.mesh=stones.commit()
 var gravel=ShaderMaterial.new();gravel.shader=load("res://scripts/visuals/dunes_sand.gdshader");gravel.set_shader_parameter("sand_texture",load("res://assets/textures/dunes_ripple_sand.jpg"));gravel.set_shader_parameter("is_rock",true)
 ejecta.material_override=gravel;landscape.add_child(ejecta)
 _desert_architecture()
 landscape.visible=false
func height(x:float,z:float)->float:
 var side=signf(x);var ax=absf(x)
 var edge=smoothstep(6.0,20.0,ax)
 # Offset diagonal crests, rather than mirrored banks or a centered trough.
 var ridge1=(1.8 if x<0 else 4.8)*exp(-pow((ax-24.0-9.0*sin(z*0.025+side))/18.0,2.0)-pow((z+78.0+side*25.0)/58.0,2.0))
 var ridge2=12.0*exp(-pow((ax-76.0-18.0*sin(z*0.018))/37.0,2.0)-pow((z+125.0-side*29.0)/93.0,2.0))
 var ridge3=12.0*exp(-pow((ax-147.0)/51.0,2.0)-pow((z+195.0)/102.0,2.0))
 return -0.14+edge*(ridge1+ridge2+ridge3)
func apply(index:int)->void:
 active=index==1 and not game.options.get("light",false);landscape.visible=active
 if index!=1:return
 game.scenery.visible=false
 for prop in game.scene_props:prop.visible=false
 var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/dunes_ripple_sand.jpg"));mat.set_shader_parameter("is_path",true);game.ground.material_override=mat
 for side in game.side_planes:
  side.visible=not active
  if not active:side.material_override=mat
 for edge in game.track_edges:edge.visible=false
 game.env_world.environment.sky.sky_material.shader=load("res://scripts/visuals/desert_sky.gdshader")
 game.env_world.environment.fog_light_color=Color("b4a17e");game.env_world.environment.fog_depth_end=240.0;game.world_sun.light_energy=1.0
 game.sky_stars.visible=false;game.layout_moons(game.get_viewport().get_visible_rect().size)
func layout_moons(size:Vector2):
 if game.visual_world_index!=1:return
 var compact=size.x>size.y and size.y<650
 var tower=landscape.get_node("DesertPagoda")
 var x=-56.0 if compact else -32.0 if size.x>size.y else -13.0
 var z=-75.0 if size.x>size.y else -62.0
 tower.position=Vector3(x,height(x,z),z);tower.scale=Vector3.ONE*(0.52 if compact else 0.62 if size.x>size.y else 0.52)
 for i in range(3):
  game.moons[i].scale=Vector3.ONE*(0.28 if i==0 else 0.001)
  game.moons[i].position=game.camera.project_position(Vector2(size.x*0.88,maxf(120.0,size.y*0.28) if compact else maxf(245.0,size.y*0.29)),60.0+i*15.0)

func _rock_material(node:Node)->void:
 if node is MeshInstance3D:
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/dunes_ripple_sand.jpg"))
  node.material_override=mat
 for child in node.get_children():_rock_material(child)

func _append_stone(node:Node3D,transform:Transform3D,st:SurfaceTool)->void:
 var at=transform*node.transform
 if node is MeshInstance3D:
  for surface in range(node.mesh.get_surface_count()):
   var arrays=node.mesh.surface_get_arrays(surface)
   var vertices=arrays[Mesh.ARRAY_VERTEX];var normals=arrays[Mesh.ARRAY_NORMAL];var indices=arrays[Mesh.ARRAY_INDEX]
   for i in range(indices.size() if indices!=null and indices.size()>0 else vertices.size()):
    var j=indices[i] if indices!=null and indices.size()>0 else i
    st.set_normal((at.basis*normals[j]).normalized());st.add_vertex(at*vertices[j])
 for child in node.get_children():
  if child is Node3D:_append_stone(child,at,st)

func _pebble(st:SurfaceTool,at:Transform3D,index:int)->void:
 var ring=[]
 for i in range(5):
  var angle=float(i)/5.0*TAU
  ring.append(Vector3(cos(angle)*(0.8+0.1*sin(index+i)),0.0,sin(angle)))
 var top=Vector3(0.1,0.65,0.05);var bottom=Vector3(0,-0.35,0)
 for i in range(5):
  var j=(i+1)%5
  for tri in [[top,ring[i],ring[j]],[bottom,ring[j],ring[i]]]:
   var a:Vector3=at*tri[0];var b:Vector3=at*tri[1];var c:Vector3=at*tri[2]
   var normal=(c-a).cross(b-a).normalized()
   for v in [a,b,c]:st.set_normal(normal);st.add_vertex(v)

func _desert_architecture():
 var tower=load("res://assets/visuals/chinese_pagoda_cc0/pagoda.glb").instantiate();tower.name="DesertPagoda";landscape.add_child(tower);tower.position=Vector3(-25.0,height(-25,-75),-75);tower.scale=Vector3.ONE*0.72;tower.rotation.y=0.35
 var footing=MeshInstance3D.new();var box=BoxMesh.new();box.size=Vector3(16,0.8,16);footing.mesh=box;footing.position=Vector3(0,-0.3,0);var mat=StandardMaterial3D.new();mat.albedo_color=Color("8b7957");mat.roughness=1.0;footing.material_override=mat;tower.add_child(footing)
 _no_shadow(tower)
func _no_shadow(node:Node):
 if node is MeshInstance3D:
  node.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
  for i in range(node.mesh.get_surface_count()):
   var source=node.get_active_material(i)
   if source is StandardMaterial3D:
    var mat=source.duplicate();mat.disable_fog=true;node.set_surface_override_material(i,mat)
 for child in node.get_children():_no_shadow(child)
