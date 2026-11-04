extends SceneTree
func _init():call_deferred("run")
func inspect_node(n:Node)->int:
 var meshes=0
 assert(not n is CollisionObject3D)
 if n is MeshInstance3D:
  meshes=1
  assert(n.position.is_finite())
  var box=n.get_aabb()
  for corner in range(8):
   var world=n.global_transform*box.get_endpoint(corner)
   assert(absf(world.x)>4.0 or world.z < -145.0,"imported model bounds enter lane corridor")
  for i in range(n.mesh.get_surface_count()):
   var m=n.get_surface_override_material(i)
   if m:assert(m is ShaderMaterial)
 for c in n.get_children():meshes+=inspect_node(c)
 return meshes
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.apply_world(0);await process_frame
 var m=g.meadow_visual
 assert(m.active and m.horizon_root.visible)
 for edge in g.track_edges:assert(not edge.visible)
 var imported=0
 var impostors=0
 for child in m.horizon_root.get_children():
  if child.has_meta("tree_impostor"):
   impostors+=1
   var source_box: AABB=child.get_meta("source_bounds")
   assert(child.position.z < -68.0)
   for corner in range(8):
    var point=source_box.get_endpoint(corner)
    assert(absf(point.x)>4.0)
   assert(child.material_override.shader.resource_path.ends_with("nature_impostor.gdshader"))
  if child.scene_file_path.begins_with("res://assets/visuals/nature_cc0/"):
   imported+=1
   assert(absf(child.position.x)>6.0 or child.has_meta("distant_landmark"))
   assert(inspect_node(child)>0)
 assert(imported+impostors==57)
 assert(impostors>8)
 assert(m.import_materials.size()<20)
 var opaque=0
 var cutout=0
 for mat in m.import_materials.values():
  if mat.shader.resource_path.ends_with("nature_opaque.gdshader"):opaque+=1
  elif mat.shader.resource_path.ends_with("nature_moonlit.gdshader"):cutout+=1
 assert(opaque>0 and cutout>0)
 g.options.light=true;g.apply_options();await process_frame;assert(not m.horizon_root.visible)
 for edge in g.track_edges:assert(edge.visible)
 g.options.light=false;g.apply_options();await process_frame;assert(m.horizon_root.visible)
 for level in range(1,6):
  g.apply_world(level);await process_frame;assert(not m.horizon_root.visible)
 g.apply_world(0);await process_frame;assert(m.horizon_root.visible)
 print("PASS57CC0placements-with-distant-impostors,noCollision,outsidecorridor,sharedmaterials,Lightandthemevisibility")
 quit()
