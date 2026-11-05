shader_type spatial;
render_mode unshaded,fog_disabled;
uniform bool is_path=false;
uniform bool is_rock=false;
uniform float scroll=0.0;
uniform sampler2D sand_texture : source_color,filter_linear_mipmap,repeat_enable;
varying vec3 wp;
varying vec3 wn;
varying float depth;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;wn=normalize(MODEL_NORMAL_MATRIX*NORMAL);depth=-(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;}
void fragment(){
 float light=0.18+0.82*max(dot(normalize(wn),normalize(vec3(-0.8,0.28,-0.25))),0.0);
 float ripples=sin(wp.x*2.3+(wp.z+scroll*25.0)*0.65+sin(wp.z*0.1))*0.007*(1.0-smoothstep(25.0,85.0,depth));
 vec3 surface=mix(vec3(0.35,0.25,0.14),vec3(0.73,0.61,0.38),light)+ripples;
 vec2 uv=vec2(wp.x/18.0,(wp.z+scroll*25.0)/18.0);float grain=dot(texture(sand_texture,uv).rgb,vec3(0.333))-0.25;surface+=grain*0.75*(1.0-smoothstep(35.0,100.0,depth));
 if(is_rock)surface=mix(vec3(0.21,0.18,0.11),vec3(0.44,0.37,0.24),light)+grain*0.03;
 float haze=smoothstep(65.0,340.0,depth)*0.86;
 if(is_path){float shoulder=smoothstep(2.0,3.6,abs(wp.x));surface=mix(surface,vec3(0.55,0.46,0.31)+grain*0.75,0.22*(1.0-shoulder));float guide=exp(-pow((abs(wp.x)-1.18)*45.0,2.0));surface+=vec3(0.12,0.11,0.08)*guide;}
 ALBEDO=mix(surface,vec3(0.71,0.63,0.49),haze);
}
