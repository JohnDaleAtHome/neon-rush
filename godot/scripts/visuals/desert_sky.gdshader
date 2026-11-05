shader_type sky;
void sky(){float h=clamp(EYEDIR.y*2.0+0.25,0.0,1.0);COLOR=mix(vec3(0.71,0.63,0.49),vec3(0.19,0.30,0.32),h);}
