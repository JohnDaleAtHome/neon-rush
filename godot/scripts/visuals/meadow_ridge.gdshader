shader_type spatial;
render_mode unshaded,fog_disabled,cull_disabled;
uniform vec3 ridge_color : source_color=vec3(0.10,0.22,0.25);
uniform vec3 haze_color : source_color=vec3(0.141,0.278,0.322);
varying vec3 wp;
void vertex(){wp=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz;}
void fragment(){float height=clamp((wp.y+2.0)/35.0,0.0,1.0);float face=0.78+0.22*abs(dot(normalize(NORMAL),normalize(vec3(-0.4,0.8,0.25))));ALBEDO=mix(haze_color,ridge_color*face,height*0.75+0.15);}
