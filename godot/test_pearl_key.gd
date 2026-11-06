extends SceneTree
var failures=0
var g
func check(ok:bool,label:String):
 if not ok:failures+=1;push_error(label)
func sea():
 g.mode="story";g.level=3;g.pieces=g.PIECES.slice(0,3);g.start_level();g.save_checkpoint();g.begin_unlock()
func step(seconds:float):
 for i in range(roundi(seconds*60)):g._process(1.0/60)
func _init():call_deferred("run")
func run():
 g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for light in [false,true]:
  for motion in [false,true]:
   g.options.light=light;g.options.motion_system=false;g.options.motion=motion
   sea()
   check(g.playable_sea_exit() and g.entities.size()==2 and g.speed==7,"two slowed hazards")
   check(g.entities[0].get_meta("kind")=="low" and g.entities[0].position==Vector3(-2.2,0.4,-18),"authored wave")
   check(g.entities[1].get_meta("kind")=="beam" and g.entities[1].position==Vector3(2.2,1.65,-28),"authored arch")
   var runs=g.totals.runs
   step(2)
   check(g.entities.size()==2 and g.entities[0].position.z < -3.9 and g.pieces.size()==3,"no random spawns or early reward")
   var z=g.entities[0].position.z;var t=g.unlock_time;var elapsed=g.elapsed
   g.toggle_pause();g._process(2)
   g.input_action(-1)
   check(g.entities[0].position.z==z and g.unlock_time==t and g.elapsed==elapsed and g.lane==1,"paused exit freezes input time hazards")
   root.size=Vector2i(844,390);await process_frame
   check(g.unlock_time==t,"resize does not advance exit")
   g.toggle_pause();step(3.1)
   check(g.level==4 and g.pieces==g.PIECES.slice(0,4) and not g.unlock,"clear lane completes once")
   check(g.totals.runs==runs+1,"one completion record")
   g.load_checkpoint();check(g.level==4 and g.pieces.size()==4,"completion checkpoint")
 # A grounded wave hit; last life returns to old checkpoint, no pearl.
 sea();g.hearts=1;g.input_action(-1);var runs=g.totals.runs;step(2.7)
 check(not g.unlock and not g.running and g.hearts==0 and g.pieces.size()==3 and g.action.text=="RETRY CHECKPOINT","fallible wave and no early pearl")
 check(g.totals.runs==runs+1,"one death record")
 g._process(3);check(g.totals.runs==runs+1,"no duplicate death")
 g.load_checkpoint();check(g.level==3 and g.pieces.size()==3,"reload before completion retains sea")
 g.on_action();check(g.gate==null and g.running and not g.unlock and g.level==3 and g.hearts==3,"retry sea not exit")
 # Same ordinary jump and slide controls/thresholds. No bonus farm.
 sea();g.input_action(-1);step(2.2);g.input_action(0);step(0.6)
 check(g.hearts==3 and g.jump_bonus==0 and g.risk_bonus==0,"jump wave without exit bonus")
 sea();g.input_action(1);step(3.6);g.input_action(2);step(0.6)
 check(g.hearts==3 and g.slide_time>0 and g.collected==0,"slide arch without pickups")
 sea();g.input_action(1);step(4.2);check(g.hearts==2,"ordinary arch damage")
 sea();g.hearts=2;g.guard=0.8;g.input_action(-1);step(0.1)
 check(g.guard<0.8 and g.player.position.x<0,"ordinary guard and movement progress")
 g.toggle_pause();g.request_discard("restart");g.request_discard("restart")
 check(g.gate==null and g.level==3 and not g.unlock and g.pieces.size()==3,"discard restart retains prior checkpoint")
 sea();g.return_menu();check(not g.running and not g.unlock and g.entities.is_empty() and g.gate==null,"menu cleans exit")
 # Story and Mission independently own max HP; reset never stacks key effect.
 g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.start_level()
 check(g.boss_hp==3 and g.guardian_max_hp()==3 and "one light breaks" in g.message.text,"key visibly weakens story")
 g.update_hud();check("Guardian 3 / 3" in g.hud.text,"story correct max display")
 g.guardian_feedback_time=.9;g.toggle_pause();g.update_hud()
 check("PAUSED" in g.message.text,"combat feedback cannot clear pause message")
 g.toggle_pause();g.hearts=1;g.guard=0;g.hurt();g.update_hud()
 check("silver bell" in g.message.text,"combat feedback cannot clear death message")
 g.boss_hp=1;g.start_level();check(g.boss_hp==3,"retry resets not stacks")
 g.mode="mission";g.start_level();g.mission_phase=2;g.update_hud()
 check(g.boss_hp==4 and g.guardian_max_hp()==4 and "Guardian 4 / 4" in g.hud.text,"mission remains four")
 g.boss=g.create_guardian();g.spawn_time=999;g.boss_clock=2.5;g._process(.01)
 g.lane=g.boss_lane;g.player.position.x=g.LANES[g.lane]
 for n in range(3):
  g.fire_time=0;g.input_action(3);step(.3)
 check(g.boss_hp==2 and g.boss_hits==2,"mission still two hits per window")
 g.boss_clock=4.79;g._process(.02);g.boss_clock=7.19;g._process(.02)
 g.lane=g.boss_lane;g.player.position.x=g.LANES[g.lane];g.boss.position.x=g.player.position.x
 for n in range(2):
  g.fire_time=0;g.input_action(3);step(.3)
 check(not g.running and "Mission complete" in g.message.text,"mission four hits completes second window")
 print("PEARL_KEY failures=",failures);quit(failures)
