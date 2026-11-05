extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=5;g.running=true;g.apply_world(5);g.apply_options()
 check(g.palace_visual.active,"palace active")
 var streets=[]
 for child in g.palace_visual.landscape.get_children():
  if child is MultiMeshInstance3D:streets.append(child)
 check(streets.size()==2,"two bounded Han house batches")
 for street in streets:
  check(street.multimesh.instance_count==14,"full street house count")
  check(street.multimesh.mesh.get_faces().size()/3==1000,"full authored house topology")
 check(g.ground.material_override.shader.resource_path.ends_with("palace_stone.gdshader"),"path material")
 for side in g.side_planes:check(not side.visible,"base sides hidden")
 var gate=g.palace_visual.landscape.get_node("MoonlightGate")
 check(gate.get_child_count()<=10,"bounded gate material batches")
 check(gate.get_meta("light_count")==5,"five scenic lights")
 check(gate.position.z<-130.0,"destination remains distant")
 inspect(g.palace_visual.landscape)
 for dim in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=dim;await process_frame;g.layout_moons(dim)
  check(not g.sky_stars.visible,"no palace star field")
  check(is_equal_approx(g.moons[0].scale.x,0.4) and g.moons[1].scale.x<0.002 and g.moons[2].scale.x<0.002,"one restrained moon")
  inspect(g.palace_visual.landscape)
  for street in streets:
   for k in range(street.multimesh.instance_count):
    var xf=g.palace_visual._house_transform(street.get_meta("street_side"),k)
    # Dummy RenderingServer does not retain MultiMesh transforms. Validate the
    # source transform headlessly; cross-check stored transforms when rendered.
    if DisplayServer.get_name()!="headless":check(street.multimesh.get_instance_transform(k).is_equal_approx(xf),"stored house transform")
    for v in street.multimesh.mesh.get_faces():
     var w=street.global_transform*xf*v
     check(absf(w.x)>4.25,"Han houses outside full lane envelope")
     check(w.y>=-0.001,"Han houses grounded")
  if dim.x>dim.y and dim.y<650:
   var horizon=g.camera.unproject_position(Vector3(0,0,-250)).y
   for moon in [g.moons[0]]:
    var radius=moon.mesh.radius*moon.scale.x
    check(g.camera.unproject_position(moon.position-g.camera.global_basis.y*radius).y<horizon-10.0,"sky satellites above horizon")
 g.options.light=true;g.apply_options();check(not g.palace_visual.landscape.visible,"Light hides palace")
 check(not g.scenery.visible,"Light no primitive avenue")
 check(not g.sky_stars.visible,"Light no star field")
 check(g.ground.material_override.shader.resource_path.ends_with("palace_stone.gdshader"),"Light keeps palace paving")
 check(g.env_world.environment.sky.sky_material.shader.resource_path.ends_with("garden_sky.gdshader"),"Light keeps courtyard sky")
 g.layout_moons(root.size)
 check(is_equal_approx(g.moons[0].scale.x,0.4) and g.moons[1].scale.x<0.002,"Light keeps one restrained moon")
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
