extends SceneTree
var failures=0
func check(ok:bool,msg:String):
 if not ok:failures+=1;push_error(msg)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for size in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=size;await process_frame
  for light in [true,false]:
   g.options.light=light;g.level=4;g.apply_world(4);g.layout_moons(size)
   var v=g.comet_visual
   check(v.light_landscape.visible==light,"quality ownership")
   check(v.landscape.visible==not light,"full ownership")
   check(v.light_landscape.get_child_count()==14,"existing shoulder plates only")
   for i in range(14):
    var p=v.light_landscape.get_child(i);var original=v.landscape.get_child(i)
    check(p.mesh==original.mesh,"shared mesh")
    check(p.material_override==original.material_override,"shared material")
    check(p.transform==original.transform,"preserved placement")
    for vertex in p.mesh.get_faces():check(absf(vertex.x)>=3.65,"outside corridor")
   for side in g.side_planes:check(not side.visible,"no flat side plane")
   for edge in g.track_edges:check(not edge.visible,"no neon edge")
   check(g.ground.material_override.shader.resource_path.ends_with("comet_stone.gdshader"),"same stone path")
   if size.x>size.y and size.y<650:
    for moon in g.moons:
     var pos=g.camera.unproject_position(moon.position)
     check(pos.x<size.x*.23 or pos.x>size.x*.76,"moons outside objective")
     check(pos.y<size.y*.4,"moons above horizon")
 for world in [0,1,2,3,5,4]:
  g.level=world;g.options.light=true;g.apply_world(world)
  check(g.comet_visual.light_landscape.visible==(world==4),"world lifecycle")
 print("COMET_LIGHT failures=",failures);quit(failures)
