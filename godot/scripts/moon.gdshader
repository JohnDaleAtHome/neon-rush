shader_type spatial;
render_mode fog_disabled;
uniform sampler2D lunar_height : filter_linear_mipmap, repeat_enable;
uniform vec4 moon_tint : source_color = vec4(1.0);
void fragment(){
 float h = texture(lunar_height, UV).r;
 float relief = clamp((h - 0.12) * 1.6, 0.0, 1.0);
 ALBEDO = moon_tint.rgb * mix(0.20, 0.95, relief);
 ROUGHNESS = 0.95;
 EMISSION = ALBEDO * 0.25;
 vec2 step_uv = vec2(1.0/1024.0);
 float dx = texture(lunar_height,UV+vec2(step_uv.x,0.0)).r-texture(lunar_height,UV-vec2(step_uv.x,0.0)).r;
 float dy = texture(lunar_height,UV+vec2(0.0,step_uv.y)).r-texture(lunar_height,UV-vec2(0.0,step_uv.y)).r;
 NORMAL_MAP = normalize(vec3(-dx*6.0,-dy*6.0,1.0))*0.5+0.5;
}
