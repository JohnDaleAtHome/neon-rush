extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.mode = "normal"
 g.start_level()
 g.shield = true
 g.hurt()
 assert(g.running and not g.shield)
 g.guard = 0
 g.hurt()
 assert(not g.running and g.stats.normal.runs >= 1)
 g.start_level()
 for i in range(3):
  var orb = g.box(Vector3.ONE,Vector3(0,1,0),Color.WHITE)
  orb.set_meta("kind","orb")
  g.entities.append(orb)
  g._process(0.01)
 assert(g.collected == 3 and g.chain_bonus == 25 and g.magnet_time > 0)
 g.toggle_pause()
 var score = g.score
 g._process(2)
 assert(g.score == score)
 g.toggle_pause()
 g.return_menu()
 g.open_settings()
 g.open_stats()
 g.export_stats("JSON")
 g.export_stats("CSV")
 g.mode = "mission"
 g.start_level()
 g.mission_cores = 6
 g._process(0.016)
 assert(g.mission_phase == 1)
 g._process(18.1)
 assert(g.mission_phase == 2 and g.boss != null)
 g.options.motion = true
 g.apply_options()
 assert(g.animator.speed_scale == 0)
 g.options.motion = false
 g.apply_options()
 g.mode = "story"
 g.level = 3
 g.pieces = g.PIECES.slice(0,3)
 g.save_checkpoint()
 g.level = 0
 g.pieces = []
 g.load_checkpoint()
 assert(g.level == 3 and g.pieces.size()==3)
 var f = FileAccess.open("user://journey.json",FileAccess.WRITE)
 f.store_string('{"level":2,"pieces":["fake","fake"]}')
 f.close()
 g.level = 0
 g.pieces = []
 g.load_checkpoint()
 assert(g.level == 0 and g.pieces.is_empty())
 g.save_checkpoint()
 print("PASS shields, one-hit endless, chains, magnet, pause score, settings/stats/exports, mission phases, reduced motion, checkpoint, corrupt save")
 g.queue_free()
 await process_frame
 quit()
