extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 for level in range(6):
  g.apply_world(level)
  assert(g.env_world.environment.sky.sky_material is ShaderMaterial)
  assert(g.ground.material_override is ShaderMaterial)
  assert(g.moons[0].material_override is ShaderMaterial)
  assert(g.moon_glows.size() == 3)
  assert(g.moons[0].material_override.get_shader_parameter("lunar_height") != null)
 for size in [Vector2(1280,720),Vector2(390,844),Vector2(844,500)]:
  g.layout_moons(size)
  for moon in g.moons:
   var screen = g.camera.unproject_position(moon.position)
   assert(screen.y > 235)
 assert(g.scenery.get_child_count() == 16)
 for tree in g.scenery.get_children():
  assert(absf(tree.position.x) >= 6.5)
  assert(tree.get_child_count() == 4)
 g.apply_world(5)
 assert(g.scene_props.size() == 120)
 for prop in g.scene_props: assert(absf(prop.position.x) >= 5.19)
 g.options.stars = false
 g.apply_options()
 for moon in g.moons: assert(not moon.visible)
 g.options.stars = true
 g.running = true
 g.apply_options()
 for moon in g.moons: assert(moon.visible)
 g.show_beat("Menu","A long narrative paragraph","START")
 for moon in g.moons: assert(not moon.visible)
 g.apply_options()
 for moon in g.moons: assert(not moon.visible)
 g.apply_world(0)
 for moon in g.moons: assert(not moon.visible)
 g.start_level()
 for moon in g.moons: assert(moon.visible)
 g.toggle_pause()
 for moon in g.moons: assert(not moon.visible)
 g.toggle_pause()
 for moon in g.moons: assert(moon.visible)
 print("PASS six themed shader skies/terrain/lunar relief and moon visibility preference")
 quit()
