extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.open_settings()
 var list = g.overlay_root.get_child(-1).get_child(0).get_child(0)
 var picker: OptionButton
 for child in list.get_children():
  if child is OptionButton and child.get_item_text(0) == "Runner: Moon Rabbit": picker = child
 assert(picker != null)
 picker.item_selected.emit(1)
 assert(g.options.shape == "sphere" and g.runner_variant.visible)
 picker.item_selected.emit(2)
 assert(g.options.shape == "diamond" and g.runner_variant.visible)
 for shape in ["rabbit","sphere","diamond"]:
  g.options.shape = shape
  g.apply_options()
  assert(g.bunny.visible == (shape == "rabbit"))
  assert(g.runner_variant.visible == (shape != "rabbit"))
  assert(g.validated_options({"shape":shape}).shape == shape)
  if shape == "sphere": assert(g.runner_variant.mesh is SphereMesh)
  if shape == "diamond": assert(g.runner_variant.mesh is ArrayMesh)
 assert(g.validated_options({"shape":"bad"}).is_empty())
 assert(g.mapped_legacy_options({"runnerShape":"cube"}).shape == "rabbit")
 assert(g.mapped_legacy_options({"runnerShape":"sphere"}).shape == "sphere")
 assert(g.mapped_legacy_options({"runnerShape":"diamond"}).shape == "diamond")
 assert(g.mapped_legacy_options({"runnerShape":"bad"}).is_empty())
 g.options.shape = "rabbit"
 g.save_options()
 print("PASS rabbit default, sphere/diamond visuals, validated settings and legacy mapping")
 quit()
