# Changelog

Lumen follows semantic versioning (see Docs/ARCHITECTURE.md › Versioning). Every release lists, for
the people moving an app's pin:

- **Breaking:** source changes an app must make.
- **Visual:** things that look or lay out differently with no code change (review snapshots, don't
  record them blind).
- **Validator:** new checks that run on an app's own themes and may flag them.
- **Added** and **Fixed.**

Apps pin exact commits; each release names its commit and tag.

## Unreleased

## 0.59.0 (2026-10-23)

Milestone M2: themes carry metrics and depth, a theme editor that can fix and seed, and design-tool
exchange.

### Added
- Theme schema 2 carries optional inherited radius, type scale, spacing scale and motion. Packs
  can lock individual metrics; invalid or locked values produce validator and import errors.
- Palette roots resolve metrics per store. Explicit app metrics keep precedence, including
  standard metrics, independently of modifier order. Exports and the CLI describe and validate
  the new fields; unchanged v1 library round trips preserve the original bytes exactly.
- Theme depth metrics declare menu and popover shadows plus hero and selection glows. Every
  optional field inherits independently; omitted fields retain the original depth constants.
  Per-store resolution and explicit app metrics keep the same precedence. Schema, reference and
  CLI validation describe the nested fields; Midnight Deep demonstrates file-driven depth.
- Theme editor Metrics tab with inherited values, resets, pack locks and live store preview;
  color, metric and validator Fix edits share native undo and redo. Fix actions repair contrast,
  foreground opacity and numeric metric bounds atomically, including independent Increase Contrast
  edits, and keep colored fills chromatic.
- New from seed derives complete, validated four-appearance themes from a hue (violet by default)
  and Paper / Graphite or Bright / Deep grounds; the accent keeps its hue and chroma across all
  appearances, aliases and links. Public token APIs expose seed derivation and Fix metadata.
  See Docs/reference/theme-editor.md for derivation and persistence rules.
- DTCG 2025.10 theme export/import and CSS custom-property export in `lumen-theme`, backed by
  additive `LumenDTCG` and `LumenCSS` APIs in `LumenTokens`. Appearance groups, metric ramps and
  shadow composites remain editable; a Lumen extension preserves source bytes, sparse declarations
  and pack locks. Import reports unsupported tokens as warnings and validates the resulting theme.
  The DTCG reference documents the design-tool loop and its unverified external-tool boundary.
- `lumen-theme diff` reports per-appearance color changes, added and removed tokens, metrics,
  depth and affected contrast deltas. `contrast` lists validator contrast requirements with
  failures first; both offer text, Markdown and JSON reports. Releases prepare a Theme values
  report under Visual after the strict build and stop before tagging until the report is committed.
- Window-owned `LumenToastCenter`, `LumenToast` and `.lumenToasts`: three visible notices,
  older-count collapse, hover-paused dismissal, persistent warning and danger notices, optional
  bordered actions aligned with the text, and an opaque raised backing in drawn and glass chrome.
- `LumenShortcut`, `LumenShortcutGroup`, a searchable `LumenShortcutsSheet` hosted by the focused
  window, and Help › Keyboard Shortcuts (⌘/). `LumenViewCommands` exports groups from the
  commands it installs.
- Catalog toast tone and stack controls, and a keyboard reference generated from its own commands.

### Changed
- `LumenListRow` infers sidebar or content context when `context` is omitted; explicit contexts
  keep their meaning, and the v0.58.0 initializers remain source compatible.

### Visual
- Contrast uses typeScale 1.1. Text-bearing controls and row heights grow with larger text while
  preserving the 24 pt control and hit-target floors. Other built-in themes retain their metrics.
- Navigation sidebars use semi-bold selected titles in active and inactive windows, reserving
  their selected width without changing subtitles or counts. Source-list hit areas reach the
  column edges while their continuous, inset selection shape stays in place; stacked sidebar rows
  inherit the sidebar selection role. The six `selection-families` goldens were re-recorded for
  the title.
- Golden canvases grow vertically for every scaled theme; unscaled captures are unchanged.

#### Theme values
<!-- lumen-theme-values:start -->
##### lumen.contrast (changed)
- [all] metrics.typeScale (added): absent → 1.1
<!-- lumen-theme-values:end -->

### Validator
- Packs can lock the entire depth declaration; explicit and inherited depth values are rejected
  through the existing validator and theme-store refusal paths.
- Depth opacity must be 0–0.6, radius 0–32 pt and vertical offset 0–radius. Popover opacity in
  each appearance and radius must be at least menu's; invalid values are reported, not clamped.
- Type scale must be 0.9–1.3, spacing scale 1.0–1.25, and explicit theme radii 0–12 pt (half the
  smallest 24 pt control). Pack locks reject even inherited or explicitly neutral overrides.

## 0.58.0 (2026-10-23)

### Breaking
- The minimum deployment target is macOS 27. Clients must raise their deployment target when moving their Lumen pin. Older-system availability gates and fallback layouts are removed; macOS 27 rendering is unchanged.

### Fixed
- Window activity (C5) reads `appearsActive` on macOS 27 and later for chrome, toolbar dimming and selection. New inactive Workspace and Utility subjects cover the flat band and quiet controls. No key/main-window observers existed in this baseline; none are retained.
- Text concatenations deprecated on macOS 26 now use `Text` interpolation; rendering is unchanged.
- The Catalog preview takes its version from the latest tag, and the Settings sample measures its
  controls only when a test or receipt asks.

### Added
- Settings: `.lumenSettingsScene()` completes the one-line sidebar-window recipe with native
  compact native chrome and a stable 320 pt content height, including Settings-scene style overrides.
  The root owns palette tint and inset sidebar selection; rich rows cap controls at 480 pt. Public query propagation
  through `.lumenSettingsQuery(_:)` and selection customization keep hosts on the stock scaffold.
- Catalog: the real Settings scene uses `LumenSettingsSidebarView`; the tabbed sample stays on its
  page. `LUMEN_CATALOG_SETTINGS_CATEGORIES=2` exercises sparse settings and
  `LUMEN_CATALOG_OPEN_SETTINGS=1` opens Settings at launch.
- Settings live-window checks and new window golden subjects cover two and five categories in
  drawn and glass chrome, including a deliberately bare-host negative case.
- PRINCIPLES §12: whole-window ownership, the single navigation-title and icon-only sidebar-toggle
  rules, measured real-window acceptance, and lessons from settings adoption. The public-root
  inventory retains the wizard and tabbed-settings gaps.
- Window corners (C2): measured 16 pt window reference, system-concentric sheets, welcome surfaces and floating status; native text and glass host subclasses apply container-relative masks on macOS 27.
- Native menu image policy (C7): `LumenMenuLabel.makeMenuItem` keeps automatic visibility by default and can preserve meaningful glyphs on macOS 27. The Catalog Menus page demonstrates both in a layout that fits its 480 pt content column.

## 0.57.0 (2026-10-23)

### Fixed
- Flexible toolbar status capsules size to their full text and percentage, shrinking only when the
  measured native toolbar room requires it. The Catalog no longer imposes a window-width budget.
- Toolbar identity items using `lumenToolbarPlatter` stay bare in both chrome styles, preserving
  the full two-line title instead of clipping it in a glass control platter.
- The drawn sidebar toggle uses the inspector button's outline glyph style and sits before the
  native sidebar tracking separator, preserving the sidebar column's toolbar position.

### Added
- `lumenSidebarToggle(columnVisibility:)` for split-view sidebar content: a bare Lumen panel
  toggle in drawn chrome, the native toggle in glass, switching without resetting content.
- Flexible `idealWidth:minWidth:` initializers for `LumenToolbarStatus` and `LumenActivityStatus`,
  with middle truncation. `LumenToolbarStatus(_:minWidth:)` measures content and native room;
  its `idealWidth:` overload is deprecated and forwards to the new behavior. The Catalog places
  the status after the identity rather than independently centering it.
- Conformance protocol (roadmap A3): `LumenCheck`, plain-value `LumenCheckContext`, and
  `LumenConformance.run(_:in:)` for app-owned checks with the existing finding format. The twelve
  built-in checks now have internal conforming types; every static API remains compatible.
- `LumenConformance.forbiddenSourcePatterns(_:in:)` for literal UTF-8 source guards.
  A minimum-text-size check and a label check are deferred until the renderer exposes resolved text sizes and the SwiftUI accessibility tree.
- Workbench's staged style-budget check and a Catalog Conformance page grouping app checks by
  owner. The page lists metadata without executing checks.
- `LumenChromeStyle` (`.drawn`, `.glass`) and `LumenStoreConfiguration.chromeStyle`, with a second
  initializer that takes it; `.lumenChromeStyle(_:)` overrides it for a subtree, and
  `\.lumenResolvedChromeStyle` is what draws. The default is `.drawn`, so apps render unchanged.
  Under `.glass` on macOS 26 and later the unified top bar's items show the system platter, the
  title bar band is flat `toolbar.background` while active, and the command palette draws on
  system glass with no hairline. `.glass` draws as `.drawn` below macOS 26, under Reduce
  Transparency and in offscreen renders (PRINCIPLES §11).
- Docs/GLASS.md, the glass policy, and PRINCIPLES §11 "Glass".
- Catalog: a Glass toggle in the main window's toolbar switches every window's chrome style;
  `LUMEN_CATALOG_CHROME=glass|drawn` sets it at launch.
- Tests: `.glass` goldens for the unified top bar, window-rendered on macOS 26 and later;
  resolution, backlight and surface-step checks for the glass navigation surfaces.
- Scoped theme stores (roadmap A2). `LumenThemeStore(configuration:registry:themes:persistsSelection:)`
  builds a store for a second window or a preview, beside the shared one; it persists nothing
  unless asked. `.lumenPaletteRoot()` and `.lumenPaletteRoot(windowChrome:)` without a store keep
  the store already in the environment (the shared store outside any root).
  `LumenThemeGallery()` and `LumenAppearanceSettings(showsGallery:)` without a store use the
  window's store. `install(_:)` stays the one-liner for single-store apps.
- `LumenSnapshot.render`, `png` and `verify` against a given store (`store:colorScheme:`), which
  give it to the view only through the environment, and `LumenSnapshot.variant(of:colorScheme:)`
  for their golden names.
- Catalog: the Themes page previews every built-in theme at once, each through its own store.
- Tests: two stores rendered in one process with their own goldens
  (`scoped-store-showcase@{standard,ultraviolet}-dark`); Workbench's XPC snapshot (110 role colors
  plus spacing and radius) produced from non-global stores.

- `ToolbarContent.lumenToolbarPlatter(_:)`: the chrome style's platter rule for native toolbar
  items (hidden in `.drawn`, the system's under `.glass`, nothing before macOS 26). `LumenTopBar`
  uses it; the Catalog's main and workspace windows now apply it to their own toolbar items, which
  showed the system platter in `.drawn` (Docs/GLASS.md › What each surface draws).
- Catalog: `Scripts/install-catalog.sh` restamps the built
  executable's SDK version (`xcrun vtool`, from `xcrun --show-sdk-version`), since `swift build`
  under Xcode 27.2 stamped it sdk 14.0 and AppKit drew the pre-26 design: no platters, no glass.

### Visual
- Command palette under `.glass`: the scope track is a hairline capsule with no fill, so no flat
  band sits across the glass (Docs/GLASS.md › What each surface draws). `.drawn` is unchanged.

### Fixed
- Command palette: the result list shrinks to the height it's offered and scrolls, up to 380 pt;
  it held its full height under `.fixedSize`, so 30 commands overflowed a 420 pt tall frame by 42 pt.

### Deprecated
- `Lumen.color(_:)` and `Lumen.nsColor(_:)`: they read the shared store whatever window they're in.
  Read `@Environment(\.lumenPalette)` (or `store.color(_:)` / `store.nsColor(_:)`) instead. They
  keep working until 1.0.

API check (`Scripts/api-check.sh v0.56.2`, 2026-10-19): no breaking changes in LumenTokens, LumenUI
or LumenConformance.

## 0.56.2 (2026-10-18)

### Visual
- On macOS before 27, the Catalog puts sidebar, list and detail in one native split, so the sidebar
  keeps its minimum at the 972 pt window minimum. macOS 27 is unchanged.
- Quiet buttons have a 24 pt minimum hit width, so a missing symbol no longer shrinks one to 8 pt.

### Fixed
- Hex dump measures the digit width once and places cells at fixed widths; scrolling is faster.
- Tests: settled window captures, OS-gated custom-symbol and toolbar-desaturation checks, and
  `LUMEN_PERF_BUDGET_SCALE` for hosted CI runners (default 1, so local budgets are unchanged).

## 0.56.1 (2026-10-17)

### Fixed
- Hidden workspace regions no longer report tile backlights to conformance checks.
- Rename the accent-derivation local to avoid name shadowing so older Swift compilers build.

## 0.56.0 (2026-10-16)

### Added
- `.lumenBottomPanel` accepts an optional `maximumHeight` absolute cap alongside its fractional
  limit. Existing calls retain their behavior; the Catalog Workbench rehearsal uses a 360 pt cap.

### Fixed
- The non-scrolling inspector now uses the near-zero measurement floor, so it stays short during
  split-column sizing; it is still placed at its ideal height, so its layout doesn't change.

## 0.55.0 (2026-10-16)

### Added
- Catalog: a public-API-only Workbench rehearsal window (Lumen menu), with synthetic toolbar,
  sidebar, disassembly, graph, inspector, debugger bar and empty-workspace states.
- `LumenWorkspaceWindow.contentMinimumWidth(_:)` lets apps declare their editor column's minimum
  (default remains 320 pt); the rehearsal uses Workbench's 560 pt requirement.

### Fixed
- Near-zero split-column measurements use the existing wrapping floor for fitted table rows,
  console lines and under-title-bar content. Ordinary width proposals
  keep their existing layout. The wrapping source check now covers generic containers as well as Text.
- Catalog: Workspace New Document adds and selects closable tabs from the toolbar or ⌘N;
  main windows retain New Window. Data & Git adds Narrow values for live semantic shortening and full-value Copy.
- Tests only: the Catalog main-window live test measures the window's real minimum size instead of
  using a 640 pt height the window can't reach (the toolbar band sits on top of the content's 640).

## 0.54.1 (2026-10-15)

Additional visual polish.

### Fixed
- Status menus (encoding, syntax, line endings) take the status bar's caption size; a borderless menu
  ignored the font it inherited.
- Sentence rows with a checkbox start their words where a plain checkbox's label and a dependent
  group's rows do (they sat 2 pt to the right).
- Test: the Workspace live-window check hosts the window as shipped and checks its real minimum
  (1000×712, the toolbar band included), not an unreachable 1000×660.
- Docs: `LumenConformance.narrowSizing` says it judges minimum heights, not ideal ones.

### Visual
- Ref pills have no ring: one chip spec.
- Table row lines give way next to the selected row in every theme.
- Welcome panel recents sit on the action cards' columns.
- The inspector header title is `title3`, a step above its section titles.
- Empty, loading and error messages wrap to even lines; no single word is left on the last line.
- Catalog: sentence-case badge and hue labels, a Themes page header, an empty state in the Data page's
  notice box.

## 0.54.0 (2026-10-15)

A broad review (regressions since 0.47, hosted live windows, changed goldens, performance at
scale, API and docs; 77 findings), fixed across the affected components. Everything ran headless.

### Added
- `EnvironmentValues.lumenReportsLayoutChecks`: on under XCTest, off in apps, so tables skip the
  truncation and visible-text reporting the conformance checks use.
- `LumenSnapshot.render(…renderer:)` returns unknown tokens for either renderer; the `.window`
  renderer captures at the requested scale on any display.
- `LumenEmptyState.inline(_:ink:leading:padding:)` is public, for leading sidebar empties.
- `LumenSettingsSidebarView.sidebarMinWidth` (200) and `.detailMinWidth` (360).
- A source scan enforcing PRINCIPLES §6 (no bare `fixedSize(horizontal: false, vertical: true)` on
  Text, with a reasoned allow-list); interaction budgets (typing, selection, scrolling) in
  `LumenPerformanceBudgetTests`.
- Listed now, added since 0.47: `.lumenEmptyMessage(_:)`, `LumenEmptyState.Prominence`,
  `LumenThemes.contrastDarkHues`, `LumenListingRowState.patchMark(_:)`,
  `LumenRowColors.selectedSecondaryOpacity`, `.lumenPanelIcon(isOn:)`, and the new metrics roles.

### Fixed
- Semantic text (0.51.0 regressions) never collapses to a bare "…": values with no break point
  (UUIDs, hashes, escaped strings, ObjC references) wrap and middle-truncate as before 0.51; search
  lines with `; # @ $ \` or an apostrophe keep their context and visible match; file names and paths
  keep the file name (`Lumen…swift`, not `…swift`). Candidate plans are memoised and chunks measured
  once per layout.
- Narrow sizing: settings rows and headers, the sidebar pane grid, the table footnote, the variable
  tree's note and the input palette no longer set a minimum taller than the window when a split view
  sizes its columns. `lumenWrapsWithoutTruncating` only raises near-zero proposals, so text wraps
  inside real columns under 120 pt (a long banner keeps its close button in a 180 pt column).
- Performance at scale (debug build): log console 100k lines, filter keystroke 11.8 s → ~1.4 s;
  palette 5k commands 1.4–4.5 s → 0.07–0.6 s per keystroke, arrows and hover no longer re-match;
  variable tree 1k rows 4.5 s → 0.3 s; stack 1k frames 7.7 s → 0.18 s; code listing 10k lines
  11 s → 0.07 s; hex dump scroll ~1 s → ~0.35 s; tables scroll without test-only reporting; string
  rows parse once; search filters once per body.
- Layout: stroked capsules lost their round ends in live windows on macOS 27.2 (pill switcher,
  comparison capsules, tabbed-box strip); history rows stretched to their container and their refs
  overflowed a narrow sidebar; palette single-line rows used the tall tile; inspector rows stack when
  the value doesn't fit; evaluation types wrap; property values wrap to 4 lines; the settings
  sidebar view's pane has a minimum; the document tab bar keeps the selection in view after a
  resize; hex dump and variable tree report their narrowest layout as their minimum.
- Docs: ARCHITECTURE (New
  button accent, naming exceptions), README/ARCHITECTURE index, PRINCIPLES §10 octagon, doc comments.

### Visual
- One 13 pt label size across mode-switcher styles; one tinted Evaluate look, inset in its field; the
  completion type stays on one line with a middle cut; the comparison detail wraps; inspector-summary
  reference rows show `-[NSViewContro…IfRequired]+112`. Catalog: the Workspace filter at the sidebar's
  foot, leading sidebar empties, a neutral "Analytics: Off" badge.

### Behaviour
- Log console: a filter change that adds or removes more than 1,000 rows rebuilds the table, which
  resets column widths a person dragged (the price of the 100k-line speed-up).
- Variable tree, stack frames and code listing are lazy above 200 rows.

## 0.53.0 (2026-10-15)

### Added
- `LumenSnapshot.Renderer` (`.image`, the default; `.window`) and `png(…renderer:)` / `verify(…renderer:)`
  overloads. `.window` draws the view in a real borderless window that's never shown, on the live code
  paths (`lumenRendersOffscreen` off, drawn as the key window), and captures it once two captures in a
  row are identical. For views whose live layout feeds measurements back through preferences.

### Fixed
- CODE-11, table goldens vs the live app: a `LumenTable`'s flexible columns share their width by
  natural widths, minimums and priorities only after measuring themselves, which the one-pass image
  renderer can't do, so goldens split them equally (a long value beside a short one was truncated in
  the golden and whole in the app). The goldens with tables (controls, forms, tools, table-headers)
  now use the window renderer and show the live widths; a new `table-live-widths` golden pins the
  difference. `editors` stays on the image renderer: its rule editor's text fields settle a pixel
  differently depending on test order, which no capture makes deterministic.

### Visual
- Re-recorded goldens (controls, forms, tools, table-headers) differ from the image renders by under
  1% of pixels: AppKit text fields and icon-tile materials antialias as a real window draws them.
  Layout is unchanged.

## 0.52.1 (2026-10-15)

### Fixed
- Swift 6 isolation warnings cleared: 94 unique warnings (5 in LumenUI, 89 in tests) that the release
  build tolerated and a stricter toolchain could turn into errors. Sources: the carousel's coordinate
  space is a global constant (a generic view's `Self.space` captured its metatype in a Sendable
  closure), and two pure-value statics are `nonisolated`. Tests: eight test classes are `@MainActor`
  like the rest, and the live-window harness runs its window work in `MainActor.assumeIsolated`.
  No behaviour or visual change; the build is warning-free.

## 0.52.0 (2026-10-15)

### Added
- `LumenConformance.narrowSizing(_:referenceWidth:factor:slack:)`: measures each view at a normal
  column width and at 1 pt, the near-zero width a split view's sizing pass uses, and fails on one
  whose height balloons (more than 4× and at least 80 pt more). The class of bug behind 0.51.1's
  blank Workspace window.
- `View.lumenWrapsWithoutTruncating()`: text that wraps and is never truncated, measured at least
  `LumenEmptyState.inlineMeasureWidth` (now public, 120 pt) wide. At any real width the text takes its
  natural size, so nothing moves; only a narrower sizing proposal is raised.

### Fixed
- Eight more components ballooned when measured narrow, the same risk as the Workspace window in any
  inspector, sidebar or split column: the pane empty, loading and error states (1157, 1084 and
  1458 pt measured 1 pt wide), the address-field hint, the empty hero's message, the code sample,
  the detail header's summary, the evaluation result and radio titles. They, the banner text and the
  inline empty state now use `.lumenWrapsWithoutTruncating()`. All goldens unchanged.

### Validator
- `LumenNarrowSizingTests` runs the check over every Lumen component that wraps text this way, with
  its golden's sample content.

## 0.51.1 (2026-10-15)

### Fixed
- The Catalog's Workspace window drew a blank body: its split view needed 1325 pt and sat centred in
  the 712 pt window, clipped at both ends (PRINCIPLES §6; found in the 2026-10-15 live check). Cause:
  an inline `LumenEmptyState` wraps without truncating, and a split view sizing its columns measures
  at a near-zero width, so each sentence asked for its height wrapped a few letters per line (three
  sidebar sections added up to the 1325). Inline sentences are now measured at least 120 pt wide;
  nothing changes where they're drawn (all goldens unchanged).

### Validator
- New live-window test: the Workspace window's split view fills the window exactly at its declared
  minimum (1000×660) and default (1000×712) sizes. A unit test keeps an inline sentence measured
  1 pt wide under 100 pt tall.

## 0.51.0 (2026-10-14)

### Visual
- Qualified symbols and reference locations shorten at complete components; selector argument
  labels and generic delimiters remain intact. String paths, completion types and search excerpts
  can wrap to two lines at token boundaries instead of cutting identifiers midway.
- Watch expressions, variable names, checklist labels and selectable code values share semantic
  display policies. Search excerpts retain the first matched token and its highlight when it fits.

### Fixed
- Display-only omissions never replace original code values: help, accessibility and Copy retain
  the complete string. Native selectable fields retain original backing text and field-editor
  selection; arbitrary custom SwiftUI fonts retain their original selectable fallback.
- Incomplete search source lines use an excerpt policy distinct from complete expressions/types.
  Display candidates are bounded for long inputs; no language-specific evaluation or rewriting occurs.

## 0.50.0 (2026-10-14)

Component, layout, glyph, color and documentation polish.

### Breaking
- `LumenNewItemButton.init`: `hue` now defaults to `.accent`; `sparkHue` is
  `LumenToken? = nil`. The New Tab plus uses the panel toggles’ size and stroke, beside them.

### Visual
- Empty states use one design with inline, pane and hero tiers. Loading and error states use the
  pane mark slot without a card; list empties use the inline tier.
- Segmented selections use the filled accent, 13 pt text and 24 pt controls. Chips share one
  continuous 6 pt shape; quiet buttons show a hover plate, and disabled primary buttons share one look.
- Table and stack selections use the quiet row treatment with inactive states. History selections
  are inset and rounded; collection headers and sidebar chevrons align consistently.
- Toolbar identity, tasks and status dim together in inactive windows. New Tab uses a single accent
  plus. Error states, console markers and status chips use `xmark.octagon.fill`.
- Custom glyph stems, live areas and optical weight align. Token, patched-bytes and anonymize tiles
  use filled glyphs; color mix keeps its outline because the filled discs merge at tile sizes.
- Contrast dark has its own hues and quieter selected background. Standard light sidebar inactive
  selection is deeper. Welcome keeps one glow token, with a clearer contrast primary rim.
- Code panes, current-line bands, card clipping, console insets, variable gutters, graph legends,
  checkbox spacing and welcome dividers are consistent across components.
- Catalog text, form and control pages cap content at 960 pt, leading-aligned; workspace and data
  pages keep their available width. README images now derive from the current accepted goldens.

- Detailed history, stack, process, string and command rows follow density metrics. Pane headers,
  action glyphs, palette queries, pressed feedback, status dots and inline dividers share named roles.
- Welcome presentations share one recent-document row. Settings headers top-align. Listing marks
  beside branch lanes sit at the pane edge; the Catalog's Appearance picker stays in five columns.
- Inspector code values use native wrapping without typographic hyphens. Original values remain
  selectable and copyable; custom SwiftUI fonts and offscreen renders use single-line truncation.

### Validator
- Sidebar inactive selection must differ from sidebar hover by at least 0.02, using the same
  visibility rule as content selections. The Workbench bridge records its seven legacy findings.

### Added
- Shared micro-glyph/count, palette-query, subheader, pane-action, status-dot and pressed-feedback
  metrics. A listing-row overload can suppress marks when branch lanes draw them at the pane edge.
- Inline and pane empty-state prominence, and documentation for subtitle/action-label/default-hue
  naming and optional-pack tokens alongside the core reference.

### Fixed
- Search match-line trimming lands on token boundaries and retains the match. Truncated values
  offer help; evaluation types retain their text. Panel status survives before labels disappear.
- Documentation reflects current toolbar marks, sidebar roles, selection and validator behavior,
  conformance references. Typography’s initializer and static mirror
  cover the complete role set.

## 0.49.0 (2026-10-14)

Two validation follow-ups.

### Validator
- `sidebar.foreground` and `sidebar.secondaryForeground` must read on the new
  `sidebar.rowSelectedInactive`. A theme that sets its own sidebar text (a dark sidebar in a light
  app) gets a finding until it sets that role too; it falls back to `bg.selectedInactive`.

### Added
- `sidebar.rowSelectedInactive` (Window Chrome): a selected sidebar row in an inactive window. It
  replaces 0.48.0's interim rule (keep the active fill when the theme sets sidebar text);
  `LumenResolvedPalette.sidebarSelectedInactive` now reads it. On cards it follows
  `bg.selectedInactiveRaised`. The Slate Sidebar example sets `#353A45`.

### Fixed
- The system-accent derivation measures a translucent ground over the ground that holds it (a
  sidebar row on the sidebar, a highlight on its menu, a floating menu over any backdrop), the same
  way the validator does, instead of always over the canvas.

## 0.48.0 (2026-10-14)

An independent review filed 31
findings across tokens, validator, theme store, components, layout, conformance, tests, docs, API
and release gates. All 31 were confirmed against the code and fixed, each with a focused regression
test where one is possible.

### Breaking
Source-compatible (existing calls compile unchanged); the API check reports the signatures:
- `LumenTheme.init(…colorSpace:…)` takes `LumenColorSpace? = nil`: a Swift child theme without
  `colorSpace` now inherits its parent's, like a JSON one, and saves without the key.
- `View.lumenSurface(_:ownsEveryColor:store:)` takes `LumenThemeStore? = nil`; `nil` uses the store
  in the environment (the one `.lumenPaletteRoot(store:)` injected) instead of the global store.
- `LumenEditorLayout.closeOthers(_:inPane:shouldClose:)` and `closeAll(inPane:shouldClose:)` gained a
  defaulted `shouldClose:` veto.
- Behaviour an app may notice:
  - Number fields step from the range's lower bound, like sliders (range `1...9` step 2: 1 → 3, was
    1 → 4); a slider's typed value snaps to its step.
  - Translucent grounds are measured over the ground that holds them (menus over any backdrop), and
    contrast pairs are also checked on raised grounds, so an app theme may get new findings.
  - System-accent colors in a Display P3 theme are derived, measured and drawn in Display P3.

### Visual
- `bg.selectedInactiveRaised` (an inactive selection on a card, sheet or menu) is a touch darker so
  tertiary text reaches 4.5:1: Standard dark `#363449` (was `#38364B`), Midnight `#252957`
  (`#262B5A`), Ultraviolet `#3C2957` (`#41325C`).
- A theme that sets its own sidebar text keeps an inactive selected row on `sidebar.rowSelected`
  (the shipped Slate Sidebar example was 1.13:1 inactive).

### Validator
- Display P3 themes are measured in Display P3 (luminance, contrast and OKLab distance).
- Contrast pairs whose text or background changes on a raised ground are checked there too.
- Distinctness compares colors as drawn (alpha over the ground that holds them).
- Translucent backgrounds composite over their holding ground, not always the canvas.
- Conformance flattens the themes it's given; an unresolved parent or a theme with no palette is a
  finding, not a vacuous pass. Palette lookups of unknown tokens are recorded in `unknownTokens`.
- The surface-step scan looks past hairlines up to 2 px; snapshot `verify` also fails when any 32 px
  patch differs by more than 25% (`Difference.densestPatchFraction`); public-view coverage counts
  only code that builds the view; the live status test requires the capsule when there's room.

### Added
- `LumenThemeFile.selfContained(_:lookup:)` (throws) and `isSelfContained`;
  `LumenThemeDirectoryWatch.watchesCurrentDirectory`; `LumenEditorLayout.move(_:fromPane:toPane:at:)`
  and `closePane(_:shouldClose:)`; `LumenResolvedPalette.sidebarSelectedInactive`;
  `LumenColor.relativeLuminance(in:)`, `contrastRatio(against:in:)`, `oklab(in:)`,
  `perceptualDistance(to:in:)`; `LumenSnapshot.patchSize`/`patchTolerance`.

### Fixed
- Tokens: `over()` is true source-over on translucent destinations; a fallback that uses one token
  twice is no longer mistaken for a cycle; raised roles a theme leaves out resolve to their plain role;
  a surface declared by two packs merges instead of crashing the store; the system accent lightens on
  a dark surface of a light theme.
- Theme store: surfaces keep the injected store; a saved theme broken at launch comes back when its
  file is fixed; the folder watch follows a folder replaced at the same path; concurrent choices
  persist in order; `LumenThemeFile` looks parents up in the active store and says when it can't.
- Split editor: bulk closes and Close Split ask `onCloseTab`; dragging a duplicated tab takes it from
  its own pane; the stacked-sidebar minimum includes the grips.
- Command palette: renaming the highlighted command out of the results moves the highlight; closing
  clears focus only in its own window, and only when focus fell into another field.
- Controls: the filter field accepts the first deliberate click or Tab; the whole-number field is
  exact across `Int` and never traps; the slider's click target is 24 pt.
- Top bar: the title-bar band in the window minimum is owned by the window (a remount doesn't add it
  twice; the last bar out removes it).
- `Scripts/release.sh` refuses golden skip/record modes and untracked build inputs.
- Docs: field chrome documented as `bg.elevated`.

## 0.47.0 (2026-10-13)

Visual polish: design decisions and the audit (tokens, goldens, code, the live
window, Workbench, fidelity and docs). The decisions, now in PRINCIPLES §1 and §10:

- Lumen must be compatible with macOS, not look like native controls. It draws its own controls on
  its surfaces, and the better design wins.
- One filled-accent look: deep accent with white text in dark. The bright accent is for lines,
  glyphs, links, tints and focus.
- One-line controls are 24 pt with 13 pt text.
- One uppercase label style for section groups and table headers; Title Case tile sections;
  sentence-case tags and badges.
- Tile backlight stays inside its strip, and is off in the toolbar.

### Breaking
- `LumenCarousel.init(_:content:)` is now generic over an id (`ID == Int`): existing calls still
  compile but draw no arrows; move to `LumenCarousel(_:ids:card:)`. The API check reports the
  signature change.
- Behaviour an app may notice:
  - The unified top bar adds its 40 pt band to the window's minimum height, and grows a window
    opened below it. Declare your content's minimum height, not the window's.
  - `LumenToolbarStatus` grows past its `width` to its label's full width when there's room, and
    hides when the whole label wouldn't fit (it never truncates).
  - `LumenShortcuts`: ⌘Q ⌘W ⌘H ⌥⌘H ⌘M ⌘, moved from `systemReserved` to `standardCommands`, so an
    app's own Quit/Close/Hide/Settings items no longer trip the shortcut check.
  - `LumenGraphNode(systemImage:)` defaults to no tile (was a `square.grid.2x2` placeholder).
  - `LumenStat(count:)` shows a million and up compactly ("98.8M"); `LumenBadge.Tone.accent` text
    is `fg.link`; `LumenSwitch` lays out 24 pt tall; `LumenPanelBar`'s minimum height is
    `paneHeaderHeight`.

### Visual
- Filled accent shapes (primary buttons, checked checkboxes and radios, a switch that's on,
  selected chips, the hex selection, filled selections) use `accent.filled` under white text.
- Selection follows four families (PRINCIPLES §10): quiet `bg.selected` for navigation lists and
  tables (now also the list editor and the code listing), filled for menus, pickers, palette,
  completion, master-detail, history, process list, wizard and filter chips, a plate for modes,
  tools and panel tabs, band and bar for code rows. On a filled row an icon tile becomes a white
  symbol on a faint white plate.
- `controlHeight` is 24 pt (was 22) and one-line controls use 13 pt text: every field (address,
  find, command and filter fields included), pop-up, pull-down and push button, and the pill
  switcher overall. Every field shows focus.
- Tab bars use `tabHeight` (32 pt; the content tab bar was 34) and pane headers with a section tile
  use `paneHeaderHeight` (36 pt). Stacked-sidebar headers gain a chevron.
- Section labels and table headers share one style; tags and badges are sentence case.
- Tile backlight is a soft contained ellipse, never crosses a hairline, and is off in the toolbar.
- Toolbar and top-bar buttons are one size (28 pt) with one hover plate; a hammer without its own
  hue is orange; a failed activity shows an xmark.
- Colors (every built-in theme): visible hover and inactive selection on cards and sheets, wells
  lighter than sidebars and inspectors (Ultraviolet), visible separators (standard dark,
  Midnight), visible tags, a darker window ground so the selected tab plate reads, deeper
  `menu.highlight`, red danger in Midnight and Ultraviolet, Midnight links in violet, visible
  current line in the contrast themes, `border.control` edges at 3:1.
- Listing: the selected row is `bg.selected`, clearly above the current-block band; bands run
  under the branch-lane gutter; the program counter is amber (`code.programCounter`).
- Document tabs fade only at an edge that runs on, from the real scroll position, and never show a
  half tab at rest. Panel tabs fold to the selected title, then scroll.
- Disabled controls fade once, to `disabledOpacity`, alone or inside a disabled group.
- Debugger rows use one name weight; register names are monospaced; a disabled breakpoint is an
  outlined tag; the narrow variable tree drops its type column whole; hex rows split after 8 bytes.
- Command palette and menu: one leading edge, word keys padded, keycaps light on the highlight,
  icon-less items keep the title column.
- Large stats-card numbers use compact notation (98.8M), with the full value as help.

### Validator
- About 25 new core rules, each with the built-in values it needed: wells lift above sidebar,
  inspector and panel grounds; hover, inactive selection and wells visible on raised grounds;
  inactive selection apart from hover; `accent.subtle` apart from `bg.selected`; menu separators
  and group borders visible; neutral tag fills visible; `border.control` at 3:1; toolbar
  secondary text on the glow; the activity capsule visible on the bar; the tab plate apart from
  the window ground; composited text on `menu.highlight` and `accent.filled`; disabled text at 2:1
  on selections and raised grounds; accent apart from `status.info`; a visible current line; and
  in the code pack `accent.subtle`, `code.currentLine` and `bg.selected` apart. `fg.link` must read
  on `accent.subtle`. An app's own themes may now be flagged by these.
- System-accent mode is derived and checked: filled shapes take a deep tone of the accent under
  white, text on the accent picks black or white, `bg.selected` follows the accent.

### Added
- Tokens: `accent.filled`, `accent.filledForeground`, `border.control`,
  `toolbar.secondaryForeground`, `bg.hoverRaised` and `bg.selectedInactiveRaised` (swapped in by
  `raised()`), and `code.programCounter` in the code pack. Each falls back to an existing role.
- Metrics: `layout.paneHeaderHeight`, `pillRim`, `toggleIndicator`, `switchHeight`, `sliderThumb`,
  `fieldInset`; typography `sectionLabelTracking` and `stat`.
- Components: `LumenStatusLabel`, `LumenStatCell`, `LumenTableHeight.fitRows(maxVisible:)` and a
  `footnote:` on `LumenTable`, `LumenPanelBar(statusLabel:accessory:)`,
  `LumenPullDownButton(showsTitle:)`, `LumenModeSwitcherPlacement`, `.lumenPanelIcon` (icon
  buttons inside panes), `LumenBranchLanes(rowStates:)`, `LumenCarousel(_:ids:card:)`,
  `LumenMenuEntry` items and separators with explicit ids, `LumenFormRow(labelWidth:)` defaulting
  to the metric.
- `LumenTheme.isHighContrast` (the Contrast theme sets it; tiles draw their Increase Contrast look
  under it) and `LumenThemeStore.resolvedColor(_:for:on:)`.
- `LumenTableText(_:monospaced:truncationMode:)` and `LumenTableColumn.text(…truncationMode:value:)`:
  `.middle` for values that differ at the end; the 8-character floor becomes 4 each side.
- Conformance: a whole-view overflow check (the app-icons golden overflowed unseen), visibly
  duplicate truncations in a column, backlight containment, and an icon-only scan that measures
  `.labelStyle(.iconOnly)` and text or shape labels. Real-window tests for the Catalog sidebar at
  the window minimum, the top bar at its minimum height, the status never truncated, and items on
  the window buttons' line.
- Goldens: disabled states, table headers, keycaps on raised grounds, selection families, the
  unified top bar, a selection inside a listing block, and forced hover states.
- PRINCIPLES §10, one look per role.

### Fixed
- `raised()` swapped keycaps by comparing colors, which never matched: keycaps were holes on cards,
  palettes and menus. It now decides by token provenance and also swaps hover and inactive
  selection; `lumenSurface` keeps an enclosing raised ground.
- An empty `LumenTable` drew its header hairline in a phantom band, twice as tall.
- System-accent mode: the selected filter chip's text was the accent on the accent.
- `LumenConsole` never followed the newest line; `LumenCarousel` arrows did nothing.
- The Catalog sidebar was cut at the window minimum; the split workspace's top bar collapsed at its
  minimum height; the status capsule truncated a long label.
- Popovers, help and icon-picker popovers apply the raised ground; address and command fields use
  field chrome; the key-value editor's cells read the card's palette.
- Single click selects at once in pickers with a double-click action; the shortcut recorder
  captures menu-owned shortcuts; command-menu ids are stable; resize cursors balance; Reduce
  Motion is honored in tab scrolling, View-menu toggles and the progress ring.
- Docs: stale counts, names and signatures; checks described as they are.

## 0.46.0 (2026-10-13)

Visual polish: the visual audit (3 P1, 19 P2, the P3 list). Goldens re-recorded after review.

### Added
- `bg.insetRaised` (falls back to `bg.inset`): wells on cards, popovers and sheets.
- `.lumenRaisedGround()` and `LumenResolvedPalette.raised()`: content on a raised ground takes
  `bg.insetRaised` for its wells. `lumenCard`, `LumenSettingsCard`, `LumenSheet`, list boxes, menus,
  the command palette, search and tool popups apply it.
- PRINCIPLES §8: dark grounds step up as they nest; one filled selection with white text.

### Validator
- `LumenLiftRule`: on a dark ground, `bg.inset` must be lighter than `bg.canvas` and
  `bg.insetRaised` lighter than `bg.elevated`. An app's dark theme with darker wells is flagged.
  Workbench's staged pack keeps its legacy darker wells (Scope, Midnight) as named known issues
  until adoption, and gains `bg.insetRaised` and the deep dark selection.

### Visual
- Dark selection: every dark built-in theme values `menu.highlight` as a deep accent (standard
  #5B4BD6, midnight #6A3FD0, ultraviolet #7A3AB8, contrast #4A3BC8) under white text. The tools
  completion list, collection, master-detail list, history rows and launch menu use it instead of
  the raw accent; keycaps on a selected row stay light.
- Dark wells are lighter than their card: inspector-summary stats, console input, list editor and
  master-detail list (now raised fields, `bg.elevated`), fields in sheets.
- Document tabs: the selected tab is never under the overflow fade (it scrolls to the centre, with
  room past the last tab); offscreen renders show the selection's end.
- Stacked sidebar headers are 36 pt: the 28 pt tile with 4 pt above and below.
- Drop zones: one plate in both states, edge to edge, hairline idle and accent targeted.
- Layout toggles: the filled glyph is the "on" state; no plate except on hover.
- Toolbar activity: progress is an inset rounded track, not a line along the capsule's edge.
- Pill mode switcher: control-height segments (28 pt overall), level with pop-ups.
- Settings search band reaches outside the row, so titles keep the column's edge; dimmed sentence
  rows use `disabledOpacity`.
- Debugger: the selected frame drops its edge bar (the plate and index mark it).
- Notices: the body uses the card's full width.
- Comparison header capsules: white text on the side's color, darkened to 4.5:1.
- Command palette: matches are bold (and accent off the selection); the trailing category shows
  only for recents and category matches, not under a header that already names it.
- Inspector summary: a detail that doesn't fit drops to its own line instead of truncating.
- Hue swatch grid spreads its columns across the popover.
- Calm weights: unselected filter chips, watch and variable names, pane-grid labels are medium.
- Key-value type chips are neutral; diff navigator sets the whitespace toggle apart after a
  divider; search results summary is trailing-aligned; an empty table keeps its header hairline;
  default empty message "No items".
- Welcome starfield: quiet stars take the accent softly in light.

### Fixed
- With the system accent on, `menu.highlightForeground` resolved to the accent itself (text
  invisible on the highlight); it now picks black or white like `fg.onAccent`.

## 0.45.0 (2026-10-13)

Visual polish: the visual audit's remaining items. 118 goldens re-recorded after review.

### Visual
- `LumenTag` chips fill with `statusNeutralBackground`, so tags read as chips in every theme (the
  dark ladder had made them vanish into the inspector).
- One accent per theme: panel toggles fall back to the accent (and the system accent); Ultraviolet
  drops its separate cyan tab line and magenta chips for its violet accent (its title-bar glow
  stays); a selected history row's lane takes the row's text color.
- Banner actions use a quiet raised button in the banner's own edge color, not the accent.
- `LumenTable` row hairlines share the selection band's inset.
- Tools: grid tiles top-align; the list's Name, Location and Last Opened columns no longer collide.
- Log filter bar: Clear is a quiet button after a divider, not a fifth chip.
- Toolbar icon buttons use regular weight at 75% of the toolbar text color (full on hover); task
  glyphs are optically matched (hammer 0.85, play 1.08).
- Managed-tool rows align description with title; the tile switcher's selection plate shares the
  sidebar's leading edge.

## 0.44.0 (2026-10-13)

Nova's top bar: one compact unified row in the title bar, every item on the
window buttons' center line, hosted as native toolbar items; editor modes move to the content's
tab bar. Checked live in the Catalog at 1400 → 900 → 1250 pt.

Nova's top bar: one compact row whose items all sit on the window buttons'
center line, Nova's toolbar order, full-color task controls, and editor modes in the content pane's
tab bar.

### Breaking (scene setup, not API)
- Apps using `LumenWorkspaceWindow` or `.lumenTopBar` should add
  `.windowToolbarStyle(.unifiedCompact(showsTitle: false))` to the window's scene for Nova's compact
  band; without it the toolbar band is the taller default. No Swift API changed.

### Visual
- `LumenWorkspaceWindow` and `.lumenTopBar` host the bar natively by default
  (`LumenTopBarPlacement.unified`): its leading content and center become the window toolbar's
  `.navigation` items and its trailing content a `.primaryAction` item, so AppKit sizes the band
  (38 pt; 40 pt on macOS 27), puts every item on the window buttons' center line, and handles clicks,
  dragging and double-click. The toolbar's background is hidden and Lumen's title bar glow is drawn
  behind it, with a hairline under it; the empty title strip is gone and the content starts higher.
  On macOS 26+ the items have no glass platter. `.topBarPlacement(.underTitleBar)` on the window, or
  `.lumenTopBarPlacement(.underTitleBar)` around `.lumenTopBar`, keeps the old SwiftUI bar.
- In the toolbar, `LumenToolbarIdentity` takes Nova's compact sizes (20 pt tile, 13 pt semibold name
  over an 11 pt subtitle); `LumenToolbarDivider` is 18 pt tall.
- The panels are never dropped. AppKit sizes each SwiftUI toolbar item at its ideal width (a single
  item spanning the toolbar can't be made flexible), and when items don't fit it drops the last one
  (the panel toggles and New Tab, not even into the overflow menu) and collapses the flexible space.
  So the status gets a width budget worked out in SwiftUI's own layout as the window resizes (the
  window's width less the window buttons, the leading and trailing items and AppKit's spacing): it
  narrows to it and, Nova-style, hides when its label wouldn't fit whole, so the toolbar never
  overflows. As a backstop for a resize that outruns the budget, the status item has the low
  visibility priority and the others the high one, so AppKit gives up the status, not the panels.
- `LumenTaskCluster`: disabled build and run keep their color, dimmed by the disabled opacity, as
  Nova's do; stop stays gray while nothing runs.

### Added
- `LumenTopBarPlacement` (`.unified`, `.underTitleBar`), `LumenWorkspaceWindow.topBarPlacement(_:)`,
  `View.lumenTopBarPlacement(_:)`, `LumenLayout.unifiedTopBarHeight`.
- `LumenWorkspaceWindow.newItemButton(_:action:)`: Nova's New Tab button after the panel toggles.
- Nova's arrangement: `LumenWorkspaceToolbar` (app mark / project / tasks + configuration, with
  slashes), `LumenToolbarStatus` (the temporary status after the tasks, hidden while idle),
  `LumenToolbarDivider` (the slash), `LumenContentTabBar` (the content pane's tab bar for editor
  modes or tabs).
- `LumenTaskAction(_:systemImage:role:hue:shortcut:perform:)`: an action in its own color (the build
  hammer).
- `LumenTopBarPlacementKey`, `LumenTopBarContentFrameKey`: what the bar reports to conformance.
- Catalog: the Split Workspace window shows layout A end to end (with the compact toolbar style on
  its scene); Workspace page › Nova toolbar groups.

### Validator
- `LumenConformance.workspaceWindow` checks a unified bar in the real window (its hosting view
  bridges toolbars, in the compact style, as a SwiftUI scene does): the band starts at the window's
  top edge with the window buttons centered in it; the window has a toolbar hosting the items ("the
  unified top bar has no window toolbar to host its items"); every item's center is on the buttons'
  center line, ±1 pt ("toolbar item N is M pt off the window buttons' center line") and none reaches
  under them ("toolbar item N overlaps the window buttons"); neither the leading item nor the panels
  is dropped for lack of room ("toolbar item “Panels” was dropped for lack of room"; the status may
  be, by design); no panel starts under the band. The old
  checks still apply to `.underTitleBar` and to bars that don't report a placement.
- Note for bars built by hand: content whose top edge touches the band's edge counts as adjacent to
  the safe area, and SwiftUI stretches AppKit-backed content (an HSplitView's NSSplitView) up under
  the toolbar. Lumen's placement keeps the hairline as its own row to avoid it; the region check
  reports it ("a panel starts N pt under the top bar").

## 0.43.0 (2026-10-13)

Visual polish: the visual review's conformance gaps closed, the dark surface ladder and calm type
weights, and the visual audit's fixes. 235 goldens re-recorded after review.

### Visual
- Dark surface ladder: in every dark theme, wells, chips and stat cells sit a step
  lighter than their surface, not darker.
- Calm type weights: headlines semibold, emphasized captions and section labels
  medium; bold only for titles and display.
- The elevation shadow and hero glow composite first, so no gray halos around keycaps, chips and
  swatches inside floating surfaces.
- Inspector's first section clears its divider; the welcome starfield fades out around the title
  and cards, and Clone uses a plain glyph; equal card and banner heights; Try Again is a capsule; the
  error state uses a standard tile; stray accent bar removed.
- Form label and field baselines align; overflowing tabs fade instead of cutting mid-word; the
  carousel's clipped edge fades; graph-node stripes follow the rounded corners.
- Command menu: one tile size, disabled rows fade their tile, a selected row's tile sits on its hue;
  section headers align to the tiles' leading edge (palette, address hero, welcome panel).
- Text on hue capsules and ref pills reaches 4.5:1 in every theme; high-contrast dark tile symbols
  are never dimmer than standard dark.
- Truncated, Pending and root badges use the warning colors; find highlights use `accentSubtle`;
  listing rows: the program counter uses the current-line band, tagged rows show only their bar.
- Midnight success `#5FD68F` (was neon) and an amber warning ground; raised fields in the watch,
  replace and commit fields; watch types in their own column.
- Icon-only buttons have a 24 pt hit area (table filters, collection modes, row remove buttons,
  disclosure, copy, rule editor +/−); typographic apostrophes in user-facing text.


### Breaking
- `LumenIconRole` gains `.section` (a section-heading tile, held to `tileSection`, 28 pt). A `switch`
  over `LumenIconRole` needs the new case. Lumen's inspector, sidebar and stacked-pane section tiles
  use it, so the icon-scale check holds them to 28 pt rather than the 16 pt inline floor (dot review
  gap 2).

### Added
- Column overflow is checked automatically (PRINCIPLES §6). Every Lumen column container reports
  content wider than itself, which SwiftUI centers and clips on both edges with no label shortened
  (Workbench's Types inspector): `LumenInspector` (so `.lumenInspector` and `LumenInspectorPane`),
  `LumenWorkspaceWindow`'s sidebar, content, inspector and bottom regions, `.lumenColumn` /
  `.lumenSidebarColumn` split-view columns, `LumenSplitEditor` panes, `LumenStackedSidebar` panes
  and `LumenSheet` content. Reports go through the new `LumenColumnOverflowKey`
  ("“Inspector” content is N pt wider than its column"), and `LumenConformance.overflow`,
  `.truncation` and `.workspaceWindow` all surface them. Measured at placement by a pass-through
  layout, so layout is unchanged and flexible content never reports. `.lumenColumnContent(_:)`
  marks an app's own column. Tests: `LumenColumnOverflowTests`.
- `.lumenIconOnlyControl(_:)` (PRINCIPLES §7): a button whose label is only an icon reports, through
  `LumenIconScaleKey`, when its hit area is under `metrics.layout.minimumHitTarget`;
  `LumenConformance.iconScale` and `.workspaceWindow` fail on it. On Lumen's panel toggles, the new
  button, sidebar-section and stacked-pane header actions, panel-bar icon actions, glyph buttons
  (table footer +/−, rule rows), code-pane actions, and every `LumenToolbarIconButtonStyle` button.
  A source scan (`LumenIconOnlyControlTests`) fails on a `Button` whose label is a bare
  `Image(systemName:)` / `LumenSymbol(` without the marker or `.labelStyle(.iconOnly)`; seven
  undersized buttons are allow-listed, fix pending (filter toggles and collection-mode buttons
  22×22, two hover remove buttons, the variable disclosure 16×16, the stepper halves 15×11, the
  inspector copy button 20×20).
- `LumenConformance.surfaceSteps(sizes:variant:registry:headerHeight:of:)`: also compares the top
  `headerHeight` band's flat background with the body's and reports "the header's surface differs
  from the pane's" (distance ≥ 3). Opt-in, since full-width bands are legal.

### Changed
- `LumenConformance.surfaceSteps` renders the pane in a real offscreen window (the one the layout
  checks use) and captures it with `cacheDisplay`, so AppKit-backed SwiftUI (List, Table, text
  views) is scanned as shipped; `ImageRenderer` is the fallback when the capture draws nothing.
  Unknown-token reporting is unchanged. A List with a tinted leading column is now reported
  (`ImageRenderer` drew nothing for it).
- The surface scan's window is now color steps of 2…60 (was 3…40).

### Validator
- The new column-overflow and icon-only reports can flag an app's existing views in its
  `overflow`/`truncation`/`workspaceWindow`/`iconScale` tests. Lumen's own: the rule editor's +/−
  row buttons are 26×22 (allow-listed in `LumenGoldenTests` and `LumenCatalogRuleTests`, fix
  pending).

## 0.42.2 (2026-10-13)

Rulings on Workbench's 0.42.1 conformance reports.

### Added
- `.lumenNeverTruncates(_:minimumScale:)`: a label may shrink to its `minimumScaleFactor` to fit;
  only cut short at that scale is it reported. The inspector summary's title and stats use it.

### Fixed
- A hidden workspace region (kept mounted at zero size) no longer reports truncation, icon scale or
  overflow: its content isn't on screen.
- `LumenTableText`'s 8-character floor no longer reports a short cell shown in full ("Find Nex…" is
  wider than "Find Next"); text within two characters of the floor must show in full instead.

## 0.42.1 (2026-10-13)

### Fixed
- A `LumenTable` never grows past its container. Before it had measured itself, its columns'
  minimum widths pushed it wider than its container, and it then measured that inflated width:
  Workbench's Types inspector (a members table needing ~272 pt in ~259 pt) clipped on both edges.
  Minimums now apply only to the measured widths, which yield when there's no room. Test:
  `LumenTableFitsItsContainerTests` (fails at 272 pt on 0.42.0).

## 0.42.0 (2026-10-13)

Visual-quality improvements: three audits (code consistency, every golden, rule coverage),
fixes and design refinements. 190 goldens re-recorded after review.

### Added
- `LumenElevation` (`.lumenElevation(.menu/.popover)`): the one shadow, for floating surfaces.
- `LumenGlow` (`.lumenGlow(.hero/.selection, color:)`): light behind a hero tile or a selected node;
  a glow is light, not depth (PRINCIPLES §7).
- `.lumenTileBacklight()`: backlit tile buttons; on in tool and mode
  switchers and toolbar tiles.
- Tile tokens on `LumenMetrics.Layout`: `tileCompact` 16, `tileMenu` 18, `tileRow` 20,
  `tileRowDetailed` 26, `tileProminent` 32, `tilePaneHeader` 40, `tileHeroCompact` 56, `tileHero`
  64, `tileWelcome` 72; `disclosureGlyph` 8.
- `.lumenFixedContainer(_:)` and `LumenConformance.overflow(sizes:of:)`: a fixed-size container
  reports content it clips.
- `LumenSheet` and `LumenTableText` minimum: `LumenTableText.minimumVisibleCharacters` (8).
- `LumenThemeStore.unknownTokens` and `LumenSnapshot.render(…)`.

### Visual
- Decorative drop shadows removed (mode-switcher plate, graph nodes, gallery and tab cards,
  carousel arrows); floating surfaces share one tight shadow; the hero glows stay.
- Fields sit on the raised surface (white in light, a step up in dark), like native fields; keycaps
  have a hairline edge.
- Midnight's accent is violet (`#A06BFF`), distinct from its danger red; the light
  warning tint is amber (`#FBF0D4`).
- Tiles by token: header tiles at the header scale, section and switcher tiles at 28, mode tiles
  shown without labels at 28; a few rows move to the nearest token (24 → 26, 30 → 28, 36 → 40).
- One-line list rows follow density (debugger, forms, search, collection, completion rows: 26 pt
  at regular).
- Inspector section tiles clear their dividers; swatches align to the value column; the toolbar
  breadcrumb drops its trailing "/"; placeholder app icons draw a symbol, not an empty square;
  selected history rows keep tags and avatars readable; letters on hues (avatars, completion
  kinds) pick white or near-black for 3:1.
- `LumenStatsCard` keeps its natural height, so values no longer shrink.

### Validator
- Every Catalog page and inspector runs through `truncation`, `iconScale` and `overflow`; every
  golden runs the same checks; source scans fail on unmarked one-line labels and on public views
  nothing exercises.
- `LumenTableText` reports a cell showing fewer than 8 characters, or a column squeezed to nothing;
  `LumenTable` carries row reports out of its lazy stack.
- `surfaceSteps` reports tokens the registry doesn't know (pass the app's registry) and uses a fixed
  12 pt edge threshold, so an inset band in a tall pane still counts.

### Fixed
- Primary labels marked never-truncate across the toolbar, welcome, sheets, collection rows, graph
  nodes, stacked panes, panel tabs and the inspector header.
- `LumenShowcase` rendered `lumen.*` symbols blank.


## 0.41.1 (2026-10-12)

### Visual
- `lumen.*` symbols are outlines beside text and filled on tiles, as Apple pairs them:
  `LumenSymbol` draws the outline form (`doc`, `eye.slash`, `square.stack.3d.up`,
  `circle.and.line.horizontal`, `point.3.connected.trianglepath.dotted`, and a new outline
  `lumen.breakpoint`), and `LumenIconTile` asks for the filled form (`.symbolVariant(.fill)`, the
  new `lumen.breakpoint.fill`). Tiles look as in 0.41.0; inline rows no longer mix solid and outline
  icons.

## 0.41.0 (2026-10-12)

Every Lumen glyph now draws as an SF Symbol.

### Added
- Five custom SF Symbols in LumenUI's asset catalog (`Sources/LumenUI/Resources/Symbols.xcassets`):
  `lumen.patchedBytes`, `lumen.colorMix`, `lumen.token`, `lumen.breakpoint`, `lumen.anonymize`.
  They're variable templates built from Apple's own symbol geometry and stem weights, so they
  interpolate through all nine weights and sit with SF Symbols. `Design/symbols/gen.py`
  regenerates them; Apple's asset compiler validates them.
- LumenUI now has a resource bundle (`Lumen_LumenUI.bundle`). Xcode and SwiftPM embed it with the
  package; nothing to do in an app.

### Visual
- `LumenSymbol` and `LumenIconTile` draw every `lumen.*` name as a symbol: one of the five custom
  symbols, or an SF Symbol equivalent (`lumen.axialSlice` now draws
  `circle.and.line.horizontal.fill`). Symbols follow the current font's size and weight like any
  SF Symbol. `LumenGlyphView` still draws the original paths for apps that call it directly.


## 0.40.0 (2026-10-12)

An app review found: tiles too small, blotchy glyphs, poorly designed icons, a
stair-stepped editor background. The fixes are rules with checks, so no app adopting Lumen can
bring them back (PRINCIPLES §7 and §8), and a new icon tile built from Apple's guidance.

### Visual
- **Icon tiles redrawn**: an SF Symbol sized like System Settings' (its box is 64% of
  the tile), drawn by the system so it's sharp at every size. Light: the hue as the tile with a
  gentle gradient and a white symbol. Dark: a slate tile with the symbol in its hue, lifted until
  it reads at 3:1. Depth from material only: each shape's gentle gradient and a soft hairline rim
  along the top; no shadows. Lumen glyph names with an SF Symbol equivalent draw it
  (`lumen.disassembly` → `text.alignleft`, `lumen.pseudocode` → `curlybraces`, `lumen.callGraph`
  → `point.3.filled.connected.trianglepath.dotted`, `lumen.crossReference` →
  `arrow.left.arrow.right`, and others); the rest keep their Lumen drawing until they're redrawn as
  custom SF Symbols.
- **Tile scale**: `LumenSidebarSwitcher(.tiles)` tiles are 28 pt, the header tile's size
  (`tileTool`); `LumenInspectorSection` tiles are 28 pt (`tileSection`) and its rows grow to fit.
  Re-record goldens that show them after review.
- Unselected tiles in `LumenSidebarSwitcher` and `LumenModeSwitcher` keep their full color; the
  plate marks the selection.
- Lumen glyphs under 24 pt draw no tint layer (`LumenGlyph.tintMinimumSize`); it read as smudges.
- `LumenTableColumn.minWidth(_:)`: the least width of a shared column, so it keeps a readable share
  when the table is narrow.
- `LumenTableColumn.header { … }`: draws a column's header as a view (a glyph); the title stays its
  accessibility label and help tag.
- `LumenTableColumn.priority(_:)`: the order shared columns give up width (higher keeps its width
  longer; default 0).
- `LumenSheet(_:subtitle:systemImage:hue:status:done:content:)`: a browse-only sheet with one
  primary action and no Cancel; Return and Esc both trigger it.
- Tile-scale metrics on `LumenMetrics.Layout`: `tileHeader` (28), `tileInspectorHeader` (32),
  `tileTool` (28), `tileSection` (28), `tileMode` (22).
- `LumenIconRole` and `.lumenIconRole(_:)`: whether a tile is a whole control or beside its text.

### Validator
- `LumenConformance.iconScale(sizes:of:)` (PRINCIPLES §7): a control tile smaller than `tileTool`
  or an inline tile under 16 pt fails; `.workspaceWindow` reports them too.
- `LumenConformance.surfaceSteps(sizes:of:)` (PRINCIPLES §8): fails where two flat background
  colors meet at a vertical edge inside a pane, such as a tinted gutter or an inset band.

### Visual (tables)
- Table-wide column widths: `LumenTable` measures each shared column's natural one-line width
  across its header and rendered rows and gives the header and every row the same widths. No
  column cuts its text while another has slack; short of room, columns shrink from the lowest
  priority up, each to its `minWidth`, and only then below their minimums. Shared columns no
  longer split the width equally in a live window. Offscreen renders (goldens) keep the equal
  split, so no golden moves.
- `LumenTableText` ends long text in an ellipsis at the tail and shows it in full as a help tag.

### Fixed
- Each `LumenTable` row is its own accessibility element and keeps its cells addressable, so an
  editable cell in a row stays reachable.

## 0.39.4 (2026-10-12)

### Fixed
- `LumenPopUp` is never narrower than its widest option (`width:` is now a minimum), so no choice is
  cut short: Workbench's "doesn't contain" was, in `LumenRuleEditor`'s fixed 116 pt comparison
  pop-up. The rule editor sizes its comparison pop-ups to the widest operator across all fields, so
  value fields still line up row to row. Review the `editors` golden.

## 0.39.3 (2026-10-12)

### Added
- More primary labels follow the no-truncation rule (`.lumenNeverTruncates`): badges, section
  headers, tabbed-box tabs, table column headers, pop-up titles, command palette titles, detail
  header titles, integration names, master-list items and the font picker's family. Titles that
  wrap (`LumenSheet`'s, empty states) aren't marked: they never truncate. Names that truncate in
  the middle by design (file names in lists, paths) stay unmarked.

## 0.39.2 (2026-10-12)

From the first live look at Workbench on 0.39.1: the split view drew under the top bar (the tool rail
and the editor and inspector headers were hidden), and the breadcrumb was cut short.

### Fixed
- The top bar of `LumenWorkspaceWindow` and `.lumenTopBar` is a real row above the content, which is
  clipped to the space under it. A safe-area inset had let AppKit-backed split views draw under it.

### Added
- No-truncation rule: `.lumenNeverTruncates(_:)` marks a one-line primary label (Lumen's breadcrumb,
  mode-switcher labels, filter chips, document tabs, section titles and panel-bar actions use it);
  the label reports itself when cut short. `LumenConformance.truncation(sizes:of:)` checks any pane,
  sheet, settings page or window, and `.workspaceWindow` now reports cut-short labels and any panel
  that starts under the top bar, besides a moved bar.
- `LumenWorkspaceWindow.panelShortcuts(_:)`: the shortcuts the panel toggles' help tags name, for an
  app whose View menu uses its own or the user's rebound set (Workbench's ⌃⌘Y bottom panel).
- `LumenWorkspaceWindow.columnWidths(sidebar:inspector:)`: the app's own column widths.

## 0.39.1 (2026-10-12)

### Added
- `LumenWorkspaceWindow.bottomPanelToggle(_:)`: the bottom toggle and ⇧⌘Y for a bottom panel the
  content draws itself (Workbench's debugger and shell deck, built from state its editor owns). The
  window adds no bottom region for it.

## 0.39.0 (2026-10-12)

From an app review on 0.38: the window must stay intact whatever panels show, the
toolbar must be readable, and the warmth and starfield interaction must come back.

### Added
- `LumenWorkspaceWindow(panels:content:sidebar:inspector:bottom:topLeading:topCenter:topTrailing:)`
  with `LumenWorkspacePanels`: the workspace window as one component. The top bar is pinned in the
  window's top safe area; every region stays mounted, collapses to zero while hidden, and is clipped,
  so no region can ask for more height than the window has; the left, bottom and right panel toggles
  sit at the bar's trailing edge with their View menu commands. A window without a region leaves its
  toggle out.
- `LumenConformance.workspaceWindow(sizes:panels:window:)`: lays the app's window out in a real
  window at each size and every panel combination and reports a top bar that moves, changes height
  or isn't Lumen's. Hiding Workbench's inspector once pushed its top bar off screen; this catches it.
- `LumenAmbientWash` and `.lumenAmbientWash(_:strength:)`: a faint accent tint over a window
  (`.rising`, `.falling`, `.pooled`). `LumenWorkspaceWindow` uses `.falling` by default
  (`.ambientWash(_:)` to change it).
- `.lumenRendersOffscreen(_:)`: an app's own snapshot harness can render Lumen components the way
  golden images do.

### Fixed
- `.lumenTopBar` pins the bar the same way, so content that grows can no longer push it off screen.
- `LumenEmptyHero`'s starfield leans toward the pointer anywhere over the hero and surges while the
  primary action is hovered, as Workbench's welcome did before 0.28.

### Visual
- `LumenModeSwitcher` is offered its width before flexible neighbors, so labels show whenever the
  bar has room (Workbench's top bar had collapsed it to glyphs at every width). `.tiles` draws 22 pt
  tiles (18 before), unselected ones less faded, and every style's targets are the toolbar's 28 pt.
  Review `mode-switcher`, `code-pane`, `settings-rich` and `strings-navigator` goldens.

## 0.38.2 (2026-10-12)

From a live check of Workbench on 0.38.1 in Midnight, Scope (light and dark) and Contrast.

### Added
- `LumenTextField(_:text:monospaced:onSubmit:)`: a one-line field in Lumen's field chrome whose focus
  shows `border.focus` (the theme's accent) instead of the system ring. For inspector and form fields.

### Visual
- `LumenThemeGallery`: the extra-surface choice ("Editor theme: Same as window") is a `LumenPopUp`-style
  menu instead of a tinted system picker; the action links wrap as whole items instead of breaking
  "Customize Midnight…" across two lines.
- `LumenCodeFontPicker`: the family is a Lumen pop-up and the size a `LumenNumberField` with "pt",
  matching the rest of a settings pane.

## 0.38.1 (2026-10-12)

### Added
- `LumenPack.retiredKeys`: theme-file keys an app retired with no successor (Workbench's
  `graph.edge.*`, `welcome.accent`). The registry merges them (`LumenRegistry.retiredKeys`), the
  validator no longer reports them as unknown, and the exported schema lists them, and renamed
  keys, as deprecated. A key can't be both retired and renamed, or retired and registered.

## 0.38.0 (2026-10-12)

A polish pass over the whole system.

### Visual
- Fields, pop-ups and cards share one chrome each: fields in `bg.inset` with a `border.default`
  hairline (`border.focus` at `stroke.regular` when focused), pop-ups and pull-downs in `bg.elevated`
  with `border.default`, cards in `bg.elevated` with `border.subtle` at the large radius. The pull-down
  and combo field move from `border.subtle` to `border.default`; the tabbed box's box matches the
  table and settings cards. Review `controls` and `editors` goldens before recording.
- One-line fields and pop-ups are `LumenMetrics.Layout.controlHeight` (22 pt) tall everywhere.
- `LumenTable` rows and header follow density (`rowHeight(in:)`), so Compact and Comfortable apply.
- Menus with a Lumen-drawn label (pop-ups, pull-downs, the inherited picker, font picker, comparison
  header, find scope, combo suggestions, type chips, ⋯ menus) now render that label faithfully live;
  the borderless menu style had been redrawing it. Each is one accessibility element, with the
  decorative chevron hidden.
- Carousel arrows sit over a fade into the canvas, and Previous hides at the start. Tabs that
  overflow a tab bar fade out at the trailing edge instead of ending in a hard cut.
- Disabled controls fade by `Layout.disabledOpacity` (0.45) and hover fills use
  `Layout.hoverOpacity` (0.6) throughout; strays at 0.5–0.7 are gone. Literal radii and strokes in the
  newer components now come from metrics, and the color well's ring and swatch-strip edge use theme
  borders instead of white.
- The completion list honors `maximumRows` in snapshots too.

### Added
- `LumenPopUp(selection:options:title:width:)` and `LumenPopUpLabel` are public: Lumen's pop-up look
  for apps.
- `.lumenToolbarIcon` and `.lumenTinted` button-style shorthands.
- `LumenMetrics.Layout.controlHeight`, `disabledOpacity`, `hoverOpacity`.
- `Sendable` on `LumenPanelTab`, `LumenSidebarItem`, `LumenDocumentTab`, `LumenRecentItem`.
- The Catalog has pages for everything added in 0.29–0.37 (Forms & Controls, Search & Navigation,
  Data & Git, Browse, Workspace) and a scoped command palette; the README has a component index and
  the architecture table covers the new files.

## 0.37.1 (2026-10-12)

### Visual
- `LumenThemeMiniature` (and so `LumenThemeGallery`) shows a few lines of code in the theme's syntax
  colors, with the current line and a selection, when the registry includes the code pack. Apps
  without `.code` see no change. Review golden images of theme galleries before recording.

## 0.37.0 (2026-10-12)

### Added
The last of Nova's second pass (#43–48):
- `LumenColorWell` (a square swatch with a hairline ring that opens the color panel) and
  `LumenColorGrid(rows:columns:color:)` (ANSI Colors × Normal / Bright).
- `LumenSwatchStrip` (with `image(_:)` for menus), `LumenSwatchMenuLabel` for native menu items, and
  `LumenIconPicker(selection:choices:size:actions:)` with `LumenIconChoice`: a large icon whose
  chevron opens a grid plus actions.
- `LumenWizardStep` with `LumenWizardChoice`: a sheet step picking one thing from large-icon rows,
  "Step 1 of 2", Cancel / Back / Next. Alert-style form sheets are `LumenSheet` with the primary
  action disabled until the form is valid.
- `LumenFieldList`, `LumenFieldRow` (`text:prompt:secure:` or any control) and `LumenInlineField`:
  an item's tile and title over a settings card of label / value rows.
- `LumenPermissionsGrid(mode:)`: Read / Write / Execute × User / Group / World with an editable octal
  field and the rw-r--r-- form (`octal`, `symbolic`, `mode(from:)`).
- `LumenManagedToolRow` with `LumenToolInstallState`: package icon, name and version, Install
  capsule, ⋯ menu and a description with a link.
- `LumenSettingsRow(_:description:badge:control:)`: a small glyph after the title saying where the
  value comes from ("Set by .editorconfig").

## 0.36.0 (2026-10-12)

### Added
From Nova's second pass (#38–42):
- `LumenKeyValueEditor(entries:typed:emptyMessage:onRestoreDefaults:)` with `LumenKeyValue` and
  `LumenValueType`: keys and values on a `LumenTable` card; the selected row's cells become fields, and
  typed editors show the type as a tinted chip that opens the type menu.
- `LumenRuleEditor(match:conditions:fields:comparisons:)` with `LumenRuleMatch` and
  `LumenRuleCondition`: "[Any] of the following are true" over predicate rows with − and +.
- `LumenSlider(value:in:step:ticks:endLabels:showsField:unit:width:)`: a themed slider with optional
  ticks, end labels and a linked value field.
- `LumenComboField(text:suggestions:prompt:monospaced:)`: type a value or pick a suggestion.
- `LumenPullDownButton(_:systemImage:menu:)`: a glyph and chevron in a quiet capsule opening an
  action menu. Menu section headers are SwiftUI's `Section("Title")`.

### Fixed
- `LumenTableColumn.text` is main-actor isolated, so strict-concurrency clients build without warnings.

## 0.35.0 (2026-10-12)

### Added
From Nova's second pass:
- `LumenTabbedBox(selection:tabs:style:title:content:)`: a segmented strip on the top edge of a
  bordered box (`.box`), or centered over a hairline at the top of a sheet (`.header`).
- `LumenRadioGroup(selection:options:title:detail:)` and `LumenRadioButton`: round radios drawn like
  `.lumenCheckbox`; an option's detail sits indented under it, enabled only while it's chosen.
- `LumenTable(_:selection:emptyMessage:footer:minHeight:columns:)` with `LumenTableColumn` (any cell
  view, or `.text(…, monospaced:)`), `LumenTableText` and `LumenTableFooter` (+ − ✎ and a trailing
  text action): a card like `LumenSettingsCard` with quiet small-caps headers and row hairlines.

## 0.34.3 (2026-10-12)

### Added
- `LumenStatusStrip` actions take `LumenBarAction`'s identifier and its new `help`
  (`LumenBarAction(…, help:accessibilityIdentifier:)`); `LumenStripStatus(…, spokenLabel:spokenValue:accessibilityIdentifier:)`
  gives the status its own identifier and speech. `LumenPanelBar` uses `help` too.
- `LumenSheet(…, cancelAccessibilityIdentifier:…)`; the primary button takes its identifier and help
  from `LumenBarAction`.
- `LumenConsole(lines:prompt:)`: a read-only transcript with no input row.

## 0.34.2 (2026-10-12)

### Added
- Accessibility identifiers for UI tests: `LumenSidebarItem(…, accessibilityIdentifier:)`
  on each pane button, `LumenBarAction(…, accessibilityIdentifier:)` on panel-bar and empty-hero
  actions, and `LumenEmptyHero(…, primaryIsDefault:identifiers:)` with identifiers for the hero
  (stable whether or not it scrolls) and its recents card.
- `LumenEmptyHero(…, primaryIsDefault: false)` stops Return from running the primary action when the
  window has other fields Return belongs to.

## 0.34.1 (2026-10-12)

### Visual
- `LumenEmptyState`'s action link sits back under the message at the 0.2 spacing (4.5 pt closer),
  and the stack re-centres to match. Its 24 pt hit area still applies but no longer adds height.
  Apps whose goldens were recorded on 0.2.x match again; goldens recorded on 0.4–0.34 with an
  action button move.

## 0.34.0 (2026-10-12)

### Added
- `LumenToolbarBreadcrumb(_:systemImage:hue:activity:onCancel:)`: a live segment after the path while
  work runs ("Indexing Files… 16 of 92"), with a progress ring and an inline stop button.
  `LumenProgressRing` draws determinate and spinning rings.
- `LumenTabOverview` and `LumenOverviewTab`: every tab as a thumbnail, the current one ringed.
- `LumenChecklistTree`, `LumenChecklistNode`, `LumenCheckState`: checkboxes in a tree, mixed when a
  folder's files differ, with status glyphs.
- `LumenCommitComposer`: a commit message with a first-line count, Amend, avatar and Commit (⌘↩).
- `LumenFontPicker`: family (each shown in its own face), style, size and Options….
- `LumenFilterChips(selection:groups:title:count:)`: chips in groups split by hairlines, with counts.
- `LumenCodeSample` and `LumenStatusRow`: terminal-style command samples, and a label with a value
  and an action.
- `LumenCarousel`, `LumenItemCard`, `LumenItemState`: store sections of sideways-scrolling cards with
  Install, Installed or progress.
- `LumenDetailHeader`: an item page's header with categories, meta, links, permissions, an action
  and Share.

All 34 capabilities from the Nova study are now in Lumen.

## 0.33.0 (2026-10-12)

### Added
- `LumenSidebarPaneGrid`: every sidebar pane as a tile grid with the docked ones checked. Click to dock or undock, or drag a tile onto `LumenSidebarSwitcher`, which now takes
  dropped panes. `LumenToolLayout` gains `show(_:)` and `dock(_:before:)`.
- `LumenShortcutRecorder`: records a shortcut into a field of keycaps. Escape
  cancels, Delete or ⊖ clears, and a conflict shows a warning. Shortcuts need ⌘, ⌃ or ⌥, except
  function keys.
- `LumenCompletionList`, `LumenCompletion`, `LumenCompletionKind`: a completion popup's list with
  lettered kind badges, the typed prefix in bold accent and types on the right.
- `LumenCollection`, `LumenCollectionControls`, `LumenCollectionItem`, `LumenCollectionMode`,
  `LumenCollectionSort`: a zoomable grid of tiles or a list sorted by its column headers, with
  collapsible groups (Nova's Launcher).

## 0.32.0 (2026-10-12)

### Added
- `LumenNotice`, `LumenNoticeCard` and `.lumenNotices(_:)`: notification cards stacked at the window's
  top trailing corner, with a quiet action and one accent action under the text.
- `LumenOutlineControls` and `LumenOutlineMode`: tree or list, depth as level pills 1–4 and alphabetical sorting. `LumenOutlineDepth.collapsedIDs(_:showing:)` opens a tree to a depth.
- `LumenHistoryRow`, `LumenRefPill`, `LumenRefKind`, `LumenAvatar`: commits with a rail, short hash,
  tinted ref capsules, time and an avatar whose hue is stable per name.
- `LumenComparisonHeader`, `LumenComparisonSide`, `LumenDiffNavigator`: side-by-side comparison
  headers with version menus, and a ‹ "2 of 5" › change navigator with an ignore-whitespace toggle.
- `.lumenFloatingStatus(content:folded:)`: the editor's status as a floating pill that folds when narrow.
- `LumenMinimap`: the document in miniature with a draggable viewport.
- `LumenLineNumberRuler`: `breakpoints`/`disabledBreakpoints` draw accent tags over line numbers;
  `onClickLine` and `menuForLine` handle clicks and the right-click menu.

## 0.31.0 (2026-10-12)

### Added
- Settings search finds individual settings: `LumenSettingsCategory(…, settings:)` names a pane's
  settings, and the sidebar lists the matching ones under each pane.
  `LumenSettingsRow` marks itself when its title matches.
- `LumenNumberField`: a value with a stepper and unit, clamped and rounded to its step.
- `LumenSentenceRow`, `LumenSentenceText`, `LumenFlowLayout`: settings phrased as sentences with
  inline controls ("☐ Limit uploads to [500] KB/s"), wrapping in a narrow pane.
- `LumenDependentGroup`: settings indented under the one that enables them, dimmed while it's off.
- `LumenCheckboxGrid`, `LumenCheckboxItem` and `.toggleStyle(.lumenCheckbox)`: themed checkboxes, in
  columns under one label.
- `LumenInheritedPicker`: a choice that follows a default ("Global Default (HTML)") until overridden.
- `LumenSettingsCard`, `LumenIntegrationRow`, `LumenIntegrationStatus`, `LumenSwitch`, `LumenHelpButton`:
  cards of rows, integrations with status, refresh and info, a themed switch and a "?" explanation.
  The card draws hairlines between rows on macOS 15 and later.
- `LumenListEditor`: an editable list with × on hover and an inline Add row.
- `LumenMasterDetail`, `LumenMasterSection`, `LumenMasterItem`: grouped items with checks on the
  configured ones, beside the selection's settings.

## 0.30.0 (2026-10-12)

### Added
- `LumenPaletteScope` and `LumenCommandPalette(_:scopes:)`/`.lumenCommandPalette(…, scopes:)`: an Open
  Quickly. Scopes show as pills with their prefix in a keycap, and typing a prefix
  first (`/` Files, `#` Symbols) switches scope. `LumenCommand` gains `scope` and `detail` (shown at
  the row's trailing edge, a file's path, say).
- `LumenHighlightedText` and `LumenMatchStyle`: text with matches marked, by a soft amber marker
  or bold accent.
- `LumenSearchResults`, `LumenSearchFile`, `LumenSearchMatch`: results grouped by file under a summary
  ("58 results in 12 files") with expand/collapse all, each line with its number and match marked.
- `LumenFindPanel`, `LumenFindQuery`, `LumenFindMode`: find and replace with a scope menu, match mode,
  case toggle, Replace All and Find.
- `LumenInputPalette`, `.lumenInputPalette` and `.lumenGoToLine`: the palette's shell asking for one
  value; Go To Line takes "12" or "12:30" (`LumenGoToLine.parse`).

## 0.29.0 (2026-10-12)

### Added
- `LumenSplitEditor` and `LumenEditorLayout`/`LumenEditorPane`: editor panes side by side, each with
  its own tab bar, Close Split, Magnify Split and New Split, and dividers that drag down to a minimum
  pane width. The focused pane's active tab carries the accent, and the others go quiet and dim
 . Every edit is a method on the layout: open, close, close others, close all, pin,
  move across panes, split and close a pane.
- `LumenDocumentTab`: `isPinned` (pinned tabs come first with a pin glyph and survive Close Others
  and Close All), `accent` for a tab kind's own line (a terminal in teal) and `path`.
- `LumenTabActions`: the tab context menu (Close Other Tabs, Close All Tabs, Pin, Copy Path,
  Duplicate Tab in Split On Left/Right) and drag-and-drop of tabs between bars.
- `LumenStackedSidebar` and `LumenStackedPane`: several panes in one sidebar under tiled,
  collapsible headers with counts and actions, sharing the height through drag grips.

### Fixed
- Golden images draw document tabs. Drop targets, drag sources, context menus and the scrolling
  tab row are left off offscreen, where they rendered as placeholders.

## 0.28.0 (2026-10-12)

### Visual
- Code text in the debugger, listing, pseudocode, hex, graph, inspector and sheet pieces falls back to
  `LumenCodeFont.standard` (12pt) when no code font is set, instead of hard-coded 10–11.5pt sizes.
  Secondary code text keeps its step down from the primary size.
- `LumenVariableRow`: names of up to 10 characters never shorten; a long value gives way first.

### Added
- `LumenSheetStatus(_:token:)`: a sheet status colored by a `LumenToken`, matching `LumenStripStatus`
  and `LumenBreakpointRow`.

### Fixed
- Catalog's Editor page reads its colors from the palette environment, as the rest of the Catalog does.

## 0.27.0 (2026-10-12)

### Added
- `LumenStringRow`: a string in a strings navigator, with the literal over its address, section and
  length.
- `LumenStringLiteral`: string text in `syntax.string`, with escapes in `syntax.keyword` and format
  specifiers in `syntax.number`.
- Catalog: Debugger, Editor and Sheets & Settings pages with every Workbench piece from 0.15 on, live.
  The Catalog's registry now includes the code pack.


## 0.26.0 (2026-10-12)

### Added
- `LumenInspectorSummary`: the card at the top of an inspector, with a kind chip, the identity large
  and copyable, a link to what it belongs to, a detail line and counts.
- `LumenReferenceRow`: a cross-reference or caller as a link that shortens in the middle, with its
  kind as a tag.


## 0.25.0 (2026-10-12)

### Added
- `LumenListingRowState` and `.lumenListingRow(_:)`: a listing row's fill and leading bar, resolved
  in a fixed order (selection, program counter, patch, tag, current block). The selection is a tint,
  so syntax colors stay readable.
- `LumenBranchLanes` and `LumenBranchLane`: jump arrows in a listing's gutter. Short jumps sit
  nearest the text so nested ones never cross, and jumps touching the selection are highlighted.
  It draws the visible window of a lazily scrolled listing.
- `LumenProgramCounterMarker`: the debugger's amber arrow for a gutter.


## 0.24.0 (2026-10-12)

### Added
- `LumenSettingsPane(…, style: .rich)` and `LumenSettingsPaneStyle`: a settings pane of titled
  sections under the tile header, instead of a grouped form.
- `LumenSettingsRow`: a setting's name, a one-line explanation and its control at the trailing edge.
  The control moves under the text in a narrow pane.


## 0.23.0 (2026-10-12)

### Added
- `LumenGraphNode` and `LumenGraphNodeState`: a graph block as a summary card, with its kind tile,
  name, instruction count and address range. The selection is in the accent, multi-selection is
  dashed, and a color tag draws as a stripe.
- `LumenGraphEdgeKind` and `LumenGraphEdgeBadge`: edge colors, dashes, widths and T/F badges (taken
  green, not taken red, unconditional gray, calls dashed accent).


## 0.22.0 (2026-10-12)

### Added
- `LumenStatusStrip`, `LumenStripStatus`, `LumenStripChip`: the strip over a code pane, with a leading
  control, the status as a dot and word, warning chips and icon-only commands. When narrow it folds
  to the dot.
- `LumenLineNumberRuler`: a line-number gutter for code `NSTextView`s, with the current line brighter
  on a `code.currentLine` band, plus `drawCurrentLine(in:color:)` for the text view itself.
- `LumenCodeListing` and `LumenCodeRun`: short read-only code in SwiftUI, with the same gutter and
  current-line tint.


## 0.21.0 (2026-10-12)

### Added
- `LumenSheet` and `LumenSheetStatus`: a sheet's frame, with a tile, title and context at the top,
  content that scrolls only when it must, and a footer with the status, quiet Cancel (Esc) and one
  accent primary action (Return).
- `LumenFormSection` and `LumenFormRow`: uppercase-titled groups of labeled fields for sheets.
- `LumenProcessList` and `LumenProcess`: running processes as rows, each with a tile, name, path, a
  root badge and the PID. Double-click activates.


## 0.20.0 (2026-10-12)

### Added
- `LumenVariableTree`, `LumenVariableRow`, `LumenVariable`, `LumenVariableSection`: a frame's
  variables as an outline, with depth guides, chevrons (spinner while loading, retry after a failure),
  quiet types and values on the right, in the accent when changed. In a narrow pane the type drops
  out whole first, so values are never cut off.


## 0.19.0 (2026-10-12)

### Added
- `LumenCommandField`, `LumenCommandPart`, `LumenEvaluationResult`: a debugger action as one inline
  command, with an accent verb, inputs split by hairlines and an accent button inside the capsule
 .
- `LumenWatchList`, `LumenWatch`: watch expressions as rows, each with its value and type, errors in
  red, × on hover and an inline Add row. Evaluate's caution appears as a ⚠︎ help tag.


## 0.18.0 (2026-10-12)

### Added
- `LumenHexDump`: bytes as a hex dump in the quiet style. Zeros fade, the selection is an accent block
  mirrored in the ASCII column, and shift-click extends it. Rows hold 16, 8 or 4 bytes, whichever
  fits.
- `LumenHexStyle`: the same colors, for apps with their own hex text view.


## 0.17.0 (2026-10-12)

### Added
- `LumenConsole` and `LumenConsoleLine`: a debugger console as a transcript. Commands follow an accent
  prompt, stops are blue and warnings amber, and the input line sits at the bottom. Lines wrap
  instead of truncating.
- `LumenBreakpointRow`, `LumenBreakpointMarker`: a saved breakpoint with an Xcode-style on/off marker
  and its state in a tinted capsule over its hit count. Its details expand beneath the row, and
  Edit and Delete are in the context menu.


## 0.16.0 (2026-10-12)

### Added
- `LumenStackFrameList` and `LumenStackFrame`: a call stack as numbered rows, with the selected frame
  tinted and system frames quieter.
- `LumenRegisterGrid` and `LumenRegister`: registers as cards, with changes since the last stop
  marked in the accent.


## 0.15.0 (2026-10-12)

### Visual
- `LumenEmptyState`'s message wraps in a narrow pane instead of truncating.

### Added
- `LumenSidebarCountSection`: a sidebar section with a tiled title and count, and one quiet line while
  it's empty.
- `LumenSidebarSwitcher(…, style: .tiles)` and `LumenSidebarSwitcherStyle`: each pane in its hue's
  tile, the current one raised.


## 0.14.0 (2026-10-12)

### Added
- `LumenToolbarGroup`: toolbar icon buttons that belong together in one quiet capsule.
  `LumenNavigationButtons`: back and forward as a group, dimmed when there's nowhere to go.
- `.lumenInspectorEmptyState(_:title:message:systemImage:)`: one centered message in place of an
  inspector's sections while nothing is selected.
- The Catalog's split workspace carries the grouped cluster.


## 0.13.0 (2026-10-12)

### Added
- `LumenAddressField`: a memory-address field with the `0x` prefix fixed in the accent, hex-only input,
  an accent Go button and Return, and a red hint for an address that doesn't parse.
- `LumenEmptyHero`: an empty workspace's glowing mark over a quiet starfield, one accent primary action,
  quiet secondary ones and recent items.
- Catalog: both, in the split workspace's inspector and on the States & Rows page.


## 0.12.0 (2026-10-12)

### Added
- `LumenPanelBar` and `LumenBarAction`: a panel or deck header with its title, its state in quiet text,
  quiet secondary actions and at most one primary action.
- `LumenPrimaryButtonStyle` (`.lumenPrimary`): the accent capsule a bar or pane leads with.
  `LumenQuietButtonStyle` (`.lumenQuiet`): secondary glyph-and-label actions with no fill.
- `LumenSidebarHeader` and `LumenStatsCard` / `LumenStat`: a sidebar's identity row and a card of
  counts.
- The Catalog's split workspace carries them where Workbench's pieces sit.


## 0.11.0 (2026-10-12)

### Added
- `LumenModeSwitcher`: switches between views of the same content (Workbench's Disassembly / Pseudocode
  / Graph / Hex) in a toolbar or top bar, replacing a segmented picker with the same inputs (a binding,
  the options, and each option's title, glyph and hue). Styles: `tiles` (the default:
  each mode's glyph in a colored tile, the current one raised on a card), `pill` and `underline`.
  Collapses to glyphs rather than clip; ←/→ move; no shortcuts of its own.
- The split workspace in the Catalog carries it where Workbench's picker sits.

### Validator
- `accent` as text on `accent.subtle` (4.5:1). Lumen's and Workbench's themes pass.


## 0.10.1 (2026-10-12)

### Breaking
- None that need a source change: 0.10.0 gave `LumenThemeEditor.init(base:store:)` a defaulted
  `editsInPlace:` parameter, which changed its signature; 0.10.1 restores it as an overload and the new
  parameter has no default. Code written for 0.9 or 0.10.0 compiles unchanged.

## 0.10.0 (2026-10-12)

### Visual
- `LumenTopBar` sits under the window buttons' band, as Workbench's does, with its glow reaching up
  behind them; `.lumenTopBar { }` no longer lays content out above the window's top safe area. (It
  used to share the row with the window buttons, and after a resize its content could end up partly
  above the window's top edge, cut off.) `LumenLayout.topBarHeight` is 44.
- The Catalog's sidebars are `LumenSourceList`s in the theme.

### Added
- The theme library: `renameUserTheme(_:to:)`, `updateUserTheme(_:overrides:)` (edit in place:
  the file keeps its id, name and parent) and `moveProblemFileToTrash(_:)`; the gallery's card menu
  gains Edit… and Rename…, and each file that failed to load gets Move to Trash.
  `LumenThemeEditor(base:store:editsInPlace:)`.
- `LumenThemeStore.systemColorsDidChange()`: with the system accent on, changing the accent in System
  Settings redraws at once (installed stores observe it).
- `LumenLogConsole` follows new lines as they arrive, unless a line is selected; lines are selectable.
- `Lumen.Layout` gains the detailed row heights and row paddings.
- Catalog: `LUMEN_CATALOG_LOGSTREAM=1`.

### Fixed
- Changing a motion duration retimes its curves (`fast` and `fastCurve` could disagree).
- `LumenThemeStore.withActiveStore` is task-local, so tests and previews running at once each see
  their own store.

## 0.9.1 (2026-10-12) · see tag

### Breaking
- None that need a source change. 0.9.0 gave `lumenPaletteRoot(store:)`, `LumenExport.write(_:to:)` and
  `LumenExport.builtInThemesJSON(_:)` new defaulted parameters, which changed their signatures against
  0.8.0. 0.9.1 restores those signatures as overloads and drops the defaults from the new parameters
  (`windowChrome:`, `brand:`, `galleryThemesOnly:`): calls without the new argument resolve to the
  restored functions, so code written for 0.8.0 or 0.9.0 compiles unchanged.

### Fixed
- `Scripts/api-check.sh` compares a tagged commit with the release before it (it compared a release
  tag with itself, so 0.9.0's signature changes passed its own CI run).

## 0.9.0 (2026-10-12) · `cc6aa63`

Workbench's look as Lumen's default (the title bar glow, themed sidebars and source lists), safety nets
for every change (CI, an API-break check, speed budgets), and the code and chart packs.

### Visual
- `.lumenPaletteRoot()` paints the native title bar with the theme's glow while the window is active,
  as Workbench's top bar does (`windowChrome: false` keeps the system's plain title bar). Midnight's is
  Workbench's own: `#2A0E40` → `#0E1331`.
- `LumenErrorState`'s Try Again is prominent in the theme's accent (a plain default button took the
  system's blue); Cancel is bordered.

### Added
- `LumenSourceList` (`LumenSourceListItem`, `LumenSourceListSection`): a sidebar list drawn in the
  theme, with the selection in `sidebar.rowSelected` rather than the system's blue highlight; ↑/↓,
  Home and End. `.lumenSidebarBackground()` for NavigationSplitView sidebars.
- `.lumenMenuOwnsShortcuts()`: one switch makes the menu bar the single owner of Lumen's shortcuts.
  `.lumenPaneCommands(_:selection:showsNavigator:arrangement:)`: View › Show <pane> (⌘1–9), which
  reveals a collapsed navigator.
- `LumenPack.code` (syntax, current line, selection, line numbers, diff) and `LumenPack.chart` (eight
  series at 3:1 and distinct, grid, axis, label), with values for every built-in theme. Their roles
  are namespaced (`LumenToken.Code.keyword`, `LumenToken.Chart.series`) so an app's own extension
  names never collide; the keys match Workbench's (`syntax.keyword`).
- `LumenExport.Brand` (`.app("Workbench")`) for app-branded schema and reference files.
- `.lumenCompactControl(prominent:)`, `LumenTagColor` and `.lumenTagTint(_:)`.
- CI on GitHub-hosted runners (strict build, every test but goldens, the API check);
  `Scripts/api-check.sh`; speed budgets (`LumenPerformanceBudgetTests`).

### Fixed
- The palette matcher folds ASCII directly and rejects non-matches before scoring: about 4.5× faster.
- README snippet tests build cleanly under Swift 6.1's Sendable checking.


## 0.8.0 (2026-10-12) · `1aefe20`

Shared workspace components and expanded validation for adopting apps.

### Validator
- Text on the status tints (`fg.primary` on each `status.*Background`), on the selection (`fg.primary`
  and `fg.secondary` on `bg.selected` and `bg.selectedInactive`) and `sidebar.foreground` on
  `sidebar.rowSelected`. Lumen's and Workbench's themes pass.

### Visual
- Snapshots tint native controls with the theme's accent, as `.lumenPaletteRoot()` does in a window.

### Added
- **Rows:** `LumenRowState` (`resolve(isSelected:isFocused:isHovered:isEnabled:isActiveWindow:)`),
  `LumenRowContext`, `LumenRowColors`, `.lumenRowBackground(_:context:)`, `LumenListRow`, `LumenCount`.
- **Code font:** `LumenCodeFont` (stores as `"Menlo:13"`), `.lumenCodeFont(_:)`, `LumenCodeFontPicker`;
  the log console, property values and monospaced rows follow it.
- **States:** `LumenBanner`, `LumenLoadingState`, `LumenErrorState`, `LumenProgressBar`, `LumenTone`,
  `.lumenCard()`.
- **Inline welcome:** `LumenWelcomePanel`.
- **Rearrangeable panes:** `LumenSidebarSwitcher(…arrangement:)` and `LumenToolLayout` (Workbench's
  stored form).
- **Panel decks:** `LumenPanelDeck`, `LumenPanelDeckControls`.
- Catalog: a States & Rows page.


## 0.7.0 (2026-10-11) · `d641de9`

Workspace structure, a conformance kit for adopting apps, and fixes for four shared behaviors.

### Breaking
- `lumenBottomPanel`: the content's `contentMinHeight` now always wins. When the window is too
  short to also fit the panel's `minHeight`, the panel steps aside (it used to keep its minimum and
  squeeze the content). `isPresented` doesn't change.
- `LumenPack` and `LumenRegistry` gain `renamedKeys`; a pack that renames a key to an unregistered
  token, or renames a key that's still registered, stops at launch.

### Visual
- `LumenToolbarBreadcrumb` shortens when space is tight (whole path, then the last level, then
  truncated) instead of drawing past its frame.
- `lumenToolbarDimming` no longer compounds with a disabled toolbar button's own dimming: disabled
  stays 45% overall in an inactive window (it was 25%, under the 2:1 floor).
- `LumenHueSwatchPicker` wraps onto two or three rows in a narrow column instead of clipping.
- `LumenActivityStatus` narrows (its label truncating) in a tight bar; `width` is its ideal.

### Added
- **Windows that draw their own structure** (Workbench's): `LumenTopBar` with `.lumenTopBar { }` for
  hidden-title-bar windows (window buttons centered in the bar, drag to move, double-click per System
  Settings), `LumenWindowDragArea`, `.lumenColumn(min:ideal:max:)`, `.lumenSidebarColumn()`,
  `LumenInspectorPane`, `LumenLayout.sidebarColumn`, `windowButtonsInset`, `topBarHeight`.
- **`LumenConformance`** (a library for test targets): `themes(in:themes:allowing:)`,
  `layout(windowMinWidth:columns:dividers:)`, `shortcuts(_:)`, `coverage(in:usedKeys:)`.
- **Contextual surface reads:** `store.color(_:on:)`, `store.nsColor(_:on:)`,
  `resolvedPalette(on:)`, `.lumenSurface(_:ownsEveryColor:)`, so a code editor's rows can draw window
  roles (`fg.primary`, `accent.subtle`) in the editor's theme.
- **Renamed keys:** `LumenPack.renamedKeys` and `LumenRegistry.migratingRenamedKeys(in:)`; the theme
  library loads old keys as their new roles and the validator names the new key.
- `LumenShortcuts.systemReserved` and `standardCommands`; `LumenKeycap.text(for:)` is public.
- Catalog: a Split Workspace window built like Workbench's (`LUMEN_CATALOG_SPLIT=1`), checked by
  LumenCatalogTests.


## 0.6.0 (2026-10-11) · `74eb552`

Shared design-system rules evolve independently of legacy app colors.

### Validator
- The accent must look different from the danger, success and warning colors (a warning). Lumen's
  themes pass; Workbench's Midnight, whose accent is its danger red, is flagged.


## 0.5.0 (2026-10-11) · `6c19c74`

A review pass over the whole system, and a new rule: a window can never be resized small enough
to cut its content off (PRINCIPLES §6).

### Breaking
- `LumenPanelToggle(edge:isOn:shortcut:)`: `shortcut: nil` now means no shortcut, as everywhere else.
  Leave the argument out for the standard one.
- Built-in themes and packs are checked when the registry is built: a fallback to an unregistered
  token, a fallback loop, a duplicate theme id or a missing parent stops the app at launch
  (previously a crash later, a silent black or white, or a theme that vanished).
- `LumenThemeImportError` has a new case, `didNotLoad`.

### Visual
- Midnight's danger red is `#FF5A36`; it was the accent's pink, so errors read as accents.
- `LumenLogConsole`: times are 24-hour in every locale (en_US showed 02:36 for 14:36); in a narrow
  panel the level chips become a menu.
- `LumenDocumentTabBar` scrolls when its tabs don't fit, following the selection, instead of
  clipping the leading tabs.
- `.lumenPaletteRoot()` gives the window a dark-only theme's appearance, so native text and controls
  stay legible with Midnight or Ultraviolet in Light mode.
- The welcome window's recents search is a `LumenFilterField`.
- A focused selection group whose selection isn't one of its items rings the whole group.
- The property row's copy button shows while it has keyboard focus.

### Validator
- Translucent grounds are measured composited over the canvas (a 10% white `bg.selected` was
  reported as failing); composite fallbacks respect their source's own opacity.
- Increase Contrast is checked only where a theme has its own palette for it, so issues aren't
  reported twice.
- Unknown keys get near-spelling suggestions; `lumen-theme` also flags unknown top-level fields and
  built-in ids.

### Added
- `LumenLayout.minimumWidth(of:)` and `LumenLayout.inspectorColumn`, to prove a view fits its column.
- `LumenAppearanceSettings`: density, the system accent switch and the theme gallery in one pane.
- `LumenFallback.bases`, `LumenColor.over(_:)`, `LumenTheme.unknownTopLevelKeys(in:)`,
  `LumenValidator.opaqueGround`, `LumenCommandRecents.record(_:among:)`, the `lumenStore`
  environment value.
- Keycaps name Home, End, Page Up/Down, Forward Delete, Clear and F1–F35.
- `LumenFilterField`: Escape clears, then leaves the field.
- Catalog: `LUMEN_CATALOG_COMMANDS=1`; every launch option is in the README; LumenCatalogTests.

### Fixed
- Command menu: one view owns the keyboard, so ← closes a submenu and ↓/↑ move inside it; in a
  popover (`.lumenCommandMenu`) submenus open in place instead of past the popover's edge; a menu
  whose items change while open no longer crashes on Return. The launch menu has one focus system.
- Palette: matching finds the best placement ("pan" ranks Open Panel over Span Selection) and
  ignores accents; duplicate command ids keep the first; recents drop commands that are gone; the
  highlight follows commands that change while it's open.
- Bottom panel: no dead zone after the window shrinks; the resize cursor can't stick.
- Log console: a source that's gone after Clear no longer blanks the menu and hides new lines.
- Swatch grids: ↑/↓ past the first or last row stay put.
- Welcome recents: the keyboard highlight scrolls into view and resets when a search hides it.
- Sidebar section actions draw glyph names; the log's Clear button shows a focus ring.
- Theme store: a palette can't be built from one theme and filed under another (a cross-thread
  race); a dark-only theme never takes a light value; a selection survives a reload while its file
  is broken; saving no longer reloads twice.
- Theme library: a file that fails to load keeps its id; import, duplicate and save report a theme
  that didn't load; customizing a user theme saves a standalone theme instead of stacking
  inheritance (the 9th level failed); ids starting with a dot write visible files.
- Theme editor: opacity only on tint and component roles; the checks list shows every appearance's
  issues, as Save does; validation runs once per render. The gallery caches validation and reports
  every file of a multi-file import.
- Partial themes take the default theme's tuned component values; child theme files inherit their
  parent's color space; pack values reach a variant a theme inherits.
- Snapshots stop on an unknown theme id instead of recording the default theme under its name.
- Settings: a search that hides the selected pane shows the empty state.
- `lumen-theme`: errors name the decoder's reason and go to stderr; hex values are parsed strictly.
- Catalog: windows can't be resized to clip their content; the Appearance settings work; one owner
  for ⌥⌘I.

## 0.4.0 (2026-10-05) · `f9a8b44`

From the live keyboard check with Keyboard Navigation on.

### Visual
- Buttons that are Tab stops have a 24 pt minimum hit area through `LumenPlainButtonStyle`: the
  empty state's action link re-centers slightly, and inspector section headers are a few points more
  compact.
- Lumen-drawn buttons show a focus ring when they have keyboard focus; previously none did.

### Added
- `.lumenFocusRing(cornerRadius:inset:)` and `.buttonStyle(.lumenPlain)`.
- `LumenSidebarSection(_:actions:content:)` with `LumenSidebarAction`.

### Fixed
- Invisible Tab stops: panel toggles, the new-item button, inspector section headers, the info and
  color buttons, welcome actions, launch menu rows, toolbar task buttons, the inspector toggle and
  status menus now show where focus is.
- Sidebar section header buttons were 10–13 pt targets; `actions:` draws them at 24 pt.

## 0.3.0 (2026-10-05) · `c72f771`

### Added
- `LumenAppIcon`: an app icon in macOS's icon grid from any symbol or glyph and hue.
- `LumenDockIcon.image(_:hue:)` and `.apply(_:hue:)`: the running app's Dock icon, for internal apps
  without an icon asset. The Catalog uses it.
- This changelog and release tags.

## 0.2.1 (2026-10-05) · `52b3be1`

### Fixed
- The interactive command palette builds only visible rows (`LazyVStack`); snapshots stay eager.
  Each command keeps one row view, so selection, scrolling and identity are unchanged.

## 0.2.0 (2026-10-04) · `d26ebb3`

### Breaking
- None for code written against 0.1.0.
- Workbench's pack copy: set `hidesThemes: LumenPack.core.themes.map(\.id)`. 0.2.0 adds a core theme,
  and a list of IDs would show it in the app's gallery.

### Visual
- `LumenPropertyRow`'s copy button has a 24 × 24 pt hit area.
- `LumenBadge`, `LumenPill`, `LumenEmptyState`, `LumenSymbolBadge`, the command menu and settings
  tabs draw symbols through `LumenSymbol`: identical for SF Symbol names.
- The hue picker button and swatches have 24 pt targets.
- `LumenTaskCluster` dims disabled buttons once, not twice.
- Icon tiles: a glyph's tint layer deepens the hue under white glyphs rather than lightening it.
- Standard and Midnight themes have a title bar glow, used only through `.lumenWindowChrome()` or
  `LumenTitlebarBackground`.

### Validator
- New pairs: `fg.primary`/`fg.secondary` on `bg.hover`; `sidebar.foreground` on `sidebar.rowHover`
  (an inverted sidebar must set its hover fill); `fg.disabled` at 2:1 on canvas, window and sidebar;
  disabled toolbar buttons at 2:1; text on `inspector.background`; `fg.primary` on `tab.activeFill`;
  `toolbar.foreground` on the title bar glow; text on `field.background`.

### Added
- Glyphs: `LumenGlyph` (17 two-tone symbols in Lumen, Binary Analysis and Imaging families),
  `LumenGlyphView`, `LumenSymbol`, template images, `LumenGlyph.register`. Any `systemImage` in
  Lumen accepts a `lumen.` name.
- Workspace: `.lumenWindowChrome()`, `LumenTitlebarBackground`, `.lumenToolbarDimming()`,
  `LumenToolbarBreadcrumb`, `LumenPanelToggles`, `.lumenBottomPanel` (with `contentMinHeight` and
  `maxFraction`), `LumenPanelTabs` (with `labels: .selectedOnly`), `LumenFilterField`,
  `LumenFilterChips`, `LumenTintedButtonStyle`, `LumenLogConsole`, `LumenSidebarSwitcher`,
  `LumenSidebarSection`, `LumenDocumentTabBar`, `LumenStatusBar`, `LumenStatusMenu`,
  `LumenNewItemButton`, `LumenLaunchMenu`, `LumenDropZone`.
- The Ultraviolet built-in theme.
- Tokens: `titlebar.activeTop`, `titlebar.activeBottom`, `layoutToggle.on`, `chip.selectedBackground`,
  `chip.selectedForeground`, `field.background` (all fall back; no existing color changes).
- Keyboard: `LumenShortcuts`, `LumenViewShortcuts`, `LumenViewCommands` (View and Window menu items,
  each optional), `.lumenPanelCommands`; arrow keys in selection groups; 24 pt hit targets
  throughout. See Docs/KEYBOARD.md.
- Command palette: `LumenCommand`, `LumenCommandPalette`, `LumenCommandRecents`,
  `.lumenCommandPalette` (⌘K by default).

### Fixed
- `LumenFilterField` no longer keeps the focus AppKit gives a new window's first text field.
- The command palette returns focus to the window when it closes.

## 0.1.0 (2026-10-03) · `58cee5e`

The first release: what Workbench adopted.

- LumenTokens: open tokens, packs, registry, themes with inheritance and Increase Contrast layers,
  the validator and its rule types, export, and the `lumen-theme` CLI.
- LumenUI: theme store with per-surface themes, palette environment, metrics, density, components,
  theme library, gallery and editor, snapshots.
- The expressive layer: icon tiles and the hue family, native menu labels, keycaps, the command
  menu, the settings kit, the welcome window and starfield, toolbar identity, activity status and
  task cluster, inspector panels, popovers, hue swatches.
- The Workbench pack, proven against Workbench's own colors (1,100 values), with v5's protections.
- Validator: translucent foregrounds (any token with contrast requirements) are errors, imported
  themes included, and `LumenThemeEditor.supportsOpacity` returns false for them.
