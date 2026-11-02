shader_type spatial;
render_mode cull_disabled;
uniform sampler2D badge_texture: source_color, filter_linear_mipmap;
varying vec3 local_point;
void vertex(){local_point=VERTEX;}
float line_segment(vec2 p,vec2 a,vec2 b){vec2 d=b-a;return length(p-a-d*clamp(dot(p-a,d)/dot(d,d),0.0,1.0));}
void fragment(){
 vec2 p=vec2(abs(local_point.x),local_point.z);
 float thread=0.0;
 thread=max(thread,1.0-smoothstep(0.000030,0.000065,line_segment(p,vec2(0.0019,0.0151),vec2(0.0030,0.0151))));
 thread=max(thread,1.0-smoothstep(0.000030,0.000065,line_segment(p,vec2(0.0030,0.0151),vec2(0.0035,0.0156))));
 thread=max(thread,1.0-smoothstep(0.000030,0.000065,line_segment(p,vec2(0.0035,0.0156),vec2(0.0035,0.0168))));
 thread=max(thread,1.0-smoothstep(0.000030,0.000065,line_segment(p,vec2(0.0035,0.0168),vec2(0.0043,0.0176))));
 thread*=1.0-smoothstep(-0.0018,0.0005,local_point.y);
 vec3 trim=local_point.x>0.0?vec3(0.11,0.64,0.75):vec3(0.62,0.12,0.40);
 // Cut panel seam and short stitch dashes establish jacket construction.
 float panel=line_segment(p,vec2(.0040,.0130),vec2(.0054,.0140));
 panel=min(panel,line_segment(p,vec2(.0054,.0140),vec2(.0054,.0162)));
 panel=min(panel,line_segment(p,vec2(.0054,.0162),vec2(.0043,.0176)));
 float front=1.0-smoothstep(-.0018,-.0008,local_point.y);
 float seam=(1.0-smoothstep(.000035,.000075,panel))*front;
 float seamshadow=(1.0-smoothstep(.000080,.000150,panel))*front;
 float stitch=step(.42,fract((local_point.x+local_point.z)*11000.0));
 float weave=sin(local_point.x*120000.0)*sin(local_point.z*120000.0)*0.015;
 // One sewn chest badge with planar bounds, only on the front shell.
 vec2 uv=vec2((local_point.x+0.0048)/0.0018,1.0-(local_point.z-0.0139)/0.00205);
 float badge_mask=step(0.0,uv.x)*step(uv.x,1.0)*step(0.0,uv.y)*step(uv.y,1.0)*(1.0-smoothstep(-0.0018,-0.0010,local_point.y));
 vec4 badge=texture(badge_texture,clamp(uv,vec2(0.0),vec2(1.0)));
 float zipper=(1.0-smoothstep(.000025,.000060,abs(abs(local_point.x)-.00112)))*step(.0126,local_point.z)*step(local_point.z,.0170)*(1.0-smoothstep(-.0018,-.0010,local_point.y));
 float teeth=step(.5,fract(local_point.z*9000.0));
 ALBEDO=mix(vec3(0.14,0.16,0.25)+vec3(weave),trim,thread*0.90);
 EMISSION=trim*thread*0.65+vec3(0.012,0.017,0.032);
 ALBEDO=mix(ALBEDO,vec3(.022,.031,.052),seamshadow*.8);
 ALBEDO=mix(ALBEDO,trim,seam*(.45+.4*stitch));
 EMISSION+=trim*seam*.16;
 ALBEDO=mix(ALBEDO,badge.rgb,badge_mask);
 ALBEDO=mix(ALBEDO,vec3(.39,.49,.55),zipper*(.45+.4*teeth));
 EMISSION+=badge.rgb*badge_mask*.035;
 ROUGHNESS=0.87;
}
