extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 var sky=g.env_world.environment.sky
 assert(sky != null)
 for light in [false,true,false]:
  g.options.light=light
  for level in [0,1,2,3,4,5,0]:
   g.apply_world(level)
   assert(g.env_world.environment.sky==sky,"Theme changes must reuse the scene-owned sky")
   assert(sky.sky_material != null)
 print("SKY_RESOURCE_LIFECYCLE_OK")
 g.queue_free()
 await process_frame
 quit()
