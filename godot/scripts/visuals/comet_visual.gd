extends Node3D
## Jagged comet shoulders and distant fractures, decorative only.
var game
var landscape:=Node3D.new()
var active:=false
func bind(main_node)->void:
 game=main_node;add_child(landscape)
 var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/comet_stone.gdshader")
 # Separated fractured plates, with real gaps between each silhouette.
 for side in [-1.0,1.0]:
  for i in range(7):
   var z=28.0-i*39.0+(7.0*sin(i*2.1) if side<0 else -14.0);var width=17.0+float((i*3)%5)*6.0
   var mesh=MeshInstance3D.new();mesh.mesh=_plate(side,z,width,i);mesh.material_override=mat;landscape.add_child(mesh)
 # Tilted irregular shards form a broken skyline, never above the playable lane.
 for spec in [[-26.0,-53.0,4.5,3.0], [35.0,-83.0,6.0,5.0],[-64.0,-139.0,9.0,7.0],[102.0,-193.0,13.0,9.0]]:
  var shard=load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(1+landscape.get_child_count()%3)+".gltf").instantiate();landscape.add_child(shard);shard.scale=Vector3(spec[2],spec[3],spec[2]*0.6);shard.position=Vector3(spec[0],-spec[3]*0.6,spec[1]);shard.rotation=Vector3(0.13,spec[0]*0.17,signf(spec[0])*0.25);_rock_material(shard)
 # Detached chunks beyond the plates, well outside the hazard sight line.
 for i in range(8):
  var side=-1.0 if i%2==0 else 1.0
  var chip=load("res://assets/visuals/nature_cc0/Rock_Medium_"+str(1+i%3)+".gltf").instantiate();landscape.add_child(chip)
  chip.scale=Vector3(0.65+float(i%3)*0.4,0.8+float(i%2)*0.6,0.8+float(i%3)*0.2)
  chip.position=Vector3(side*(11.0+float(i%4)*4.0),-1.5+float(i%3)*1.2,-20.0-i*13.0);chip.rotation=Vector3(i*0.6,i*1.7,i*0.3);_rock_material(chip)
 landscape.visible=false
func apply(index:int)->void:
 active=index==4 and not game.options.get("light",false);landscape.visible=active
 if not active:return
 game.env_world.environment.fog_light_color=Color("211529")
 game.env_world.environment.fog_depth_end=180.0
 for side in game.side_planes:side.visible=false
 for edge in game.track_edges:edge.visible=false
 var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/comet_stone.gdshader");mat.set_shader_parameter("path_surface",true);game.ground.material_override=mat
 for prop in game.scene_props:prop.visible=false
 game.layout_moons(game.get_viewport().get_visible_rect().size)
func _rock_material(node:Node)->void:
 if node is MeshInstance3D:
  var mat=ShaderMaterial.new();mat.shader=load("res://scripts/visuals/comet_stone.gdshader");node.material_override=mat
 for child in node.get_children():_rock_material(child)

func _plate(side:float,z:float,width:float,index:int)->ArrayMesh:
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES)
 var inner=4.1+float((index*3)%5)*0.7;var y=-0.85+float(index%4)*0.18
 var length=26.0+float(index%3)*3.5
 var top=[]
 for k in range(9):
  var t=float(k)/9.0*TAU
  var radial=1.0+0.18*sin(float(k*7+index*3))
  var x=maxf(inner,inner+width*0.5+cos(t)*width*0.5*radial)
  var zz=z-length*0.5+sin(t)*length*0.5*radial
  var yy=y+0.6+1.2*sin(float(k*3+index))*smoothstep(inner,inner+width,x)
  top.append(Vector3(side*x,yy,zz))
 var center=Vector3.ZERO
 for v in top:center+=v/9.0
 center.y+=1.0+float(index%3)*0.7
 for i in range(9):
  var next=(i+1)%9
  var a=top[i];var b=top[next]
  for v in ([center,b,a] if side>0 else [center,a,b]):st.add_vertex(v)
  var down_a=Vector3(lerpf(a.x,center.x,0.75),-9.0,lerpf(a.z,center.z,0.75));var down_b=Vector3(lerpf(b.x,center.x,0.75),-9.0,lerpf(b.z,center.z,0.75))
  for v in ([a,b,down_b,a,down_b,down_a] if side>0 else [b,a,down_a,b,down_a,down_b]):st.add_vertex(v)
 st.generate_normals();return st.commit()

# End of Comet visual study.

func layout_moons(size:Vector2)->void:
 if not active or size.x<=size.y or size.y>=650:return
 # The old 265px minimum falls below the horizon on short landscape screens.
 # Keep small satellites at the outer sky edges, away from the objective band.
 for i in range(game.moons.size()):
  var depth=60.0+i*15.0
  var point=Vector2(size.x*[0.13,0.82,0.93][i],size.y*0.30)
  game.moons[i].scale=Vector3.ONE*[0.48,0.30,0.20][i]
  game.moons[i].position=game.camera.project_position(point,depth)
# End of Comet visual study.
