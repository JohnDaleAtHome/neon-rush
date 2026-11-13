# Offline baseline recovery validation

November 13, 2026 source checkpoint: `d3fc22e8f453274588128c425181f1540f784847`.

## Scope

The 28 original baseline assets now restore from a tracked offline sourcepack before the existing manifest check. This removes the normal bootstrap's staging-download dependency without changing gameplay, runtime scripts, asset content or saves. The original manifest URLs are retained as provenance. The Web preset explicitly excludes baseline-sourcepack metadata.

The pack contains 38 text chunks, 9,037,256 base64 characters encoding 6,777,940 compressed bytes. Rebuilding the pack independently from exact cached baseline files reproduced every chunk and all index metadata. Asset size before packing is 7,108,084 bytes. The helper validates ordered chunk hashes, aggregate hash, manifest hash, decoded size, exact file set, file lengths and asset SHA256 before writing anything. It rejects duplicate JSON keys, unsafe paths and symlink destinations, and limits decoding/decompression sizes.

## Committed-source checks

- An untouched archive of the checkpoint, initially without binary assets, completed the entire documented asset bootstrap with socket creation and connection disabled. Zero network attempts occurred.
- All 43 changed repository paths exactly matched the tested candidate, including the 39 pack paths, helper, format/license note, bootstrap and export preset.
- Clean Godot 4.7.2 import passed.
- All 73 isolated native suites passed in separate 37 and 36 suite batches.
- Web release export passed. The resulting PCK contained 212 resources and 7,739,692 resource bytes. Every payload MD5 matched its directory entry. No baseline sourcepack, tests, QA or fixtures were included. Clean imports may vary imported binary sizes; this is not a deterministic-pack claim.
- The committed helper passed 23 independent positive/negative cases: empty restore, byte/mtime idempotence, missing/changed/extra chunks, manifest/aggregate corruption, invalid limits, chunk-name traversal, duplicate metadata/payload keys, six unsafe path forms, extra payload files, corrupt asset, destination/temp symlinks and a late non-file destination. Rejected cases were checked for no asset writes.

## Limits

This is source recovery and release-resource validation, not a new visual or natural-play result. There is no public deployment, actual-device performance, other-browser, listening, human-balance or full-natural-campaign clearance. Godot and export templates remain separate installed prerequisites. Per-file replacement is not a transaction across all assets, crash durability or a defense against concurrent filesystem changes. Stop the bootstrap on any error; do not run concurrent restores against one checkout.
