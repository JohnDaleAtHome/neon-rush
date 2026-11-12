extends RefCounted
# One locked warning/launch per closed Guardian shield window.
const WARNING_SECONDS=1.0
var window_id=-1
var warned=false
var launched=false
var target_lane=-1
var warning_age=0.0
func reset():
 window_id=-1
 warned=false
 launched=false
 target_lane=-1
 warning_age=0.0
func step(dt:float,closed:bool,window:int,lane:int)->Dictionary:
 if not is_finite(dt) or dt<0 or lane<0 or lane>2: return {"event":"invalid"}
 if not closed:
  # An opened shield consumes the current window. No rearm on a stale ID.
  window_id=window
  warned=true
  launched=true
  target_lane=-1
  warning_age=0.0
  return {"event":"none"}
 if window!=window_id:
  window_id=window
  warned=false
  launched=false
  target_lane=-1
  warning_age=0.0
 if not warned:
  warned=true
  target_lane=lane
  return {"event":"warn","lane":target_lane}
 if launched:return {"event":"none"}
 warning_age+=dt
 if warning_age>=WARNING_SECONDS:
  launched=true
  return {"event":"launch","lane":target_lane}
 return {"event":"none"}
