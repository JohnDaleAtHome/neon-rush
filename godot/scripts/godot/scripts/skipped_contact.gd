extends RefCounted
# A fallback only for a complete skipped band. Ordinary endpoint contacts stay unchanged.
static func below(a:float,b:float,limit:float)->Vector2:
 if a==b:return Vector2(-INF,INF) if a<limit else Vector2.ZERO
 var t:float=(limit-a)/(b-a)
 return Vector2(-INF,t) if b>a else Vector2(t,INF)
static func overlap(parts:Array)->Vector2:
 var result:=Vector2(0,1)
 for p in parts:
  result.x=maxf(result.x,p.x);result.y=minf(result.y,p.y)
 return result
static func band(a:float,b:float,r:float)->Vector2:
 return overlap([below(a,b,r),below(-a,-b,r)])
static func exists(parts:Array)->bool:
 var span:=overlap(parts)
 return span.x<span.y
static func skipped(z0:float,z1:float,r:float)->bool:
 return z0<=-r and z1>=r and z1>z0
static func evaluate(kind:String,z0:float,z1:float,x0:float,x1:float,y0:float,y1:float,slide0:float,dt:float,magnet:bool)->Dictionary:
 var radius:float=2.2 if kind=="orb" and magnet else 1.1
 var result={"contact":false,"jump":false,"near":false}
 if not skipped(z0,z1,radius):return result
 var along:=band(z0,z1,radius)
 var lateral:=band(x0,x1,3.4 if kind=="orb" and magnet else 1.0)
 var base:Array=[along,lateral]
 if kind in ["orb","shield"]:
  result.contact=exists(base+[below(y0,y1,1.8)])
 elif kind=="beam":
  result.contact=exists(base+[below(-y0,-y1,-.1)]) or exists(base+[below(slide0,slide0-dt,0)])
  # Equality at .1 or slide0-dt*t==0 is included by the accepted beam rule.
  if y0==.1 and y1==.1:result.contact=exists(base)
  if slide0<=0:result.contact=exists(base)
 else:
  result.contact=exists(base+[below(y0,y1,.65 if kind=="low" else 2.3)])
 if kind=="low":result.jump=not result.contact and exists(base+[below(-y0,-y1,-.65)])
 if kind=="tall":
  var near_z:=band(z0,z1,2.2)
  result.near=exists([near_z,band(x0,x1,1.8),below(-x0,-x1,-1)]) or exists([near_z,band(x0,x1,1.8),below(x0,x1,-1)])
  if x0==x1 and absf(x0)==1:result.near=exists([near_z])
 return result
