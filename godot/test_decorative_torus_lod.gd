extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for level in [1,3]:
  g.apply_world(level);await process_frame;await process_frame
  assert(g.scene_props.size()==30)
  var triangles=0
  for i in range(30):
   var p=g.scene_props[i]
   assert(p.mesh is TorusMesh)
   assert(p.mesh.rings==24 and p.mesh.ring_segments==12)
   var side=-1 if i%2==0 else 1
   assert(is_equal_approx(p.position.x,side*(5.2+(i%3)*1.6)))
   assert(is_equal_approx(p.position.z,-i*4.5-8))
   var expected=(0.6+(i%3)*0.3) if level==1 else 0.85
   assert(is_equal_approx(p.mesh.outer_radius,expected))
   assert(is_equal_approx(p.mesh.inner_radius,expected*0.65 if level==1 else 0.7))
   var arrays=p.mesh.surface_get_arrays(0)
   triangles+=arrays[Mesh.ARRAY_INDEX].size()/3
  assert(triangles==17280)
  g.options.light=true;g.apply_world(level);await process_frame;await process_frame
  assert(g.scene_props.size()==0)
  g.options.light=false
 print("PASS decorative torus LOD exact dimensions/positions,30props,17280triangles perworld,Light cleanup")
 quit()
