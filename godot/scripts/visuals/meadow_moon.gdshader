shader_type spatial;
render_mode fog_disabled;
uniform sampler2D lunar_height : filter_linear_mipmap, repeat_enable;
uniform vec4 moon_tint : source_color = vec4(1.0);
uniform vec3 haze_color : source_color = vec3(0.078,0.208,0.18);
void fragment(){
 float h = texture(lunar_height, UV).r;
 float relief = clamp((h - 0.12) * 1.6, 0.0, 1.0);
 vec3 lunar = moon_tint.rgb * mix(0.36,0.78,relief);
 ALBEDO = mix(lunar,haze_color,0.28);
 ROUGHNESS = 0.95;
 EMISSION = haze_color*0.06 + ALBEDO*0.12;
 vec2 step_uv = vec2(1.0/1024.0);
 float dx = texture(lunar_height,UV+vec2(step_uv.x,0.0)).r-texture(lunar_height,UV-vec2(step_uv.x,0.0)).r;
 float dy = texture(lunar_height,UV+vec2(0.0,step_uv.y)).r-texture(lunar_height,UV-vec2(0.0,step_uv.y)).r;
 NORMAL_MAP = normalize(vec3(-dx*3.0,-dy*3.0,1.0))*0.5+0.5;
}
