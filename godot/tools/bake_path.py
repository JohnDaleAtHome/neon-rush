from pathlib import Path
import numpy as np
from PIL import Image
# Original tile data. Periodic seeds produce an offline repeatable material,
# not a downloaded texture or runtime procedural neighbourhood search.
w,h=512,1024
x,y=np.meshgrid((np.arange(w)+.5)/w*8,(np.arange(h)+.5)/h*16)
cx,cy=np.floor(x),np.floor(y);fx,fy=x-cx,y-cy
nearest=np.full((h,w),100.);second=nearest.copy();tone=np.zeros((h,w))
def rand(x,y):return np.mod(np.sin(x*127.1+y*311.7)*43758.5453,1)
for iy in [-1,0,1]:
 for ix in [-1,0,1]:
  sx,sy=np.mod(cx+ix,8),np.mod(cy+iy,16)
  a,b=rand(sx,sy),rand(sx+47,sy+13)
  dist=np.sqrt((ix+.5+(a-.5)*.55-fx)**2+(iy+.5+(b-.5)*.55-fy)**2)
  take=dist<nearest;second=np.where(take,nearest,np.minimum(second,dist));tone=np.where(take,a,tone);nearest=np.minimum(nearest,dist)
t=np.clip((second-nearest-.025)/.060,0,1);seam=1-t*t*(3-2*t)
a=np.zeros((h,w,3),dtype=np.uint8);a[:,:,0]=(tone*255).astype('uint8');a[:,:,1]=(seam*255).astype('uint8')
destination=Path(__file__).resolve().parents[1]/'assets/visuals/meadow/path_cells.png'
destination.parent.mkdir(parents=True,exist_ok=True)
Image.fromarray(a).save(destination)
