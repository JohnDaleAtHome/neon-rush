extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.start_level()
 for world in [1,3]:
  g.apply_world(world)
  for dim in [Vector2i(844,500),Vector2i(812,375),Vector2i(1024,600)]:
   root.size=dim;await process_frame;g.layout_moons(dim)
   var horizon=g.camera.unproject_position(Vector3(0,0,-250)).y
   for m in [g.moons[0]]:
    var p=g.camera.unproject_position(m.position)
    var radius=m.mesh.radius*m.scale.x
    var top=g.camera.unproject_position(m.position+g.camera.global_basis.y*radius).y
    var bottom=g.camera.unproject_position(m.position-g.camera.global_basis.y*radius).y
    assert(top>100.0,"satellite overlaps top controls")
    assert(bottom<horizon-10.0,"satellite below horizon")
    assert(p.x<dim.x*0.23 or p.x>dim.x*0.76,"satellite overlaps objective center")
   var before=g.moons[0].position;g.layout_moons(dim);assert(before.is_equal_approx(g.moons[0].position))
  root.size=Vector2i(390,844);await process_frame;g.layout_moons(Vector2(390,844))
  if world==1:
   assert(is_equal_approx(g.moons[0].scale.x,0.28))
   assert(g.moons[1].scale.x<0.002 and g.moons[2].scale.x<0.002)
  else:
   assert(is_equal_approx(g.moons[0].scale.x,0.34))
   assert(g.moons[1].scale.x<0.002 and g.moons[2].scale.x<0.002)
 g.options.stars=false;g.apply_options();for m in g.moons:assert(not m.visible)
 print("PASS compact Dunes/Sea sky placement, three landscape sizes, portrait restoration, visibility and resize idempotence")
 quit()
