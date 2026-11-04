shader_type spatial;
render_mode unshaded,cull_back,fog_disabled;
uniform sampler2D base_texture : source_color,filter_linear_mipmap;
uniform vec3 tint : source_color=vec3(0.2,0.45,0.35);
uniform bool foliage=true;
uniform float fog_end=135.0;
uniform vec3 fog_color : source_color=vec3(0.141,0.278,0.322);
varying float view_depth;
void vertex(){view_depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){
 vec4 tex=texture(base_texture,UV);

 float lightness=dot(tex.rgb,vec3(0.25,0.6,0.15));
 vec3 col=foliage?mix(tint*0.5,tint*1.5,lightness):tex.rgb*tint;
 float fog=smoothstep(30.0,fog_end,view_depth);
 float shade=0.65+0.35*max(dot(normalize(NORMAL),normalize(vec3(-0.4,0.8,0.25))),0.0);
 ALBEDO=mix(col*shade,fog_color,fog);ROUGHNESS=0.95;
}
