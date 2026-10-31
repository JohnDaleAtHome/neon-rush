extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.rng.seed = 104729
 g.mode = "story"
 g.level = 0
 g.pieces = []
 g.start_level()
 var steps = 0
 var deaths = 0
 var visits = {0:true}
 while steps < 24000:
  steps += 1
  if not g.running:
   if g.action.text == "NEW JOURNEY": break
   if g.pending_advance:
    g.on_action()
   else:
    deaths += 1
    if deaths > 5: break
    g.on_action()
  elif not g.unlock:
   if g.level == 5:
    var desired = g.boss_lane
    g.input_action(signi(desired - g.lane)) if desired != g.lane else g.input_action(3)
   else:
    var nearest = null
    var target = g.lane
    var nz = -100.0
    for item in g.entities:
     if item.get_meta("kind") == "orb" and item.position.z < -1 and item.position.z > nz:
      target = roundi(item.position.x/2.2)+1
      nz = item.position.z
    for item in g.entities:
     if item.get_meta("kind") not in ["orb","shield","shot"] and item.position.z > -9 and item.position.z < 1:
      var il = int(item.get_meta("lane"))
      if il == target: target = (il+1)%3
      if il == g.lane:
       if item.get_meta("kind") == "low": g.input_action(0)
       elif item.get_meta("kind") == "beam": g.input_action(2)
    if target >= 0 and target != g.lane: g.input_action(signi(target-g.lane))
   g._process(1.0/60)
  else: g._process(1.0/60)
  visits[g.level] = true
 print("CAMPAIGN_RESULT steps=",steps," deaths=",deaths," levels=",visits," final=",g.message.text," pieces=",g.pieces)
 if not (steps < 24000 and g.action.text == "NEW JOURNEY"):
  quit(1)
  return
 g.queue_free()
 await process_frame
 quit()
