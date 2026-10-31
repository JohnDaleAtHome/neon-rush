# WIP reunion encounter cleanup

The final guardian hit previously opened the reunion text but left the guardian, shots and obstacles frozen behind it. Extract finish_story to record the completion, clear the active encounter/entities/guardian/gate/footprints and jump bookkeeping, reset the checkpoint, and then show the unchanged reunion words. Return from processing immediately, so the just-cleared projectile is not erased or queued twice. Main menu and ordinary run completion are unchanged.

Guardian regression now checks the final real projectile hit clears combat objects and flags, resets journey, and keeps the existing single New Journey action plus menu controls. Guardian/campaign/systems/review-fix tests pass, including8911-step deterministic campaign, zero retries. Actual seeded reunion release pixels inspected at390x819 and844x390, with no frozen combat objects. Fixture-only completion preview is not a natural playthrough, and this adds no final reunion character art.

Based on committed c99626bb2837. No hosting changes; frozen reviews and official game unchanged.
