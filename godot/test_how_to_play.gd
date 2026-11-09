extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var help=load("res://scripts/visuals/how_to_play.gd")
 assert(help.SECTIONS.size()==4)
 var text=""
 for section in help.SECTIONS:text+=section[0]+section[1]
 for required in ["A / D","Space","Down arrow or S","F during Guardian","P or Escape","M.","Swipe left / right","FIRE stays visible","not bridge pieces","current level again","not a restorable journey save","two hits"]:assert(required in text)
 for paused in [false,true]:
  if paused:g.start_level();g.toggle_pause()
  var state=[g.level,g.pieces.duplicate(),g.options.duplicate(true),g.stats.duplicate(true),g.elapsed,g.running,g.paused]
  var before=g.overlay_root.get_child_count()
  g.options_button.grab_focus();g.open_settings();await process_frame
  var settings=g.popup_stack.back();var button=settings.get_child(0).get_child(0).get_child(3)
  assert(button.text=="HOW TO PLAY");button.grab_focus();button.pressed.emit();await process_frame
  var popup=g.popup_stack.back();var list=popup.get_child(0).get_child(0)
  assert(list.get_child(0).text=="HOW TO PLAY" and list.get_child(1).has_focus())
  assert(g.popup_stack.size()==2 and button.focus_mode==Control.FOCUS_NONE)
  var connections=g.get_viewport().size_changed.get_connections().size()
  for size in [Vector2i(390,844),Vector2i(320,568),Vector2i(844,390),Vector2i(1280,720),Vector2i(390,844)]:
   root.size=size;await process_frame;await process_frame
   var rect=popup.get_global_rect();var bounds=g.get_viewport().get_visible_rect()
   assert(rect.position.x>=0 and rect.position.y>=0 and rect.end.x<=bounds.end.x+.1 and rect.end.y<=bounds.end.y+.1)
  for key in [KEY_P,KEY_M,KEY_LEFT,KEY_SPACE]:
   var e=InputEventKey.new();e.keycode=key;e.pressed=true;g._unhandled_key_input(e)
  assert([g.level,g.pieces,g.options,g.stats,g.elapsed,g.running,g.paused]==state)
  assert(list.get_child(-1).text=="DONE - CLOSE HELP");list.get_child(-1).pressed.emit();await process_frame;await process_frame
  assert(g.popup_stack.size()==1 and button.has_focus())
  assert(g.get_viewport().size_changed.get_connections().size()==connections-1)
  for i in range(3):
   var again=help.open(g);await process_frame;again.get_child(1).pressed.emit();await process_frame;await process_frame
   assert(g.popup_stack.size()==1 and button.has_focus())
  help.open(g);await process_frame
  var escape=InputEventKey.new();escape.keycode=KEY_ESCAPE;escape.pressed=true
  g._unhandled_key_input(escape);await process_frame;await process_frame
  assert(g.popup_stack.size()==1 and button.has_focus())
  g._unhandled_key_input(escape);await process_frame;await process_frame
  assert(g.popup_stack.is_empty() and g.overlay_root.get_child_count()==before and g.options_button.has_focus())
  assert([g.level,g.pieces,g.options,g.stats,g.elapsed,g.running,g.paused]==state)
 g.queue_free();await process_frame
 print("PASS read-only control/save guidance, Settings path, nested menu/pause focus, resize, close/reopen and no state changes")
 quit()
