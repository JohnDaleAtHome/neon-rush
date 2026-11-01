shader_type spatial;
render_mode cull_disabled;
uniform bool seam=false;
void vertex(){
 float trail=UV.x*UV.x;
 VERTEX.z+=sin(TIME*3.6+UV.x*5.0)*0.0007*trail;
 VERTEX.x+=cos(TIME*2.4+UV.x*4.0)*0.00025*trail;
}
void fragment(){
 float stitch=step(0.75,fract(UV.x*24.0))*step(0.88,UV.y);
 ALBEDO=seam?vec3(0.13,0.9,1.0):mix(vec3(0.025,0.045,0.085),vec3(0.14,0.3,0.38),stitch*0.6);
 EMISSION=seam?vec3(0.025,0.22,0.3):vec3(0.0);
 ROUGHNESS=0.85;
}
