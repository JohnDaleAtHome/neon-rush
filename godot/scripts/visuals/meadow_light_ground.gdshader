shader_type spatial;
render_mode fog_disabled;
uniform vec3 fog_color : source_color = vec3(.14,.28,.32);
uniform sampler2D path_cells : filter_linear_mipmap, repeat_enable;
uniform float scroll = 0.0;
uniform bool bank = false;
varying vec3 world_point;
varying float view_depth;
void vertex(){world_point=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;view_depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){
 vec2 cell=texture(path_cells,vec2(world_point.x*.085,(world_point.z+scroll*25.0)*.026875)).rg;
 vec3 surface=bank?vec3(.044,.09,.065):mix(mix(vec3(.065,.088,.11),vec3(.14,.17,.19),cell.r*.65),vec3(.028,.061,.05),cell.g*.82);
 float fog=smoothstep(20.0,92.0,view_depth);
 ALBEDO=surface*(1.0-fog);EMISSION=fog_color*fog;ROUGHNESS=.95;ALPHA=1.0-smoothstep(35.0,95.0,view_depth);
}
