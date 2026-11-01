shader_type spatial;
render_mode unshaded, fog_disabled;
uniform sampler2D lunar_height : filter_linear_mipmap, repeat_enable;
uniform vec4 moon_tint : source_color = vec4(1.0);
uniform vec3 haze_color : source_color = vec3(0.078,0.208,0.18);
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
void fragment(){
 float h = texture(lunar_height, UV).r;
 float relief = clamp((h - 0.12) * 1.6, 0.0, 1.0);
 vec3 lunar = moon_tint.rgb * mix(0.36,0.78,relief);
 float veil=smoothstep(0.45,0.72,noise(SCREEN_UV*vec2(9.0,24.0)));
 // Share the sky's cloud field, including over the lunar limb.
 float y=SCREEN_UV.y;
 vec2 cloud_point=vec2((SCREEN_UV.x-0.5)*6.5,y*17.0+sin((SCREEN_UV.x-0.5)*5.0));
 float cloud=noise(cloud_point)*0.62+noise(cloud_point*2.0)*0.26+noise(cloud_point*4.0)*0.12;
 float cover=smoothstep(0.44,0.70,cloud);
 float limb=pow(clamp(1.0-abs(dot(normalize(NORMAL),normalize(VIEW))),0.0,1.0),2.0);
 vec3 atmosphere=mix(haze_color,vec3(0.055,0.075,0.13),0.4);
 ALBEDO = mix(lunar*0.7,atmosphere,0.48+cover*0.35+limb*0.12);
 ALPHA = (1.0-limb*0.32)*(1.0-cover*0.28);
 ROUGHNESS = 0.95;
 EMISSION = vec3(0.0);
 vec2 step_uv = vec2(1.0/1024.0);
 float dx = texture(lunar_height,UV+vec2(step_uv.x,0.0)).r-texture(lunar_height,UV-vec2(step_uv.x,0.0)).r;
 float dy = texture(lunar_height,UV+vec2(0.0,step_uv.y)).r-texture(lunar_height,UV-vec2(0.0,step_uv.y)).r;
 NORMAL_MAP = normalize(vec3(-dx*3.0,-dy*3.0,1.0))*0.5+0.5;
}
