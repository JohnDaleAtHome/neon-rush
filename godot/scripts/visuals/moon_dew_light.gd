extends RefCounted
static func attach(bridge:Node3D)->void:
 var shader=Shader.new()
 shader.code="""
shader_type spatial;
render_mode unshaded, blend_add, depth_draw_never, cull_disabled, shadows_disabled;
uniform float phase=0.0;
varying vec2 ground_pos;
void vertex(){ground_pos=(MODEL_MATRIX*vec4(VERTEX,1.0)).xz;}
void fragment(){
 vec2 p=ground_pos;
 float bloom=smoothstep(0.0,0.7,phase);
 float radius=length(vec2(p.x,p.y*0.7));
 float angle=atan(p.y*0.7,p.x);
 float petals=2.35+0.32*cos(angle*6.0);
 float pad=(1.0-smoothstep(petals*0.45,petals,radius))*bloom;
 float reach=mix(5.0,58.0,smoothstep(0.35,2.5,phase));
 float path=(1.0-smoothstep(1.6,3.5,abs(p.x)))*(1.0-smoothstep(reach*0.65,reach,-p.y))*(1.0-smoothstep(-1.0,4.0,p.y));
 float strength=max(pad*0.50,path*0.22*bloom);
 ALBEDO=vec3(0.72,0.85,0.58);
 ALPHA=strength;
}
"""
 var mat=ShaderMaterial.new();mat.shader=shader
 var light=MeshInstance3D.new();light.name="MoonDewGroundLight"
 var plane=PlaneMesh.new();plane.size=Vector2(7,72);light.mesh=plane
 light.position=Vector3(0,0.08,-30);light.material_override=mat
 light.cast_shadow=GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
 bridge.add_child(light)

static func update(bridge:Node3D,seconds:float,reduced:bool)->void:
 if not is_instance_valid(bridge):return
 var light=bridge.get_node_or_null("MoonDewGroundLight")
 if light:light.material_override.set_shader_parameter("phase",3.0 if reduced else seconds)
