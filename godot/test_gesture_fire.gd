extends SceneTree
var g
func _init():call_deferred("run")
func run():
 g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 g.options.buttons=false
 for mode in ["story","mission"]:
  g.mode=mode;g.level=5 if mode=="story" else 0;g.pieces=g.PIECES.duplicate();g.start_level()
  if mode=="mission":g.mission_phase=2;g.apply_options()
  assert(g.controls.visible and g.controls.get_child(4).visible)
  for i in [0,1,2,3]:assert(not g.controls.get_child(i).visible)
  assert(not g.options.buttons)
  for hand in ["left","center","right"]:
   g.options.hand=hand
   for size in [Vector2i(320,700),Vector2i(390,844),Vector2i(844,390),Vector2i(1280,720)]:
    root.size=size;await process_frame;g.apply_options()
    var view=g.get_viewport().get_visible_rect().size
    assert(g.controls.offset_left>=0 and g.controls.offset_right<=view.x)
    assert(g.controls.size.x<=96.1)
  g.toggle_pause();assert(not g.controls.visible);g.toggle_pause();assert(g.controls.visible)
  g.fire_time=0;g.controls.get_child(4).pressed.emit();assert(g.fire_time>0)
  g.options.buttons=true;g.apply_options()
  for i in range(5):assert(g.controls.get_child(i).visible)
  g.options.buttons=false;g.apply_options()
 g.options.buttons=false;g.save_options();g.options.buttons=true;g.load_options();assert(not g.options.buttons)
 g.mode="story";g.level=0;g.pieces=[];g.start_level();assert(not g.controls.visible)
 g.mode="mission";g.start_level();assert(not g.controls.visible)
 g.mode="chase";g.start_level();assert(not g.controls.visible)
 g.mode="normal";g.start_level();assert(not g.controls.visible)
 g.options.buttons=true;g.apply_options();assert(g.controls.visible)
 assert(not g.controls.get_child(2).visible and not g.controls.get_child(4).visible)
 g.options.buttons=false;g.mode="story";g.level=5;g.pieces=g.PIECES.duplicate();g.start_level();g.return_menu();g.apply_options();assert(not g.controls.visible)
 print("PASS gesture movement with required Guardian FIRE, both modes, pause/options/menu, all handed bounds")
 g.queue_free();await process_frame;quit()
