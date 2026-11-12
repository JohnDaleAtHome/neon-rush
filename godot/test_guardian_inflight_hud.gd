extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.start_level();g.options.sound=false;g.stop_audio()
 g._process(1.0/60)
 assert(g.message.text=="SHIELD CLOSED - DODGE THE AIM")
 g.lane=2
 for t in range(144):g._process(1.0/60)
 assert(g.last_open and g.hearts==3 and g.guardian_bolt_approaching())
 assert(g.message.text=="SHIELD OPEN - BOLT STILL IN FLIGHT")
 assert(g.progress_label.text=="SHIELD OPEN - ALIGN AND FIRE")
 g.guardian_feedback="HIT! Guardian 2 / 3";g.guardian_feedback_time=.9;g.boss_hits=2;g.update_hud()
 assert(g.status_label.text==g.guardian_feedback)
 assert(g.progress_label.text=="TWO HITS - WAIT FOR NEXT GREEN")
 g.paused=true;g.message.text="PAUSED";g.update_hud();assert(g.message.text=="PAUSED")
 g.paused=false
 for t in range(40):g._process(1.0/60)
 assert(g.last_open and not g.guardian_bolt_approaching() and g.message.text=="")
 g.start_level();assert(not g.guardian_bolt_approaching())
 g.mode="mission";g.mission_phase=2;g.last_open=true;g.message.text="MISSION UNCHANGED";g.update_hud()
 assert(g.message.text=="MISSION UNCHANGED")
 g.stop_audio();g.queue_free();await process_frame
 print("GUARDIAN_INFLIGHT_HUD_TEST_PASS: overlappingflight/open/fire/feedback/cap/pause/clear/reset/Mission")
 quit()
