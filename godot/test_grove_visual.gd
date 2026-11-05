extends SceneTree
var failures=0
func check(ok:bool,message:String):
 if not ok:failures+=1;push_error(message)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.mode="story";g.level=2;g.running=true;g.apply_world(2);g.apply_options()
 check(g.grove_visual.active,"grove active")
 check(g.grove_visual.landscape.get_child_count()==66,"baseline scenery plus pavilion/batched walls/base")
 check(not g.scenery.visible,"options do not restore lollipop scenery")
 check(g.ground.material_override.shader.resource_path.ends_with("grove_ground.gdshader"),"path material")
 for p in g.scene_props:check(not p.visible,"old props hidden")
 for side in g.side_planes:check(not side.visible,"base sides hidden")
 var understory=g.grove_visual.landscape.get_node("AmberUnderstory")
 check(understory.mesh.get_surface_count()==1,"one batched understory surface")
 check(understory.mesh.surface_get_array_len(0)<120000,"bounded understory vertices")
 var foundation=g.grove_visual.landscape.get_node("PavilionFoundation")
 var paving=g.grove_visual.landscape.get_node("PavilionPaving")
 check(paving.position==Vector3(-10.4,.2,-48),"accepted pavilion top preserved")
 check(paving.mesh.size==Vector2(11.2,11.2),"accepted footprint preserved")
 var skirt=foundation.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
 check(skirt.size()==288,"48 terrain-following skirt segments")
 for v in skirt:
  check(absf(v.x)>=4.79,"foundation lane margin")
  check(is_equal_approx(v.y,.2) or is_equal_approx(v.y,g.grove_visual._height(v.x,v.z)-.12),"skirt top or buried terrain endpoint")
 # Check between skirt endpoints too, not just the mesh vertices.
 var corners=[Vector2(-16.0,-53.6),Vector2(-4.8,-53.6),Vector2(-4.8,-42.4),Vector2(-16.0,-42.4)]
 var min_burial=100.0
 for k in 4:
  for j in 12:
   var a:Vector2=corners[k].lerp(corners[(k+1)%4],j/12.0)
   var b:Vector2=corners[k].lerp(corners[(k+1)%4],(j+1)/12.0)
   for n in range(21):
    var t=n/20.0;var p:Vector2=a.lerp(b,t)
    var bottom=lerpf(g.grove_visual._height(a.x,a.y),g.grove_visual._height(b.x,b.y),t)-.12
    var burial=g.grove_visual._height(p.x,p.y)-bottom
    min_burial=minf(min_burial,burial)
    check(burial>.10,"skirt buried between vertices")
 print("FOUNDATION min_burial=",min_burial," samples=1008")
 for i in range(41):
  for j in range(41):
   var x=-16.0+11.2*i/40.0;var z=-53.6+11.2*j/40.0
   check(g.grove_visual._height(x,z)<.2,"terrain stays below paving")
 inspect(g.grove_visual.landscape)
 for dim in [Vector2i(390,844),Vector2i(1280,800),Vector2i(360,640),Vector2i(844,500)]:
  root.size=dim;await process_frame;g.layout_moons(dim)
  check(g.moons[0].scale.x==0.25,"one restrained moon")
  check(g.moons[1].scale.x<=0.0011 and g.moons[2].scale.x<=0.0011,"no planet trio")
  check(not g.sky_stars.visible,"no space star field")
 g.options.light=true;g.apply_options();check(not g.grove_visual.landscape.visible,"Light hides grove")
 check(not g.scenery.visible,"Light no primitive avenue")
 check(not g.sky_stars.visible,"Light no star field")
 check(g.ground.material_override.shader.resource_path.ends_with("grove_ground.gdshader"),"Light keeps stone path")
 check(g.env_world.environment.sky.sky_material.shader.resource_path.ends_with("garden_sky.gdshader"),"Light keeps garden sky")
 g.layout_moons(root.size)
 check(g.moons[0].scale.x==0.25 and g.moons[1].scale.x<0.002,"Light no planet trio")
 for side in g.side_planes:check(side.visible,"Light restores sides")
 g.options.light=false
 for world in [0,1,3,4,5,2]:
  g.level=world;g.apply_world(world);g.apply_options();check(g.grove_visual.active==(world==2),"world ownership")
 check(not g.scenery.visible,"return ownership")
 print("GROVE_VISUAL failures=",failures);quit(failures)
func inspect(node:Node):
 check(not node is CollisionObject3D,"no scenic collisions")
 if node is MeshInstance3D:
  for surface in range(node.mesh.get_surface_count()):
   for v in node.mesh.surface_get_arrays(surface)[Mesh.ARRAY_VERTEX]:
    var w=node.global_transform*v
    check(w.is_finite(),"finite geometry")
    check(absf(w.x)>=3.65,"scenery outside lanes")
 for child in node.get_children():inspect(child)
# End of grove regression test.
