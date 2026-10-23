# Glass policy

macOS 27 draws the system's chrome in Liquid Glass: toolbar platters, sidebars, popovers,
menus and the floating controls over content. Lumen's §1 separates behavior (must match macOS)
from look (Lumen's). Glass is both: a look, and a system behavior that reacts to Reduce
Transparency, Increase Contrast and, on 27, the user's transparency slider. This document is the
policy for it. PRINCIPLES §11 is its summary; the chrome policy was decided on 2026-10-19.

## The decision in one paragraph

The drawn chrome is the reference and the default. A Lumen app may opt into system glass for its
navigation layer, and only there, through one switch (`LumenChromeStyle.glass`). Content never
uses glass. Both styles use the same tokens, metrics, keyboard behavior, focus and selection, so a
theme and a component never know which one is drawing. Contrast is measured against the opaque
fallback, so the blur can add legibility but never supply it.

## Two layers

| Layer | Surfaces | Glass? |
|---|---|---|
| Navigation | The window toolbar's background (the system platter under toolbar items), the unified top bar's band, the sidebar edge, floating palettes (the ⌘K command palette, the input palette), popovers | May use system glass under `.glass` |
| Content | Lists, source lists and sidebar rows, tables, cards and tiles, editors and code views, inspectors, sheets and their bodies, settings panes, status bars, banners, menus (the command menu, context menus, pop-ups) | Never |

The content layer needs a stable, measured ground: the contrast rules (§2, §3) are checked
against tokens, and a surface that changes with what scrolls under it or with a slider cannot be
checked. Menus are dense text over a list: glass under them is glass under content.

## Rules

1. **No glass on glass.** One glass surface at a time along any line of sight. A popover over a
   glass toolbar is the system's popover; a palette over a glass toolbar is one glass sheet with
   opaque rows inside it. Lumen never applies `glassEffect` to a view that sits inside a surface
   that already has it, and never stacks `GlassEffectContainer`s.
2. **Tint only primary actions.** Glass carries the palette's foreground (`fg.*` on
   `toolbar.background`'s role); `.tint(palette.accent)` goes on the one primary action in a bar
   or palette, as it does in `.drawn`. Interactive, tinted glass on `.lumenPrimary` is C8 and sits
   under this rule.
3. **Contrast is measured against the opaque fallback.** Every foreground on a glass surface meets
   its contrast rule against the token the drawn chrome paints there: `toolbar.background` for the
   toolbar band, `menu.background` for the palette, `sidebar.background` for the sidebar edge. The
   validator and the conformance checks keep running on the drawn chrome, which is what the glass
   degrades to; nothing may rely on the blur, so Reduce Transparency, Increase Contrast and the
   27 slider can only make a surface more readable.
4. **The drawn chrome stays the reference.** `.drawn` is the default through 0.x (roadmap D1).
   The goldens, the validator and every Catalog page are recorded in it; `.glass` gets its own
   goldens for a bounded subset (the surfaces in the navigation row above) on the OS of record
   (macOS 27, D5), recorded through a real window because offscreen renders have no backdrop.
5. **Degrade, never break.** `.glass` draws as `.drawn` when Reduce Transparency
   is on, and in offscreen renders (`ImageRenderer` and the goldens' image renderer). The
   resolution happens once, in the environment, so every surface in a window agrees.
6. **Nothing else changes.** Tokens, metrics, density, keyboard behavior, focus rings, selection
   looks (§10), the title bar's hierarchy and the toolbar's priorities are identical in both
   styles. A theme has no glass keys; a component reads the resolved style only to pick its
   ground.

## The switch

```swift
public enum LumenChromeStyle: String, CaseIterable, Identifiable, Sendable {
    case drawn   // Lumen paints every ground (the default)
    case glass   // the navigation layer uses system glass on macOS 27 and later
}
```

- `LumenStoreConfiguration.chromeStyle` sets an app's style; it defaults to `.drawn`, so every
  existing client renders unchanged. The initializer that takes `chromeStyle:` is a second one;
  the original keeps its signature.
- `.lumenChromeStyle(_:)` overrides the store's style for a subtree: one window, a preview, a
  golden. It is an environment override, not a second store.
- `\.lumenChromeStyle` is what was asked for; `\.lumenResolvedChromeStyle` is what draws. A
  surface in the navigation layer reads the resolved value and picks its ground; it never reads
  `#available` or Reduce Transparency itself. `LumenChromeStyle.systemSupportsGlass` answers the
  capability for code outside a view; it is always true on supported systems.
- Changing the style at run time (the Catalog's toggle) must not reset view state: the surfaces
  switch grounds inside `.background {}` and `.overlay {}` closures and value-based modifiers, never
  by branching around their content.

## What each surface draws

| Surface | `.drawn` | `.glass` (macOS 27 and later) |
|---|---|---|
| Window toolbar (`lumenWindowChrome`) | The title bar's gradient while the window is key (`titlebar.activeTop` to `titlebar.activeBottom`), `toolbar.background` when inactive; toolbar items sit on the band with the system platter hidden (`ToolbarContent.lumenToolbarPlatter(_:)` on each item, which `LumenTopBar` applies and an app's own `.toolbar` items adopt); `.lumenSidebarToggle(columnVisibility:)` on a `NavigationSplitView` sidebar replaces the system toggle with a bare outline button matching the inspector toggle | The system platter shows under controls; direct `ToolbarItem` identities stay bare in both styles (the specialized `lumenToolbarPlatter` overload); `.lumenSidebarToggle(columnVisibility:)` keeps the system sidebar toggle; the band is flat `toolbar.background` in both window states, so the gradient never sits under glass |
| Unified top bar (`LumenTitlebarBackground`, hidden title bar) | The same band, drawn by Lumen | Flat `toolbar.background`; the items are Lumen's controls, which draw no glass of their own |
| Command palette (⌘K) | `menu.background` in a `radius.xl` continuous rect, a `border.default` hairline, the popover elevation and an 8 % scrim | `glassEffect(.regular)` in the same shape; no hairline (the glass draws its own rim); the same elevation, scrim, rows, row highlight and keycaps. Nothing inside paints a flat band over the glass: the scope track is a `menu.separator` hairline capsule with no fill, and the footer has no fill in either style; grouping comes from hairlines, spacing and the controls |
| Popovers (`lumenPopover`, `LumenPopoverContent`) | The system popover's material; Lumen draws the content | Unchanged: on 26 and later the system popover is already glass, and rule 1 says Lumen adds none |
| Command menu, context menus, pop-ups | `menu.background`, opaque | Unchanged (content layer) |
| Sidebar (`lumenSidebarBackground`, `lumenSidebarColumn`) | `sidebar.background` | Unchanged in C1; the edge-to-edge treatment and what the sidebar's edge does under a glass toolbar are C3 |
| Everything in the content layer | Tokens | Unchanged, always |

## Receipts

- Goldens: the existing set stays in `.drawn` and is not re-recorded for this policy. The `.glass`
  set is `unified-top-bar-glass` in `Tests/LumenUITests/Goldens`, recorded with the window renderer
  on macOS 27 and skipped under Reduce Transparency. A golden only goes in when the
  capture holds the `.glass` look: the window renderer (`cacheDisplay`) draws no system glass, so
  the command palette has no `.glass` golden; the Catalog is its receipt.
- Conformance: `LumenChromeStyleTests` checks the resolution rules (default `.drawn`, `.glass`
  degrades under Reduce Transparency and offscreen), runs `backlight` on the top bar and
  the palette under `.glass`, and runs `surfaceSteps` on the top bar under `.glass` and on the
  palette's opaque fallback, which is what rule 3 measures against (the capture can't see the
  palette's glass, so a `.glass` scan would report steps over the bare window background).
- The Catalog: the Glass toggle in the main window's toolbar switches every open window;
  `LUMEN_CATALOG_CHROME=glass|drawn` sets it for one launch (never saved). Both styles must show no
  conformance findings on macOS 27 (the M1 exit test).
- The SDK stamp: AppKit picks the macOS 26 design (toolbar platters, glass) by the SDK a binary
  was linked against. The first M1 exit run on 27.2 showed no platters in either style because
  `swift build` stamped the Catalog `minos 14.0 sdk 14.0`: the Swift 6.4.2 driver hands ld
  `-platform_version macos 14.0.0 14.0.0` although the sysroot is MacOSX27.2.sdk. The test host is
  stamped by Xcode (sdk 27.0), so goldens were unaffected. `Scripts/install-catalog.sh`
  restamps the SDK with `xcrun vtool -set-build-version macos 14.0
  <xcrun --show-sdk-version> -replace` before bundling (checked once with `otool -l`: minos 14.0,
  sdk 27.2). Package.swift gets no unsafeFlags, so apps can still depend on Lumen; an app built
  the same way should check its own stamp. The macOS 27 floor supersedes that minimum: both packaging scripts now stamp minos 27.0 and
  the selected SDK. The older stamp above is retained as the historical receipt.

- The palette's interior (chrome fix, 2026-10-19): the M1 exit screenshots on 27.2 showed the
  scope track (`bg.insetRaised` at 60 %) as an opaque band across the glass. Under `.glass` it is
  now a hairline capsule with no fill; `.drawn` is unchanged. The footer already drew no fill: the
  darker band under it in the screenshot is the window behind the glass. No golden changed: the
  palette has no `.glass` golden, and offscreen renders draw `.drawn`.
- Excluded scan finding: `surfaceSteps` on the `.drawn` palette at Midnight dark reports steps at
  x = 16 and 32 pt (33 in one render), 14 pt tall. They are the 18 pt row tiles' plates, 59 from `menu.background`,
  just inside the scan's 60 content cutoff; a tile is content, not a ground. Left as is (no
  retinted theme, no wider thresholds); the reason is in `surfaceSteps`' doc comment. The `.glass`
  palette scans' steps are the bare-window artifact described above.
- Excluded exit-test finding: the exit pass's `overflow` check on the palette measures the
  snapshot initializer's palette, which lays out every result row without a scroll view (30
  commands stand 1085 pt tall and overflow 580×420 and 580×560 whatever the window offers). The
  palette never presents that way: the interactive palette caps its list at 380 pt and shrinks to
  what it's offered, and `LumenCommandPaletteTests.testPaletteMeasuresAsTallAsItDraws` is its
  receipt. The pass counts these findings as excluded until it builds the interactive palette for
  that check (exclusion confirmed by the maintainer, 2026-10-19).
- M1 exit test on 27.2, run 2 (2026-10-19, the Catalog restamped sdk 27.2): 364
  checks, 29 raw findings, every one documented above (4 palette overflow, 2 Midnight tile plates,
  23 `.glass` bare-window steps), net 0 in both styles: the exit test passes on 27.2. On screen: `.drawn` items bare on the band,
  `.glass` platters showing, the scope track a hairline under glass, the status item present. Two
  system-owned buttons keep a round platter in `.drawn`, the split view's sidebar toggle and the
  toolbar's » overflow button, which `lumenToolbarPlatter` can't reach; whether `.drawn` should
  replace the system toggle (`.toolbar(removing: .sidebarToggle)` plus `LumenPanelToggle`) is C4's
  call. The maintainer decided on 2026-10-22: `.drawn` replaces it with `LumenPanelToggle`, `.glass` keeps the
  system toggle, and C4 fixes the default-width overflow; the hairline scope track and the Midnight
  tile-plate exclusion are confirmed. The macOS 27 floor retires the pending macOS 26 run.

- C4 partial (2026-10-22): the shared sidebar modifier uses the split view's column-visibility binding and swaps toolbar items without replacing the content subtree. Native sidebar menu actions remain available. The Catalog uses `LumenToolbarStatus(_:minWidth:)`: the full label and percentage set its natural width, and measured native item allocations limit it to the available room before middle truncation. Its 180 pt floor preserves native overflow. The deprecated `idealWidth:` overload forwards to this content-sizing behavior. Its navigation placement follows the identity, avoiding the independent principal-item centering constraint. The shared sidebar modifier positions its outline button before the native sidebar tracking separator. Narrow-window overflow remains system-owned. Fixed-width status initializers and existing golden subjects are unchanged.

## What later items add, and what this policy fixes for them

- C2 (corners): a glass palette keeps `radius.xl`; if 27's concentric corners change the window
  radius, the palette's radius is still a metric, not a glass property.
- C3 (sidebars to the window edges): decides the sidebar edge under a glass toolbar. The content
  of the sidebar (rows, selection) stays content and stays opaque whatever C3 decides.
- C4 (toolbar priorities, scroll edges): `scrollEdgeEffectStyle` is set per style; under `.glass`
  the system's soft edge is allowed on the navigation layer, under `.drawn` Lumen keeps its hard
  edge. The overflow menu is a menu: content, opaque.
- C5 (window activity): `.glass` already drops the active gradient, so the inactive-window golden
  variant for `.glass` is the same band; only `.drawn` has an active and an inactive look.
- C8 (interactive glass): rule 2. `.lumenPrimary` may take `Glass.regular.interactive()` under
  `.glass` only, off under Reduce Motion.
- A2 (scoped stores): the style lives on the store's configuration and resolves through the
  environment, so a second store in the same process can carry its own style with no further work.
- A3 (checks as a protocol): the glass checks are ordinary `backlight` and `surfaceSteps` runs on
  views wrapped in `.lumenChromeStyle(.glass)`; a `LumenCheck` needs no style parameter, only a
  subject that sets the environment.
