extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var shared_mesh: Mesh
 var shared_material: Material
 for mode in ["story","easy","normal","hard","mission","chase"]:
  for level in range(6):
   g.mode=mode;g.level=level
   for kind in ["low","tall","beam"]:
    var h=g.box(Vector3(1.4,.8,1.2),Vector3(0,.4,-7),Color("e4a35b"));g.decorate_hazard(h,kind);g.add_cue(h,kind)
    var cue=h.get_child(h.get_child_count()-1)
    assert(cue.text=={"low":"JUMP","tall":"DODGE","beam":"SLIDE"}[kind])
    assert(cue.global_rotation.length()<.001)
    if mode=="story" and level==0 and kind=="low":
     var bounds=h.mesh.get_aabb()
     assert(bounds.size.distance_to(Vector3(1.4,.8,1.2))<.0001)
     assert(bounds.get_center().length()<.0001)
     assert(h.mesh.get_surface_count()==1)
     assert(h.mesh.surface_get_array_len(0)<=180)
     assert(h.material_override.albedo_texture.get_size()==Vector2(256,256))
     shared_mesh=h.mesh;shared_material=h.material_override
    else:
     assert(h.mesh!=g.MEADOW_BALE_MESH)
    h.queue_free()
 g.mode="story";g.level=0;g.rng.seed=41
 for i in 24:
  g.spawn_wave()
  var h=g.entities[-3]
  assert(h.get_meta("kind")=="low")
  assert(h.mesh==shared_mesh and h.material_override==shared_material)
  assert(is_equal_approx(h.position.y,.4) and h.position.z== -44)
  assert(h.rotation==Vector3.ZERO)
  assert(h.get_child(0).text=="JUMP")
 print("PASS Meadow CC0 bale bounds/material/mesh reuse, 24 real spawn waves, all 108 mode/level/kind cases and upright cues")
 quit()
