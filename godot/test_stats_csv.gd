extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.history = [{"mode":"story","score":1028,"distance":364,"treats":6,"seconds":30,"completed_at":"2026-11-01T02:00:00","level":2,"outcome":"level complete"},{"mode":"normal","score":10,"distance":5,"treats":0,"seconds":1,"completed_at":"date,quoted","outcome":"a \"quote\"\nand line"}]
 var original = g.history.duplicate(true)
 var csv = g.stats_csv()
 assert(csv.begins_with("mode,score,distance_m,treats,seconds,completed_at,story_level,outcome\n"))
 assert("story,1028,364,6,30,2026-11-01T02:00:00,2,level complete\n" in csv)
 assert("normal,10,5,0,1,\"date,quoted\",,\"a \"\"quote\"\"\nand line\"\n" in csv)
 assert(g.csv_cell("a\rb") == "\"a\rb\"")
 assert(g.csv_cell(0) == "0" and g.csv_cell("") == "")
 assert(g.history == original)
 g.history = []
 assert(g.stats_csv().split("\n").size() == 2)
 print("PASS CSV story level/outcome, additive columns, numeric/empty cells, comma/quote/newline escaping and no mutation")
 quit()
