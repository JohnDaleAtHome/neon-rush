extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.mode = "story"
 g.level = 0
 g.pieces = []
 g.stats = {}
 g.history = []
 g.start_level()
 g.dew = 6
 g._process(0.01)
 assert(g.pending_advance and not g.running)
 g.on_action()
 g.update_unlock(5.1)
 assert(g.level == 1 and g.stats.story.runs == 1 and g.history[0].outcome == "level complete")
 g.elapsed = 2
 g.score = 70
 g.return_menu()
 assert(g.stats.story.runs == 2 and g.stats.story.best >= 70)
 g.return_menu()
 assert(g.stats.story.runs == 2)
 g.start_level()
 g.hearts = 1
 g.hurt()
 assert(g.stats.story.runs == 3 and g.history[0].outcome == "checkpoint retry")
 g.level = 0
 g.pieces = []
 g.save_checkpoint()
 print("PASS six-Dew immediate progression, Story level stats, discard, duplicate protection, checkpoint retry stats")
 g.queue_free()
 await process_frame
 quit()
