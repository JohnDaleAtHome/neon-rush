extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 assert(not g.apply_stats_data({"records":[],"history":{}}))
 assert(g.apply_stats_data({"records":{"normal":{"best":12345,"runs":7}},"history":[{"mode":"normal","score":100,"distance":20,"treats":2,"seconds":3,"completed_at":"2026-10-31T12:00:00Z"},{"mode":"hard","score":-1},{"mode":"fake","score":1}]}))
 assert(g.stats.normal.best == 12345 and g.stats.normal.runs == 7 and g.history.size() == 1)
 assert(g.apply_stats_data({"records":{"normal":{"best":"bad","runs":-1}},"history":[]}))
 assert(g.stats.normal.best == 0 and g.stats.normal.runs == 0)
 print("PASS stats backup schema, exact best/run restoration, invalid rows/metrics rejected")
 quit()
