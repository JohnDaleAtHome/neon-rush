extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=2;g.running=true;g.apply_world(2);g.apply_options()
 check(g.grove_visual.active,"grove active")
 check(g.grove_visual.landscape.get_child_count()==61,"24trees12rocks22bushes2banks1understory")
 check(not g.scenery.visible,"options do not restore lollipop scenery")
 check(g.ground.material_override.shader.resource_path.ends_with("grove_ground.gdshader"),"path material")
 for p in g.scene_props:check(not p.visible,"old props hidden")
 for side in g.side_planes:check(not side.visible,"base sides hidden")
 var understory=g.grove_visual.landscape.get_node("AmberUnderstory")
 check(understory.mesh.get_surface_count()==1,"one batched understory surface")
 check(understory.mesh.surface_get_array_len(0)<120000,"bounded understory vertices")
 inspect(g.grove_visual.landscape)
 for dim in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=dim;await process_frame;g.layout_moons(dim)
  if dim.x>dim.y and dim.y<650:
   var horizon=g.camera.unproject_position(Vector3(0,0,-250)).y
   for moon in g.moons:
    var radius=moon.mesh.radius*moon.scale.x
    check(g.camera.unproject_position(moon.position-g.camera.global_basis.y*radius).y<horizon-10.0,"sky satellites above horizon")
 g.options.light=true;g.apply_options();check(not g.grove_visual.landscape.visible,"Light hides grove")
 check(not g.scenery.visible,"Light no primitive avenue")
 for side in g.side_planes:check(side.visible,"Light restores sides")
 g.options.light=false
 for world in [0,1,3,4,5,2]:
  g.level=world;g.apply_world(world);g.apply_options();check(g.grove_visual.active==(world==2),"world ownership")
 check(not g.scenery.visible,"return ownership")
 print("GROVE_VISUAL failures=",failures);quit(failures)
func inspect(node:Node):
 check(not node is CollisionObject3D,"no scenic collisions")
 if node is MeshInstance3D:
  for surface in range(node.mesh.get_surface_count()):
   for v in node.mesh.surface_get_arrays(surface)[Mesh.ARRAY_VERTEX]:
    var w=node.global_transform*v
    check(w.is_finite(),"finite geometry")
    check(absf(w.x)>=3.65,"scenery outside lanes")
 for child in node.get_children():inspect(child)
# End of grove regression test.
