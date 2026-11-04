extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.apply_world(5);await process_frame;await process_frame
 assert(g.scene_props.size()==120)
 var globes=0
 for p in g.scene_props:
  if p is MeshInstance3D and p.mesh is SphereMesh:
   assert(p.mesh.radial_segments==24 and p.mesh.rings==12)
   assert(is_equal_approx(p.mesh.radius,0.38) and is_equal_approx(p.mesh.height,0.70))
   assert(is_equal_approx(p.position.y,3.4))
   assert(p.get_child_count()==1)
   assert(p.material_override.emission_enabled)
   globes+=1
 assert(globes==30)
 g.options.light=true;g.apply_world(5);await process_frame;await process_frame;assert(g.scene_props.is_empty())
 g.options.light=false;g.apply_world(5);await process_frame;await process_frame;assert(g.scene_props.size()==120)
 g.apply_world(3);await process_frame;await process_frame;assert(g.scene_props.size()==30)
 print("PASS Palace30lanterns,exactsize/glow/height,tessellation,Lightrestore/worldcleanup")
 quit()
