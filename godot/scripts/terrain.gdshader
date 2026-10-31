shader_type spatial;
render_mode fog_disabled;
uniform sampler2D terrain_texture : source_color, filter_linear_mipmap, repeat_enable;
uniform vec4 terrain_tint : source_color = vec4(1.0);
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform vec2 uv_scale = vec2(1.0,6.0);
uniform float scroll = 0.0;
varying float fog_amount;
varying float far_fade;
void vertex(){
 float depth = -(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;
 fog_amount = smoothstep(24.0,105.0,depth);
 far_fade = 1.0-smoothstep(72.0,130.0,depth);
}
void fragment(){
 vec3 surface = texture(terrain_texture,UV*uv_scale+vec2(0.0,scroll)).rgb*terrain_tint.rgb;
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount;
 ROUGHNESS = 0.95;
 ALPHA = far_fade;
}
