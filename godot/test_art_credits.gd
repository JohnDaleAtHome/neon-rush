extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var credits=load("res://scripts/visuals/art_credits.gd")
 assert(FileAccess.file_exists(credits.NOTICE_PATH))
 assert("HAN-HOUSE-LICENSE.txt" in FileAccess.get_file_as_string("res://export_presets.cfg"))
 var text=credits.text()
 for required in ["Wildfire Games","https://www.wildfiregames.com/","https://creativecommons.org/licenses/by-sa/3.0/","Changes:","CC BY-SA 3.0","Copyright (C) 2009","Quaternius","Poly Haven","VVayToyek","Innerscene","Pixor","Mish7913"]:assert(required in text)
 for paused in [false,true]:
  if paused:g.start_level();g.toggle_pause()
  var before=g.overlay_root.get_child_count();var level=g.level;var pieces=g.pieces.duplicate();var time=g.elapsed
  g.open_settings()
  var settings=g.overlay_root.get_child(-1)
  var button=settings.get_child(0).get_child(0).get_child(2)
  assert(button.text=="ART CREDITS");button.grab_focus();button.pressed.emit();await process_frame
  var popup=g.overlay_root.get_child(-1);var list=popup.get_child(0).get_child(0)
  assert(list.get_child(1).has_focus() and button.focus_mode==Control.FOCUS_NONE)
  assert(g.overlay_root.get_child(-2).mouse_filter==Control.MOUSE_FILTER_STOP)
  var connections=g.get_viewport().size_changed.get_connections().size()
  assert(list.get_node("ArtCreditsNotice").text==text)
  for size in [Vector2i(390,844),Vector2i(320,568),Vector2i(844,390),Vector2i(1280,720),Vector2i(390,844)]:
   root.size=size;await process_frame;await process_frame
   assert(popup.position.x>=0 and popup.position.y>=0)
   assert(popup.position.x+popup.size.x<=g.get_viewport().get_visible_rect().size.x+.1)
   assert(popup.position.y+popup.size.y<=g.get_viewport().get_visible_rect().size.y+.1)
  var close=list.get_child(-1);assert(close.text=="DONE - CLOSE CREDITS");close.pressed.emit();await process_frame
  await process_frame
  assert(g.get_viewport().size_changed.get_connections().size()==connections-1)
  assert(g.overlay_root.get_child_count()==before+2 and is_instance_valid(settings))
  assert(button.has_focus() and button.focus_mode==Control.FOCUS_ALL)
  assert(g.level==level and g.pieces==pieces and g.elapsed==time)
  if paused:assert(g.paused)
  for i in range(3):
   var again=credits.open(g)
   again.get_child(1).pressed.emit();await process_frame;await process_frame
   assert(g.get_viewport().size_changed.get_connections().size()==connections-1)
   assert(g.overlay_root.get_child_count()==before+2)
  credits.open(g);await process_frame
  var key=InputEventAction.new();key.action="ui_accept";key.pressed=true;Input.parse_input_event(key);await process_frame
  key=InputEventAction.new();key.action="ui_accept";key.pressed=false;Input.parse_input_event(key);await process_frame;await process_frame
  assert(g.overlay_root.get_child_count()==before+2 and button.has_focus())
  settings.queue_free();await process_frame
 g.queue_free();await process_frame
 print("PASS preserved notice/contributors, Settings path, four-size resize, footer/keyboard close, background focus isolation/restore, menu/pause and unchanged state")
 quit()
