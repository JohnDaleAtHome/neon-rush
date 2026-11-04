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
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/ground_sand.png"))
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
  st.generate_normals();terrain.mesh=st.commit();var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/ground_sand.png"));terrain.material_override=mat;landscape.add_child(terrain)
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
  st.generate_normals();rim.mesh=st.commit();var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/ground_sand.png"));rim.material_override=mat;landscape.add_child(rim)
 for i in range(18):
  var side=-1.0 if i%2==0 else 1.0;var x=side*(10.0+float(i%4)*6.0);var z=-20.0-i*8.0
  var rock=load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(1+i%3)+".gltf").instantiate()
  rock.scale=Vector3.ONE*(0.35+float(i%3)*0.18);rock.rotation.y=i*1.7
  rock.position=Vector3(x,height(x,z)-0.25,z)
  _rock_material(rock);landscape.add_child(rock)
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
 active=index==1 and not game.options.get("light",false)
 landscape.visible=active
 if active:
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/ground_sand.png"));mat.set_shader_parameter("is_path",true);game.ground.material_override=mat
  var crater_mat=ShaderMaterial.new();crater_mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");crater_mat.set_shader_parameter("sand_texture",load("res://assets/textures/ground_sand.png"))
  for prop in game.scene_props:prop.material_override=crater_mat
  for side in game.side_planes:side.visible=false
  for edge in game.track_edges:edge.visible=false

func _rock_material(node:Node)->void:
 if node is MeshInstance3D:
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/dunes_sand.gdshader");mat.set_shader_parameter("sand_texture",load("res://assets/textures/ground_sand.png"))
  node.material_override=mat
 for child in node.get_children():_rock_material(child)
