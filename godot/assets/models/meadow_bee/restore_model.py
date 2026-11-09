"""Restore the byte-identical CC0 Meadow bee model before Godot import."""
from pathlib import Path
import base64, hashlib
root = Path(__file__).resolve().parent
raw = base64.b64decode((root / "bee.glb.b64").read_text(), validate=False)
if len(raw) != 57672 or hashlib.sha256(raw).hexdigest() != "0687a865029fad29678759bff04b53a8db70cb95f69835bf8e94a3e2273a1d56":
    raise ValueError("Meadow bee model validation failed; no file written")
(root / "bee.glb").write_bytes(raw)
print("Restored verified CC0 Meadow bee GLB")
