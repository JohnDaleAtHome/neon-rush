extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var shader=load("res://scripts/visuals/meadow_foliage.gdshader").code
 assert(shader.contains("return -0.14+edge*rear*outer*(low+bluff)"))
 assert(shader.contains("low=0.65+0.45*sin(z*0.06+x*0.10)"))
 assert(shader.contains("bluff=3.0*exp(-pow((x-23.0)/16.0,2.0)-pow((z+54.0)/48.0,2.0))"))
 for x in [-54.0,-28.0,-18.0,-6.0,0.0,6.0,18.0,28.0,54.0]:
  for z in [-145.0,-100.0,-60.0,-25.0,10.0]:
   var h=g.meadow_visual._bank_height(x,z)
   assert(is_finite(h))
   var edge=smoothstep(4.0,12.0,absf(x));var rear=1.0-smoothstep(112.0,144.0,-z);var outer=1.0-smoothstep(44.0,53.8,absf(x))
   var low=0.65+0.45*sin(z*0.06+x*0.10);var bluff=3.0*exp(-pow((x-23.0)/16.0,2.0)-pow((z+54.0)/48.0,2.0)) if x>0 else 0.0
   assert(absf(h-(-0.14+edge*rear*outer*(low+bluff)))<0.001)
   if absf(x)<4.0:assert(absf(h+0.14)<0.001)
 print("PASS clearing contact: 45 CPU/foliage height samples, flat corridor and outer falloff")
 quit()
