# Sea celestial framing study

2026-11-05, Godot 4.7.2. Source-only improvement, not a public deployment.

## Direction
The Sea used three large detailed moons and a star field. These dominated the
scene's identity. One small moon, no Sea star field and a quieter teal sky reduce
that space-like hierarchy. This is not yet a Chinese-style Sea redesign.

Research references, studied rather than copied into the game:
- HoYoverse art team, regional identity, landmarks and empty space:
  https://genshin.hoyoverse.com/en/news/detail/103681
- Red Candle producer, coherent myth/technology foundations:
  https://news.xbox.com/en-us/2024/09/27/nine-sols-how-we-brought-a-taopunk-world-to-life/
- Nine Sols publisher screenshots:
  https://store.steampowered.com/app/1809540/Nine_Sols/
- NetEase UX team, restrained form and interface:
  https://game.academy.163.com/course/careerArticle?course=698
- Realm of Ink developer interview, clear playable space and edges:
  https://rogueliker.com/realm-of-ink-interview/

## Scope
No props, meshes, borrowed imagery, water geometry, collision, gameplay,
story or save changes. Sea owns its moon layout through normal and Light mode.
Other worlds restore their own layouts. The stars toggle still hides moons.
Light mode retains its existing lightweight base terrain and does not receive
a new Chinese-style environment.

## Checks
- 41 regression suites pass, including four Sea layout sizes and transitions.
- Rendered Sea test passes. Old three-moon assertions now match the intended
  single-moon design. Sea also hides stars during apply_world, avoiding an
  intermediate star field before apply_options.
- Rendered campaign reaches reunion: 8,911 steps, zero deaths, all six worlds.
- Release Web: phone 390x844, desktop 1280x800, landscape 844x390, phone Light.
  Actual pixels inspected. Zero page errors; no QA bridge in release output.
- Baseline texture shutdown warnings remain. No device performance claim,
  no subjective fun acceptance and no public deployment clearance.
