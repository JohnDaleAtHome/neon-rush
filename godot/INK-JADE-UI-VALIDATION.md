# Quiet ink and jade UI - November 6, 2026

The interface now uses quiet jade fills, thin bronze edges, warm text and small corners instead of cyan glow. Story text, action labels, layout, touch controls, modes, saves and gameplay are unchanged. This is a supporting material treatment, not a historical-authenticity claim.

## Design research

The Shuyan interface designer's original portfolio, https://www.jliuwong.com/projects/shuyan/ , shows thin warm framing, quiet dark secondary buttons and pale dialogue. The reference was inspected visually. No reference artwork was copied. The industry interview https://www.zcool.com.cn/article/ZMTI0NjA5Mg==.html discusses consistent material language across the game interface. The artist study https://www.gameui.net/works/5108 also illustrates why gold and unrelated motifs alone do not make a coherent design. No paid kit or unrelated Japanese interface was treated as Chinese reference.

Godot uses native StyleBoxFlat resources: https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html . The existing moon-toggle silhouettes are retained with palette variants embedded as two tiny PNG byte strings in the theme, decoded once and cached. This keeps exact offline source recovery without changing the older visual sourcepack.

## Verification

- Actual native Sea story beat at 390x844, 1280x800 and 844x390 inspected. The action frame no longer glows or covers the story subject.
- Actual menu, settings, running Light/high-contrast/large controls and pause frames at those three sizes inspected. Old blue toggles were caught and replaced before acceptance. Final browser settings with embedded PNG variants inspected.
- `test_ink_jade_ui.gd`: four viewport sizes including 320x568, Light and high-contrast combinations, exact turtle choice and action signal, focus, unchanged 44px minimum logical target, text contrast at least 4.5:1 and action borders at least 3:1. PASS. These checks do not claim every pixel in every world is WCAG certified.
- Unchanged visual-integration and control-options tests pass. Campaign simulation: 8,911 steps, zero deaths, all six levels, reunion.
- Clean release Web menu/settings at three sizes: zero page errors; no QA bridge. This is not a full clean browser campaign or actual-phone performance test.
- Final private release PCK: 7,283,896 bytes versus 7,279,032 previously (+4,864). No timing or device-performance conclusion from size.
- Native renderer shutdown texture warnings persist from the baseline.

Accessibility references: https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html and https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html .

No public deployment in this change.
