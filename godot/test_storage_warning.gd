extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="normal";g.start_level();g.set_storage_warning();await process_frame
 assert(g.popup_stack.is_empty(),"Do not interrupt live movement")
 assert(not g.storage_notice_shown)
 g.toggle_pause();await process_frame
 assert(g.popup_stack.size()==1 and g.storage_notice_shown)
 var notice=g.popup_stack[0]
 assert(g.storage_warning.contains("not journey progress"))
 notice.queue_free();await process_frame;await process_frame
 g.set_storage_warning();await process_frame
 assert(g.popup_stack.is_empty(),"Notice only once per session")
 g.open_settings();await process_frame
 for label in get_nodes_in_group("storage_warning_labels"):
  assert(label.text==g.STORAGE_CAUTION and label.visible)
 g.popup_stack[0].queue_free();await process_frame;await process_frame
 g.storage_warning="";g.open_stats();await process_frame
 var labels=get_nodes_in_group("storage_warning_labels")
 assert(labels.size()==1 and not labels[0].visible)
 g.set_storage_warning()
 assert(labels[0].visible and labels[0].text==g.STORAGE_CAUTION)
 assert(g.popup_stack.size()==1,"No stacked warning over an existing panel")
 g.popup_stack[0].queue_free();await process_frame
 g.queue_free();await process_frame
 print("STORAGE_WARNING_OK live deferral, paused notice, once-only, dynamic panels, accurate backup limits")
 quit()
