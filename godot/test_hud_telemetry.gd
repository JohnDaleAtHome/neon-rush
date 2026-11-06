extends SceneTree
var failures=0
func check(ok:bool,msg:String):
 if not ok:failures+=1;push_error(msg)
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for dims in [Vector2i(390,844),Vector2i(320,568),Vector2i(1280,800),Vector2i(844,390)]:
  root.size=dims;await process_frame
  for mode in ["story","chase","mission"]:
   for compact in [true,false]:
    g.mode=mode;g.options.compact=compact;g.options.large=true;g.level=4 if mode=="story" else 0;g.pieces=g.PIECES.slice(0,g.level);g.start_level();g.mission_phase=2;g.elapsed=999;g.dew=99;g.score=999999;g.distance=99999;g.collected=999;g.shadow_gap=28;g.boss_hp=4;g.update_hud()
    await process_frame
    check(not g.hud.get_global_rect().intersects(g.pause_button.get_global_rect()),"HUD clear of pause "+mode)
    check(g.hud.get_global_rect().end.x<g.get_viewport().get_visible_rect().size.x,"HUD on screen "+mode)
    check(g.hud.get_global_rect().end.y<=g.status_label.get_global_rect().position.y,"HUD above feedback "+mode)
    check(g.hud.get_theme_font_size("font_size")==14,"dense metrics compact font")
    if mode in ["chase","story"]:check(g.hud.text.contains("\nShadow 28.0m"),"shadow own line")
    if mode=="mission":check(g.hud.text.contains("\nGuardian 4 / 4"),"guardian own line")
  g.mode="story";g.level=5;g.update_hud();await process_frame
  check(g.hud.text.contains("\nGuardian 4 / 4"),"storyguardian ownline")
  check(not g.hud.get_global_rect().intersects(g.pause_button.get_global_rect()),"storyguardian clear pause")
  g.level=0;g.options.compact=false;g.update_hud()
  check(g.hud.get_theme_font_size("font_size")==17,"ordinaryfont restored")
 print("HUD_TELEMETRY failures=",failures);quit(failures)
