extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.mode = "story"
 g.level = 4
 g.pieces = g.PIECES.slice(0,4)
 for reason in ["hearts","shadow","restart"]:
  g.start_level()
  g.input_action(2)
  g.fire_time = 0.3
  g.jump_buffer = 0.12
  g.touch_active = true
  g.touch_moved = true
  g.touch_origin = Vector2(100,500)
  if reason == "hearts":
   g.hearts = 1
   g.hurt()
   g.on_action()
  elif reason == "shadow":
   g.shadow_gap = 2.5001
   g._process(1.0/60)
   g.on_action()
  else:
   g.toggle_pause()
   g.request_discard("restart")
   g.request_discard("restart")
  assert(g.slide_time == 0 and g.fire_time == 0 and g.jump_buffer == 0)
  assert(not g.touch_active and not g.touch_moved and g.touch_origin == Vector2.ZERO)
  assert(g.level == 4 and g.pieces.size() == 4 and g.hearts == 3 and g.elapsed == 0)
  var release = InputEventScreenTouch.new()
  release.pressed = false
  release.position = Vector2(100,500)
  g._input(release)
  assert(g.velocity == 0)
 g.level = 5
 g.pieces = g.PIECES.duplicate()
 g.fire_time = 0.3
 g.start_level()
 g.input_action(3)
 assert(g.entities.size() == 1 and g.entities[0].get_meta("kind") == "shot")
 print("PASS retry/restart clears duck/fire/buffer/gesture state, stale release cannot jump, guardian first fire available")
 quit()
