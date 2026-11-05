shader_type spatial;
render_mode cull_disabled;
uniform bool path_surface=false;
uniform sampler2D stone:source_color,filter_linear_mipmap,repeat_enable;
varying vec3 wp;varying vec3 wn;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.)).xyz;wn=normalize(MODEL_NORMAL_MATRIX*NORMAL);}
void fragment(){
 vec3 w=pow(abs(wn),vec3(4.));w/=max(dot(w,vec3(1.)),.001);
 vec3 tex=texture(stone,wp.zy*.3).rgb*w.x+texture(stone,wp.xz*.3).rgb*w.y+texture(stone,wp.xy*.3).rgb*w.z;
 float v=dot(tex,vec3(.2126,.7152,.0722));vec3 col=mix(vec3(.11,.16,.17),vec3(.32,.38,.39),v);
 if(path_surface){float row=floor(wp.z/2.1);vec2 tile=vec2(wp.x+mod(row,2.)*.8,wp.z)/vec2(1.6,2.1);vec2 edge=min(fract(tile),1.-fract(tile));float joint=1.-smoothstep(.007,.02,min(edge.x,edge.y));float grain=sin(wp.x*1.3+sin(wp.z*.7))*sin(wp.z*1.8+wp.x*.9);col=mix(vec3(.20,.26,.28)*(.96+grain*.04),vec3(.085,.13,.15),joint*.55);}
 ALBEDO=col;ROUGHNESS=.95;EMISSION=col*.28;
}
