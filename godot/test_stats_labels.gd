extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 var record = {"best":1028,"distance":364,"treats":6,"seconds":30,"runs":4}
 var snapshot = record.duplicate(true)
 assert(g.mode_records_text("story",record) == "STORY\nBest score: 1028 pts\nLongest distance: 364m\nMost treats: 6\nLongest time: 30s\nRecorded level attempts: 4")
 assert("Recorded attempts: 4" in g.mode_records_text("normal",record))
 assert("Best score: 0 pts" in g.mode_records_text("mission",{}))
 assert(record == snapshot)
 g.stats.story = record
 g.totals = {"runs":4,"distance":1213,"treats":15,"seconds":100}
 g.open_stats()
 var texts = []
 collect_labels(g, texts)
 var rendered = "\n".join(texts)
 assert("4 recorded attempts / 1213m / 15 treats" in rendered)
 assert("Independent records, not one attempt." in rendered)
 assert("Story counts level attempts, not full journeys." in rendered)
 assert("Longest distance: 364m" in rendered)
 assert(g.totals.distance == 1213 and g.stats.story == snapshot)
 print("PASS independent record labels, Story level attempts, cumulative totals and no data mutation")
 quit()
func collect_labels(node: Node, texts: Array):
 if node is Label: texts.append(node.text)
 for child in node.get_children(): collect_labels(child,texts)
