extends SceneTree
var found={}
func _init():call_deferred("run")
func inspect(n):
 if n is MeshInstance3D and n.mesh:
  for i in range(n.mesh.get_surface_count()):
   var mat=n.mesh.surface_get_material(i)
   if mat:found[String(mat.resource_name)]=true
   var a=n.mesh.surface_get_arrays(i)
   var v=a[Mesh.ARRAY_VERTEX]
   for p in v:assert(p.is_finite())
   if a[Mesh.ARRAY_BONES]!=null:
    assert(a[Mesh.ARRAY_BONES].size()==v.size()*4)
    assert(a[Mesh.ARRAY_WEIGHTS].size()==v.size()*4)
 for c in n.get_children():inspect(c)
func run():
 var m=MochiVisual.create()
 assert(m!=null)
 root.add_child(m)
 inspect(m)
 for name in ["Bunny_Main","Bunny_Secondary","Eye_White","Eye_Black","Nose_Pink","Mouth_Dark","Belly_Fur","Bunny_Jacket","Neon_Trim","Pendant_Glow","Neon_Magenta"]:
  assert(found.has(name))
 m.queue_free()
 await process_frame
 print("PASS Mochi concept-cleanup materials, finite vertices and skinning arrays")
 quit()
