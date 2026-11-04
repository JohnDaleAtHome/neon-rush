shader_type spatial;
render_mode unshaded,cull_disabled,fog_disabled;
uniform sampler2D tree_texture : source_color,filter_linear_mipmap;
uniform vec3 fog_color : source_color=vec3(0.141,0.278,0.322);
varying float view_depth;
void vertex(){view_depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){vec4 tex=texture(tree_texture,UV);ALPHA=tex.a;ALPHA_SCISSOR_THRESHOLD=0.35;ALBEDO=mix(tex.rgb,fog_color,smoothstep(30.0,135.0,view_depth));}
