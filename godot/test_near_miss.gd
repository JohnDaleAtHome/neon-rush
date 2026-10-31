extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.mode = "normal"
 g.start_level()
 g.spawn_time = 999
 var hazard = g.box(Vector3.ONE,Vector3(1.4,0,0),Color.WHITE)
 hazard.set_meta("kind","tall")
 g.entities.append(hazard)
 g._process(0.01)
 assert(g.running and g.risk_bonus == 0)
 g._process(0.08)
 assert(g.risk_bonus == 15 and g.pickup_feedback == "+15 NEAR MISS")
 g._process(0.08)
 assert(g.risk_bonus == 15)
 var far = g.box(Vector3.ONE,Vector3(2.2,0,0),Color.WHITE)
 far.set_meta("kind","tall")
 g.entities.append(far)
 g._process(0.1)
 assert(g.risk_bonus == 15)
 g.collected = 2
 g.chain_bonus = 25
 g.jump_bonus = 20
 g.score = 200
 assert(g.score_breakdown() == "40 distance + 100 treats\n25 chain + 20 jump + 15 near miss")
 g.distance = 249
 g.update_hud()
 assert("249 / 250m" in g.progress_label.text)
 g.collected = 10
 g.distance = 250
 g._process(0.01)
 assert(g.run_goal and g.progress_label.text == "GOAL COMPLETE")
 print("PASS close dodge only, once-per-hazard near miss, score breakdown and visible run goal")
 quit()
