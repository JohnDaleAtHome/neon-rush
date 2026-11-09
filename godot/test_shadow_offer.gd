extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g)
 await process_frame
 g.set_process(false);g.mode="story";g.level=4;g.pieces=g.PIECES.slice(0,4);g.start_level()
 var pieces=g.pieces.duplicate()
 g.pending_advance=true
 g.show_beat(g.LEVEL_NAMES[4],"The shadow corners Mochi. You don't have to be dark alone. Have a mochi.","OFFER A MOCHI")
 g.show_story_encounter(4)
 var actor=g.story_props[0]
 var art=actor.get_node("ShadowKindnessOffer") as Sprite3D
 assert(art.texture.get_width()==656 and art.texture.get_height()==518)
 assert(not art.shaded and art.alpha_cut==SpriteBase3D.ALPHA_CUT_DISCARD)
 assert(g.story_props.size()==2 and not g.running and not g.player.visible)
 assert(g.action.text=="OFFER A MOCHI" and g.story_props[1].text=="A SHADOW, ALONE")
 for light in [false,true]:
  g.options.light=light;g.apply_options()
  for size in [Vector2(390,844),Vector2(844,390),Vector2(320,568),Vector2(1280,720),Vector2(390,844)]:
   g.layout_encounter(size)
   var pos=actor.position;var labelpos=g.story_props[1].position;var local=art.position
   g.layout_encounter(size)
   assert(actor.position.is_equal_approx(pos) and art.position.is_equal_approx(local))
   assert(g.story_props[1].position.is_equal_approx(labelpos))
   assert(is_equal_approx(art.scale.x,1.45 if size==Vector2(844,390) else 1.0))
   assert(g.pieces==pieces and g.pending_advance and not g.running)
 g.on_action()
 assert(g.unlock and g.player.visible and g.story_props.is_empty())
 assert(g.level==4 and g.pieces==pieces)
 await process_frame
 assert(not is_instance_valid(actor))
 for which in [2,3]:
  g.level=which;g.show_story_encounter(which)
  assert(g.story_props[0].get_node_or_null("ShadowKindnessOffer")==null)
  g.clear_encounter()
  await process_frame
 g.return_menu()
 assert(g.story_props.is_empty())
 g.stop_audio();await create_timer(.1).timeout;g.queue_free();await process_frame
 print("PASS original Shadow offer texture, both qualities/four layouts, resize reversibility, unchanged one-action progression, other encounters and cleanup")
 quit()
