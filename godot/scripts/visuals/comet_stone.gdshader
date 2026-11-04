shader_type spatial;
render_mode cull_disabled;
uniform bool path_surface=false;
varying vec3 wp;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;}
void fragment(){
 float strata=sin(wp.y*1.3+sin(wp.x*0.19+wp.z*0.12));
 vec3 c=mix(vec3(0.022,0.018,0.035),vec3(0.11,0.065,0.14),max(0.0,NORMAL.y)*0.75+0.1+strata*0.06);
 if(path_surface)c=mix(vec3(0.115,0.075,0.135),vec3(0.15,0.10,0.165),sin(wp.z*0.13+wp.x*0.9)*0.2+0.5);
 float crack=pow(max(0.0,1.0-abs(sin(wp.x*0.31+sin(wp.z*0.11+sin(wp.x*0.15))*2.0))),36.0)*smoothstep(5.0,12.0,abs(wp.x));
 c=mix(c,vec3(0.20,0.14,0.24),crack*0.5);
 c=mix(c,vec3(0.10,0.035,0.13),smoothstep(45.0,240.0,-wp.z)*0.70);
 ALBEDO=c;ROUGHNESS=0.96;EMISSION=c*0.18;
}
