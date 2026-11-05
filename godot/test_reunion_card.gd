extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame
  for light in [false,true]:
   for large in [false,true]:
    g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.options.light=light;g.options.large=large;g.options.contrast=true;g.start_level();g.finish_story();await process_frame;g.adapt_layout();await process_frame
    var card=g.reunion_card
    assert(card.visible and not g.panel.visible and not g.message.visible and not g.running)
    assert(g.action.text=="NEW JOURNEY" and g.level==0 and g.pieces.is_empty())
    assert(card.primary.has_focus())
    var screen=g.get_viewport().get_visible_rect()
    for button in [card.primary,card.menu,card.settings]:
     var rect=button.get_global_rect();assert(rect.position.x>=0 and rect.end.x<=screen.size.x+.1 and rect.position.y>=0 and rect.end.y<=screen.size.y+.1)
     assert(rect.size.y>=44)
    assert(card.words.get_global_rect().end.y<card.actions.position.y or dims.x>dims.y*1.3)
    var count=g.stats.story.runs
    card.settings.pressed.emit();await process_frame
    var popup=g.overlay_root.get_child(g.overlay_root.get_child_count()-1);assert(popup is PanelContainer and popup.get_index()>card.get_index());popup.queue_free();await process_frame
    assert(card.visible and g.stats.story.runs==count)
    card.menu.pressed.emit();assert(not card.visible and g.panel.visible)
    assert(g.stats.story.runs==count)
    g.finish_story();card.primary.pressed.emit();assert(g.running and g.level==0 and not card.visible and g.pieces.is_empty())
    assert(g.stats.story.runs==count)
 g.queue_free();await process_frame
 print("PASS Reunion 4sizes Light/large/highcontrast; targets bounds focus settings menu restart one completion no extra viewport")
 quit()
