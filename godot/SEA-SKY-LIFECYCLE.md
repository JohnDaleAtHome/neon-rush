# Sea sky lifecycle

Sea now reuses the Sky created by main for the current world, replacing only its material. Shader, camera uniforms, atmosphere and gameplay are unchanged.

## Evidence

- 40 isolated headless regression suites pass.
- Native Compatibility renderer sequential campaign: 8911 steps, zero deaths, all six worlds and reunion.
- Native shutdown warnings drop from four 349524-byte texture warnings to the two-warning baseline in both sequential world-switch and campaign harnesses. Those remaining warnings are unresolved, not a clean shutdown claim.
- 390x844 reduced-motion Sea captures before and after are pixel-identical; inspected side by side.
- An earlier attribution of the extra pair to Comet did not survive fresh repeat tests. Skipping Sea in the sequential matrix removed the extra pair, while skipping Comet did not. Removing Sea's second Sky or reusing main's Sky removed the pair. Replacing only the Sea shader did not.

No deployment, actual-device performance clearance, story, saves or collision changes.
