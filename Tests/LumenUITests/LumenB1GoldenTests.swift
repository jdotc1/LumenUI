import AppKit
import SwiftUI
import XCTest
import LumenTokens
import LumenUI


/// One new subject, in the six gallery variants. A test-local file-review fixture is captured with its
/// native title bar; recording reports review-required failures, never an automatic acceptance.
@MainActor
final class LumenB1GoldenTests: XCTestCase {
    private let directory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appending(path: "Goldens")

    func testUtilityWindow() throws {
        try XCTSkipIf(ProcessInfo.processInfo.environment["LUMEN_SKIP_GOLDENS"] == "1",
                      "Golden images are checked on the recording Mac")
        let variants = LumenSnapshot.Variant.all(for: LumenRegistry.core.galleryThemes)
        XCTAssertEqual(variants.count, 6)
        for variant in variants {
            let name = "b1-utility-window@\(variant.label).png"
            let actual = try render(variant)
            let url = directory.appending(path: name)
            if LumenSnapshot.isRecording {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                try actual.write(to: url)
                XCTFail("Recorded \(name); review this new whole-window subject")
            } else {
                let expected = try Data(contentsOf: url)
                let difference = LumenSnapshot.compare(actual, expected)
                XCTAssertFalse(difference.sizeMismatch, name)
                XCTAssertLessThanOrEqual(difference.differingPixelFraction, 0.005, name)
                XCTAssertLessThanOrEqual(difference.densestPatchFraction, LumenSnapshot.patchTolerance, name)
            }
        }
    }

    private func render(_ variant: LumenSnapshot.Variant) throws -> Data {
        let store = LumenSnapshot.store(for: variant, registry: .core)
        return try LumenThemeStore.withActiveStore(store) {
            try MainActor.assumeIsolated {
                let root = B1UtilityFixture()
                    .lumenPaletteRoot(store: store)
                    .lumenMetrics(.standard)
                    .lumenChromeStyle(.drawn)
                    .environment(\.colorScheme, variant.colorScheme)
                    .environment(\.displayScale, 2)
                    .environment(\.appearsActive, true)
                let host = NSHostingView(rootView: root)
                host.sizingOptions = []
                host.sceneBridgingOptions = [.toolbars]
                let window = NSWindow(contentRect: CGRect(origin: .zero, size: B1UtilityFixture.defaultSize),
                                      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
                                      backing: .buffered, defer: false)
                window.isReleasedWhenClosed = false
                window.appearance = NSAppearance(named: variant.colorScheme == .dark ? .darkAqua : .aqua)
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.toolbarStyle = .unifiedCompact
                window.contentView = host
                window.center()
                window.orderFrontRegardless()
                defer { window.close() }
                for _ in 0..<20 {
                    (host.superview ?? host).layoutSubtreeIfNeeded()
                    window.displayIfNeeded()
                    RunLoop.current.run(until: Date().addingTimeInterval(0.03))
                }
                XCTAssertNotNil(window.toolbar, "A utility golden includes its native toolbar")
                let frameView = try XCTUnwrap(host.superview)
                XCTAssertGreaterThan(frameView.bounds.height, window.contentLayoutRect.height)
                let captures = directory.deletingLastPathComponent().deletingLastPathComponent()
                    .deletingLastPathComponent().appending(path: ".build/b1-captures")
                try FileManager.default.createDirectory(at: captures, withIntermediateDirectories: true)
                let captureURL = captures.appending(path: "utility-\(variant.label).png")
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
                process.arguments = ["-x", "-o", "-l", String(window.windowNumber), captureURL.path]
                try process.run()
                process.waitUntilExit()
                XCTAssertEqual(process.terminationStatus, 0)
                return try Data(contentsOf: captureURL)
            }
        }
    }
}

/// Generic file metadata only: the demo never reads an external file or uses patient data.
private struct B1UtilityFixture: View {
    static let minimumSize = CGSize(width: 640, height: 400)
    static let defaultSize = CGSize(width: 1120, height: 680)

    @State private var panels = LumenUtilityPanels()
    @State private var selection: String? = "sample-01"
    @State private var sparse: Bool

    init(sparse: Bool = false) {
        _sparse = State(initialValue: sparse)
    }

    private var files: [B1DemoFile] { sparse ? Array(B1DemoFile.samples.prefix(1)) : B1DemoFile.samples }

    var body: some View {
        LumenUtilityWindow(panels: $panels, minimumSize: Self.minimumSize) {
            B1FileTable(files: files, selection: $selection)
        } sidebar: {
            LumenSourceList(sections: [LumenSourceListSection("Source Files", items: files.map {
                LumenSourceListItem(id: $0.id, title: $0.name, detail: $0.kind, systemImage: "doc", hue: .hueTeal)
            })], selection: $selection)
        } inspector: {
            B1TagInspector(file: files.first { $0.id == selection })
        } statusBar: {
            Text("\(files.count) files")
            Spacer(minLength: 8)
            Text(sparse ? "Reviewing 1 of 1" : "Reviewing 2 of 4")
            LumenProgressBar(sparse ? 1 : 0.5).frame(width: 96)
        } topLeading: {
            LumenToolbarIdentity("File Utility", systemImage: "doc.on.doc", hue: .hueTeal)
        } topTrailing: {
            Button(sparse ? "Show Populated Content" : "Show Sparse Content", systemImage: sparse ? "list.bullet" : "rectangle.compress.vertical") {
                sparse.toggle()
                if sparse { selection = B1DemoFile.samples.first?.id }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(LumenToolbarIconButtonStyle())
            .help(sparse ? "Show Populated Content" : "Show Sparse Content")
        }
        .contentMinimumWidth(640)
        .columnWidths(sidebar: (200, 220, 300), inspector: (240, 280, 360))
    }
}

private struct B1DemoFile: Identifiable {
    let id: String
    let name: String
    let kind: String
    let size: String
    let state: String

    static let samples = [
        B1DemoFile(id: "sample-01", name: "Sample 01.dcm", kind: "Image", size: "512 KB", state: "Ready"),
        B1DemoFile(id: "sample-02", name: "Sample 02.dcm", kind: "Image", size: "512 KB", state: "Ready"),
        B1DemoFile(id: "sample-03", name: "Sample 03.dcm", kind: "Image", size: "256 KB", state: "Review"),
        B1DemoFile(id: "sample-04", name: "Sample 04.dcm", kind: "Image", size: "256 KB", state: "Queued"),
    ]
}

private struct B1FileTable: View {
    let files: [B1DemoFile]
    @Binding var selection: String?
    @Environment(\.lumenMetrics) private var metrics

    var body: some View {
        VStack(alignment: .leading, spacing: metrics.spacing.s4) {
            LumenSectionHeader("File Review")
            LumenTable(files, selection: $selection, minHeight: 160, columns: [
                LumenTableColumn("File") { LumenTableText($0.name) }.minWidth(120).priority(1),
                LumenTableColumn("Size", width: 64) { LumenTableText($0.size) },
                LumenTableColumn("State", width: 64) { LumenTableText($0.state) },
            ])
            Spacer(minLength: 0)
        }
        .padding(metrics.spacing.s5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private struct B1TagInspector: View {
    let file: B1DemoFile?

    var body: some View {
        LumenInspectorHeader("Tags", subtitle: file?.name ?? "No file selected", systemImage: "tag", hue: .hueTeal)
        if let file {
            LumenInspectorSection("File", systemImage: "doc", hue: .hueTeal) {
                LumenInspectorRow("Type") { Text(file.kind) }
                LumenInspectorRow("Size") { Text(file.size) }
                LumenInspectorRow("State") { Text(file.state) }
            }
            LumenInspectorSection("Image Tags", systemImage: "square.grid.2x2", hue: .hueBlue) {
                LumenInspectorRow("Rows") { Text("512") }
                LumenInspectorRow("Columns") { Text("512") }
                LumenInspectorRow("Bits") { Text("16") }
                LumenInspectorRow("Encoding") { Text("Explicit VR") }
            }
        }
    }
}
