extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 var before = g.overlay_root.get_child_count()
 g.open_settings()
 var popup = g.overlay_root.get_child(-1)
 var list = popup.get_child(0).get_child(0)
 var found = false
 for child in list.get_children():
  if child is Button and child.text == "DONE - CLOSE SETTINGS":
   found = true
   child.pressed.emit()
 assert(found)
 await process_frame
 assert(g.overlay_root.get_child_count() == before)
 print("PASS settings bottom footer closes only its popup")
 quit()
