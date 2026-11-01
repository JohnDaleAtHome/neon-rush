shader_type spatial;
render_mode cull_disabled;
uniform float layer=1.0;
varying vec3 local_point;
float hash(vec3 p){return fract(sin(dot(p,vec3(127.1,311.7,74.7)))*43758.5453);}
void vertex(){
 local_point=VERTEX;
 VERTEX+=NORMAL*layer*0.000055;
}
void fragment(){
 vec2 eye=vec2((abs(local_point.x)-0.00365)/0.0017,(local_point.z-0.02275)/0.0020);
 if(local_point.y< -0.002 && dot(eye,eye)<1.5)discard;
 // Fine elongated cells follow a slight swept groom rather than square speckles.
 vec3 p=vec3(local_point.x+local_point.z*0.12,local_point.y-local_point.z*0.35,local_point.z)*vec3(24000.0,24000.0,2400.0);
 float fibers=hash(floor(p));
 ALPHA=fibers;
 ALPHA_SCISSOR_THRESHOLD=0.50+layer*0.11;
 ALBEDO=vec3(0.83,0.89,0.96);
 ROUGHNESS=0.95;
 RIM=0.14;
 RIM_TINT=0.6;
}
