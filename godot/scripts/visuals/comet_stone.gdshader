shader_type spatial;
render_mode cull_disabled;
uniform bool path_surface=false;
uniform bool cliff_surface=false;
varying vec3 wp;
varying vec3 wn;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;wn=normalize(MODEL_NORMAL_MATRIX*NORMAL);}
void fragment(){
 float strata=sin(wp.y*1.3+sin(wp.x*0.19+wp.z*0.12));
 vec3 c=mix(vec3(0.022,0.018,0.035),vec3(0.11,0.065,0.14),max(0.0,NORMAL.y)*0.75+0.1+strata*0.06);
 if(path_surface){
  float row=floor(wp.z/10.0);
  float offset=fract(row*0.618)*2.4;
  vec2 cell=fract(vec2(wp.x*0.28+offset,wp.z*0.1+wp.x*0.012));
  float seam=1.0-smoothstep(0.006,0.018,min(min(cell.x,1.0-cell.x),min(cell.y,1.0-cell.y)));
  c=mix(vec3(0.115,0.075,0.135),vec3(0.15,0.10,0.165),fract(row*0.413)*0.3+0.35);
  c=mix(c,vec3(0.045,0.025,0.055),seam*0.42);
 }
 float crack=pow(max(0.0,1.0-abs(sin(wp.x*0.31+sin(wp.z*0.11+sin(wp.x*0.15))*2.0))),36.0)*smoothstep(5.0,12.0,abs(wp.x));
 c=mix(c,vec3(0.20,0.14,0.24),crack*0.5);
 c=mix(c,vec3(0.10,0.035,0.13),smoothstep(45.0,240.0,-wp.z)*0.70);
 if(cliff_surface)c=mix(vec3(0.055,0.035,0.075),vec3(0.24,0.16,0.28),0.3+max(0.0,dot(wn,normalize(vec3(-0.6,0.65,-0.5))))*0.7);
 ALBEDO=c;ROUGHNESS=0.96;EMISSION=c*(cliff_surface ? 1.5 : 0.18);
}
