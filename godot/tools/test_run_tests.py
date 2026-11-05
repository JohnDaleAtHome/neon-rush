#!/usr/bin/env python3
"""Standard-library tests for the runner, without requiring Godot."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest


class RunnerTests(unittest.TestCase):
    def test_isolation_failures_timeout_and_validation(self):
        with tempfile.TemporaryDirectory() as root:
            root = Path(root)
            (root / 'tools').mkdir()
            runner = root / 'tools/run_tests.py'
            shutil.copyfile(Path(__file__).with_name('run_tests.py'), runner)
            for name in ['a', 'b', 'error', 'fail', 'slow']:
                (root / ('test_' + name + '.gd')).touch()
            calls = root / 'calls.jsonl'
            fake = root / 'fake-godot'
            fake.write_text('''#!/usr/bin/env python3
import json, os, pathlib, sys, time
paths = [os.environ[k] for k in ['XDG_DATA_HOME', 'XDG_CONFIG_HOME', 'XDG_CACHE_HOME']]
assert all(pathlib.Path(p).is_dir() for p in paths)
assert not (pathlib.Path(paths[0]) / 'sentinel').exists()
(pathlib.Path(paths[0]) / 'sentinel').write_text('changed')
with open(os.environ['CALLS'], 'a') as f: f.write(json.dumps(paths)+'\\n')
suite = sys.argv[-1]
if 'error' in suite: print('SCRIPT ERROR: intentional fixture')
if 'fail' in suite: sys.exit(7)
if 'slow' in suite: time.sleep(10)
print('PASS fixture', flush=True)
''')
            fake.chmod(0o755)
            host = root / 'host'
            host.mkdir()
            (host / 'sentinel').write_text('preserve')
            env = dict(os.environ, CALLS=str(calls), XDG_DATA_HOME=str(host), XDG_CONFIG_HOME=str(host), XDG_CACHE_HOME=str(host))
            command = [sys.executable, str(runner), '--godot', str(fake)]
            def run(log, *tests, extra=()):
                return subprocess.run(command + ['--logs', str(root/log), *extra, *tests], env=env,
                                      stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, timeout=8)
            passed = run('passlogs', 'test_a.gd', 'test_b.gd', 'test_a.gd')
            self.assertEqual(passed.returncode, 0, passed.stdout)
            self.assertIn('2/2 passed', passed.stdout)
            self.assertEqual((host/'sentinel').read_text(), 'preserve')
            seen = [json.loads(line) for line in calls.read_text().splitlines()]
            self.assertEqual(len(seen), 2)
            self.assertNotEqual(seen[0], seen[1])
            self.assertTrue(all(not Path(p).exists() for row in seen for p in row))
            failed = run('badlogs', 'test_error.gd', 'test_fail.gd', 'test_slow.gd', 'test_b.gd', extra=('--timeout', '.25'))
            self.assertEqual(failed.returncode, 1, failed.stdout)
            self.assertIn('1/4 passed; 3 failed', failed.stdout)
            self.assertIn('TIMEOUT', failed.stdout)
            self.assertIn('SCRIPT ERROR', (root/'badlogs/test_error.log').read_text())
            count = len(calls.read_text().splitlines())
            self.assertEqual(run('invalid', '../test_a.gd').returncode, 2)
            self.assertEqual(run('passlogs', 'test_a.gd').returncode, 1)
            self.assertEqual(len(calls.read_text().splitlines()), count)
            self.assertFalse((root/'invalid').exists())


if __name__ == '__main__':
    unittest.main()
