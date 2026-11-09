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
 # Only run this destructive path fixture under the runner's disposable user data.
 var data = OS.get_user_data_dir()
 assert(data.contains("neon-rush-test-"), "Use tools/run_tests.py for isolated user data")
 for entry in [["options","save_options"],["journey","save_checkpoint"],["stats","save_stats"]]:
  var path = data.path_join(entry[0]+".json")
  var original = FileAccess.get_file_as_string(path) if FileAccess.file_exists(path) else ""
  if FileAccess.file_exists(path): assert(DirAccess.remove_absolute(path)==OK)
  assert(DirAccess.make_dir_absolute(path)==OK)
  g.storage_warning = ""
  g.call(entry[1])
  assert(g.storage_warning == g.STORAGE_CAUTION, entry[0]+" open failure needs caution")
  assert(DirAccess.remove_absolute(path)==OK)
  if original != "":
   var restored=FileAccess.open(path,FileAccess.WRITE)
   assert(restored != null)
   restored.store_string(original)
   restored.close()
  g.storage_warning = ""
  g.call(entry[1])
  assert(g.storage_warning == "", entry[0]+" successful write must not warn")
  assert(FileAccess.file_exists(path))
 g.queue_free();await process_frame
 print("STORAGE_WARNING_OK live deferral, paused notice, once-only, dynamic panels, accurate backup limits, isolated native write failures")
 quit()
