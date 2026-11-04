shader_type spatial;
render_mode cull_disabled;
varying vec3 wp;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;}
void fragment(){
 float strata=0.5+0.5*sin(wp.y*1.8+sin(wp.x*0.7)*0.5);
 vec3 c=mix(vec3(0.04,0.095,0.12),vec3(0.10,0.19,0.22),strata*0.25+smoothstep(-0.5,7.0,wp.y)*0.5);
 float wet=1.0-smoothstep(-0.4,0.7,wp.y);
 c=mix(c,vec3(0.045,0.115,0.16),smoothstep(70.0,250.0,-wp.z)*0.85);
 ALBEDO=c*(1.0-wet*0.20);ROUGHNESS=0.95;EMISSION=c*0.13;
}
