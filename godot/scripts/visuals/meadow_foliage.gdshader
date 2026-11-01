shader_type spatial;
render_mode fog_disabled, cull_disabled;
uniform vec3 base_color : source_color = vec3(0.13,0.30,0.23);
uniform vec3 fog_color : source_color = vec3(0.078,0.208,0.18);
uniform bool vertex_colors = false;
uniform float sway = 0.035;
varying vec3 world_point;
varying float view_depth;
void vertex(){
 vec3 world=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 float weight=clamp(VERTEX.y+0.15,0.0,1.0);
 VERTEX.x+=sin(TIME*0.8+world.z*0.2+world.x*0.3)*sway*weight;
 world_point=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 view_depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;
}
void fragment(){
 float fog=smoothstep(20.0,140.0,view_depth);
 vec3 col=vertex_colors?COLOR.rgb:base_color;
 ALBEDO=col*(1.0-fog);
 EMISSION=fog_color*fog;
 ROUGHNESS=1.0;
}
