shader_type spatial;
render_mode fog_disabled;
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform float scroll = 0.0;
uniform sampler2D path_cells : filter_linear_mipmap, repeat_enable;
uniform bool fade_geometry = true;
varying float view_depth;
varying vec3 world_point;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float noise(vec2 p){vec2 i=floor(p);vec2 f=fract(p);f=f*f*(3.0-2.0*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
void vertex(){
 world_point=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;
 float depth = -(MODELVIEW_MATRIX*vec4(VERTEX,1.0)).z;
 view_depth = depth;
}
void fragment(){
 float fog_amount = smoothstep(20.0,92.0,view_depth);
 float far_fade = 1.0-smoothstep(46.0,112.0,view_depth);
 vec2 moving_point=world_point.xz+vec2(0.0,scroll*25.0);
 float grain=noise(moving_point*7.0)*0.7+noise(moving_point*1.1)*0.3;
 // Worn stepping stones remain flat and fully traversable. Irregular stone
 // cells and moss joints remove the highway-grid rhythm without curving lanes.
 vec2 cell_data=texture(path_cells,vec2(world_point.x*0.085,moving_point.y*0.026875)).rg;
 float seam=cell_data.g;
 float slab_tone=cell_data.r;
 vec3 stone=mix(vec3(0.065,0.088,0.11),vec3(0.14,0.17,0.19),grain*0.25+slab_tone*0.65);
 vec3 earth=vec3(0.028,0.061,0.050)*(0.85+grain*0.28);
 vec3 surface=mix(stone,earth,seam*0.82);
 float shoulder_noise=noise(moving_point*0.55)*0.7+noise(moving_point*1.6)*0.3;
 float moss=smoothstep(2.60+shoulder_noise*0.45,3.45+shoulder_noise*0.40,abs(world_point.x));
 surface=mix(surface,vec3(0.044,0.105,0.075)*(0.72+grain*0.55),moss);
 // Soft shoulder glow stays at the physical edge, outside all three lanes.
 float shoulder=exp(-pow((abs(world_point.x)-3.65)*3.0,2.0));
 surface+=vec3(0.012,0.05,0.055)*shoulder;
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount+vec3(0.0,0.015,0.022)*shoulder*(1.0-fog_amount);
 ROUGHNESS = 0.95;
 ALPHA = fade_geometry ? far_fade : 1.0;
}
