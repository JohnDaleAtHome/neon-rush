#!/usr/bin/env python3
"""Linux-only isolated truncation regression. Never uses the normal game profile."""
import argparse
import os
from pathlib import Path
import resource
import signal
import subprocess
import sys
import tempfile

SCRIPT = '''extends SceneTree
func _init():call_deferred('run')
func run():
 var g=load('res://scenes/main.tscn').instantiate();root.add_child(g);await process_frame;g.set_process(false)
 var base=OS.get_user_data_dir();assert('neon-rush-test-' in base)
 g.level=4;g.pieces=g.PIECES.slice(0,4)
 for pair in [['options','save_options'],['journey','save_checkpoint'],['stats','save_stats']]:
  var path=base.path_join(pair[0]+'.json');var f=FileAccess.open(path,FileAccess.WRITE);f.store_string('previous valid bytes');f.close()
  g.storage_warning='';g.call(pair[1]);assert(g.storage_warning==g.STORAGE_CAUTION)
  assert(FileAccess.get_file_as_string(path)=='previous valid bytes');assert(not FileAccess.file_exists(path+'.pending'))
 g.queue_free();await process_frame;await create_timer(.2).timeout
 print('VERIFIED_SAVE_FAULT_PASS');quit()
'''

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--godot', required=True)
    args = parser.parse_args()
    if sys.platform != 'linux':
        parser.error('fault isolation verified only on Linux')
    project = Path(__file__).resolve().parents[1]
    with tempfile.TemporaryDirectory(prefix='neon-rush-test-save-fault-') as tmp:
        base = Path(tmp)
        script = base / 'fault.gd'
        script.write_text(SCRIPT, encoding='utf-8')
        env = os.environ.copy()
        env.update(XDG_DATA_HOME=str(base/'data'), XDG_CONFIG_HOME=str(base/'config'), XDG_CACHE_HOME=str(base/'cache'))
        def limit_child():
            signal.signal(signal.SIGXFSZ, signal.SIG_IGN)
            resource.setrlimit(resource.RLIMIT_FSIZE, (64, 64))
        result = subprocess.run([args.godot, '--headless', '--path', str(project), '--script', str(script)], env=env, preexec_fn=limit_child, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=25, text=True)
        print(result.stdout, end='')
        if result.returncode or 'VERIFIED_SAVE_FAULT_PASS' not in result.stdout or 'ERROR:' in result.stdout:
            raise SystemExit('FAIL isolated verified save truncation')
    print('PASS all three native save paths preserve old bytes and warn on induced truncation')

if __name__ == '__main__':
    main()
