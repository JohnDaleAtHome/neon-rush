shader_type spatial;
render_mode fog_disabled, cull_disabled;
uniform vec3 base_color : source_color = vec3(0.13,0.30,0.23);
uniform vec3 fog_color : source_color = vec3(0.078,0.208,0.18);
uniform bool vertex_colors = false;
uniform float sway = 0.035;
varying vec3 world_point;
varying float view_depth;
float bank_height(float x,float z){
 float edge=smoothstep(4.0,12.0,abs(x));
 float rear=1.0-smoothstep(112.0,144.0,-z);
 float outer=1.0-smoothstep(44.0,53.8,abs(x));
 return -0.14+edge*rear*outer*(1.4+0.75*sin(z*0.055+x*0.14)+0.45*sin(z*0.12-x*0.19));
}
void vertex(){
 vec3 world=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 float weight=clamp(VERTEX.y+0.15,0.0,1.0);
 VERTEX.x+=sin(TIME*0.8+world.z*0.2+world.x*0.3)*sway*weight;
 // Color alpha tags only short grass. No alpha output: material stays opaque.
 if(vertex_colors && COLOR.a<0.5){
  vec3 grass_world=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
  grass_world.y=bank_height(grass_world.x,grass_world.z)+VERTEX.y*length(MODEL_MATRIX[1].xyz);
  VERTEX=(inverse(MODEL_MATRIX)*vec4(grass_world,1.0)).xyz;
 }
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
