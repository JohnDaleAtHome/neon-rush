# Grove story witness, November6,2026

The stopped firefly kindness beat now shows an original illustrated Wu Gang watching the rescue, with axe at rest. He matches the original generated man on the accepted reunion card, which was the sole generation image reference. No museum picture, third-party character model or closed worker/sage/hanfu model was reused. This is a static2D illustrated witness inside the3D encounter, not an animated/live3D NPC or new dialogue/reward mechanic. The old primitive firefly/vines and exact story words, HELP THE FIREFLY action, blossom reward, bridge order and saves are unchanged. No running scenery or hazard changed.

## Provenance and scope
- https://www.vam.ac.uk/blog/imperial-chinese-robes-va/12-zodiac-animals-va relates the rabbit, Chang'e and Wu Gang/cassia lunar tradition.
- https://www.ihchina.cn/news_1_details/9811.html describes the healing cassia and Wu Gang among variant lunar stories.
- https://www.philamuseum.org/objects/192790 records Qian Huian's1889Wu Gang. This painting was not copied or supplied to image generation; its image is not a game asset.
The game is an original retelling, not a costume or folklore reconstruction. Earlier model research/closures remain documented; no claim this sprite is an open-source3D model.

## Recovery and rendering
scripts/visuals/grove_witness.gd contains the exact384x562RGBA PNG as base64,65,731bytes. Decode occurs outside asserts, one shared cached ImageTexture, no runtime network or extra viewport. Sprite height2m at(.95,1,0) relative to existing KindnessActor; ordinary depth test/scissor alpha, not a fixed-size HUD overlay. Existing encounter centering/resizing moves the whole actor, and normal clear_encounter frees it before running/crossing resumes. It appears only in Grove's stopped beat, both Full and Light, never the turtle/shadow beat. No new collision or interaction node.

## Checks
Six isolated native suites pass: witness4sizes/bothqualities/otherbeats/resize/cleanup, kindness art, encounter layout, campaign, reunion card and preferences backup. Actual native390x844,1280x800,844x390,320x568 inspected. Initial QA omitted pending_advance and showed menu controls; fixed the fixture before judging art, no runtime menu change. Full scripted campaign8,911steps/zero deaths/all6worlds to reunion inspected at Grove beat. Release Webfixture advances through ordinary start/_process into the beat, then actual HELP click begins crossing and clears witness. Actual390Full/Light and844Full inspected, errors[]QAundefined. Not a natural whole browser campaign or device performance clearance.

Prior929efc1has52/52fresharchive suites; this change's coverage is targeted, not a newer full-suite claim. Existing native quit-time texture cleanup warnings remain. Public game unchanged, no deployment.

Godot sprite/material references: https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html and https://forum.godotengine.org/t/3d-models-into-billboards-sprites/98399 .
