extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.mode = "story"
 g.level = 5
 g.pieces = g.PIECES.duplicate()
 g.start_level()
 assert(g.boss.mesh is SphereMesh)
 assert(g.boss.has_node("EclipseRing"))
 assert(g.boss.get_child_count() == 5)
 g.update_guardian_art(false)
 var closed = g.boss.get_node("EclipseRing").material_override.albedo_color
 g.update_guardian_art(true)
 var opened = g.boss.get_node("EclipseRing").material_override.albedo_color
 assert(closed != opened)
 g.spawn_time = 999
 g.boss_clock = 2.5
 g._process(0.01)
 g.lane = g.boss_lane
 g.player.position.x = g.LANES[g.lane]
 for n in range(3):
  g.fire_time = 0
  g.input_action(3)
  for tick in range(18): g._process(1.0/60)
 assert(g.boss_hp == 2)
 assert(g.boss_hits == 2)
 assert("wait for green" in g.guardian_feedback)
 assert("WAIT FOR NEXT GREEN" in g.progress_label.text)
 g.boss_clock = 4.79
 g._process(0.02)
 assert(not g.last_open)
 g.boss_clock = 7.19
 g._process(0.02)
 assert(g.last_open and g.boss_hits == 0)
 g.lane = g.boss_lane
 g.player.position.x = g.LANES[g.lane]
 g.boss.position.x = g.player.position.x
 for n in range(2):
  g.fire_time = 0
  g.input_action(3)
  for tick in range(18): g._process(1.0/60)
 assert(g.action.text == "NEW JOURNEY")
 assert(not g.fresh_button.visible)
 g.show_beat("Menu", "Choose", "START STORY")
 assert(g.fresh_button.visible)
 print("GUARDIAN_FEEDBACK_TEST_PASS: unchanged two-hit windows, HP4 to reunion, next-window cue, one reunion action")
 quit()
