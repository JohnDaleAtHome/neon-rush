# Eclipse Guardian face, November 6, 2026

Original generated static frontal mask replaces the four primitive horn/eye children of the existing sphere. It is fictional game art, not an external open-source model, a named deity, or a reconstruction of a taotie. No museum image was copied or supplied to generation. Broad paired eyes, bilateral facial layout and bronze-like framing were informed by primary collection descriptions:
- https://www.britishmuseum.org/collection/term/x114735
- https://www.brooklynmuseum.org/objects/213207
- https://asia-archive.si.edu/exhibition/key-themes/

The historical meaning is uncertain. These references do not imply that the Eclipse Guardian is a historical figure. A3.8k untextured model lead at https://sketchfab.com/3d-models/taotie-mask-download-52e12d98c9e045479c1ae0943b032407 had no readable license in fetched content and was not adopted. The CC0 Smithsonian3D ritual vessel at https://www.si.edu/object/3d/ritual-wine-ewer-gong-masks-taotie-dragons-and-real-animals:d8c646aa-4ebc-11ea-b77f-2e728ce88125 is the wrong object/shape and was not downloaded. Prior block-lion/Bixie scenery studies remain closed.

## Runtime and recovery
scripts/visuals/eclipse_mask.gd contains the exact256x243 RGBA PNG as base64. Decode into one shared cached ImageTexture, no runtime network, no extra viewport or live model. Sprite width1.8m stays within the original1.8m core/2.32m ring. Position, sphere radius, aim comparison, ring geometry, movement, HP4,2-hit windows and progression are unchanged. Purple/green/amber modulation supplements the unchanged ring and text, not replaces them. Sprite uses normal depth testing, no fixed-size screen overlay. The module is the complete art recovery source.

## Checks
-5 isolated native suites pass: new mask4sizes/both quality/state/shared texture/envelope, guardian feedback, campaign, reunion card, preferences backup.
- Actual native3aspects x3states inspected. Scripted Full campaign8,911steps/zero deaths/all6worlds to reunion, Palace actual frame inspected. Earlier accepted be89838 source had51/51 fresh archive suites; this change is targeted coverage, not a new whole-suite claim.
- Release Web fixture invokes ordinary Palace start, then runs normal frame processing. Actual390x844 Full/Light and844x390 Full inspected, closed/open and fire/miss cues. No page/script errors, no QA hook. This is not a natural browser campaign. No actual-device performance clearance.
- First private release export exposed an assert-side-effect PNG decode bug. Decode moved outside assert, corrected exports rerun, errors empty. Scratch imported PNG removed before final clean export. No claim of fixing unrelated existing quit-time texture cleanup warnings.
- Public game unchanged. No deployment or device approval.

Technical references: https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html and https://forum.godotengine.org/t/3d-models-into-billboards-sprites/98399 .
