extends SceneTree
const S=preload("res://scripts/skipped_contact.gd")
var failures=0
func check(ok:bool,msg:String):
 if not ok:failures+=1;push_error(msg)
func _init():call_deferred("run")
func run():
 var cases=[
  [-2,2,0,0,0,0,true],[-2,2,0,0,1,1,false],[-2,2,0,2.2,0,0,true],[-2,2,2.2,2.2,0,0,false],
  [-2,2,2.2,0,0,0,true],[-2,2,-2.2,2.2,0,0,true],[-2,2,0,0,.65,.65,false],[-2,2,1,1,0,0,false],
  [-2,2,0,0,1.2,0,true],[-2,2,0,0,0,1.2,true],[-2,2,1.1,1.8,0,0,false]]
 for a in cases:check(S.evaluate("low",a[0],a[1],a[2],a[3],a[4],a[5],0,.1,false).contact==a[6],"hand oracle "+str(a))
 check(S.evaluate("low",-2,2,0,2.2,0,0,0,.1,false).contact,"early dodge contact")
 check(S.evaluate("low",-2,2,0,0,1,1,0,.1,false).jump,"jump marks clear")
 check(not S.evaluate("low",-2,2,0,0,.65,.65,0,.1,false).jump,"exact height not bonus")
 check(S.evaluate("tall",-3,3,1.2,1.2,0,0,0,.1,false).near,"near interval")
 check(S.evaluate("tall",-3,3,-1.2,-1.2,0,0,0,.1,false).near,"negative near interval")
 check(S.evaluate("tall",-3,3,1,1,0,0,0,.1,false).near,"inclusive near boundary")
 check(not S.evaluate("tall",-3,3,1.8,1.8,0,0,0,.1,false).near,"exclusive outer near boundary")
 check(S.evaluate("beam",-2,2,0,0,0,0,.05,.1,false).contact,"slide expires inside")
 check(not S.evaluate("beam",-2,2,0,0,0,0,.65,.1,false).contact,"slide clears")
 check(S.evaluate("beam",-2,2,0,0,.1,.1,.65,.1,false).contact,"beam exact height")
 check(S.evaluate("orb",-3,3,2.2,2.2,0,0,0,.1,true).contact,"magnet collects")
 check(not S.evaluate("orb",-3,3,2.2,2.2,0,0,0,.1,false).contact,"normal outside lane")
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false);g.options.sound=false
 for kind in ["low","tall"]:
  g.mode="hard";g.start_level();g.spawn_time=999;g.speed=38;g.guard=0;g.shield=false;g.magnet_time=0;g.shield_time=999;g.lane=1;g.player.position=Vector3.ZERO;g.height=1.1 if kind=="low" else 0;g.velocity=2 if kind=="low" else 0;g.jump_bonus=0;g.risk_bonus=0
  for e in g.entities:e.queue_free()
  g.entities.clear()
  var h=g.box(Vector3.ONE,Vector3(0 if kind=="low" else 1.2,.4,-2),Color.WHITE);h.set_meta("kind",kind);h.set_meta("lane",1);g.entities.append(h)
  g._process(.1);check(g.running,"bonus run alive");check(g.jump_bonus==20 if kind=="low" else g.risk_bonus==15,"swept bonus "+kind)
  g._process(.1);check(g.jump_bonus==20 if kind=="low" else g.risk_bonus==15,"bonus once "+kind)
 print("SKIPPED_CONTACT 11oracle+16edge/bonus failures=",failures);quit(failures)
