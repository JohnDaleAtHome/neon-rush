"""Restore the byte-identical 256px CC0 bale texture before importing Godot."""
from pathlib import Path
import base64, hashlib
root=Path(__file__).resolve().parent
data=base64.b64decode((root/"hay.jpg.b64").read_text())
assert hashlib.sha256(data).hexdigest()=="a4ae49187d33e5c89a0747f48d9c32976503792fbe630784153605dad552a44a"
(root/"textures").mkdir(exist_ok=True)
(root/"textures/hay.jpg").write_bytes(data)
print("Restored verified Meadow bale texture")
