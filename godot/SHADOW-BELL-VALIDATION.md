# Shadow checkpoint silver bell
November 9, 2026. Source checkpoint, not deployed.

The original story uses the silver bell to accompany checkpoint retries. A heart-loss Story retry schedules bell.wav after its retry panel, but Shadow Comet capture showed the same silver-bell text without scheduling that sound. An isolated native baseline test confirmed heart-retry bell stream and zero shadow-retry audio players with sound enabled.

The patch adds the same existing sound("bell") call after the Shadow Comet retry panel. No new audio, story words, timing, difficulty, checkpoint, reward, save schema or visuals. Sound off still suppresses it.

All60 isolated native suites pass after test cleanup correctly waits for stopped audio playback to settle. The first test version passed functional assertions but failed the suite's existing resource-error gate on immediate shutdown; the test was corrected, not the runtime gate. Focused checks compare heart and shadow bell streams and preserve four pieces/level4, and confirm sound-off silence.

A separate release-Web fixture triggers Shadow capture from an actual keyboard gesture, reports one bell.wav player with playing=true, the expected retry panel and level4/fourpieces. Actual390px retry pixels inspected. Ordinary unseeded release390px start/jump also passed with no page errors and no exposed neonQA. Release PCK has195paths with no test/QA/fixture/oracle entries. This proves the playback request, not audible quality, physical-device behavior or natural campaign acceptance. Public game unchanged. This records pre-integration candidate evidence; recovered-source checks are separate.
