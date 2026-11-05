extends SceneTree
func _init():call_deferred("run")
func inspect(n:Node)->void:
 assert(not n is CollisionObject3D)
 if n is MeshInstance3D:
  assert(n.position.is_finite())
  if n.mesh is ArrayMesh:
   for surface in range(n.mesh.get_surface_count()):
    for local_v in n.mesh.surface_get_arrays(surface)[Mesh.ARRAY_VERTEX]:
     var v=n.global_transform*local_v
     assert(v.is_finite())
     assert(absf(v.x)>=3.59 or v.z<=-145.0,"dune enters near lane geometry")
  elif n.mesh:
   var box=n.global_transform*n.get_aabb()
   assert(box.end.x < -4.0 or box.position.x>4.0,"scenic rock enters corridor")
 for c in n.get_children():inspect(c)
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=1;g.start_level();g.apply_world(1);await process_frame
 var d=g.dunes_visual
 assert(d.active and d.landscape.visible)
 assert(d.landscape.get_child_count()==11)
 var ejecta=d.landscape.get_node("DuneEjecta")
 assert(ejecta.mesh.get_surface_count()==1)
 assert(ejecta.material_override.get_shader_parameter("is_rock"))
 assert(ejecta.mesh.get_faces().size()>96*12)
 inspect(d.landscape)
 for x in [-200.0,-25.0,-3.6,3.6,25.0,200.0]:
  for z in [-200.0,-100.0,0.0]:assert(is_finite(d.height(x,z)))
 assert(absf(d.height(3.6,-55.0)+0.14)<0.001)
 for side in g.side_planes:assert(not side.visible)
 for edge in g.track_edges:assert(not edge.visible)
 assert(g.scene_props.size()==30)
 var terrain=g.ground.material_override
 assert(terrain.shader.resource_path.ends_with("dunes_sand.gdshader"))
 assert(terrain.get_shader_parameter("is_path"))
 g.options.light=true;g.apply_options();await process_frame
 assert(not d.active and not d.landscape.visible)
 for side in g.side_planes:assert(side.visible)
 for edge in g.track_edges:assert(not edge.visible)
 assert(not g.sky_stars.visible)
 assert(g.ground.material_override.shader.resource_path.ends_with("dunes_sand.gdshader"))
 assert(g.env_world.environment.sky.sky_material.shader.resource_path.ends_with("desert_sky.gdshader"))
 assert(is_equal_approx(g.moons[0].scale.x,0.28))
 g.options.light=false;g.apply_options();await process_frame;assert(d.active)
 for level in [0,2,3,4,5,-1]:
  g.apply_world(level);await process_frame;assert(not d.landscape.visible)
 g.apply_world(1);await process_frame;assert(d.landscape.visible)
 for size in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=size;await process_frame;g.adapt_layout();await process_frame
  for moon in g.moons:assert(moon.visible)
  assert(is_equal_approx(g.moons[0].scale.x,0.28) and g.moons[1].scale.x<0.002)
  assert(not g.sky_stars.visible)
  inspect(d.landscape)
 print("PASS Silver Dunes scenery bounds,11scenicnodes,30hiddenlegacyprops,Light/world restoration,fouraspects")
 quit()
