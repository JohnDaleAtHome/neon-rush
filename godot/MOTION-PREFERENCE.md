# System motion preference

New users default to the browser's prefers-reduced-motion setting. Settings offers System/Full/Reduced. Explicit old-engine and legacy boolean choices remain overrides. System is rechecked when applying settings or returning focus. Gameplay physics and timing are unchanged; reduced motion limits optional scenery/animation movement.

The browser path stores this choice in a separate same-origin localStorage key in addition to engine settings. Browser testing found engine-only writes of this new choice did not survive immediate reload reliably; the synchronous backup now passes actual selection/reload under an emulated reduced-motion browser. Original legacy options remain untouched. Other setting persistence deserves a separate reload audit; this patch does not claim to fix all storage paths.

Headless motion/system/migration/mode/campaign regressions pass. Browser emulated reduce and no-preference resolve correctly; visible dropdown Full override stays Full after reload despite reduce OS setting.390x844 actual settings/dropdown/full pixels inspected. No public deployment.
