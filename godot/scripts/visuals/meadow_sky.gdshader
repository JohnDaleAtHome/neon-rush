shader_type sky;
uniform sampler2D sky_gradient : source_color, filter_linear, repeat_disable;
uniform vec3 haze_color : source_color = vec3(0.078431,0.207843,0.180392);
uniform vec3 camera_forward = vec3(0.0,0.0,-1.0);
uniform vec3 camera_up = vec3(0.0,1.0,0.0);
uniform float vertical_tangent = 0.7;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
void sky(){
 float y = 0.5 - 0.5 * dot(EYEDIR,camera_up) / max(0.01,dot(EYEDIR,camera_forward)) / vertical_tangent;
 vec3 base = texture(sky_gradient,vec2(0.5,clamp(y,0.0,1.0))).rgb;
 // Layered indigo night and broad cloud wisps echo the character concept palette.
 vec3 night=mix(vec3(0.022,0.026,0.065),vec3(0.058,0.075,0.13),clamp(y*2.0,0.0,1.0));
 vec2 p=vec2(EYEDIR.x*6.5,y*17.0+sin(EYEDIR.x*5.0));
 float cloud=noise(p)*0.62+noise(p*2.0)*0.26+noise(p*4.0)*0.12;
 float veil=smoothstep(0.46,0.76,cloud)*smoothstep(0.10,0.25,y)*(1.0-smoothstep(0.36,0.46,y));
 vec3 clouded=mix(night,vec3(0.115,0.14,0.23),veil*0.5);
 COLOR=mix(clouded,haze_color,smoothstep(0.30,0.43,y));
}
