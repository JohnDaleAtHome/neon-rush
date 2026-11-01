shader_type spatial;
render_mode fog_disabled;
uniform sampler2D terrain_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform vec4 terrain_tint : source_color = vec4(1.0);
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform vec2 uv_scale = vec2(1.0,6.0);
uniform float scroll = 0.0;
uniform bool fade_geometry = true;
varying float view_depth;
void vertex(){
 float depth = -(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;
 view_depth = depth;
}
void fragment(){
 float fog_amount = smoothstep(20.0,92.0,view_depth);
 float far_fade = 1.0-smoothstep(46.0,112.0,view_depth);
 vec3 surface = texture(terrain_texture,UV*uv_scale+vec2(0.0,scroll)).rgb*terrain_tint.rgb;
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount;
 ROUGHNESS = 0.95;
 ALPHA = fade_geometry ? far_fade : 1.0;
}
