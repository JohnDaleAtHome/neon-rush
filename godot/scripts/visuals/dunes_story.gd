extends RefCounted
# Original fictional framed travel lantern. No copied model or museum media.
static func material(color: Color) -> StandardMaterial3D:
 var m=StandardMaterial3D.new();m.albedo_color=color;m.roughness=0.8;return m
static func mesh(parent: Node3D, shape: Mesh, at: Vector3, mat: Material) -> MeshInstance3D:
 var n=MeshInstance3D.new();n.mesh=shape;n.position=at;n.material_override=mat;parent.add_child(n);return n
static func cylinder(parent: Node3D, at: Vector3, radius: float, height: float, mat: Material, top: float=-1.0):
 var s=CylinderMesh.new();s.top_radius=radius if top<0 else top;s.bottom_radius=radius;s.height=height;s.radial_segments=6;return mesh(parent,s,at,mat)
static func build() -> Node3D:
 var root=Node3D.new();root.name="DunesStoryLantern"
 var silver=material(Color("b7c6bc"));var dark=material(Color("4d655e"));var paper=material(Color("f2df9b"));var gold=material(Color("bc934d"));var printmat=material(Color("675841"))
 var lantern=Node3D.new();lantern.position=Vector3(-.65,-.035,0);root.add_child(lantern)
 cylinder(lantern,Vector3(0,.07,0),.32,.1,dark)
 cylinder(lantern,Vector3(0,.2,0),.4,.14,silver,.32)
 cylinder(lantern,Vector3(0,.7,0),.34,.92,paper)
 cylinder(lantern,Vector3(0,1.18,0),.42,.1,silver)
 cylinder(lantern,Vector3(0,1.31,0),.44,.18,dark,.19)
 cylinder(lantern,Vector3(0,1.43,0),.21,.08,gold)
 for n in 6:
  var angle=n*TAU/6;var x=sin(angle)*.35;var z=cos(angle)*.35
  var s=BoxMesh.new();s.size=Vector3(.048,.94,.048);mesh(lantern,s,Vector3(x,.7,z),silver)
  var t=BoxMesh.new();t.size=Vector3(.025,.25,.025);mesh(lantern,t,Vector3(x,.035,z),gold)
 # Upright open carry loop, not a solid halo.
 var ring=TorusMesh.new();ring.inner_radius=.15;ring.outer_radius=.18;ring.rings=16;ring.ring_segments=5
 var handle=mesh(lantern,ring,Vector3(0,1.66,0),dark);handle.rotation_degrees.x=90
 # A rounded toe and narrow heel are connected in each original sole silhouette.
 var points=PackedVector2Array([Vector2(-.065,-.17),Vector2(-.09,-.1),Vector2(-.09,.02),Vector2(-.055,.07),Vector2(-.055,.17),Vector2(.055,.17),Vector2(.055,.07),Vector2(.085,.01),Vector2(.08,-.1),Vector2(.04,-.17)])
 var st=SurfaceTool.new();st.begin(Mesh.PRIMITIVE_TRIANGLES);var tris=Geometry2D.triangulate_polygon(points)
 for id in tris:st.set_normal(Vector3.UP);st.add_vertex(Vector3(points[id].x,0,points[id].y))
 var sole=st.commit();var mm=MultiMesh.new();mm.transform_format=MultiMesh.TRANSFORM_3D;mm.mesh=sole;mm.instance_count=10
 for n in 10:
  var yaw=.1 if n%2==0 else -.1
  mm.set_instance_transform(n,Transform3D(Basis(Vector3.UP,yaw),Vector3(.33+(.16 if n%2==0 else -.16),-.035,-.5-n*.7)))
 var prints=MultiMeshInstance3D.new();prints.multimesh=mm;prints.material_override=printmat;root.add_child(prints)
 return root
