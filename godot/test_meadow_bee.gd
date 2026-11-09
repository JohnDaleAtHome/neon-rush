extends SceneTree
func _init():call_deferred('run')
func clear(g):
 for e in g.entities:e.queue_free()
 g.entities.clear()
func run():
 var g=load('res://scenes/main.tscn').instantiate();root.add_child(g);await process_frame;g.set_process(false)
 assert(FileAccess.file_exists('res://assets/models/meadow_bee/bee.glb'))
 assert('https://poly.pizza/m/HvfIku26CK' in load('res://scripts/visuals/art_credits.gd').text())
 g.mode='story';g.level=0;g.pieces=[];g.start_level();g.rng.seed=104729
 g.elapsed=0
 for i in 20:
  clear(g);g.spawn_wave();assert(g.entities[0].get_meta('kind')=='low')
 g.elapsed=5
 var lows=0;var bees=0
 for i in 100:
  clear(g);g.spawn_wave();var h=g.entities[0];var kind=h.get_meta('kind')
  if kind=='low':lows+=1
  else:
   assert(kind=='tall' and h.has_meta('sway'));bees+=1
   assert(h.get_meta('action_cue').text=='DODGE')
  for orb in g.entities.slice(1):assert(absf(orb.position.x-h.position.x)>=2.19)
 assert(bees>0 and lows>bees)
 # Gameplay sway must be identical with reduced motion on or off.
 # At each extreme, both adjacent lanes remain outside contact range.
 for reduced in [false,true]:
  g.options.motion_system=false;g.options.motion=reduced
  for il in range(3):
   for phase in [PI/2,3*PI/2]:
    for pl in range(3):
     clear(g);g.start_level();g.spawn_time=999;g.guard=0;g.hearts=3
     g.lane=pl;g.player.position.x=g.LANES[pl]
     var h=g.box(Vector3(1.4,2.5,1.2),Vector3(g.LANES[il],1.25,-.05),Color.WHITE)
     g.decorate_hazard(h,'tall');h.set_meta('kind','tall');h.set_meta('lane',il);h.set_meta('sway',true);g.entities.append(h)
     g.elapsed=(phase+10*TAU-float(h.get_instance_id()%9))/2-1./60
     g._process(1./60)
     assert(g.hearts==(2 if il==pl else 3))
     if il!=pl:assert(absf(h.position.x-g.player.position.x)>=1.39)
 # Tall collision is consistent for ground, jumping, and sliding poses.
 for pose in [0.,1.,2.0]:
  clear(g);g.start_level();g.spawn_time=999;g.guard=0;g.hearts=3;g.lane=1;g.player.position.x=0;g.height=pose;g.velocity=0;g.slide_time=.5 if pose==0 else 0
  var h=g.box(Vector3(1.4,2.5,1.2),Vector3(0,1.25,-.05),Color.WHITE)
  g.decorate_hazard(h,'tall');h.set_meta('kind','tall');h.set_meta('lane',1);g.entities.append(h)
  g._process(1./60);assert(g.hearts==2)
 clear(g);g.queue_free();await process_frame;print('MEADOW_BEE_PROTOTYPE ',bees,' bees ',lows,' bales, first4seconds bales, safe pickup lanes, actual Full/reduced-motion sway-extreme contacts and dodge-only poses');quit()
