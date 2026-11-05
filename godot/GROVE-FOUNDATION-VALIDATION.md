# Cinnamon Grove pavilion foundation

Source preparation, November 5, 2026. Not a public deployment or actual-device performance approval.

## Change
The previous 11.2m square podium had a fixed bottom at -0.2m. The underlying bank ranges from -0.3557112 to -0.0237312m across 1,681 samples, leaving a gap up to 0.1557112m. Retain the pavilion transform, podium top y=0.2m and its footprint. Replace the podium with path-matched paving and 48 stone skirt segments whose bottom endpoints extend 0.12m below the terrain. The existing pavilion overhang beyond the podium is unchanged.

No new asset or external dependency. Uses the existing CC0 nature stone texture and Grove path shader. The existing CC0 pavilion source is https://vvaytoyek.itch.io/chinese-four-corner-pavilion-free . Trees, understory, camera, story actors, lanes, hazards and saves are unchanged. This is a small contact/material repair, not a complete Grove redesign.

## Verification
- Native phone 390x844, desktop 1280x800 and compact 844x390 frames inspected.
- Web release phone/desktop/compact plus phone Light inspected, zero page errors. Light retains the existing fallback.
- Grove visual, visual integration, encounter layout and full campaign suites passed. Full campaign: 8,911 steps, zero deaths, all six worlds and reunion.
- Targeted Grove story at all three aspects: 1,863 steps, zero deaths each, Cinnamon Blossom and transition to Sea. Story beat and crossing pixels inspected.
- Regression checks: 288 skirt vertices, lane margin, finite noncolliding geometry, exact top and footprint, Light/world ownership. An additional 1,008 between-endpoint samples have minimum burial 0.117893m. All 1,681 footprint terrain samples remain below the top.
- Software-rendered phone A1/B1/A2/B2 mean frame times: 82.1944/80.6400/79.6760/77.5502ms. Not a speedup claim or a substitute for a real device. Draw calls 106 to 107, primitives 71,236 to 71,322.
- Matched clean Web exports without local QA scripts: PCK 7,188,016 to 7,188,864 bytes (+848). No new texture.
- Known native texture-release warnings at shutdown remain; no claim of an error-free engine log.

Public hosted game unchanged. The visual difference is subtle at gameplay scale, strongest in the phone view. Prior rejected Grove canopy and layout studies are not included.
