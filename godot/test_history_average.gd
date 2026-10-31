extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 var rows = [{"mode":"normal","score":100,"distance":20,"treats":1,"seconds":3},{"mode":"normal","score":300,"distance":40,"treats":4,"seconds":7}]
 assert(g.shown_average(rows) == "Shown average (2 runs):\n200 pts / 30m / 2.5 treats / 5s\n\n")
 assert(g.shown_average([]) == "")
 var filtered = rows.filter(func(r): return r.score > 100)
 assert("300 pts / 40m / 4.0 treats / 7s" in g.shown_average(filtered))
 rows.sort_custom(func(a,b): return a.score > b.score)
 assert("300 pts" in g.shown_average(rows.slice(0,1)))
 print("PASS shown-row averages, empty history, filter and sorted subset")
 quit()
