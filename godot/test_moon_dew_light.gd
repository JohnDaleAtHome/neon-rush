extends SceneTree
var failures=0
func check(ok:bool,label:String):
 if not ok:failures+=1;push_error(label)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.options.sound=false;g.stop_audio();g.options.motion_system=false
 for light in [false,true]:
  for reduced in [false,true]:
   g.options.light=light;g.options.motion=reduced;g.level=0;g.pieces=[];g.start_level();g.dew=6;g.begin_unlock()
   var bridge=g.gate;var effect=bridge.get_node_or_null("MoonDewGroundLight")
   check(effect is MeshInstance3D,"Meadow crossing owns only mesh light")
   check(effect.get_child_count()==0,"no collider or processing child")
   check(effect.mesh is PlaneMesh and effect.mesh.size==Vector2(7,72),"single two-triangle surface")
   check(effect.material_override.get_shader_parameter("phase")== (3.0 if reduced else 0.0),"reduced motion starts steady")
   for n in range(60):g._process(1.0/60.0)
   var phase=float(effect.material_override.get_shader_parameter("phase"));var t=g.unlock_time
   check(absf(phase-(3.0 if reduced else t))<0.0001,"phase follows active crossing only")
   g.paused=true
   for n in range(60):g._process(1.0/60.0)
   check(g.unlock_time==t and effect.material_override.get_shader_parameter("phase")==phase,"pause freezes light")
   g.paused=false
   for n in range(240):g._process(1.0/60.0)
   check(g.level==0 and g.pieces.size()==0,"no early piece or shortened crossing")
   g._process(1.0/60.0);await process_frame
   check(g.level==1 and g.pieces==["Moon Dew Vial"] and not g.unlock,"unchanged ordered reward")
   check(not is_instance_valid(bridge) and not is_instance_valid(effect),"light freed with bridge")
 for world in range(1,5):
  g.level=world;g.pieces=g.PIECES.slice(0,world);g.start_level();g.begin_unlock()
  check(g.gate.get_node_or_null("MoonDewGroundLight")==null,"no light on other crossings")
 g.level=0;g.pieces=[];g.start_level();g.begin_unlock();var effect=g.gate.get_node("MoonDewGroundLight");g.return_menu();await process_frame
 check(not is_instance_valid(effect),"menu removes light")
 g.stop_audio();g.queue_free();await process_frame
 print("MOON_DEW_LIGHT failures=",failures);quit(failures)
