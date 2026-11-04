extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=5;g.running=true;g.apply_world(5);g.apply_options()
 check(g.palace_visual.active,"palace active")
 for i in range(3):check(g.palace_visual.landscape.get_child(i).get_child_count()<=10,"bounded pavilion material batches")
 check(g.ground.material_override.shader.resource_path.ends_with("palace_stone.gdshader"),"path material")
 for side in g.side_planes:check(not side.visible,"base sides hidden")
 var gate=g.palace_visual.landscape.get_node("MoonlightGate")
 check(gate.get_child_count()<=10,"bounded gate material batches")
 check(gate.get_meta("light_count")==5,"five scenic lights")
 check(gate.position.z<-130.0,"destination remains distant")
 inspect(g.palace_visual.landscape)
 for dim in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=dim;await process_frame;g.layout_moons(dim)
  check(absf(g.palace_visual.landscape.get_child(0).position.x)>=16.0,"pavilion lateral placement")
  if dim.x>dim.y and dim.y>=650:
   check(g.palace_visual.landscape.get_child(0).position.x < -28.0,"wide pavilion clears moon group")
  if dim.x>dim.y and dim.y<650:
   check(g.palace_visual.landscape.get_child(0).position.x < -26.0,"landscape clears central cue")
   var horizon=g.camera.unproject_position(Vector3(0,0,-250)).y
   for moon in g.moons:
    var radius=moon.mesh.radius*moon.scale.x
    check(g.camera.unproject_position(moon.position-g.camera.global_basis.y*radius).y<horizon-10.0,"sky satellites above horizon")
 g.options.light=true;g.apply_options();check(not g.palace_visual.landscape.visible,"Light hides palace")
 check(not g.scenery.visible,"Light no primitive avenue")
 for side in g.side_planes:check(side.visible,"Light restores sides")
 g.options.light=false
 for world in [0,1,2,3,4,5]:
  g.level=world;g.apply_world(world);g.apply_options();check(g.palace_visual.active==(world==5),"world ownership")

 print("PALACE_VISUAL failures=",failures);quit(failures)
func inspect(node:Node):
 check(not node is CollisionObject3D,"no scenic collisions")
 if node is MeshInstance3D:
  for surface in range(node.mesh.get_surface_count()):
   for v in node.mesh.surface_get_arrays(surface)[Mesh.ARRAY_VERTEX]:
    var w=node.global_transform*v
    check(w.is_finite(),"finite geometry")
    check(absf(w.x)>=3.65 or (w.z < -130.0 and w.y>9.0),"scenery outside lanes or distant overhead gate")
 for child in node.get_children():inspect(child)
# End of palace regression test.
