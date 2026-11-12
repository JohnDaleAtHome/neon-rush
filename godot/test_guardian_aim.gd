extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g);await process_frame
 g.set_process(false);g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.start_level();g.options.sound=false;g.stop_audio()
 for t in range(30):g._process(1.0/60)
 assert(g.guardian_aim_event=="warning" and not g.guardian_aim.launched)
 var age=g.guardian_aim.warning_age
 g.toggle_pause()
 for t in range(300):g._process(1.0/60)
 assert(g.guardian_aim.warning_age==age and not g.guardian_aim.launched)
 g.toggle_pause();g.lane=0;g.player.position.x=g.LANES[0]
 for t in range(61):g._process(1.0/60)
 assert(g.guardian_aim.launched and g.guardian_aim.target_lane==1)
 for t in range(80):g._process(1.0/60)
 assert(g.hearts==3)
 assert(g.last_open and g.guardian_aim_event=="none")
 assert("ALIGN AND FIRE" in g.progress_label.text)
 g.start_level();assert(not g.guardian_aim.launched and g.guardian_aim.target_lane==-1)
 # Existing two-hit cap and next-window win, with new loop active.
 g.boss_clock=2.5;g._process(.01);g.lane=g.boss_lane;g.player.position.x=g.LANES[g.lane]
 for n in range(3):
  g.fire_time=0;g.input_action(3)
  for t in range(18):g._process(1.0/60)
 assert(g.boss_hp==1 and g.boss_hits==2)
 g.boss_clock=4.79;g._process(.02);g.boss_clock=7.19;g._process(.02)
 g.lane=g.boss_lane;g.player.position.x=g.LANES[g.lane];g.boss.position.x=g.player.position.x
 for n in range(2):
  g.fire_time=0;g.input_action(3)
  for t in range(18):g._process(1.0/60)
 assert(g.action.text=="NEW JOURNEY" and g.boss==null)
 g.stop_audio();g.queue_free();await process_frame
 print("GUARDIAN_AIM_TEST_PASS pause/lock/dodge/open/reset/twohit/reunion SYNTHETIC")
 quit()
