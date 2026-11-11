extends RefCounted
# Current Web templates map touchcancel and touchend to the same engine event.
# Preserve their distinction before the engine's canvas bubble listener runs.
# FIFO per DOM identifier also preserves order when several events arrive in one frame.
static func install():
 if not OS.has_feature("web"):return
 JavaScriptBridge.eval("""(()=>{
 const key='__neonTouchRelease';
 if(window[key])window[key].dispose();
 const canvas=document.querySelector('canvas');if(!canvas)return;
 const pending=new Map();
 const onRelease=e=>{for(const t of e.changedTouches){
  const q=pending.get(t.identifier)||[];
  q.push(e.type==='touchcancel');pending.set(t.identifier,q);
 }};
 const state={consume(id){const q=pending.get(id);if(!q)return false;
  const canceled=q.shift();if(!q.length)pending.delete(id);return canceled;
 },dispose(){canvas.removeEventListener('touchend',onRelease,true);
  canvas.removeEventListener('touchcancel',onRelease,true);pending.clear();
  if(window[key]===state)delete window[key];}};
 canvas.addEventListener('touchend',onRelease,{capture:true,passive:true});
 canvas.addEventListener('touchcancel',onRelease,{capture:true,passive:true});
 window[key]=state;
 })()""",true)

static func consume(index:int)->bool:
 if not OS.has_feature("web"):return false
 return JavaScriptBridge.eval("window.__neonTouchRelease && window.__neonTouchRelease.consume(%d) ? 'canceled' : 'ended'" % index,true)=="canceled"

static func dispose():
 if OS.has_feature("web"):JavaScriptBridge.eval("if(window.__neonTouchRelease)window.__neonTouchRelease.dispose()",true)
