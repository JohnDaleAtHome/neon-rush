extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false);g.stop_audio();g.options.sound=false
 assert(g.opening_card.visible and g.opening_card.texture!=null)
 assert(g.opening_card.mouse_filter==Control.MOUSE_FILTER_IGNORE)
 assert(g.opening_card.get_index()<g.message.get_index())
 var texture_id=g.opening_card.texture.get_instance_id()
 for mode in g.mode_names:
  g.mode=mode;g.start_level()
  assert(not g.opening_card.visible and g.running)
  g.toggle_pause();assert(g.paused and not g.opening_card.visible)
  g.toggle_pause();assert(not g.opening_card.visible)
  g.return_menu();assert(g.opening_card.visible)
  var old_text=g.message.text;g.open_settings();assert(g.popup_stack.size()==1 and g.opening_card.visible)
  g.popup_stack[-1].queue_free();await process_frame
  assert(g.message.text==old_text and g.opening_card.texture.get_instance_id()==texture_id)
 g.mode="story";g.level=0;g.pieces=[];g.start_level();g.pending_advance=true;g.show_story_encounter(0)
 assert(not g.opening_card.visible)
 g.pending_advance=false;g.show_beat("The silver bell rings","Retry","RETRY CHECKPOINT")
 assert(not g.opening_card.visible)
 g.show_beat("RUN COMPLETE","Done","RETRY RUN");assert(not g.opening_card.visible)
 g.return_menu()
 for dims in [Vector2i(390,844),Vector2i(844,500),Vector2i(1280,800)]:
  root.size=dims;await process_frame;g.adapt_layout()
  assert(g.opening_card.visible)
  var art=g.opening_card.get_global_rect();var message=g.message.get_global_rect();var panel=g.panel.get_global_rect()
  print("BOUNDS ",dims," art=",art," message=",message," panel=",panel)
  assert(not art.intersects(message) and not art.intersects(panel))
  for c in g.panel.get_children():
   if c.visible:assert(c.get_global_rect().end.y<=root.get_visible_rect().end.y+1)
 print("PASS menu-only opening image, six modes, pause/retry/encounter isolation, popup and layout")
 g.stop_audio();g.queue_free();await process_frame;quit()
