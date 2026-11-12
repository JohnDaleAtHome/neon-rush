extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.start_level();g.options.sound=false;g.stop_audio()
 var reference=RandomNumberGenerator.new();reference.seed=1237;g.rng.seed=1237
 for wave in range(12):
  var l=reference.randi_range(0,2)
  var safe=(l+1+reference.randi_range(0,1))%3
  var n=g.entities.size();g.spawn_wave();assert(g.entities.size()==n+2)
  for i in range(2):
   assert(g.entities[n+i].get_meta("kind")=="orb")
   assert(g.entities[n+i].position==Vector3(g.LANES[safe],1,[-34,-39][i]))
 assert(reference.state==g.rng.state)
 g.start_level();g.mode="mission";g.mission_phase=2
 var n=g.entities.size();g.spawn_wave();assert(g.entities.size()==n+3)
 assert(g.entities[n].get_meta("kind")=="low")
 g.mode="story";g.level=5
 for jumping in [false,true]:
  g.start_level()
  for t in range(61):g._process(1.0/60)
  assert(g.guardian_aim.launched)
  for t in range(66):g._process(1.0/60)
  if jumping:g.input_action(0)
  for t in range(42):g._process(1.0/60)
  assert(g.hearts==(3 if jumping else 2))
 g.start_level();g.boss_clock=2.2;g._process(.01)
 assert(g.guardian_aim_event=="warning")
 for t in range(20):g._process(1.0/60)
 assert(g.last_open and g.guardian_aim.target_lane==-1 and g.guardian_aim_event=="none")
 for item in g.entities:assert(item.get_meta("kind")=="orb")
 g.stop_audio();g.queue_free();await process_frame
 print("GUARDIAN_PICKUPS_TEST_PASS: original12wavepair/RNG/Mission, delayedstayhit/jumpclear/lateopen")
 quit()
