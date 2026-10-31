extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 for which in [2,3,4]:
  g.level = which
  g.show_story_encounter(which)
  assert(g.story_props.size() == 2)
  var actor = g.story_props[0]
  assert(actor.name == "KindnessActor")
  assert(actor.get_child_count() >= 6)
  assert(g.story_props[1] is Label3D)
  assert(not g.player.visible)
  for part in actor.get_children(): assert(part is MeshInstance3D)
  for size in [Vector2(390,819),Vector2(1280,800),Vector2(844,390)]:
   g.layout_encounter(size)
   var before = actor.position
   g.layout_encounter(size)
   assert(actor.position.is_equal_approx(before))
  g.clear_encounter()
  assert(g.story_props.is_empty() and g.player.visible)
  await process_frame
  assert(not is_instance_valid(actor))
 print("PASS firefly wings/light/vines, turtle head/feet/eyes/shell, shadow ears/eyes/arms, resize and cleanup")
 quit()
