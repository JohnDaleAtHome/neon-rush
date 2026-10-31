extends SceneTree
func _init(): call_deferred("run")
func run():
 var g = load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 var good = g.validated_options({"light":true,"hand":"right","color":"mint","swipe":30.0,"last_mode":"hard","motion_system":false})
 assert(good.light and good.hand == "right" and good.color == "mint" and good.swipe == 30 and good.last_mode == "hard" and not good.motion_system)
 var bad = g.validated_options({"light":"true","hand":"fake","color":"fake","swipe":999,"last_mode":"fake","unknown":"x"})
 assert(bad.is_empty())
 print("PASS browser preferences backup validator accepts supported values only")
 quit()
