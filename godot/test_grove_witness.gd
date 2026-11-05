extends SceneTree
func _init():call_deferred("run")
func run():
 var m=load("res://scripts/visuals/grove_witness.gd")
 assert(m.texture()==m.texture() and m.texture().get_size()==Vector2(384,562))
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims
  for light in [false,true]:
   var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false);g.options.light=light
   for which in [2,3,4]:
    g.level=which;g.show_story_encounter(which)
    var actor=g.story_props[0];assert(actor.has_node("WuGangWitness")== (which==2))
    if which==2:
     var s=actor.get_node("WuGangWitness");assert(s is Sprite3D and s.texture==m.texture())
     assert(s.position==Vector3(0.95,1,0) and not s.no_depth_test and not s.fixed_size)
     assert(not s.shaded and is_equal_approx(s.pixel_size*562,2.0))
    g.layout_encounter(dims);var before=actor.position;g.layout_encounter(dims);assert(actor.position.is_equal_approx(before))
    g.clear_encounter();await process_frame;assert(not is_instance_valid(actor) and g.story_props.is_empty())
   g.queue_free();await process_frame
 print("GROVE_WITNESS_TEST_PASS: exact/shared art, only Grove beat, 4 sizes/both quality/resize/cleanup, no runtime NPC or gameplay change")
 quit()
