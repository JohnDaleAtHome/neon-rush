extends SceneTree
func _init():call_deferred("run")
func run():
 var helper=load("res://scripts/visuals/meadow_visual.gd").new()
 root.add_child(helper)
 for name in ["CommonTree_3","CommonTree_5"]:
  var view=SubViewport.new();view.size=Vector2i(512,512);view.transparent_bg=true;view.own_world_3d=true;view.render_target_update_mode=SubViewport.UPDATE_ALWAYS;root.add_child(view)
  var tree=load("res://assets/visuals/nature_cc0/"+name+".gltf").instantiate()
  helper._tint_import(tree,Color("82baa6"));view.add_child(tree)
  var box=helper._import_bounds(tree,Transform3D.IDENTITY)
  var camera=Camera3D.new();camera.projection=Camera3D.PROJECTION_ORTHOGONAL;camera.size=maxf(box.size.x,box.size.y)*1.04;camera.position=Vector3(box.get_center().x,box.get_center().y,12);view.add_child(camera);camera.look_at(box.get_center());camera.current=true
  for i in range(8):await process_frame
  await RenderingServer.frame_post_draw
  var image=view.get_texture().get_image();image.save_png("res://assets/visuals/nature_cc0/"+name+"_impostor.png")
  print("BAKE ",name," box=",box," size=",camera.size)
  view.queue_free();await process_frame
 quit()
