extends Node3D
## Layered warm grove, decoration only. Existing CC0 nature models.
var game
var landscape:=Node3D.new()
var active:=false
func bind(main_node)->void:
 game=main_node;add_child(landscape)
 # Unequal clusters, not matched avenue rows. Leave central sky and all lanes open.
 var trees=[[-8.5,-16.0,0.9],[9.5,-32.0,1.0],[-9.0,-51.0,0.85],[8.5,-83.0,1.0],[-9.5,-108.0,1.0],[9.0,-150.0,1.1],[-23.0,-8.0,1.8],[28.0,-30.0,2.2],[-36.0,-55.0,2.5],[34.0,-101.0,2.1],[-39.0,-128.0,2.5],[43.0,-182.0,3.0],[-12.0,9.0,1.4], [15.0,-5.0,1.6],[-17.0,-27.0,1.8],[12.0,-43.0,1.25],[-10.0,-67.0,1.1],[22.0,-75.0,2.0],[-26.0,-90.0,1.7],[13.0,-116.0,1.4],[-18.0,-142.0,1.6],[28.0,-161.0,2.2],[-33.0,-185.0,2.4],[16.0,-208.0,1.8]]
 for i in range(trees.size()):
  var spec=trees[i]
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
 landscape.visible=false
func apply(index:int)->void:
 active=index==2 and not game.options.get("light",false);landscape.visible=active
 if not active:return
 game.scenery.visible=false
 for p in game.scene_props:p.visible=false
 for p in game.side_planes:p.visible=false
 for e in game.track_edges:e.visible=false
 game.env_world.environment.fog_light_color=Color("453223")
 var pathmat=ShaderMaterial.new();pathmat.shader=load("res://scripts/visuals/grove_ground.gdshader");pathmat.set_shader_parameter("path_surface",true);game.ground.material_override=pathmat
 game.env_world.environment.fog_depth_end=155.0
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
 if not active or size.x<=size.y or size.y>=650:return
 for i in range(game.moons.size()):
  var point=Vector2(size.x*[0.13,0.82,0.93][i],size.y*0.30)
  game.moons[i].scale=Vector3.ONE*[0.48,0.30,0.20][i]
  game.moons[i].position=game.camera.project_position(point,60.0+i*15.0)

func _bounds(node:Node,base:Transform3D)->AABB:
 var result=AABB();var found=false
 for child in node.get_children():
  var transform:Transform3D=base*child.transform if child is Node3D else base
  if child is MeshInstance3D:
   var box=transform*child.get_aabb();result=result.merge(box) if found else box;found=true
  var nested=_bounds(child,transform)
  if nested.size.length()>0:result=result.merge(nested) if found else nested;found=true
 return result
