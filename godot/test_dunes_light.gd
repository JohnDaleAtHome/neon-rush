extends SceneTree
func _init():call_deferred("run")
func inspect(n):
 assert(not n is CollisionObject3D)
 for c in n.get_children():inspect(c)
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var d=g.dunes_visual;var lite=d.light_landscape;var tower=d.light_tower
 assert(lite.get_child_count()==1);inspect(lite)
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame
  for world in range(6):
   for light in [false,true]:
    g.options.light=light;g.apply_world(world);await process_frame;g.layout_moons(dims)
    assert(lite.visible==(world==1 and light));assert(d.landscape.visible==(world==1 and not light))
    if world==1 and light:
     var footing=tower.get_child(tower.get_child_count()-1)
     var b=footing.global_transform*footing.get_aabb()
     assert(b.position.x>-27.7 and b.end.x<-3.7)
     assert(b.position.z>-137 and b.end.z<13)
     assert(absf(b.position.y+0.13)<0.0001)
     for c in g.side_planes:assert(c.visible)
     if dims.x>dims.y and dims.y<650:
      var at=g.camera.unproject_position(tower.position)
      assert(at.x<root.get_visible_rect().size.x*0.40)
 print("PASS DunesLight single existing pagoda, flat footing contact/footprint, no collision,4sizes all-world/quality ownership")
 quit()
