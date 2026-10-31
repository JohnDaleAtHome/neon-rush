extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.options.guides = false
 g.apply_options()
 assert(not g.lane_guides[0].visible)
 g.options.guides = true
 g.apply_options()
 assert(g.lane_guides[0].visible)
 for hand in ["left","center","right"]:
  g.options.hand = hand
  g.apply_options()
  assert(g.controls.offset_left >= 0 and g.controls.offset_right <= g.get_viewport().get_visible_rect().size.x)
 g.options.hand = "center"
 g.options.guides = false
 g.save_options()
 print("PASS lane guides visibility and all handed control bounds")
 g.queue_free()
 await process_frame
 quit()
