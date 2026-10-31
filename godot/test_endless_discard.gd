extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.stats.clear()
 g.history.clear()
 g.totals = {"runs":0,"distance":0,"treats":0,"seconds":0}
 for mode in ["easy","normal","hard","chase","mission"]:
  g.mode = mode
  g.start_level()
  g.elapsed = 9.0
  g.score = 800.0
  g.distance = 50.0
  g.collected = 3
  g.toggle_pause()
  g.request_discard("restart")
  assert(not g.stats.has(mode))
  g.request_discard("restart")
  assert(g.stats[mode].runs == 1 and g.stats[mode].best == 800)
  assert(g.running and not g.paused and g.elapsed == 0)
  g.elapsed = 4.0
  g.distance = 10.0
  g.toggle_pause()
  g.request_discard("menu")
  g.request_discard("menu")
  assert(g.stats[mode].runs == 2)
  g.return_menu()
  assert(g.stats[mode].runs == 2)
 assert(g.totals.runs == 10 and g.totals.seconds == 65 and g.history.size() == 10)
 g.mode = "normal"
 g.start_level()
 g.elapsed = 1.0
 g.finish_run("test")
 g.finish_run("duplicate")
 assert(g.stats.normal.runs == 3 and g.totals.runs == 11)
 print("PASS five endless-mode confirmed discards, restart/menu, totals and no duplicate accounting")
 quit()
