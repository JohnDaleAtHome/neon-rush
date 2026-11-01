shader_type sky;
uniform sampler2D sky_gradient : source_color, filter_linear, repeat_disable;
uniform vec3 haze_color : source_color = vec3(0.078431,0.207843,0.180392);
uniform vec3 camera_forward = vec3(0.0,0.0,-1.0);
uniform vec3 camera_up = vec3(0.0,1.0,0.0);
uniform float vertical_tangent = 0.7;
void sky(){
 float y = 0.5 - 0.5 * dot(EYEDIR,camera_up) / max(0.01,dot(EYEDIR,camera_forward)) / vertical_tangent;
 vec3 base = texture(sky_gradient,vec2(0.5,clamp(y,0.0,1.0))).rgb;
 // Low-frequency broken wisps, quiet enough to leave objective text readable.
 float cloud=sin(EYEDIR.x*19.0+sin(EYEDIR.y*24.0)*1.8)*sin(EYEDIR.x*7.0-EYEDIR.y*21.0);
 float band=exp(-pow((y-0.43)*10.0,2.0));
 vec3 clouded=mix(base,vec3(0.17,0.24,0.28),smoothstep(0.28,0.85,cloud)*band*0.16);
 // The lower sky converges on the same haze as distant opaque geometry.
 COLOR = mix(clouded,haze_color,smoothstep(0.24,0.40,y));
}
