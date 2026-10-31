extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.mode = "story"
 g.level = 3
 g.start_level()
 g.pending_advance = true
 g.show_beat("Storm Sea","Wake a friend with a kind word.","SPEAK KINDLY TO THE TURTLE")
 g.show_story_encounter(3)
 assert(not g.player.visible)
 assert(not g.fresh_button.visible and not g.sound_button.visible and not g.options_button.visible and not g.stats_button.visible)
 for size in [Vector2(390,819),Vector2(1280,800),Vector2(844,390)]:
  g.layout_encounter(size)
  var before = g.story_props[0].position
  g.layout_encounter(size)
  assert(g.story_props[0].position.is_equal_approx(before))
 g.on_action()
 assert(g.player.visible and g.story_props.is_empty() and g.unlock)
 g.start_level()
 g.toggle_pause()
 assert(g.sound_button.visible and g.options_button.visible and g.stats_button.visible)
 g.return_menu()
 assert(g.sound_button.visible and g.options_button.visible and g.stats_button.visible)
 assert(is_equal_approx(g.dimmer.color.a,0.78))
 print("PASS dedicated kindness beat, one action, actor visibility, resize idempotence and restored run/menu")
 quit()
