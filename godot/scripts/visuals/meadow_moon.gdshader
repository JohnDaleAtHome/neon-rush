shader_type spatial;
render_mode unshaded, fog_disabled;
uniform sampler2D lunar_height : filter_linear_mipmap, repeat_enable;
uniform vec4 moon_tint : source_color = vec4(1.0);
uniform vec3 haze_color : source_color = vec3(0.078,0.208,0.18);
uniform vec3 camera_forward=vec3(0,0,-1);
uniform vec3 camera_up=vec3(0,1,0);
uniform vec3 camera_right=vec3(1,0,0);
uniform float vertical_tangent=0.7;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
void fragment(){
 float h = texture(lunar_height, UV).r;
 float relief = clamp((h - 0.12) * 1.6, 0.0, 1.0);
 vec3 lunar = moon_tint.rgb * mix(0.36,0.78,relief);
 vec2 ndc=(SCREEN_UV-0.5)*vec2(2.0,-2.0);
 float aspect=VIEWPORT_SIZE.x/VIEWPORT_SIZE.y;
 vec3 ray=normalize(camera_forward+camera_right*ndc.x*vertical_tangent*aspect+camera_up*ndc.y*vertical_tangent);
 float y=SCREEN_UV.y;
 vec2 p=vec2(ray.x*7.0,y*12.0+sin(ray.x*4.0));
 float cloud=noise(p)*0.62+noise(p*2.0)*0.26+noise(p*4.0)*0.12;
 float cover=smoothstep(0.46,0.76,cloud)*smoothstep(0.10,0.25,y)*(1.0-smoothstep(0.36,0.46,y));
 float limb=pow(clamp(1.0-abs(dot(normalize(NORMAL),normalize(VIEW))),0.0,1.0),2.0);
 vec3 atmosphere=mix(vec3(0.022,0.026,0.065),vec3(0.058,0.075,0.13),clamp(y*2.0,0.0,1.0));
 atmosphere=mix(atmosphere,vec3(0.115,0.14,0.23),cover*0.8);
 atmosphere=mix(atmosphere,haze_color,smoothstep(0.30,0.43,y));
 ALBEDO = mix(lunar*0.48,atmosphere,0.38+cover*0.48+limb*0.12);
 ALPHA = (1.0-limb*0.32)*(1.0-cover*0.28);
 ROUGHNESS = 0.95;
 EMISSION = vec3(0.0);
 vec2 step_uv = vec2(1.0/1024.0);
 float dx = texture(lunar_height,UV+vec2(step_uv.x,0.0)).r-texture(lunar_height,UV-vec2(step_uv.x,0.0)).r;
 float dy = texture(lunar_height,UV+vec2(0.0,step_uv.y)).r-texture(lunar_height,UV-vec2(0.0,step_uv.y)).r;
 NORMAL_MAP = normalize(vec3(-dx*3.0,-dy*3.0,1.0))*0.5+0.5;
}
