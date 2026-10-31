extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 var old = g.mapped_legacy_options({"motion":true})
 assert(old.motion and old.motion_system == false)
 assert(not g.mapped_legacy_options({"motion":null}).has("motion_system"))
 g.options.motion_system = false
 g.options.motion = true
 g.apply_options()
 assert(g.reduced_motion() and g.animator.speed_scale == 0)
 g.options.motion = false
 g.apply_options()
 assert(not g.reduced_motion() and g.animator.speed_scale == 1)
 print("PASS explicit motion preferences, legacy override, system fallback mapping")
 quit()
