extends SceneTree
var shader_materials={}
var tinted={}
var failures=[]
func _init():call_deferred("run")
func collect(node):
 if node is MeshInstance3D:
  for i in range(node.mesh.get_surface_count()):
   var source=node.mesh.surface_get_material(i)
   var name=String(source.resource_name)
   var key=str(node.get_instance_id())+":"+str(i)
   if name in ["Bunny_Jacket","Scarf_Navy","Scarf_Seam"]:
    shader_materials[key]=[node,i,node.get_surface_override_material(i),name]
   if name in ["Bunny_Secondary","Eye_White"]:tinted[key]=[node,i,name]
 for child in node.get_children():collect(child)
func check(condition,label):
 if not condition:failures.append(label)
func verify(color,gold):
 for key in shader_materials:
  var x=shader_materials[key];var current=x[0].get_surface_override_material(x[1])
  check(current is ShaderMaterial,"shader type "+x[3])
  check(current==x[2],"shader identity "+x[3])
 for key in tinted:
  var x=tinted[key];var current=x[0].get_surface_override_material(x[1])
  check(current is StandardMaterial3D,"tint material "+x[2])
  if current is StandardMaterial3D:
   var expected=Color(color) if x[2]=="Bunny_Secondary" else Color("ffdc78") if gold else x[0].mesh.surface_get_material(x[1]).albedo_color
   check(current.albedo_color.is_equal_approx(expected),"tint value "+x[2])
   if x[2]=="Eye_White":
    check(current.vertex_color_use_as_albedo==not gold,"gold does not multiply cyan iris colors")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 # Create a fresh character before option application to capture authored identities.
 var m=MochiVisual.create();root.add_child(m);collect(m)
 check(shader_materials.size()>=3,"all authored shader surfaces found")
 check(tinted.size()>=2,"both tint categories found")
 for entry in [["mint","9ed6af"],["violet","ba9cdd"],["rose","e7a3ba"]]:
  g.options.color=entry[0]
  for gold in [false,true,false]:
   g.options.gold=gold;g.gold_unlocked=true
   g.apply_bunny_tint(m);verify(entry[1],gold)
 # Actual ordinary option application on game-owned character must keep all shaders.
 shader_materials.clear();tinted.clear();collect(g.bunny)
 for entry in [["mint","9ed6af"],["violet","ba9cdd"]]:
  g.options.color=entry[0];g.options.gold=false
  for light in [true,false]:
   g.options.light=light;g.apply_options();verify(entry[1],false)
 if failures.is_empty():print("PASS authored cloth/scarf shader identity across tints, gold on/off and ordinary light/options application")
 else:
  for failure in failures:print("FAIL ",failure)
 quit(0 if failures.is_empty() else 1)
