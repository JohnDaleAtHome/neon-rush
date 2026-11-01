shader_type spatial;
render_mode fog_disabled;
uniform vec3 fog_color : source_color = vec3(0.1,0.2,0.1);
uniform float scroll = 0.0;
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
 // Broad slate slabs with quiet engraved joints, not a stretched noise strip.
 vec2 slab=vec2(world_point.x*0.80,moving_point.y*0.36);
 float row=floor(slab.y);
 slab.x+=mod(row,2.0)*0.5;
 vec2 joint=abs(fract(slab)-0.5);
 float seam=smoothstep(0.465,0.495,max(joint.x,joint.y));
 float slab_tone=hash(floor(slab));
 vec3 surface=mix(vec3(0.035,0.060,0.085),vec3(0.11,0.15,0.18),grain*0.28+slab_tone*0.55);
 surface*=1.0-seam*0.65;
 // Soft shoulder glow stays at the physical edge, outside all three lanes.
 float shoulder=exp(-pow((abs(world_point.x)-3.65)*3.0,2.0));
 surface+=vec3(0.012,0.05,0.055)*shoulder;
 ALBEDO = surface*(1.0-fog_amount);
 EMISSION = fog_color*fog_amount+vec3(0.0,0.015,0.022)*shoulder*(1.0-fog_amount);
 ROUGHNESS = 0.95;
 ALPHA = fade_geometry ? far_fade : 1.0;
}
