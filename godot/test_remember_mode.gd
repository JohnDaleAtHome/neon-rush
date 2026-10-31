extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 for key in g.mode_names:
  g.options.last_mode = key
  g.restore_selected_mode()
  assert(g.mode == key and g.mode_select.selected == g.mode_names.find(key))
 g.options.last_mode = "invalid"
 g.restore_selected_mode()
 assert(g.mode == "story" and g.mode_select.selected == 0)
 g.mode = "hard"
 g.start_level()
 assert(g.options.last_mode == "hard" and g.mode_select.selected == 3)
 assert(g.mapped_legacy_options({"mode":"chase"}).last_mode == "chase")
 g.return_menu()
 g.on_fresh_pressed()
 assert(g.mode == "story" and g.options.last_mode == "story")
 print("PASS remembered mode validation, six dropdown states, legacy mode and fresh Story reset")
 quit()
