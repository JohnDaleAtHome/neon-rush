# Run score feedback parity

Chill/Classic/Rush/Chase award15points for a close grounded dodge of a tall hazard. It must have been seen within1.0-1.8m horizontal distance near the player, then pass safely. Each hazard pays once, not during damage protection. Story/Mission excluded, matching legacy scope.

Near miss and successful jump show brief point feedback. Endless/chase HUD shows250m+10treat goal progress or GOAL COMPLETE. End-of-run summary separates distance, treats, chain, jump and near-miss points.

Unit test covers close/far dodge, once-only award, exact score split and goal completion. History/jump/pause/migration/guardian/review/campaign/systems regressions pass. Actual390x844 local browser fixtures show near miss/goal HUD and exact200point breakdown, pixels inspected, no errors. These are controlled fixtures, not naturally earned scores. Temporary fixture scripts removed and production scene restored. No public deployment.
