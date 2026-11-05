extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false);g.mode="story";g.level=0;g.pieces=[];g.start_level()
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame
  for light in [true,false,true,false]:
   g.options.light=light;g.apply_options();g.adapt_layout();g.meadow_visual._process(0)
   assert(g.meadow_visual.active==not light)
   assert(g.meadow_visual.horizon_root.visible==not light)
   assert(g.meadow_visual.shadow.visible==not light)
   assert(g.scene_props.is_empty() if light else g.scene_props.size()==98)
   assert(g.env_world.environment.sky.sky_material.shader.resource_path.ends_with("meadow_sky.gdshader"))
   assert(g.ground.material_override.shader.resource_path.ends_with("meadow_light_ground.gdshader" if light else "meadow_terrain.gdshader"))
   for e in g.track_edges:assert(not e.visible)
   for p in g.side_planes:assert(p.visible==light)
   for i in range(3):
    var moon=g.moons[i]
    assert(moon.material_override.shader.resource_path.ends_with("meadow_moon.gdshader"))
    assert(moon.scale.is_equal_approx(Vector3.ONE*[.88,.42,.28][i]))
    assert(moon.position.is_finite())
   g.options.stars=false;g.apply_options()
   for moon in g.moons:assert(not moon.visible)
   g.options.stars=true;g.apply_options()
  g.options.light=true;g.apply_options()
  for level in [1,2,3,4,5,-1,0]:
   g.apply_world(level)
   if level!=0:assert(g.env_world.environment.sky.sky_material.shader.resource_path!="res://scripts/visuals/meadow_sky.gdshader")
   assert(not g.meadow_visual.horizon_root.visible)
 print("PASS Meadow Light/Full 4sizes x4toggles: cheap theme, no props/shadow/edges, moon option and other-world cleanup")
 quit()
