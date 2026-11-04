shader_type spatial;
render_mode fog_disabled;
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform vec3 grass_low : source_color = vec3(0.045,0.115,0.095);
uniform vec3 grass_high : source_color = vec3(0.12,0.23,0.17);
varying float view_depth;
varying vec3 world_point;
varying vec3 world_normal;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
void vertex(){
 world_normal=normalize(MODEL_NORMAL_MATRIX*NORMAL);
 world_point=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 float depth = -(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;
 view_depth = depth;
}
void fragment(){
 float patch=noise(world_point.xz*0.25)*0.6+noise(world_point.xz*10.0)*0.4;
 float fog_amount = smoothstep(20.0,140.0,view_depth);
 vec3 surface=mix(grass_low,grass_high,patch);
 float rock=smoothstep(0.10,0.42,1.0-normalize(world_normal).y);
 float drift=smoothstep(0.4,0.7,patch);
 surface=mix(surface,vec3(0.18,0.24,0.24)*(0.7+patch*0.6),rock*0.7);
 surface*=0.96+drift*0.08;
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount;
 ROUGHNESS = 0.95;
 // Opaque banks avoid triangle-sorted alpha seams against the underlay.
}
