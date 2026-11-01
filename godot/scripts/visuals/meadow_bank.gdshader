shader_type spatial;
render_mode fog_disabled;
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform vec3 grass_low : source_color = vec3(0.055,0.11,0.063);
uniform vec3 grass_high : source_color = vec3(0.078,0.15,0.088);
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
 float patch=noise(world_point.xz*0.22)*0.7+noise(world_point.xz*1.7)*0.3;
 float fog_amount = smoothstep(20.0,140.0,view_depth);
 vec3 surface=mix(grass_low,grass_high,patch);
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount;
 ROUGHNESS = 0.95;
 // Opaque banks avoid triangle-sorted alpha seams against the underlay.
}
