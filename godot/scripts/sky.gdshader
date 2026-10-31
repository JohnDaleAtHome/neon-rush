shader_type sky;
uniform sampler2D sky_gradient : source_color, filter_linear, repeat_disable;
uniform vec3 camera_forward = vec3(0.0,0.0,-1.0);
uniform vec3 camera_up = vec3(0.0,1.0,0.0);
uniform float vertical_tangent = 0.7;
void sky(){
 float y = 0.5 - 0.5 * dot(EYEDIR,camera_up) / max(0.01,dot(EYEDIR,camera_forward)) / vertical_tangent;
 COLOR = texture(sky_gradient,vec2(0.5,clamp(y,0.0,1.0))).rgb;
}
