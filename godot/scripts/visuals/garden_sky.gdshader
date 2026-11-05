shader_type sky;
void sky(){float h=clamp(EYEDIR.y*2.0+0.25,0.0,1.0);COLOR=mix(vec3(0.41,0.46,0.44),vec3(0.10,0.22,0.28),h);}
