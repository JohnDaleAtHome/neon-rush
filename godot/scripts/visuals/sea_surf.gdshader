shader_type spatial;
render_mode unshaded,cull_disabled,fog_disabled;
uniform bool animate=true;
varying vec3 wp;varying float depth;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;float a=wp.x*0.13+wp.z*0.055+TIME*float(animate)*0.65;float b=wp.x*0.07-wp.z*0.09-TIME*float(animate)*0.4;VERTEX.y+=sin(a)*0.48+sin(b)*0.27;depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){vec3 c=mix(vec3(0.12,0.29,0.32),vec3(0.28,0.45,0.46),0.5+0.5*sin(wp.x*1.8+wp.z*0.7));ALBEDO=mix(c,vec3(0.045,0.115,0.16),smoothstep(25.0,190.0,depth));ROUGHNESS=1.0;}
