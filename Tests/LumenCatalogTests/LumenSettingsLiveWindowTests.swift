import AppKit
import SwiftUI
import XCTest
import LumenTokens
import LumenUI
import LumenConformance
@testable import LumenCatalog

/// The stock settings scaffold in a real AppKit window, including SwiftUI's bridged toolbar.
/// These checks deliberately inspect native table style, drawn pixels and toolbar geometry;
/// a scaled Catalog tile cannot establish any of those window-level properties.
@MainActor
final class LumenSettingsLiveWindowTests: XCTestCase {
    private enum Violation: String, CaseIterable, Sendable {
        case sourceList, sidebarPalette, historyGroup, controlHeights, navigationTitle, toggleCount, bandHeight, selectionPalette
    }

    private struct Observation: Sendable {
        var violations: Set<Violation> = []
        var details: [String] = []
        var description: String { details.joined(separator: "; ") }
    }

    func testFiveCategoryDrawnSettingsWindow() throws {
        try assertStock(categoryCount: 5, chrome: .drawn)
    }

    func testTwoCategoryDrawnSettingsWindow() throws {
        try assertStock(categoryCount: 2, chrome: .drawn)
    }

    func testFiveCategoryGlassSettingsWindow() throws {
        try assertStock(categoryCount: 5, chrome: .glass)
    }

    func testTwoCategoryGlassSettingsWindow() throws {
        try assertStock(categoryCount: 2, chrome: .glass)
    }

    /// A deliberately bare host reproduces the failure modes from client adoption: flat system-grey list,
    /// automatic sidebar toggle, automatic toolbar style and a category title without history.
    /// Every invariant must reject it. Keeping this fixture prevents a permissive probe (or a
    /// missing toolbar/table silently interpreted as success) from blessing the old composition.
    func testBareClientStyleHostFailsEveryWindowInvariant() throws {
        let result = try observe(BareSettingsHost(categories: categories(2)), compact: false)
        XCTAssertTrue(result.violations.isSuperset(of: [.sourceList, .sidebarPalette, .historyGroup, .controlHeights, .navigationTitle]), result.description)
        print("BARE_HOST: \(result.description)")
    }

    func testBoundSelectionAndNativeHistoryKeepWindowSizeStable() throws {
        let selection = SettingsSelectionBox()
        let root = BoundSettingsHost(categories: categories(2), selection: selection)
        try withWindow(root, compact: true, sizing: [.minSize, .maxSize]) { window, host, _ in
            let frameSize = window.frame.size
            let contentSize = window.contentLayoutRect.size
            let hostSize = host.frame.size

            @MainActor func buttons() throws -> (back: NSButton, forward: NSButton) {
                let history = try XCTUnwrap(window.toolbar?.items.first {
                    $0.itemIdentifier.rawValue.contains("lumen.settings.history")
                })
                let root = try XCTUnwrap(history.view)
                let controls = descendants(root).compactMap { $0 as? NSButton }.sorted {
                    $0.convert($0.bounds, to: nil).minX < $1.convert($1.bounds, to: nil).minX
                }
                XCTAssertEqual(controls.count, 2, "History must expose its two native action buttons")
                return (try XCTUnwrap(controls.first), try XCTUnwrap(controls.dropFirst().first))
            }

            @MainActor func assertState(_ id: String, title: String, back: Bool, forward: Bool) throws {
                let controls = try buttons()
                XCTAssertEqual(selection.value, id, "Navigation must write back to the public binding")
                XCTAssertEqual(window.title, title, "The live navigation title must follow the selected pane")
                XCTAssertEqual(controls.back.isEnabled, back)
                XCTAssertEqual(controls.forward.isEnabled, forward)
                XCTAssertEqual(window.frame.size, frameSize, "Changing panes must not resize the window")
                XCTAssertEqual(window.contentLayoutRect.size, contentSize, "Changing panes must not resize its content")
                XCTAssertEqual(host.frame.size, hostSize, "The scaffold must retain its content frame")
            }

            try assertState("engine", title: "Engine", back: false, forward: false)
            selection.value = "missing"
            settle(window: window, host: host)
            try assertState("engine", title: "Engine", back: false, forward: false)
            selection.value = nil
            settle(window: window, host: host)
            try assertState("engine", title: "Engine", back: false, forward: false)
            selection.value = "reports"
            settle(window: window, host: host)
            try assertState("reports", title: "Reports", back: true, forward: false)
            try buttons().back.performClick(nil)
            settle(window: window, host: host)
            try assertState("engine", title: "Engine", back: false, forward: true)
            try buttons().forward.performClick(nil)
            settle(window: window, host: host)
            try assertState("reports", title: "Reports", back: true, forward: false)
        }
    }

    func testTrailingControlStaysWithinBoundedRowMeasure() throws {
        let measure = SettingsRowMeasure()
        let row = LumenSettingsRow("Availability", description: "Bundled engine is ready.") {
            Button("Recheck Paths") {}
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: SettingsRowControlFrameKey.self,
                                           value: geometry.frame(in: .named("settingsRow")))
                })
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .coordinateSpace(name: "settingsRow")
        .onPreferenceChange(SettingsRowControlFrameKey.self) { value in
            MainActor.assumeIsolated { measure.frame = value }
        }
        try withWindow(row, compact: true) { _, host, _ in
            XCTAssertLessThanOrEqual(measure.frame.maxX, 480.5, "A trailing control must not float to the wide window edge")
            XCTAssertGreaterThan(measure.frame.height, 0)
            print("ROW_MEASURE: control \(measure.frame); host \(host.bounds)")
        }
    }

    func testEngineSampleControlsSharePaneTrailingEdge() throws {
        CatalogSettingsWindowReceipt.engineControlFrames = [:]
        defer { CatalogSettingsWindowReceipt.engineControlFrames = [:] }
        let root = LumenSettingsSidebarView(categories(2))
            .environment(\.measuresCatalogEngineControls, true)
        try withWindow(root, compact: true) { _, _, _ in
            let frames = CatalogSettingsWindowReceipt.engineControlFrames
            let edges = try ["Check", "Toggle", "Reset"].map { name in
                let frame = try XCTUnwrap(frames[name], "Missing live sample control: \(name)")
                XCTAssertGreaterThan(frame.width, 0)
                return frame.maxX
            }
            XCTAssertLessThanOrEqual(try XCTUnwrap(edges.max()) - XCTUnwrap(edges.min()), 1,
                                     "Check, toggle and Reset must share the pane's trailing edge")
            print("ENGINE_TRAILING_EDGES: Check \(edges[0]), Toggle \(edges[1]), Reset \(edges[2]) pt")
        }
    }

    func testLightSurfacesInBothChromeStyles() throws {
        try assertStock(categoryCount: 2, chrome: .drawn, scheme: .light)
        try assertStock(categoryCount: 2, chrome: .glass, scheme: .light)
    }

    func testStockRootOverridesSettingsPreferenceToolbar() throws {
        try withWindow(LumenSettingsSidebarView(categories(2)), compact: false, sizing: [.minSize, .maxSize], initialStyle: .preference) { window, host, _ in
            XCTAssertEqual(window.toolbarStyle, .unifiedCompact)
            XCTAssertEqual(window.contentLayoutRect.height, LumenSettingsSidebarView.stableContentHeight, accuracy: 0.5)
            let originalFrame = window.frame
            // Reproduce the real Settings scene overriding the declarative Scene style.
            window.toolbarStyle = .preference
            settle(window: window, host: host)
            XCTAssertEqual(window.toolbarStyle, .unifiedCompact)
            XCTAssertEqual(window.frame, originalFrame, "Later scene updates must not shrink the window again")
            let height = window.frame.height - window.contentLayoutRect.height
            XCTAssertLessThanOrEqual(height, standardUnifiedBandHeight())
            print("SETTINGS_SCENE_OVERRIDE: style \(window.toolbarStyle.rawValue), band \(height)")
        }
    }

    func testSidebarRemovalScopeInNativeToolbars() throws {
        for scope in RemovalScope.allCases {
            try withWindow(RemovalScopeHost(scope: scope), compact: true) { window, _, _ in
                let identifiers = window.toolbar?.items.map { $0.itemIdentifier.rawValue } ?? []
                let defaults = identifiers.filter { $0.contains("toggleSidebar") }
                print("REMOVAL_SCOPE \(scope): \(identifiers)")
                XCTAssertEqual(defaults.count, scope == .sidebar ? 0 : 1, "Removal must be scoped to the owning sidebar column")
            }
        }
    }

    private func assertStock(categoryCount: Int, chrome: LumenChromeStyle, scheme: ColorScheme = .dark) throws {
        let result = try observe(
            LumenSettingsSidebarView(categories(categoryCount), selection: "engine")
                .lumenChromeStyle(chrome),
            compact: true, scheme: scheme
        )
        print("STOCK \(categoryCount) \(chrome) \(scheme): \(result.description)")
        XCTAssertTrue(result.violations.isEmpty,
                      "\(categoryCount) categories, \(chrome): \(result.violations.map(\.rawValue).sorted()); \(result.description)")
    }

    private func categories(_ count: Int) -> [LumenSettingsCategory] {
        // Exercise the actual public-row Catalog example, not a simplified surrogate pane.
        Array(CatalogSettings.categories.prefix(count))
    }

    private func observe<V: View>(_ view: V, compact: Bool, scheme: ColorScheme = .dark) throws -> Observation {
        try withWindow(view, compact: compact, scheme: scheme) { window, host, store in
            try inspect(window: window, host: host, store: store, scheme: scheme)
        }
    }

    private func withWindow<V: View, Result: Sendable>(_ view: V, compact: Bool, scheme: ColorScheme = .dark, sizing: NSHostingSizingOptions = [], initialStyle: NSWindow.ToolbarStyle? = nil,
                                            inspect: @MainActor (NSWindow, NSView, LumenThemeStore) throws -> Result) throws -> Result {
        let store = LumenSnapshot.store(for: .init(themeID: LumenThemes.standardID, colorScheme: scheme), registry: .core)
        return try LumenThemeStore.withActiveStore(store) {
            try MainActor.assumeIsolated {
                let root = view.lumenPaletteRoot(store: store).lumenDensityRoot(store: store)
                    .lumenMetrics(.standard).preferredColorScheme(scheme)
                    .environment(\.controlActiveState, .active)
                let host = NSHostingView(rootView: AnyView(root))
                host.sizingOptions = sizing
                host.sceneBridgingOptions = [.toolbars, .title]
                let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 820, height: LumenSettingsSidebarView.stableContentHeight),
                                      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                                      backing: .buffered, defer: false)
                window.isReleasedWhenClosed = false
                window.appearance = NSAppearance(named: scheme == .dark ? .darkAqua : .aqua)
                // NSHostingView does not instantiate a SwiftUI Scene. Mirror the public
                // .lumenSettingsScene() scene contract here; all toolbar content remains stock.
                window.toolbarStyle = initialStyle ?? (compact ? .unifiedCompact : .automatic)
                window.titleVisibility = compact ? .visible : .hidden
                window.contentView = host
                window.setContentSize(NSSize(width: 820, height: LumenSettingsSidebarView.stableContentHeight))
                window.center()
                window.orderFrontRegardless()
                defer { window.close() }
                settle(window: window, host: host)
                return try inspect(window, host, store)
            }
        }
    }

    private func settle(window: NSWindow, host: NSView) {
        for _ in 0..<20 {
            (host.superview ?? host).layoutSubtreeIfNeeded()
            host.displayIfNeeded()
            window.displayIfNeeded()
            RunLoop.current.run(until: Date().addingTimeInterval(0.03))
        }
    }

    private func inspect(window: NSWindow, host: NSView, store: LumenThemeStore, scheme: ColorScheme) throws -> Observation {
        var result = Observation()
        let contentViews = descendants(host)
        let table = contentViews.compactMap { $0 as? NSTableView }.min {
            $0.convert($0.bounds, to: nil).minX < $1.convert($1.bounds, to: nil).minX
        }
        if table?.effectiveStyle != .sourceList { result.violations.insert(.sourceList) }
        result.details.append("table style: \(String(describing: table?.effectiveStyle.rawValue))")
        if table?.selectionHighlightStyle != NSTableView.SelectionHighlightStyle.none { result.violations.insert(.selectionPalette) }
        result.details.append("native selection fill: \(String(describing: table?.selectionHighlightStyle.rawValue))")

        let expected = store.resolvedColor(.sidebarBackground, for: scheme == .dark ? .dark : .light)
        let frameView = try XCTUnwrap(host.superview, "A live window must have its native frame")
        // Capture the composed, ordered native window. GPU-backed split surfaces can be
        // black in cacheDisplay even though their on-screen pixels are correct.
        let directory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
            .deletingLastPathComponent().deletingLastPathComponent().appending(path: ".build/settings-captures")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let imageURL = directory.appending(path: "live-\(UUID().uuidString).png")
        let capture = Process()
        capture.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        capture.arguments = ["-x", "-o", "-l", String(window.windowNumber), imageURL.path]
        try capture.run()
        capture.waitUntilExit()
        XCTAssertEqual(capture.terminationStatus, 0)
        let bitmap = try XCTUnwrap(NSBitmapImageRep(data: Data(contentsOf: imageURL)))
        result.details.append("capture: \(imageURL.path)")
        if let sidebar = contentViews.compactMap({ $0 as? NSSplitView })
            .first(where: { $0.arrangedSubviews.filter { !$0.isHidden }.count >= 2 })?
            .arrangedSubviews.first {
            var opaqueSamples = 0
            result.details.append("sidebar sample rect: \(frameView.convert(sidebar.bounds, from: sidebar)); capture: \(frameView.bounds)")
            let differences = [0.25, 0.5, 0.75].compactMap { fraction -> Double? in
                // Empty area below all five rows, away from selection, edges and separators.
                let point = frameView.convert(NSPoint(x: sidebar.bounds.width * fraction,
                    y: sidebar.bounds.height * (sidebar.isFlipped ? 0.85 : 0.15)), from: sidebar)
                let x = Int(((point.x - frameView.bounds.minX) / frameView.bounds.width * CGFloat(bitmap.pixelsWide)).rounded(.down))
                let yInFrame = frameView.isFlipped ? point.y - frameView.bounds.minY : frameView.bounds.maxY - point.y
                let y = Int((yInFrame / frameView.bounds.height * CGFloat(bitmap.pixelsHigh)).rounded(.down))
                guard x >= 0, y >= 0, x < bitmap.pixelsWide, y < bitmap.pixelsHigh,
                      let color = bitmap.colorAt(x: x, y: y)?.usingColorSpace(.sRGB) else { return nil }
                if color.alphaComponent >= 0.98 { opaqueSamples += 1 }
                result.details.append("sidebar sample (\(x),\(y)) RGBA: \(color.redComponent),\(color.greenComponent),\(color.blueComponent),\(color.alphaComponent)")
                return max(abs(Double(color.redComponent) - expected.red),
                           abs(Double(color.greenComponent) - expected.green),
                           abs(Double(color.blueComponent) - expected.blue))
            }
            // Permit antialiasing / colorspace rounding, not the rejected system-grey ground.
            if differences.count != 3 || opaqueSamples != 3 || differences.contains(where: { $0 > 0.045 }) {
                result.violations.insert(.sidebarPalette)
            }
            result.details.append("sidebar RGB distances: \(differences), token: \(expected)")
        } else {
            result.violations.insert(.sidebarPalette)
            result.details.append("sidebar pixel sample unavailable")
        }

        let items = window.toolbar?.items ?? []
        let sidebarItem = items.first { $0.itemIdentifier.rawValue.contains("lumen.settings.sidebar") }
        let historyItem = items.first { $0.itemIdentifier.rawValue.contains("lumen.settings.history") }
        let historyControls = historyItem.map(controlFrames) ?? []
        let sidebarControls = sidebarItem.map(controlFrames) ?? []
        let toggleItems = items.filter {
            $0.itemIdentifier.rawValue.contains("toggleSidebar") ||
            $0.itemIdentifier.rawValue.contains("lumen.settings.sidebar")
        }
        let duplicateToggle = toggleItems.count != 1
        if duplicateToggle { result.violations.insert(.toggleCount) }
        let band = window.frame.height - window.contentLayoutRect.height
        let standardBand = standardUnifiedBandHeight()
        if band > standardBand + 0.5 { result.violations.insert(.bandHeight) }
        result.details.append("toggle count: \(toggleItems.count); band: \(band) pt; unified standard: \(standardBand) pt; content: \(window.contentLayoutRect.size)")
        let historyPresent = historyItem?.isNavigational == true && historyControls.count >= 2
        if !historyPresent { result.violations.insert(.historyGroup) }
        if let toggle = sidebarControls.first, historyControls.count >= 2,
           toggle.height > 0, !duplicateToggle,
           historyControls.allSatisfy({ abs($0.height - toggle.height) <= 0.5 }) {
            // All three rendered controls share the same native height.
        } else {
            result.violations.insert(.controlHeights)
        }
        result.details.append("toolbar: \(items.map { $0.itemIdentifier.rawValue })")
        result.details.append("sidebar controls: \(sidebarControls); history controls: \(historyControls)")
        result.details.append("invalid sidebar-toggle count: \(duplicateToggle)")

        // A navigation title is permitted once beside the navigation group. It is never a
        // principal/standalone category label, and the pane header is outside the toolbar.
        let titleItems = items.filter { item in
            item.label == "Engine" || item.title == "Engine" ||
            item.view.map { descendants($0).compactMap { $0 as? NSTextField }.contains { $0.stringValue == "Engine" } } == true
        }
        let settingsTitle = items.contains { item in
            item.label == "Settings" || item.title == "Settings" ||
            item.view.map { descendants($0).compactMap { $0 as? NSTextField }.contains { $0.stringValue == "Settings" } } == true
        }
        let labeledButtons = items.flatMap { $0.view.map(descendants) ?? [] }.compactMap { $0 as? NSButton }
            .contains { $0.imagePosition != .imageOnly && ["Sidebar", "Back", "Forward"].contains($0.title) }
        let extraTitleItems = titleItems.filter { !$0.itemIdentifier.rawValue.localizedCaseInsensitiveContains("title") }
        if settingsTitle || labeledButtons || window.title != "Engine" || !historyPresent || titleItems.count > 1 || !extraTitleItems.isEmpty {
            result.violations.insert(.navigationTitle)
        }
        result.details.append("window title: \(window.title); title items: \(titleItems.map { $0.itemIdentifier.rawValue })")
        if !result.violations.isEmpty,
           let path = ProcessInfo.processInfo.environment["LUMEN_SETTINGS_DIAGNOSTICS_DIR"] {
            let directory = URL(fileURLWithPath: path, isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let imageURL = directory.appendingPathComponent("settings-\(UUID().uuidString).png")
            let png = try XCTUnwrap(bitmap.representation(using: .png, properties: [:]))
            try png.write(to: imageURL)
            result.details.append("diagnostic PNG: \(imageURL.path)")
        }
        return result
    }

    private static var measuredUnifiedBand: CGFloat?

    private func standardUnifiedBandHeight() -> CGFloat {
        if let measured = Self.measuredUnifiedBand { return measured }
        let root = Text("Standard window").frame(width: 400, height: 200)
            .toolbar { ToolbarItem(placement: .navigation) { Button("Back", systemImage: "chevron.backward") {} } }
        let host = NSHostingView(rootView: root)
        host.sceneBridgingOptions = [.toolbars, .title]
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 200),
                              styleMask: [.titled, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.toolbarStyle = .unified
        window.contentView = host
        settle(window: window, host: host)
        let height = window.frame.height - window.contentLayoutRect.height
        Self.measuredUnifiedBand = height
        window.close()
        return height
    }

    /// Native toolbar controls, not symbol ink bounds. A ControlGroup may bridge as either
    /// individual buttons or a segmented control; both expose the same rendered segment height.
    private func controlFrames(_ item: NSToolbarItem) -> [CGRect] {
        if let group = item as? NSToolbarItemGroup, !group.subitems.isEmpty {
            let frames = group.subitems.flatMap(controlFrames)
            if !frames.isEmpty { return frames }
        }
        guard let root = item.view else { return [] }
        let controls = descendants(root).compactMap { $0 as? NSControl }.filter { !$0.isHidden }
        let segments = controls.compactMap { $0 as? NSSegmentedControl }
        if let segmented = segments.first {
            let frame = segmented.convert(segmented.bounds, to: nil)
            return Array(repeating: frame, count: segmented.segmentCount)
        }
        let buttons = controls.compactMap { $0 as? NSButton }
        return buttons.map { $0.convert($0.bounds, to: nil) }
    }

    private func descendants(_ root: NSView) -> [NSView] {
        [root] + root.subviews.flatMap(descendants)
    }
}

@MainActor
private final class SettingsSelectionBox: ObservableObject {
    @Published var value: String? = "engine"
}

private struct BoundSettingsHost: View {
    let categories: [LumenSettingsCategory]
    @ObservedObject var selection: SettingsSelectionBox

    var body: some View {
        LumenSettingsSidebarView(categories, selection: $selection.value)
    }
}

/// This fixture intentionally omits the stock scaffold. Explicit plain/system-grey styling makes
/// the observed client failure deterministic across macOS's changing automatic List defaults.
private struct BareSettingsHost: View {
    let categories: [LumenSettingsCategory]
    @State private var selection: String? = "engine"
    @State private var query = ""

    var body: some View {
        NavigationSplitView {
            List(categories, selection: $selection) { category in
                Label(category.title, systemImage: category.systemImage).tag(category.id)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(nsColor: .windowBackgroundColor))
            .searchable(text: $query, placement: .sidebar, prompt: "Search")
            .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 280)
        } detail: {
            categories[0].content().navigationTitle(categories[0].title)
        }
    }
}

private enum RemovalScope: CaseIterable { case none, split, sidebar }

private struct RemovalScopeHost: View {
    let scope: RemovalScope
    var body: some View {
        NavigationSplitView {
            List { Text("Engine") }
                .toolbar(removing: scope == .sidebar ? .sidebarToggle : nil)
        } detail: {
            Text("Engine details")
        }
        .toolbar(removing: scope == .split ? .sidebarToggle : nil)
    }
}

@MainActor private final class SettingsRowMeasure { var frame: CGRect = .zero }
private struct SettingsRowControlFrameKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        // ViewThatFits also evaluates the fallback; its unplaced zero frame must not erase
        // the visible candidate's actual control frame.
        let next = nextValue()
        if next.width > 0 && next.height > 0 { value = next }
    }
}
