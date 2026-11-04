shader_type spatial;
render_mode unshaded,cull_disabled,fog_disabled;
varying float depth;
void vertex(){depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){ALBEDO=mix(COLOR.rgb*0.62,vec3(0.27,0.19,0.13),smoothstep(24.0,155.0,depth));ROUGHNESS=1.0;}
