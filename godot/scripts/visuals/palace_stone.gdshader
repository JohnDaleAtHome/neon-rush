shader_type spatial;
render_mode cull_disabled;
varying vec3 wp;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;}
void fragment(){float row=floor(wp.z/2.8);vec2 tile=vec2(wp.x+mod(row,2.0)*1.35,wp.z)/vec2(2.7,2.8);vec2 edge=min(fract(tile),1.0-fract(tile));float joint=1.0-smoothstep(0.007,0.016,min(edge.x,edge.y));float random=fract(sin(dot(floor(tile),vec2(12.98,78.23)))*43758.54);vec3 col=mix(vec3(0.22,0.22,0.29),vec3(0.27,0.27,0.34),random);ALBEDO=mix(col,vec3(0.16,0.16,0.23),joint*0.6);ROUGHNESS=0.92;}
