extends SceneTree
var failures=0
func check(ok:bool,label:String):
 if not ok:failures+=1;push_error(label)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.options.light=false;g.options.motion_system=false;g.mode="story"
 for world in range(5):
  g.level=world;g.pieces=g.PIECES.slice(0,world);g.start_level();g.begin_unlock()
  var bridge=g.gate
  check(bridge.name=="MoonBridgeCrossing" and bridge.get_meta("scenic_bridge",false),"decorative crossing owns bridge")
  check(bridge.get_child_count()==1,"one batched bridge mesh")
  var mesh=bridge.get_child(0).mesh
  for v in mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:check(v.is_finite() and absf(v.x)>3.65,"finite geometry outside playable lanes")
  var original=bridge.position
  for i in range(140):g._process(1.0/60.0)
  check(bridge.position==original,"bridge stays at ground instead of rising bar")
  check(g.level==world and g.unlock,"crossing duration unchanged before five seconds")
  check(g.pieces.size()==world,"no early piece reward")
  for i in range(162):
   if g.unlock:g._process(1.0/60.0)
  check(g.level==world+1 and not g.unlock,"existing next level after five seconds")
  check(g.gate==null,"bridge removed at level change")
  await process_frame;check(not is_instance_valid(bridge),"bridge freed after level change")
 g.level=2;g.pieces=g.PIECES.slice(0,2);g.start_level();g.begin_unlock();var bridge=g.gate;g.return_menu();await process_frame
 check(g.gate==null and not is_instance_valid(bridge),"menu cleans temporary bridge")
 print("CROSSING_VISUAL failures=",failures);quit(failures)
