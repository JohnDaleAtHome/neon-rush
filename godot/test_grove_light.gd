extends SceneTree
func _init():call_deferred("run")
func inspect(n):
 assert(not n is CollisionObject3D)
 for c in n.get_children():inspect(c)
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var v=g.grove_visual;var lite=v.light_landscape;var cards=0;var originals=0;var banks=0
 inspect(lite)
 for c in v.landscape.get_children():
  if c is MeshInstance3D and c.material_override is ShaderMaterial and c.material_override.shader.resource_path.ends_with("grove_impostor.gdshader"):originals+=1
 for c in lite.get_children():
  if c is MeshInstance3D and c.material_override is ShaderMaterial:
   if c.material_override.shader.resource_path.ends_with("grove_impostor.gdshader"):
    cards+=1
    assert(absf(c.position.x)-c.mesh.size.x*0.5>4.1)
    var matched=false
    for source in v.landscape.get_children():
     if source is MeshInstance3D and source.mesh==c.mesh and source.transform==c.transform:matched=true
    assert(matched) # Keep the accepted terrain-grounded tree transform, not its bounds-center height.
   elif c.material_override.shader.resource_path.ends_with("grove_ground.gdshader") and c.name!="PavilionPaving":banks+=1
 assert(cards==ceili(originals/2.0));assert(banks==2)
 assert(lite.has_node("ChinesePavilion") and lite.has_node("PavilionFoundation") and lite.has_node("PavilionPaving"))
 assert(not lite.has_node("AmberUnderstory"))
 for world in range(6):
  for light in [false,true]:
   g.options.light=light;g.apply_world(world);await process_frame
   assert(lite.visible==(world==2 and light));assert(v.landscape.visible==(world==2 and not light))
   if world==2:
    for side in g.side_planes:assert(not side.visible)
    assert(not g.scenery.visible)
 g.options.light=true;g.apply_world(2)
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame;g.layout_moons(dims)
  var at=g.camera.unproject_position(g.moons[0].position)
  assert(at.y<dims.y*0.5)
 print("PASS GroveLight cards=",cards,"/",originals," banks=",banks," pavilion/foundation, grounded/offlane/no collisions, world/quality/resize")
 quit()
