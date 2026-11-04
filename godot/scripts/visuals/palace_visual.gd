extends Node3D
## Original moonlit side pavilions. Decorative, no gameplay collision.
var game
var landscape:=Node3D.new()
var active:=false
func bind(main_node)->void:
 game=main_node;add_child(landscape)
 for spec in [[-16.0,-34.0,1.0],[23.0,-73.0,1.35],[-33.0,-124.0,1.6]]:
  var pavilion=Node3D.new();landscape.add_child(pavilion);pavilion.position=Vector3(spec[0],0,spec[1]);pavilion.scale=Vector3.ONE*spec[2]
  _box(pavilion,Vector3(11,0.5,9),Vector3(0,0,0),Color("76778f"))
  _box(pavilion,Vector3(9.8,0.4,7.8),Vector3(0,0.4,0),Color("9390a4"))
  for x in [-3.6,3.6]:
   for z in [-2.7,2.7]:
    _box(pavilion,Vector3(0.38,5.0,0.38),Vector3(x,3.0,z),Color("673853"))
    _box(pavilion,Vector3(0.7,0.25,0.7),Vector3(x,0.8,z),Color("c2b38a"))
  for x in [-3.9,3.9]:_box(pavilion,Vector3(0.28,1.0,6.2),Vector3(x,1.2,0),Color("9d7788"))
  for z in [-3.0,3.0]:_box(pavilion,Vector3(8.0,0.3,0.35),Vector3(0,5.2,z),Color("d0b879"))
  for x in [-1.8,1.8]:
   for z in [-1.3,1.3]:_box(pavilion,Vector3(0.24,1.3,0.24),Vector3(x,7.2,z),Color("673853"))
  for tier in range(2):
   var roof=MeshInstance3D.new();roof.mesh=_roof(6.0-float(tier)*1.4,4.8-float(tier)*1.2,5.3+float(tier)*2.1);roof.material_override=_material(Color("253249"));roof.material_override.cull_mode=BaseMaterial3D.CULL_DISABLED;pavilion.add_child(roof)
  _box(pavilion,Vector3(0.45,1.0,0.45),Vector3(0,8.7,0),Color("c9b47c"))
 # Side terraces and low balustrades leave the central lane sight line open.
 for side in [-1.0,1.0]:
  _box(landscape,Vector3(24,0.5,235),Vector3(side*16.0,-0.55,-90),Color("24283c"))
  for i in range(17):
   _box(landscape,Vector3(0.45,0.8,0.45),Vector3(side*5.1,0.1,12.0-i*13.0),Color("8d879b"))
  _box(landscape,Vector3(0.20,0.18,221),Vector3(side*5.1,0.55,-92),Color("9b94aa"))
 landscape.visible=false
func apply(index:int)->void:
 active=index==5 and not game.options.get("light",false);landscape.visible=active
 if not active:return
 for side in game.side_planes:side.visible=false
 for edge in game.track_edges:edge.visible=false
 var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/palace_stone.gdshader");game.ground.material_override=mat
 game.env_world.environment.fog_light_color=Color("34334e")
 game.env_world.environment.fog_depth_end=220.0
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
 if not active:return
 var short_landscape=size.x>size.y and size.y<650
 for i in range(3):
  landscape.get_child(i).position.x=[-16.0,23.0,-33.0][i]*(1.7 if short_landscape else 1.0)
 if not short_landscape:return
 for i in range(game.moons.size()):
  game.moons[i].scale=Vector3.ONE*[0.48,0.30,0.20][i]
  game.moons[i].position=game.camera.project_position(Vector2(size.x*[0.13,0.82,0.93][i],size.y*0.30),60.0+i*15.0)
# End of palace visual study.
