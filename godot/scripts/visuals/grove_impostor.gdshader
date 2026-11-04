shader_type spatial;
render_mode unshaded,cull_disabled,fog_disabled;
uniform sampler2D tree_texture : source_color,filter_linear_mipmap;
varying float view_depth;
void vertex(){view_depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){vec4 tex=texture(tree_texture,UV);ALPHA=tex.a;ALPHA_SCISSOR_THRESHOLD=0.25;float value=dot(tex.rgb,vec3(0.25,0.6,0.15));vec3 col=mix(vec3(0.10,0.045,0.012),vec3(0.43,0.24,0.055),value);ALBEDO=mix(col,vec3(0.27,0.19,0.13),smoothstep(30.0,155.0,view_depth));}
