shader_type spatial;
render_mode unshaded,cull_disabled;
uniform sampler2D facade : source_color,filter_linear_mipmap;
varying float depth;
void vertex(){depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){vec4 c=texture(facade,UV);if(c.a<0.45){discard;}ALBEDO=mix(c.rgb,vec3(0.376,0.424,0.412),smoothstep(45.0,220.0,depth)*0.6);}
