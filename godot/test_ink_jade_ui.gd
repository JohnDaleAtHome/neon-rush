extends SceneTree
func _init():call_deferred("run")
func lum(c):
 var a=[]
 for v in [c.r,c.g,c.b]:a.append(v/12.92 if v<=0.04045 else pow((v+0.055)/1.055,2.4))
 return .2126*a[0]+.7152*a[1]+.0722*a[2]
func ratio(a,b):return (maxf(lum(a),lum(b))+.05)/(minf(lum(a),lum(b))+.05)
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for dims in [Vector2i(390,844),Vector2i(1280,800),Vector2i(844,390),Vector2i(320,568)]:
  root.size=dims
  for light in [false,true]:
   for contrast in [false,true]:
    g.options.light=light;g.options.contrast=contrast;g.options.large=true;g.apply_options();g.mode="story";g.level=3;g.pieces=g.PIECES.slice(0,3);g.start_level();g.elapsed=30;g._process(.01)
    await process_frame
    assert(g.pending_advance and not g.running)
    assert(g.action.text=="SPEAK KINDLY TO THE TURTLE")
    assert(g.action.size.y>=44)
    assert(g.action.get_global_rect().position.x>=0 and g.action.get_global_rect().end.x<=g.get_viewport().get_visible_rect().size.x+.1)
    for state in ["normal","hover","pressed"]:
     var box=g.action.get_theme_stylebox(state)
     var text=g.action.get_theme_color("font_color" if state=="normal" else "font_"+state+"_color")
     assert(box.shadow_size==0 and box.corner_radius_top_left==4)
     assert(ratio(text,box.bg_color)>=4.5)
     assert(ratio(box.border_color,box.bg_color)>=3.0)
    var focus=g.action.get_theme_stylebox("focus")
    assert(focus.border_width_left>=1 and focus.border_color==NeonHudTheme.ACCENT)
    g.action.grab_focus();assert(g.action.has_focus());g.action.pressed.emit();assert(g.unlock)
 g.queue_free();await process_frame
 print("PASS InkJade UI 4 sizes x Light x contrast, readable states/borders, focus, 44px targets, exact choice and action signal")
 quit()
