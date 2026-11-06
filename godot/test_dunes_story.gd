extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for light in [false,true]:
  g.options.light=light;g.mode="story";g.level=1;g.pieces=[g.PIECES[0]];g.start_level();g.pending_advance=true
  g.show_beat("Silver Dunes","test","LIFT SILVER LANTERN");g.show_story_encounter(1)
  assert(g.story_props.size()==1 and not g.player.visible)
  var actor=g.story_props[0];assert(actor.name=="DunesStoryLantern")
  var prints=actor.get_child(1);assert(prints is MultiMeshInstance3D and prints.multimesh.instance_count==10)
  for size in [Vector2(390,844),Vector2(1280,800),Vector2(844,390),Vector2(320,568)]:
   g.layout_encounter(size);assert(actor.position==Vector3.ZERO)
  assert(g.pieces==[g.PIECES[0]])
  g.on_action();assert(g.unlock and g.story_props.is_empty() and g.player.visible)
  await process_frame;assert(not is_instance_valid(actor))
  var steps=0
  while g.unlock and steps<1000:g._process(1.0/60);steps+=1
  assert(g.level==2 and g.pieces==g.PIECES.slice(0,2))
 g.clear_encounter();g.level=0;g.show_story_encounter(0);assert(g.story_props.is_empty())
 print("PASS original Dunes lantern/ten sole prints, Full/Light, ground-anchored resize, unchanged reward and crossing cleanup")
 quit()
