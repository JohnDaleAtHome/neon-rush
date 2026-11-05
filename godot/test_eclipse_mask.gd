extends SceneTree
func _init():call_deferred("run")
func run():
 var module=load("res://scripts/visuals/eclipse_mask.gd")
 assert(module.texture()==module.texture())
 assert(module.texture().get_size()==Vector2(256,243))
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims
  for light in [false,true]:
   var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false);g.options.light=light;g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.start_level()
   var b=g.boss;var face=b.get_node("EclipseMask")
   assert(b.mesh is SphereMesh and is_equal_approx(b.mesh.radius,0.9))
   assert(b.position==Vector3(0,1.8,-18))
   assert(b.get_child_count()==2 and b.has_node("EclipseRing"))
   assert(face.texture==module.texture() and is_equal_approx(face.pixel_size,1.8/256))
   assert(is_equal_approx(face.position.z,0.94) and not face.no_depth_test)
   assert(not face.fixed_size and not face.shaded)
   var colors=[];var rings=[]
   for state in range(3):
    g.boss_hits=2 if state==2 else 0;g.update_guardian_art(state!=0)
    colors.append(face.modulate);rings.append(b.get_node("EclipseRing").material_override.albedo_color)
   assert(colors[0]!=colors[1] and colors[1]!=colors[2] and colors[0]!=colors[2])
   assert(rings[0]!=rings[1] and rings[1]!=rings[2])
   var tex=face.texture
   for tick in 100:g.update_guardian_art(true)
   assert(face.texture==tex)
   g.queue_free();await process_frame
 print("ECLIPSE_MASK_TEST_PASS: exact embedded art, shared texture, 4 sizes/2 quality, aim envelope/ring/depth and 3 states unchanged")
 quit()
