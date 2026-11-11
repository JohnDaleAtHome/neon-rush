extends RefCounted
# Native save replacement. Exact readback before replacing the previous file.
static func replace_file(path:String,text:String)->bool:
 var temp=path+'.pending'
 var file=FileAccess.open(temp,FileAccess.WRITE)
 if not file:return false
 file.store_string(text);file.close()
 var readback=FileAccess.open(temp,FileAccess.READ)
 if not readback:
  DirAccess.remove_absolute(temp);return false
 var bytes=readback.get_buffer(readback.get_length());readback.close()
 if bytes!=text.to_utf8_buffer():
  DirAccess.remove_absolute(temp);return false
 var status=DirAccess.rename_absolute(temp,path)
 if status!=OK:DirAccess.remove_absolute(temp)
 return status==OK
