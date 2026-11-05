shader_type spatial;
render_mode cull_disabled;
varying vec3 wp;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.)).xyz;}
void fragment(){
 float swell=sin(wp.x*.24+wp.z*.13)*sin(wp.z*.17-wp.x*.08);
 vec3 col=mix(vec3(.065,.16,.20),vec3(.09,.23,.27),swell*.5+.5);
 ALBEDO=col;ROUGHNESS=.95;EMISSION=col*.15;
}
