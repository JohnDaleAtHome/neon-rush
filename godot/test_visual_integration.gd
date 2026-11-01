extends SceneTree
func _init(): call_deferred("run")
func run():
 var g=load("res://scenes/main.tscn").instantiate()
 root.add_child(g)
 await process_frame
 g.set_process(false)
 g.options.light=false
 g.apply_world(0)
 assert(g.meadow_visual.active)
 assert(g.meadow_visual.rolling_banks.size()==2)
 assert(g.meadow_visual.horizon_layers.size()==34)
 for x in [-53.8,-24.0,-3.8,3.8,24.0,53.8]:
  assert(absf(g.meadow_visual._bank_height(x,-144.0)+0.14)<0.001)
 for bank in g.meadow_visual.rolling_banks:
  var verts=bank.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
  var min_y=100.0
  var max_y=-100.0
  for v in verts:
   assert(absf(v.x)>=3.7999)
   min_y=minf(min_y,v.y)
   max_y=maxf(max_y,v.y)
  assert(max_y-min_y>1.0)
 for side in g.side_planes:assert(not side.visible)
 assert(is_equal_approx(g.world_sun.light_energy,0.85))
 assert(g.animation_names.size()==14)
 assert(g.scene_props.size()==98)
 var flower_vertices=0
 for i in range(34):
  var plant=g.scene_props[i]
  assert(plant.mesh is ArrayMesh)
  assert(absf(plant.position.x)>4.8)
  var arr=plant.mesh.surface_get_arrays(0)
  assert(arr[Mesh.ARRAY_VERTEX].size()>500)
  assert(arr[Mesh.ARRAY_COLOR].size()==arr[Mesh.ARRAY_VERTEX].size())
  flower_vertices+=arr[Mesh.ARRAY_VERTEX].size()
  for v in arr[Mesh.ARRAY_VERTEX]: assert(v.is_finite())
 assert(flower_vertices<180000)
 for prop in g.scene_props:
  if prop.has_meta("bank_clearance"):
   prop.position.z = -110.0
 g.meadow_visual._process(0.0)
 for prop in g.scene_props:
  if prop.has_meta("bank_clearance"):
   assert(absf(prop.position.y-float(prop.get_meta("bank_clearance"))-g.meadow_visual._bank_height(prop.position.x,prop.position.z))<0.001)
 var original_props=g.scene_props.duplicate()
 g.options.light=true
 g.apply_options()
 assert(not g.meadow_visual.active)
 for side in g.side_planes:assert(side.visible)
 assert(is_equal_approx(g.world_sun.light_energy,1.7))
 assert(not g.meadow_visual.horizon_root.visible)
 assert(not g.meadow_visual.shadow.visible)
 assert(g.scene_props.is_empty())
 await process_frame
 for p in original_props: assert(not is_instance_valid(p))
 g.options.light=false
 g.apply_options()
 assert(g.meadow_visual.active)
 assert(g.scene_props.size()==98)
 assert(g.meadow_visual.horizon_root.visible)
 g.apply_world(1)
 assert(not g.meadow_visual.active)
 assert(not g.meadow_visual.horizon_root.visible)
 assert(g.scene_props.size()==30)
 g.apply_world(-1)
 assert(not g.meadow_visual.active)
 assert(g.scene_props.is_empty())
 g.apply_world(0)
 assert(g.meadow_visual.active)
 assert(g.scene_props.size()==98)
 var popup=g.popup_frame("TEST")
 NeonHudTheme.style_popup(popup)
 var frame=popup.get_parent().get_parent()
 assert(frame is PanelContainer)
 assert(is_equal_approx(frame.get_theme_stylebox("panel").bg_color.a,1.0))
 print("PASS Meadow light-toggle cleanup/restoration, theme transitions and opaque HUD popup")
 g.queue_free()
 await process_frame
 quit()
