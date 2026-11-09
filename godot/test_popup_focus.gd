extends SceneTree
func _init():call_deferred("run")
func accept():
 var e=InputEventAction.new();e.action="ui_accept";e.pressed=true;Input.parse_input_event(e);await process_frame
 e=InputEventAction.new();e.action="ui_accept";e.pressed=false;Input.parse_input_event(e);await process_frame;await process_frame
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for paused in [false,true]:
  if paused:g.start_level();g.toggle_pause()
  var before=g.overlay_root.get_child_count();var state=[g.level,g.pieces.duplicate(),g.options.duplicate(true),g.stats.duplicate(true),g.elapsed,g.running,g.paused]
  for name in ["settings","stats"]:
   var opener=g.options_button if name=="settings" else g.stats_button
   opener.grab_focus()
   for repeat in range(3):
    if name=="settings":g.open_settings()
    else:g.open_stats()
    await process_frame
    var popup=g.popup_stack.back();var list=popup.get_child(0).get_child(0);var close=list.get_child(1)
    assert(close.has_focus() and opener.focus_mode==Control.FOCUS_NONE)
    assert(g.popup_stack.size()==1 and g.overlay_root.get_child_count()==before+2)
    assert(g.overlay_root.get_child(-2).mouse_filter==Control.MOUSE_FILTER_STOP)
    for key in [KEY_P,KEY_M,KEY_LEFT,KEY_SPACE]:
     var e=InputEventKey.new();e.keycode=key;e.pressed=true;g._unhandled_key_input(e)
    assert([g.level,g.pieces,g.options,g.stats,g.elapsed,g.running,g.paused]==state)
    await accept()
    assert(g.popup_stack.is_empty() and g.overlay_root.get_child_count()==before)
    assert(opener.has_focus() and opener.focus_mode==Control.FOCUS_ALL)
  g.options_button.grab_focus();g.open_settings();await process_frame
  var settings=g.popup_stack.back();var button=settings.get_child(0).get_child(0).get_child(2)
  button.grab_focus();button.pressed.emit();await process_frame
  assert(g.popup_stack.size()==2 and button.focus_mode==Control.FOCUS_NONE)
  var escape=InputEventKey.new();escape.keycode=KEY_ESCAPE;escape.pressed=true
  g._unhandled_key_input(escape);await process_frame;await process_frame
  assert(g.popup_stack.size()==1 and button.has_focus())
  g._unhandled_key_input(escape);await process_frame;await process_frame
  assert(g.popup_stack.is_empty() and g.options_button.has_focus())
  assert(g.overlay_root.get_child_count()==before)
  assert([g.level,g.pieces,g.options,g.stats,g.elapsed,g.running,g.paused]==state)
 g.queue_free();await process_frame
 print("PASS Settings/Stats focus ownership, one Enter close, background shortcut/pointer isolation, nested Escape and state/focus restoration")
 quit()
