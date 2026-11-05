extends SceneTree
func _init():call_deferred("run")
func inspect(n):
 assert(not n is CollisionObject3D)
 for c in n.get_children():inspect(c)
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var v=g.palace_visual;var lite=v.light_landscape
 assert(lite.get_child_count()==5)
 inspect(lite)
 var instances=0
 for c in lite.get_children():
  if c is MultiMeshInstance3D:
   instances+=c.multimesh.instance_count
   assert(c.multimesh.instance_count==8)
   for i in range(8):
    var t=c.multimesh.get_instance_transform(i)
    for k in 8:
     var point=t*c.multimesh.mesh.get_aabb().get_endpoint(k)
     assert(absf(point.x)>4.25)
 assert(instances==16)
 assert(lite.get_node("MoonlightGate").get_meta("light_count")==5)
 for world in range(6):
  for light in [false,true]:
   g.options.light=light;g.apply_world(world);await process_frame
   assert(lite.visible==(world==5 and light))
   assert(v.landscape.visible==(world==5 and not light))
   if world==5:
    assert(not g.scenery.visible)
    for edge in g.track_edges:assert(not edge.visible)
    for side in g.side_planes:assert(side.visible==light)
 assert(v.landscape.get_child_count()>lite.get_child_count())
 print("PASS PalaceLight 16 shared Han houses, five-light landmark, off-lane, no collision, Full/Light/all-world visibility")
 quit()
