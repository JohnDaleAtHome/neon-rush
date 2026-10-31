# Asset recovery contingency

This small source commit deliberately does not store binary assets in git. The complete source archive has them. To restore this checkout, run `python3 godot/fetch-assets.py` before opening Godot. The standard-library script downloads 28 assets from the companion staging site, validates exact byte lengths and SHA256 hashes, and writes only verified bytes. See assets-manifest.json.

This depends on the companion stage staying available. It is less durable than storing assets directly in git, and must not be described as a self-contained checkout. Binary assets should be added in later incremental commits when the upload route permits. No secrets or paid services are used. Story and requirements remain the repository's root documents.
