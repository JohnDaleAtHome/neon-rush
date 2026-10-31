extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.totals = {"runs":0,"distance":0,"treats":0,"seconds":0}
 g.import_legacy_totals({"totals":{"runs":30,"distance":5000,"orbs":120}})
 assert(g.totals.runs == 30 and g.totals.treats == 120)
 g.mode = "story"
 g.level = 0
 g.start_level()
 g.distance = 20
 g.collected = 2
 g.elapsed = 3
 g.record_story_attempt("discarded")
 g.record_story_attempt("discarded")
 assert(g.totals.runs == 31 and g.totals.distance == 5020 and g.totals.treats == 122 and g.totals.seconds == 3)
 var payload = {"records":g.stats.duplicate(true),"history":g.history.duplicate(true),"totals":g.totals.duplicate(),"totals_scope":g.totals_scope}
 assert(g.apply_stats_data(payload))
 assert(g.totals.runs == 31)
 assert(g.apply_stats_data({"records":{},"history":[]}))
 assert(g.totals.runs == 0 and "this engine update" in g.totals_scope)
 print("PASS legacy totals, one-attempt increments, backup restore and honest missing-baseline scope")
 quit()
