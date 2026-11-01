# Visual implementation plan

## Scope and baseline

Approved by Vic on 1 November 2026 at 07:23 SGT: record the visual priorities in game requirements, create an implementation document and work on them in parallel. This is a new bounded implementation phase after the 07:19:49 sprint endpoint. There is no new recurring cadence or invented deadline.

Source baseline: `f9d4537442b68f168bdc400fda25cc24ac8f9c01` (v33). Public review remains v29, source `1612c7fd269d19db4e0685b7d16c7de49ef3b06c`. The v30-33 diff fixes stats/CSV/retry inputs and documentation, not the visual direction. Official legacy and frozen builds stay unchanged.

The concept is the tracked `docs/concept-art/mochi-main-character.webp`, not a newly inferred reference. GAME-REQUIREMENTS.md owns the approved outcomes; STORYLINE.md remains story canon. PORT-STATUS.md retains unfinished gameplay, art and natural/device acceptance gaps.

## Parallel lanes and safe integration

These are integration boundaries, not claims that the work is finished. Workers return focused patches and their evidence. The integration owner applies them serially against a known commit and owns shared `godot/scripts/main.gd` and project settings. Do not replace main.gd from stale copies.

| Lane | Owned new paths | Required outcome |
| --- | --- | --- |
| Character | `godot/scripts/visuals/mochi_visual.gd`, `godot/assets/visuals/mochi/` | Recognizable silhouette, eyes, clothing and pendant; soft material response; moving character readable at gameplay scale. |
| Meadow world | `godot/scripts/visuals/meadow_visual.gd`, `godot/assets/visuals/meadow/` | Calm path, shaped/varied surroundings, coherent horizon/sky/fog/moons and soft grounding shadow, without hiding hazards. |
| HUD | `godot/scripts/visuals/hud_theme.gd`, `godot/assets/visuals/ui/` | Consistent theme and clearer hierarchy, short instructions, large controls, readable portrait/landscape and keyboard/touch states. |
| Integration and docs | Shared script/project hooks, requirements, plan, status and tests | Preserve gameplay/save contracts and combine the lanes into one reviewable release build. |

Coordinate proposed API/signature changes before applying them. New modules should be self-contained and document the minimal integration calls. If a worker must touch another lane, return that change as an explicitly separate integration hunk. Existing rabbit remains available until the replacement can run and animate correctly; preserving a fallback is not final-art acceptance.

## Work order

1. Freeze the baseline and record concept/current-game evidence. Update requirements and this plan before implementation integration.
2. Build character, Meadow/atmosphere and HUD in parallel within their paths. Report missing asset/tool limits early; do not substitute a tint for character work or claim full concept fidelity from a primitive sketch.
3. Integrate small changes in a clean working copy. Keep physics/collision, level timing, pickups, checkpoint schema, stats and controls unchanged unless a separately demonstrated defect requires a scoped fix.
4. Render one ordinary-input Meadow session on portrait mobile and desktop, plus pause/menu and a visible hazard/pickup encounter. Inspect actual pixels. Label fixtures and emulation as such.
5. Correct integration issues, then export a source-exact release Web review artifact with commit, asset provenance and test evidence. Do not overwrite immutable v29 or official legacy.
6. Obtain visual feedback on the integrated Meadow look before treating it as the style to propagate. Carry approved principles through distinct level environments; assess NPC/guardian/reunion presentation separately.

## Acceptance gates

### Character
- At gameplay size, the face/ears, cyan eyes, jacket and moon pendant read as Mochi from the tracked concept rather than the old generic rabbit.
- Soft white material, dark costume and restrained neon accents remain readable against Meadow. Avoid a metallic toy finish or glow that obscures the silhouette.
- Running/jumping/ducking and lane movement remain clear. Grounding shadow follows the intended contact point and does not become a floating decal.

### World and atmosphere
- The road is quieter than hazards/pickups; lane boundaries remain clear.
- Side terrain has shaped silhouettes and variation without the current dark blotches or obvious rows of identical cards.
- Horizon, fog and sky blend into a coherent scene; moons read within that scene rather than detached stickers.
- Test the Web Compatibility renderer. Do not rely on unsupported effects or claim physical-device performance from desktop emulation.

### HUD
- Portrait and landscape keep scene/runner clear, text legible and touch targets usable.
- Start, pause/resume, settings, control visibility/size and story instructions retain their meanings.
- The interface has one coherent palette/type/spacing/button language. Reduced-motion and accessibility preferences still work.

### Integration and evidence
- Existing 26 committed suites are the regression baseline. Run relevant focused tests during each change and the complete set for the integrated release; report failures rather than hiding them behind screenshots.
- Clean import and release Web export succeed. Release exposes no debug QA state. Check browser errors and actual interaction, not only export exit status.
- Capture ordinary-input mobile-size and desktop gameplay evidence, and label controlled visual fixtures separately. Natural L5 completion/L6/guardian/reunion remain open until actually played.
- Human art feedback, audio listening, fun and physical-device performance are separate gates. No automated or screenshot-only pass settles them.

## Delivery and limits

Return source patches/commits, asset licenses/provenance, inspected screenshots and a source-exact review build. Main coordinates commits, review publication and user summaries. No paid work, recurring wake loop, official replacement, gameplay rebalance or full-campaign completion claim is implied by this phase.

Status at plan creation: requirements and plan prepared; parallel lanes being assigned; implementation not yet integrated. Preserve subsequent evidence in a dated progress section rather than retroactively treating this plan as a completion report.

## Integrated checkpoint - 1 November 2026

Character, Meadow and HUD modules are now combined for review. Shared integration
also fixes Light-quality transitions, opaque popup panels and Meadow-only
exposure. The ground underlay uses the bank shader to avoid a diagonal colour
wedge. See `godot/VISUAL-CHECKPOINT.md` for scope and remaining gates. This does
not approve concept fidelity or propagation to other levels. Runtime review
provenance and exact regression results accompany the source-exact build.

## Mochi geometry cleanup - 1 November 2026

After the reproducible v34 checkpoint, direct mesh inspection found reversed
pupil winding and mistakenly deleted inner-ear components. v35 corrects both,
removes misplaced collar/hem rings, builds a genuine side-opening crescent,
separates pink nose/dark mouth/white belly from tintable ears, exposes turquoise
irises, adds cheek/forelock tufts and replaces the lathe bib with a clipped
short open jacket following the existing rig. All 14 animations remain.
This is a low-poly concept-directed draft, not final character approval.
The current Meadow/horizon and full-game acceptance gaps remain unchanged.

## Meadow geometry increment - 1 November 2026

The post-v35 local candidate replaces tiny berms/flat ridge quads with rolling bank meshes, overlapping 3D hills, groves and fern clusters. World-space bank color removes broad texture-induced diagonal bands. Bank edges taper to the underlay; terrain-bound props track the shaped bank while scrolling. Original side planes restore in Light mode and other themes. No gameplay/main-script changes are part of this increment. All 28 suites pass, with actual portrait/desktop scrolling and hazard/dew pixels inspected. See `godot/MEADOW-VISUAL.md` for exact evidence and remaining horizon, art and device gaps. This is an incremental WIP checkpoint, not concept fidelity or campaign art acceptance.


## Solid Meadow foliage increment - 1 November 2026

After v36,the34flat plant cards are replaced by single-mesh solid flower/reed clumps with stems/leaves and vertex colors. No new binary assets or shared gameplay code change. Path nonlinear fog/fade is calculated per fragment rather than per vertex. Expanded integration and all28suites pass;actual portrait/desktop scrolling,duck and bale/dew pixels inspected. The path still has a tonal seam and the distant horizon remains a strip. This is incremental WIP,not landscape-art approval or physical-device acceptance.


## v39 character expression/proportion checkpoint (WIP)
The generator now replaces the pinched V-shaped mouth with a small curved smile,
reduces eye projection/width, shortens ear root scales and reduces lower-arm
branches uniformly to0.78. Finger descendants follow those branch transforms.
All14animation channels and inverse bind matrices are unchanged; four named
rest-node scales intentionally differ, so original node JSON equality is no
longer claimed. This is exploratory concept-directed work, not accepted final
art. Bulky fingers, simple fur, jacket detail and round eye forms remain.
42native snapshots sample14animations at10/50/90percent; native fixtures do not
replace actual gameplay, natural campaign, physical-device or human acceptance.


## v40 white-fur/cuff WIP
Runtime main/belly fur albedo is a lighter cool white instead of blue-grey.
Dark wrist cuffs with narrow magenta piping are clipped from the forearm mesh
and preserve its skin weights, rather than floating rigid rings. This is a
small costume increment, not final concept fidelity; fingers, eyes, silhouette,
fur surface and most costume details remain simplified. No mechanic changes.


## v41 batched character refinement (WIP)
Layered shorter cheek tufts and a swept forelock replace the large three-spike
cheeks; lower-arm root scale is now0.69/0.73/0.69, with descendant fingers and
cuffs following the rig. Smaller pink nose, smaller jade-green crescent with
less emission, cyan boot edge/ankle strips and a narrow magenta jacket hem
bring the palette/costume closer to the tracked concept. Animation channels,
inverse binds and hierarchy remain original. Eye recess experiments were
rejected after three-quarter pixels showed face occlusion; retained eye
geometry remains v39/v40. This is still a generic low-poly approximation,
not final fur/costume, swept-ear silhouette, or accepted concept fidelity.


## v42 Meadow foliage/atmosphere batch (WIP)
Branched trees use overlapping varied crowns rather than three tall blobs.
Paired leaflets replace the nine angular fern blades;48ferns total51,840
vertices. A shared opaque foliage shader adds restrained wind and the same
fragment-depth fog ramp as the banks to flowers/ferns/tree crowns. Scene prop
counts/scroll wrapping, bank height following, light-mode cleanup and other
themes stay unchanged. This is stylized procedural WIP, not final landscape
art: the distant tonal horizon strip, simple trunks, detached moons and
limited ground cover remain. No gameplay, character, asset binary or deploy
changes. Real-device performance and natural campaign/art acceptance remain
open; desktop/mobile browser fixtures are only visual/regression evidence.


## v43 Meadow ground cover and atmosphere batch (WIP)
Short grass fans surround the48fern meshes without adding props/draw calls;
each combined fern/grass mesh is1404vertices,67,392total. Grass x positions
stay outside4.25world units from the lane center. An opaque vertex-color tag
lets the foliage shader reanchor grass to the bank at its current world
position, including scroll/wrap, rather than baking one terrain height.
Banks use a slightly lighter varied green palette. Meadow-only moon material
reduces relief/contrast with teal haze and lower glow; the established three
moon layout and Show moons option remain. A separate Meadow sky shader adds
very quiet broken wisps while retaining the gradient and objective legibility.
Main gameplay, character, binaries, sourcepack and other themes are unchanged.
Light-mode/other-theme cleanup retains the base moon shader.

Actual release390duck/1280scroll pixels were inspected after correcting grass
that initially intruded into the corridor. All28headless suites, clean import
and Web export pass; browser reported0pageerrors and QAundefined. These are
regression/visual fixtures, not natural-campaign or physical-device acceptance.
Still procedural WIP: grass looks angular, horizon has a tonal strip, moons
are less stark but remain detached, and final landscape/character art fidelity
is not accepted. No deployment or final-art acceptance is implied.
