extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var original=[]
 for e in g.track_edges:original.append(e.material_override)
 g.level=3;g.apply_world(3)
 check(g.sea_visual.active,"Sea active")
 check(g.sea_visual.landscape.get_child_count()==9,"2water6rock1surf")
 check(g.ground.material_override.shader.resource_path.ends_with("sea_water.gdshader"),"path material")
 for p in g.scene_props:check(not p.visible,"decorative rings hidden")
 for side in g.side_planes:check(not side.visible,"base side hidden")
 check(g.lane_guides.size()==2,"guides unchanged")
 for child in g.sea_visual.landscape.get_children():
  check(not child is CollisionObject3D,"scenery no collision")
  if child.name!="StackSurf":check(absf(child.position.x)>8.0,"scenery away from playable lanes")
  if child is MeshInstance3D and child.name!="StackSurf":
   check(child.mesh is PlaneMesh,"water mesh")
   check(child.mesh.subdivide_width<=80,"bounded subdivision")
 var surf=g.sea_visual.landscape.get_node("StackSurf")
 check(surf.mesh.get_surface_count()==1,"one batched surf surface")
 for v in surf.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]:check(v.is_finite() and absf(v.x)>3.65,"finite off-track surf")
 check(g.env_world.environment.sky.sky_material.shader.resource_path.ends_with("sea_sky.gdshader"),"Sea sky ownership")
 g.options.motion=true;g.apply_world(3);check(not g.sea_visual.water_material.get_shader_parameter("animate"),"reduced motion");check(not surf.material_override.get_shader_parameter("animate"),"reduced surf motion")
 g.options.light=true;g.apply_world(3);check(not g.sea_visual.landscape.visible,"Light hides sea")
 for side in g.side_planes:check(side.visible,"Light restores sides")
 for i in range(g.track_edges.size()):check(g.track_edges[i].material_override==original[i],"Light restores edge")
 g.options.light=false
 for world in [0,1,2,4,5,3]:
  g.level=world;g.apply_world(world);check(g.sea_visual.active==(world==3),"world ownership")
  if world!=3:
   for i in range(g.track_edges.size()):check(g.track_edges[i].material_override==original[i],"world restores edge")
 for dim in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=dim;await process_frame;g.layout_moons(dim);check(g.sea_visual.landscape.visible,"aspect sea visible")
 print("SEA_VISUAL failures=",failures);quit(failures)
