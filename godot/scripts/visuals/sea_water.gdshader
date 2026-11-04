shader_type spatial;
render_mode cull_disabled;
uniform bool path_surface=false;
uniform bool animate=true;
varying vec3 world_position;
void vertex(){
 world_position=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 if(!path_surface){
  float a=world_position.x*0.13+world_position.z*0.055+(TIME*float(animate))*0.65;
  float b=world_position.x*0.07-world_position.z*0.09-(TIME*float(animate))*0.4;
  float edge=smoothstep(4.0,11.0,abs(world_position.x));
  VERTEX.y+=edge*(sin(a)*0.48+sin(b)*0.27);
  NORMAL=normalize(vec3(-edge*(cos(a)*0.0624+cos(b)*0.0189),1.0,-edge*(cos(a)*0.0264-cos(b)*0.0243)));
 }
}
void fragment(){
 vec2 p=world_position.xz;
 float waves=sin(p.x*0.13+p.y*0.055+(TIME*float(animate))*0.65)*0.5+sin(p.x*0.07-p.y*0.09-(TIME*float(animate))*0.4)*0.3;
 float crest=sin(p.y*0.48+sin(p.x*0.055+p.y*0.025)*1.1+TIME*float(animate)*0.45);
 float broken=smoothstep(-0.20,0.30,sin(p.x*0.23+p.y*0.09)+sin(p.x*0.06-p.y*0.13)*0.5);
 float ribbons=smoothstep(0.92,0.99,crest)*broken*smoothstep(4.0,9.0,abs(p.x));
 vec3 water=mix(vec3(0.018,0.070,0.105),vec3(0.055,0.19,0.23),waves*0.5+0.5);
 water=mix(water,vec3(0.15,0.33,0.38),ribbons*0.45);
 if(path_surface){water=mix(vec3(0.045,0.10,0.14),vec3(0.07,0.16,0.19),sin(p.y*0.08+p.x*0.1)*0.15+0.5);}
 water=mix(water,vec3(0.045,0.115,0.16),smoothstep(70.0,250.0,-p.y)*0.8);
 if(!path_surface){
  float sweep=p.x+14.0+sin(p.y*0.022)*7.0;
  float glint=exp(-sweep*sweep/(80.0+max(-p.y,0.0)*0.4));
  float drift=TIME*float(animate)*0.18;
  float facets=smoothstep(0.55,0.95,sin(p.y*1.8+sin(p.x*0.7)+drift));
  facets*=smoothstep(-0.1,0.6,sin(p.x*1.5+p.y*0.6)+sin(p.x*0.5-p.y*0.8)*0.5);
  water+=vec3(0.13,0.19,0.21)*glint*facets*(1.0-smoothstep(100.0,280.0,-p.y));
 }
 ALBEDO=water;ROUGHNESS=0.55;SPECULAR=0.35;
 EMISSION=water*0.30;
}
