extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g)
 await process_frame
 g.set_process(false);g.options.sound=true
 g.mode="story";g.level=4;g.pieces=g.PIECES.slice(0,4);g.start_level();g.hearts=1;g.guard=0;g.hurt()
 assert(not g.running and g.action.text=="RETRY CHECKPOINT")
 assert(g.audio_players.size()==1)
 print("HEART_RETRY_AUDIO ",g.audio_players[0].stream.resource_path)
 assert(g.audio_players[0].stream.resource_path=="res://assets/bell.wav")
 g.stop_audio()
 await create_timer(.1).timeout
 g.start_level();g.shadow_gap=2.51;g.spawn_time=999;g._process(.1)
 assert(not g.running and g.action.text=="RETRY CHECKPOINT")
 print("SHADOW_RETRY_AUDIO_COUNT ",g.audio_players.size())
 if not g.audio_players.is_empty():print("SHADOW_RETRY_AUDIO ",g.audio_players[0].stream.resource_path)
 assert(g.audio_players.size()==1,"Shadow checkpoint retry must ring the same silver bell")
 assert(g.audio_players[0].stream.resource_path=="res://assets/bell.wav")
 assert(g.level==4 and g.pieces==g.PIECES.slice(0,4))
 g.stop_audio()
 await create_timer(.1).timeout
 g.options.sound=false;g.start_level();g.shadow_gap=2.51;g._process(.1)
 assert(g.audio_players.is_empty())
 print("PASS shadow capture bell, heart retry parity, sound off and checkpoint preserved")
 g.stop_audio()
 await create_timer(.1).timeout
 g.queue_free()
 await process_frame
 quit()
