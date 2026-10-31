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
 g.height = 0.02
 g.velocity = -2
 g.input_action(0)
 assert(g.jump_buffer > 0)
 g._process(0.02)
 assert(g.velocity > 0 and g.jump_buffer == 0)
 g.height = 2
 g.velocity = 0
 g.input_action(0)
 g._process(0.13)
 assert(g.jump_buffer == 0 and g.velocity < 0)
 g.start_level()
 g.spawn_time = 999
 g.height = 1
 g.velocity = 0
 var other = g.box(Vector3.ONE,Vector3(g.LANES[0],0,1.0),Color.WHITE)
 other.set_meta("kind","low")
 g.entities.append(other)
 g._process(0.02)
 assert(g.jump_bonus == 0)
 var same = g.box(Vector3.ONE,Vector3(g.LANES[1],0,0.9),Color.WHITE)
 same.set_meta("kind","low")
 g.entities.append(same)
 g._process(0.005)
 g._process(0.03)
 assert(g.jump_bonus == 20)
 g._process(0.03)
 assert(g.jump_bonus == 20)
 print("PASS 120ms landing jump buffer, expired buffer, lane-specific jump clear and one-time award")
 quit()
