extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame
  g.level=3
  for light in [false,true,false,true]:
   g.options.light=light;g.apply_world(3);g.apply_options();await process_frame
   assert(g.sea_visual.active==not light and g.sea_visual.landscape.visible==not light)
   assert(g.ground.material_override.shader.resource_path.ends_with("sea_causeway.gdshader"))
   assert(g.env_world.environment.sky.sky_material.shader.resource_path.ends_with("sea_sky.gdshader"))
   assert(not g.sky_stars.visible)
   for side in g.side_planes:
    assert(side.visible==light)
    if light:assert(side.material_override.shader.resource_path.ends_with("sea_light_water.gdshader"))
   for edge in g.track_edges:assert(edge.visible==not light)
   assert(is_equal_approx(g.moons[0].scale.x,.34))
   assert(g.sea_visual.landscape.get_child_count()==10)
  g.options.stars=false;g.apply_options()
  for moon in g.moons:assert(not moon.visible)
  g.options.stars=true
 for world in [0,1,2,4,5]:
  g.level=world;g.options.light=false;g.apply_world(world);g.apply_options()
  assert(not g.sea_visual.active and not g.sea_visual.landscape.visible)
  assert(not g.ground.material_override is ShaderMaterial or not g.ground.material_override.shader.resource_path.ends_with("sea_causeway.gdshader"))
 g.queue_free();await process_frame
 print("PASS Sea Light 4 sizes toggles sky paving quietmoon hiddengeometry and world cleanup")
 quit()
