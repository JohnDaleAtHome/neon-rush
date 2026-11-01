shader_type spatial;
render_mode cull_disabled;
varying vec3 local_point;
void vertex(){local_point=VERTEX;}
float line_segment(vec2 p,vec2 a,vec2 b){vec2 d=b-a;return length(p-a-d*clamp(dot(p-a,d)/dot(d,d),0.0,1.0));}
void fragment(){
 vec2 p=vec2(abs(local_point.x),local_point.z);
 float thread=0.0;
 thread=max(thread,1.0-smoothstep(0.000018,0.000040,line_segment(p,vec2(0.0019,0.0151),vec2(0.0030,0.0151))));
 thread=max(thread,1.0-smoothstep(0.000018,0.000040,line_segment(p,vec2(0.0030,0.0151),vec2(0.0035,0.0156))));
 thread=max(thread,1.0-smoothstep(0.000018,0.000040,line_segment(p,vec2(0.0035,0.0156),vec2(0.0035,0.0168))));
 thread=max(thread,1.0-smoothstep(0.000018,0.000040,line_segment(p,vec2(0.0035,0.0168),vec2(0.0043,0.0176))));
 thread*=1.0-smoothstep(-0.0018,0.0005,local_point.y);
 vec3 trim=local_point.x>0.0?vec3(0.11,0.64,0.75):vec3(0.62,0.12,0.40);
 float weave=sin(local_point.x*120000.0)*sin(local_point.z*120000.0)*0.015;
 ALBEDO=mix(vec3(0.14,0.16,0.25)+vec3(weave),trim,thread*0.75);
 EMISSION=trim*thread*0.24+vec3(0.012,0.017,0.032);
 ROUGHNESS=0.87;
}
