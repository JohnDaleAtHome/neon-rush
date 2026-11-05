#!/usr/bin/env python3
"""Run native Godot suites with disposable Linux user-data directories."""
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile
import time

PROJECT = Path(__file__).resolve().parent.parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('tests', nargs='*', help='Root test_*.gd names; default: all')
    parser.add_argument('--godot', default=os.environ.get('GODOT_BIN'), help='Godot executable (or GODOT_BIN, godot, godot4)')
    parser.add_argument('--timeout', type=float, default=60, help='Seconds per suite, default 60')
    parser.add_argument('--logs', type=Path, required=True, help='New directory for full suite logs')
    args = parser.parse_args()
    if not sys.platform.startswith('linux'):
        parser.error('XDG isolation is verified on Linux only; refusing to touch native user data elsewhere')
    if args.timeout <= 0:
        parser.error('--timeout must be positive')
    godot = args.godot or shutil.which('godot') or shutil.which('godot4')
    godot = shutil.which(godot) if godot else None
    if not godot:
        parser.error('Godot not found; pass --godot or set GODOT_BIN')
    tests = []
    for name in args.tests or sorted(p.name for p in PROJECT.glob('test_*.gd')):
        candidate = PROJECT / name
        if candidate.parent != PROJECT or not re.fullmatch(r'test_[A-Za-z0-9_]+\.gd', name) or not candidate.is_file():
            parser.error('Not a root test suite: ' + name)
        if name not in tests:
            tests.append(name)
    if not tests:
        parser.error('No test suites found')
    # Never overwrite prior evidence. Each child gets its own brand-new state.
    args.logs.mkdir(parents=True, exist_ok=False)
    failures = 0
    for test in tests:
        start = time.monotonic()
        with tempfile.TemporaryDirectory(prefix='neon-rush-test-') as isolated:
            env = os.environ.copy()
            for variable, child in [('XDG_DATA_HOME', 'data'), ('XDG_CONFIG_HOME', 'config'), ('XDG_CACHE_HOME', 'cache')]:
                directory = Path(isolated) / child
                directory.mkdir()
                env[variable] = str(directory)
            command = [godot, '--headless', '--path', str(PROJECT), '--script', 'res://' + test]
            try:
                result = subprocess.run(command, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                                        timeout=args.timeout, encoding='utf-8', errors='replace')
                output, code = result.stdout, result.returncode
                status = 'PASS' if code == 0 and not re.search(r'(?m)^(?:SCRIPT ERROR:|ERROR:|Parse Error:)', output) else 'FAIL'
            except subprocess.TimeoutExpired as exc:
                output = exc.stdout or b''
                if isinstance(output, bytes):
                    output = output.decode('utf-8', errors='replace')
                code, status = None, 'TIMEOUT'
            except OSError as exc:
                output, code, status = str(exc), None, 'LAUNCH ERROR'
            log = args.logs / (Path(test).stem + '.log')
            log.write_text(output, encoding='utf-8')
            failures += status != 'PASS'
            print(f'{status:12} {test} ({time.monotonic()-start:.2f}s, exit={code}) {log}', flush=True)
    print(f'{len(tests)-failures}/{len(tests)} passed; {failures} failed', flush=True)
    return int(failures > 0)


if __name__ == '__main__':
    sys.exit(main())
