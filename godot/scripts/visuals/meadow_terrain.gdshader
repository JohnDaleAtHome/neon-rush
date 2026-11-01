shader_type spatial;
render_mode fog_disabled;
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform float scroll = 0.0;
uniform bool fade_geometry = true;
varying float view_depth;
varying vec3 world_point;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
void vertex(){
 world_point=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 float depth = -(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;
 view_depth = depth;
}
void fragment(){
 float fog_amount = smoothstep(20.0,92.0,view_depth);
 float far_fade = 1.0-smoothstep(46.0,112.0,view_depth);
 vec2 moving_point=world_point.xz+vec2(0.0,scroll*25.0);
 float grain=noise(moving_point*7.0)*0.7+noise(moving_point*1.1)*0.3;
 vec3 surface=mix(vec3(0.018,0.035,0.031),vec3(0.021,0.040,0.035),grain);
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount;
 ROUGHNESS = 0.95;
 ALPHA = fade_geometry ? far_fade : 1.0;
}
