shader_type spatial;
render_mode unshaded,fog_disabled,cull_disabled;
uniform bool path_surface=false;
varying vec3 wp;varying float depth;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){float grain=sin(wp.x*1.3+sin(wp.z*0.7))*sin(wp.z*1.8+wp.x*0.9);vec3 col=mix(vec3(0.12,0.075,0.035),vec3(0.22,0.15,0.075),grain*0.045+0.5);if(path_surface){col=vec3(0.28,0.18,0.09);float leaf=step(0.985,sin(wp.x*4.1+wp.z*1.4)*cos(wp.z*2.8));col=mix(col,vec3(0.38,0.24,0.10),leaf*0.35);}
  ALBEDO=mix(col,vec3(0.27,0.19,0.13),smoothstep(28.0,155.0,depth));ROUGHNESS=1.0;}
