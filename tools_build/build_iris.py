from PIL import Image
import numpy as np,os
n=512;y,x=np.mgrid[0:n,0:n];x=(x+.5-n/2)/(n/2);y=(y+.5-n/2)/(n/2);r=np.sqrt(x*x+y*y);a=np.arctan2(y,x)
fiber=.07*np.sin(a*51+2*np.sin(a*13)+r*7)+.035*np.cos(a*93+r*11)
v=.82+.12*np.exp(-((r-.53)/.17)**2)+fiber*np.clip((r-.35)*4,0,1)
v*=1-.70*np.exp(-((r-.97)/.07)**2)
v*=.80+.20*np.clip(y+.4,0,1)
v=np.clip(v,.08,1);rgb=np.uint8(np.stack([v,v,v],axis=2)*255)
Image.fromarray(rgb).save(os.path.join(os.path.dirname(__file__),'../godot/assets/visuals/mochi/iris_detail.png'))
