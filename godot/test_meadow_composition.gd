extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.start_level();g.apply_world(0)
 for size in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,500),Vector2i(360,640)]:
  root.size=size;await process_frame;g.adapt_layout();await process_frame
  g.layout_moons(Vector2(size))
  for moon in g.moons:
   var center=g.camera.unproject_position(moon.position)
   var radius=moon.mesh.radius*moon.scale.x
   var top=g.camera.unproject_position(moon.position+g.camera.global_basis.y*radius)
   assert(top.y>218.0,"lunar silhouette crosses objective band")
   assert(center.x>0 and center.x<size.x)
  assert(g.moons[0].scale.is_equal_approx(Vector3.ONE*0.88))
 g.options.stars=false;g.apply_options();for moon in g.moons:assert(not moon.visible)
 g.options.stars=true;g.apply_options();for moon in g.moons:assert(moon.visible)
 g.options.light=true;g.apply_options();assert(not g.meadow_visual.active)
 for moon in g.moons:assert(moon.scale.is_equal_approx(Vector3.ONE))
 g.options.light=false;g.apply_options();assert(g.meadow_visual.active)
 g.apply_world(1)
 assert(is_equal_approx(g.moons[0].scale.x,0.28))
 assert(g.moons[1].scale.x<0.002 and g.moons[2].scale.x<0.002)
 print("PASS clearing composition: four aspect ratios, lunar objective clearance, show-moons and Light/world restoration")
 quit()
