extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false);g.mode="story";g.level=3;g.pieces=g.PIECES.slice(0,3);g.start_level()
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims;await process_frame
  for light in [false,true]:
   g.options.light=light;g.apply_options();g.show_story_encounter(3)
   assert(g.story_props.size()==2 and not g.player.visible)
   var actor=g.story_props[0];var turtle=actor.get_child(0)
   assert(actor.name=="KindnessActor" and actor.get_child_count()==1)
   assert(turtle.scale.is_equal_approx(Vector3.ONE*3.35))
   var meshes=turtle.find_children("*","MeshInstance3D",true,false);assert(meshes.size()==6)
   var bounds=AABB();var first=true;var triangles=0
   for mesh in meshes:
    var local=mesh.transform*mesh.get_aabb()
    bounds=local if first else bounds.merge(local);first=false
    for surface in range(mesh.mesh.get_surface_count()):
     var arrays=mesh.mesh.surface_get_arrays(surface)
     triangles+=arrays[Mesh.ARRAY_INDEX].size()/3 if arrays[Mesh.ARRAY_INDEX]!=null else arrays[Mesh.ARRAY_VERTEX].size()/3
   assert(triangles==1634)
   assert(bounds.size.x*3.35<1.4 and bounds.size.y*3.35<1.2)
   var eye=meshes.filter(func(n):return n.name=="Turtle eyes")[0]
   assert(is_equal_approx(eye.scale.y,.16))
   assert(g.story_props[1].text=="SLEEPY MOON-TURTLE")
   g.layout_encounter(Vector2(dims));var before=actor.position;g.layout_encounter(Vector2(dims));assert(actor.position.is_equal_approx(before))
   g.clear_encounter();await process_frame;assert(not is_instance_valid(actor))
 print("PASS authored CC0 turtle 1634tris/6meshes, bounds, sleepy eyes, 4sizes x2quality resize/cleanup, storylabel")
 quit()
