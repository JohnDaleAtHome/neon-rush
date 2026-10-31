extends SceneTree
func _init():
 call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 for selected in ["easy","normal","hard","chase","mission","story"]:
  g.mode = selected
  g.start_level()
  assert(g.running and g.hearts == 3)
  g.input_action(-1)
  assert(g.lane == 0)
  g.input_action(0)
  assert(g.velocity > 0)
  g.toggle_pause()
  assert(g.paused)
  var hp = g.hearts
  g.hurt()
  # Direct hurt must not mutate paused games.
  assert(g.hearts == hp)
  g.toggle_pause()
  g.return_menu()
 g.mode = "story"
 g.level = 0
 g.pieces = []
 for i in range(5):
  g.start_level()
  g.pending_advance = true
  g.on_action()
  assert(g.unlock)
  g.update_unlock(5.1)
  assert(g.level == i+1 and g.pieces.size() == i+1)
 g.start_level()
 assert(g.boss_hp == 4 and g.boss != null)
 print("PASS Godot allsixmode/start/lane/jump/pause/menu/fiveunlock/checkpoint/finalegate scaffold")
 quit()
