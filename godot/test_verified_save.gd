extends SceneTree
func _init():call_deferred('run')
func run():
 var base=OS.get_user_data_dir();assert('neon-rush-test-' in base)
 var helper=preload('res://scripts/verified_save.gd')
 var p=base.path_join('verified.json');var old='old';var f=FileAccess.open(p,FileAccess.WRITE);f.store_string(old);f.close()
 for text in ['月兔','',old,'again','again']:
  assert(helper.replace_file(p,text));assert(FileAccess.get_file_as_bytes(p)==text.to_utf8_buffer())
 assert(DirAccess.make_dir_absolute(p+'.pending')==OK)
 assert(not helper.replace_file(p,'blocked'));assert(FileAccess.get_file_as_string(p)=='again')
 assert(DirAccess.dir_exists_absolute(p+'.pending'));assert(DirAccess.remove_absolute(p+'.pending')==OK)
 var d=base.path_join('directory.json');assert(DirAccess.make_dir_absolute(d)==OK)
 assert(not helper.replace_file(d,'new'));assert(DirAccess.dir_exists_absolute(d));assert(not FileAccess.file_exists(d+'.pending'))
 var g=load('res://scenes/main.tscn').instantiate();root.add_child(g);await process_frame;g.set_process(false)
 for pair in [['options','save_options'],['journey','save_checkpoint'],['stats','save_stats']]:
  var path=base.path_join(pair[0]+'.json');g.storage_warning='';g.call(pair[1]);assert(g.storage_warning=='')
  assert(JSON.parse_string(FileAccess.get_file_as_string(path)) is Dictionary);assert(not FileAccess.file_exists(path+'.pending'))
 g.queue_free();await process_frame;await create_timer(.2).timeout
 print('VERIFIED_SAVE_PASS exact UTF8/empty/repeat/open fail/rename fail/old preservation/three saves');quit()
