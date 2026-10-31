extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 for level in [0,3]:
  g.mode = "story"
  g.level = level
  for kind in ["low","tall","beam"]:
   var hazard = g.box(Vector3(1.4,0.8,1.2),Vector3(0,0.4,-6),Color.WHITE)
   g.decorate_hazard(hazard,kind)
   g.add_cue(hazard,kind)
   var cue = hazard.get_child(hazard.get_child_count()-1)
   assert(cue is Label3D)
   assert(cue.text == {"low":"JUMP","tall":"DODGE","beam":"SLIDE"}[kind])
   assert(absf(cue.global_rotation.z) < 0.001)
   assert(absf(cue.global_position.z - (-5.34)) < 0.001)
   assert(absf(cue.global_position.x) < 0.001)
   assert(cue.global_position.y > hazard.global_position.y if kind == "low" else is_equal_approx(cue.global_position.y,hazard.global_position.y))
 print("PASS actionable upright JUMP/SLIDE/DODGE cues, including rotated low hazards and sea waves")
 quit()
