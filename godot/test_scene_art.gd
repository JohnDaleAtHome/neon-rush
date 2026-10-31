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
 g.options.stars = false
 g.apply_options()
 for moon in g.moons: assert(not moon.visible)
 g.options.stars = true
 g.apply_options()
 for moon in g.moons: assert(moon.visible)
 print("PASS six themed shader skies/terrain/lunar relief and moon visibility preference")
 quit()
