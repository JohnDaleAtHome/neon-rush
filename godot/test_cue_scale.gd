extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for wh in [Vector2i(390,844),Vector2i(844,390),Vector2i(320,568),Vector2i(1280,800)]:
  root.size=wh;await process_frame;await process_frame
  for level in [0,1,2,3,4,5]:
   g.mode="story";g.level=level
   for kind in ["low","tall","beam"]:
    var h=g.box(Vector3(1.4,.8,1.2),Vector3(0,.4,-12),Color.WHITE)
    g.decorate_hazard(h,kind);g.add_cue(h,kind);g.entities.append(h)
    var c=h.get_meta("action_cue");var original=c.position
    for z in [-44.,-24.,-12.,-6.,-3.,0.,8.]:
     h.position.z=z;g.refresh_hazard_cues()
     var base=g.camera.unproject_position(c.global_position);var top=g.camera.unproject_position(c.global_position+Vector3.UP*c.font_size*c.pixel_size)
     var expected=clampf(16./maxf(base.distance_to(top),.01),1.,4.)
     assert(absf(c.scale.x-expected)<.001)
     assert(c.position==original and not c.no_depth_test)
     assert(absf(c.global_rotation.z)<.001)
     assert(c.text=={"low":"JUMP","tall":"DODGE","beam":"SLIDE"}[kind])
    g.entities.erase(h);h.queue_free()
 g.mode="story";g.level=4;g.start_level();g.set_process(false)
 var h=g.box(Vector3(1.4,2.5,1.2),Vector3(0,1.25,-12),Color("b84569"));g.decorate_hazard(h,"tall");g.add_cue(h,"tall");h.set_meta("kind","tall");h.set_meta("lane",1);h.set_meta("sway",true);g.entities.append(h)
 var c=h.get_meta("action_cue")
 for light in [false,true]:
  g.options.light=light;g.apply_options()
  for wh in [Vector2i(390,844),Vector2i(844,390),Vector2i(320,568),Vector2i(1280,800)]:
   root.size=wh;await process_frame;await process_frame
   g.paused=true;var pos=h.position;var elapsed=g.elapsed
   g._process(.2)
   assert(h.position==pos and g.elapsed==elapsed)
   var a=g.camera.unproject_position(c.global_position);var b=g.camera.unproject_position(c.global_position+Vector3.UP*c.font_size*c.pixel_size)
   assert(absf(c.scale.x-clampf(16./a.distance_to(b),1.,4.))<.001)
   g.paused=false;g._process(.016)
   assert(h.position!=pos and absf(c.global_rotation.z)<.001)
 print("PASS 4 sizes 6 worlds 3 kinds 7 depths bounded scale, positions, upright, depth, words plus Full/Light paused resize and resumed sway")
 quit()
