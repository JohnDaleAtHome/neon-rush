extends SceneTree
func _init():call_deferred("run")
func inspect(n):
 assert(not n is CollisionObject3D)
 if n is MeshInstance3D:
  var b=n.global_transform*n.get_aabb()
  assert(b.position.x>-27.7 and b.end.x<-3.7)
  assert(b.position.z>-137 and b.end.z<13)
 for c in n.get_children():inspect(c)
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var v=g.meadow_visual;var lite=v.light_village
 assert(lite.get_child_count()==2)
 inspect(lite)
 var house=v._village_house_mesh(lite.get_child(0));var b=house.global_transform*house.get_aabb()
 assert(absf(b.position.y+0.13)<0.0001)
 assert(is_equal_approx(lite.get_child(1).position.y,-0.13))
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame
  for world in range(6):
   for light in [false,true]:
    g.options.light=light;g.apply_world(world);await process_frame
    assert(lite.visible==(world==0 and light))
    assert(v.horizon_root.visible==(world==0 and not light))
    if world==0 and light:
     for side in g.side_planes:assert(side.visible)
     assert(g.scene_props.is_empty())
 print("PASS MeadowLightVillage existing house/flat top, side footprint/ground contact/no collision,4sizes all-world quality ownership")
 quit()
