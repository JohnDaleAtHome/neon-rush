shader_type sky;
uniform vec3 camera_forward=vec3(0.0,0.0,-1.0);
uniform vec3 camera_up=vec3(0.0,1.0,0.0);
uniform float vertical_tangent=0.7;
void sky(){
 float y=0.5-0.5*dot(EYEDIR,camera_up)/max(0.01,dot(EYEDIR,camera_forward))/vertical_tangent;
 float x=EYEDIR.x/max(0.01,-EYEDIR.z);
 vec3 c=mix(vec3(0.008,0.018,0.045),vec3(0.045,0.115,0.16),smoothstep(0.16,0.41,y));
 float bank=sin(x*2.8+sin(x*5.0)*0.25)*0.018;
 float cloud=smoothstep(0.15+bank,0.20+bank,y)*(1.0-smoothstep(0.23+bank,0.28+bank,y));
 float lower=smoothstep(0.34-bank*0.7,0.37-bank*0.7,y)*(1.0-smoothstep(0.39-bank*0.7,0.43-bank*0.7,y));
 c=mix(c,vec3(0.09,0.13,0.18),cloud*0.75);
 c=mix(c,vec3(0.025,0.065,0.10),lower*0.5);
 COLOR=c;
}
