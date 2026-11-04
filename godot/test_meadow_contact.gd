extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var shader=load("res://scripts/visuals/meadow_foliage.gdshader").code
 assert(shader.contains("float terrace=smoothstep(shoulder,shoulder+3.0,abs(x))*(7.0+3.0*sin(z*0.025))"))
 assert(shader.contains("-0.14+rear*outer*terrace+edge*rear*outer*"))
 for x in [-28.0,-18.0,18.0,28.0]:
  for z in [-25.0,-60.0,-100.0]:
   var h=g.meadow_visual._bank_height(x,z)
   assert(is_finite(h))
   var shoulder=16.0+sin(z*0.045)*3.0+(2.0 if x>0 else 0.0)
   var terrace=smoothstep(shoulder,shoulder+3.0,absf(x))*(7.0+3.0*sin(z*0.025))
   var edge=smoothstep(4.0,12.0,absf(x));var rear=1.0-smoothstep(112.0,144.0,-z);var outer=1.0-smoothstep(44.0,53.8,absf(x))
   var expected=-0.14+rear*outer*terrace+edge*rear*outer*(2.4+1.35*sin(z*0.055+x*0.14)+0.80*sin(z*0.12-x*0.19)+smoothstep(12.0,28.0,absf(x))*(2.0+4.5*exp(-pow((z+48.0)/28.0,2.0))+2.0*sin(z*0.045+x*0.08)))
   assert(absf(h-expected)<0.001)
 print("PASS terrace contact formula includes raised shoulders in foliage and CPU terrain")
 quit()
