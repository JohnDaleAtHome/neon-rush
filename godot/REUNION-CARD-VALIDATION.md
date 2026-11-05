# Reunion still-life card, November 6 2026

The former reunion beat showed a full menu over an empty runway. This ending-only card gives the mooncake a readable illustration: original fluted pastry with a floral relief, plate and three cups of tea. It is a partial reunion illustration, not a depiction of Chang'e or Wu Gang. A stylized original flowering branch now gives the existing cinnamon-tree setting a visible cue. It is not an exact botanical model. Original story title and words are unchanged.

The original geometry is retained as text source in reunion-sourcepack/reunion_still.gd.txt. A fixed orthographic camera at (0,3.6,4), looking at(0,.45,0), size5.4, rendered to a transparent 720x520 viewport; directional light rotation (-55,-25,0), energy .65; ambient .3. The baked updated PNG is embedded in reunion_card.gd, decoded only when the ending first appears. Production adds no active 3D scene or viewport. No photograph, mould pattern or calligraphy was copied.

Cultural reference, not copied art:
- https://www.roots.gov.sg/ich-landing/ich/mid-autumn-festival : round mooncake, family harmony, tea and sharing.
- https://www.roots.gov.sg/Collection-Landing/listing/1618806 : Tai Thong wooden mould, actual scalloped cavities inspected.
- https://theburningkitchen.com/traditional-mooncake/ : actual photograph and maker's defined moulded relief/browned pastry guidance.
- https://omnivorescookbook.com/traditional-mooncake/ : raised pattern and baking contrast.

The ending calls the same completion/checkpoint code. New Journey invokes the existing action. Main Menu restores mode, sound, stats and settings access. Settings opens the existing popup above the card. Starting or showing another beat hides the card. Runtime gameplay and save schema are unchanged.

Verification:
- Dedicated native test: 390x844, 1280x800, 844x390, 320x568, both Light states and large-controls states with high contrast. Checks focus, 44+ logical-pixel buttons, bounds, settings popup ordering, menu and restart, one completion record, reset level/pieces.
- Campaign: 8,911 simulated steps, zero deaths, six worlds, reunion. Pause, ink/jade UI, browser save and preferences backup suites pass.
- Actual native and release-Web portrait/landscape/small-phone frames inspected. Initial release image failure caught: decoding was inside assert, which release removes. Decode is now unconditional.
- Browser ending fixture calls the real finish_story once; ordinary Settings/Close/New Journey interactions inspected. Fixture is separate from clean release and does not establish a natural browser campaign.
- Release fixture console/page errors absent after correction; QA global undefined. Prior blank-art screenshots are superseded.
- Clean release pack 7,325,056 bytes vs 7,284,568 bytes before: +40,488 bytes. The only new runtime render work is a static UI texture and text/buttons; no device-speed claim. Live runtime frame cost not benchmarked.
- No hosting update or actual-device clearance. Character art remains open.

## November6 branch-frame follow-through
Original asymmetrical branching cylinders, narrow leaves and small four-petal pale clusters, static baked with the table. No new asset license or live scene cost. Cultural context: https://www.vam.ac.uk/blog/imperial-chinese-robes-va/12-zodiac-animals-va and https://www.ihchina.cn/news_1_details/9811.html . Botanical shape reference: https://landscapeplants.oregonstate.edu/plants/osmanthus-fragrans and https://gardens.si.edu/collections/explore/object/ofeo-sg_2022-0695A . No reference image copied. Prior rejected Grove/tree model studies remain closed.

Actual native four-size and release-fixture Web390/844/320 pixels inspected, including Settings/Close/New Journey. No page errors, QA absent. Initial offscreen bake missed viewport update mode and then clipped the branch; both caught and corrected before this result. Four targeted native suites pass: reunion card, guardian feedback, campaign and preferences backup. Clean release PCK7,344,448 vs7,326,400 (+18,048 bytes). One temporary bake script was removed before final export. Clean release does not contain the completion fixture. This is partial story-art progress, not natural-browser campaign or device acceptance.
