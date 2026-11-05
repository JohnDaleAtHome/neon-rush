shader_type spatial;
render_mode unshaded,fog_disabled,cull_disabled;
uniform bool path_surface=false;
varying vec3 wp;varying float depth;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){float grain=sin(wp.x*1.3+sin(wp.z*0.7))*sin(wp.z*1.8+wp.x*0.9);vec3 col=mix(vec3(0.12,0.17,0.10),vec3(0.22,0.25,0.15),grain*0.07+0.5);if(path_surface){float row=floor(wp.z/2.1);vec2 tile=vec2(wp.x+mod(row,2.0)*0.8,wp.z)/vec2(1.6,2.1);vec2 edge=min(fract(tile),1.0-fract(tile));float joint=1.0-smoothstep(0.007,0.02,min(edge.x,edge.y));col=mix(vec3(0.26,0.29,0.26)*(0.96+grain*0.04),vec3(0.14,0.17,0.15),joint*0.55);float leaf=step(0.985,sin(wp.x*4.1+wp.z*1.4)*cos(wp.z*2.8));col=mix(col,vec3(0.38,0.24,0.10),leaf*0.35);}
  ALBEDO=mix(col,vec3(0.41,0.46,0.44),smoothstep(28.0,155.0,depth));ROUGHNESS=1.0;}
