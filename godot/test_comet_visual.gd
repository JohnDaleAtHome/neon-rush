extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.level=4;g.apply_world(4)
 check(g.comet_visual.active,"Comet active")
 check(g.comet_visual.landscape.get_child_count()==27,"14plates4shards8chunks1fracturebatch")
 var cliffs=g.comet_visual.landscape.get_node("CometFractures")
 check(cliffs.mesh.get_faces().size()==972,"18fragments324triangles")
 check(cliffs.material_override.get_shader_parameter("cliff_surface"),"separate cliff material")
 check(g.ground.material_override.shader.resource_path.ends_with("comet_stone.gdshader"),"path material")
 for p in g.scene_props:check(not p.visible,"primitive boulders hidden")
 for side in g.side_planes:check(not side.visible,"base sides hidden")
 for edge in g.track_edges:check(not edge.visible,"pink edges hidden")
 check(g.lane_guides.size()==2,"guides unchanged")
 inspect(g.comet_visual.landscape)
 g.options.light=true;g.apply_world(4);check(not g.comet_visual.landscape.visible,"Light hides comet")
 for side in g.side_planes:check(side.visible,"Light restores sides")
 for edge in g.track_edges:check(edge.visible,"Light restores edges")
 g.options.light=false
 for world in [0,1,2,3,5,4]:
  g.level=world;g.apply_world(world);check(g.comet_visual.active==(world==4),"world ownership")
 for dim in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=dim;await process_frame;g.layout_moons(dim);check(g.comet_visual.landscape.visible,"aspect comet visible")
  if dim.x>dim.y and dim.y<650:
   var horizon=g.camera.unproject_position(Vector3(0,0,-250)).y
   for moon in g.moons:
    var radius=moon.mesh.radius*moon.scale.x
    var bottom=g.camera.unproject_position(moon.position-g.camera.global_basis.y*radius).y
    check(bottom<horizon-10.0,"landscape moons above distant lane horizon")
    var pos=g.camera.unproject_position(moon.position)
    check(pos.x<dim.x*0.23 or pos.x>dim.x*0.76,"landscape moons outside objective center")
 print("COMET_VISUAL failures=",failures);quit(failures)
func inspect(node:Node):
 check(not node is CollisionObject3D,"no scenic collision")
 if node is MeshInstance3D:
  var aabb=node.get_aabb();check(aabb.size.is_finite(),"finitebounds")
  for surface in range(node.mesh.get_surface_count()):
   var arrays=node.mesh.surface_get_arrays(surface)
   for v in arrays[Mesh.ARRAY_VERTEX]:
    var w=node.global_transform*v
    check(w.is_finite(),"finitevertex")
    check(absf(w.x)>=3.65,"scenery outside running lanes")
 for child in node.get_children():inspect(child)

# End of Comet visual study.
