from pathlib import Path
import base64, hashlib
root = Path(__file__).resolve().parent
raw = base64.b64decode((root / "turtle.glb.b64").read_text())
assert hashlib.sha256(raw).hexdigest() == "0a50b7759c95582fe0217b260f77b16eca1a6a3d6b8e4f89eaccabbee3fa28a0"
(root / "turtle.glb").write_bytes(raw)
print("Restored verified CC0 turtle GLB")
