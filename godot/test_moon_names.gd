extends SceneTree
func _init():call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var hints=load("res://scripts/visuals/hud_theme.gd").LEVEL_HINTS
 var help=load("res://scripts/visuals/how_to_play.gd").SECTIONS
 for i in range(1,4):
  var moon=["Silver Moon","Cinnamon Moon","Storm Moon"][i-1]
  assert(moon in hints[i] and moon in help[2][1])
  g.mode="story";g.level=i;g.pieces=g.PIECES.slice(0,i);g.start_level()
  assert(g.message.text==hints[i])
  assert(g.LEVEL_NAMES[i]==["Silver Dunes","Cinnamon Grove","Storm Sea"][i-1])
  for wh in [Vector2i(320,568),Vector2i(390,844),Vector2i(844,390),Vector2i(1280,800)]:
   root.size=wh;await process_frame;await process_frame
   assert(g.message.get_line_count()<=3)
 g.queue_free();await process_frame;print("PASS canonical moon names in opening hints/help, unchanged level names, four-size line bound");quit()
