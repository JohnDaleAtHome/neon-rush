extends SceneTree
func _init():call_deferred('run')
func touch(g,pressed:bool,canceled:bool=false):
 var e=InputEventScreenTouch.new();e.position=Vector2(195,400);e.pressed=pressed;e.canceled=canceled;g._input(e)
func run():
 var g=load('res://scenes/main.tscn').instantiate();root.add_child(g);await process_frame;g.set_process(false);g.mode='story';g.level=0;g.pieces=[];g.options.tap=true
 for moved in [false,true]:
  g.start_level();touch(g,true);g.touch_moved=moved;touch(g,false,true)
  assert(g.velocity==0 and g.jump_buffer==0 and not g.touch_active and not g.touch_moved and g.touch_origin==Vector2.ZERO)
  touch(g,false);assert(g.velocity==0,'stale release after canceled touch must not jump')
  touch(g,true);touch(g,false);assert(g.velocity==9,'new normal tap remains usable')
 g.start_level();g.options.tap=false;touch(g,true);touch(g,false,true);assert(g.velocity==0)
 g.start_level();g.options.tap=true;touch(g,false,true);assert(g.velocity==0)
 # Cancel never changes a jump/slide already in progress or invents input.
 g.start_level();g.input_action(0);var v=g.velocity;touch(g,true);touch(g,false,true);assert(g.velocity==v and g.jump_buffer==0)
 g.start_level();g.input_action(2);var duck=g.slide_time;touch(g,true);touch(g,false,true);assert(g.slide_time==duck and g.velocity==0)
 # Cancellation clears stale gesture state even at stopped/paused moments.
 for state in ["menu","paused"]:
  g.start_level();touch(g,true);g.touch_moved=true
  g.running=state!="menu";g.paused=state=="paused"
  touch(g,false,true)
  assert(not g.touch_active and not g.touch_moved and g.touch_origin==Vector2.ZERO and g.velocity==0)
  g.running=true;g.paused=false;touch(g,false);assert(g.velocity==0)
  touch(g,true);touch(g,false);assert(g.velocity==9)
 g.queue_free();await process_frame
 print('TOUCH_CANCEL_PASS canceled tap/drag/idle/stale release no action, new normal tap works, existing jump/slide preserved');quit()
