import AppKit
import SwiftUI
import XCTest
import LumenTokens
@testable import LumenUI

/// Only new D4 subjects are recorded. Recording deliberately reports review-required failures;
/// do not repeat unchanged checks merely to turn the recording run green.
@MainActor final class LumenD4GoldenTests: XCTestCase {
    private let directory = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appending(path: "Goldens")
    private var variants: [LumenSnapshot.Variant] { LumenSnapshot.Variant.all(for: LumenRegistry.core.galleryThemes) }

    private func includes(_ variant: LumenSnapshot.Variant) -> Bool {
        guard let selection = ProcessInfo.processInfo.environment["LUMEN_GOLDEN_THEME"], !selection.isEmpty else { return true }
        if selection == "non-contrast" { return variant.themeID != LumenThemes.contrastID }
        return variant.themeID == selection || variant.label == selection
            || variant.themeID.split(separator: ".").last.map(String.init) == selection
    }

    func testToastInfo() { checkToast(.info, name: "d4-toast-info") }
    func testToastSuccess() { checkToast(.success, name: "d4-toast-success") }
    func testToastWarning() { checkToast(.warning, name: "d4-toast-warning") }
    func testToastDanger() { checkToast(.danger, name: "d4-toast-danger") }
    func testToastCollapse() { check(stack, name: "d4-toast-collapse", size: CGSize(width: 420, height: 440)) }
    func testShortcutsSheet() { check(sheet, name: "d4-shortcuts", size: CGSize(width: 680, height: 440)) }
    func testToastGlass() {
        check(stack.lumenChromeStyle(.glass), name: "d4-toast-glass", size: CGSize(width: 420, height: 440), glass: true)
    }
    func testShortcutsGlass() {
        check(sheet.lumenChromeStyle(.glass), name: "d4-shortcuts-glass", size: CGSize(width: 680, height: 440), glass: true)
    }

    private var sheet: some View {
        LumenShortcutsSheet(groups: LumenViewCommands().shortcutGroups + LumenShortcutsCommands.shortcutGroups)
    }

    private var stack: some View {
        let center = LumenToastCenter(now: { 0 }, schedulesTimers: false)
        for (index, tone) in LumenTone.allCases.enumerated() {
            center.post(LumenToast(title: ["Analysis started", "Export complete", "Source changed on disk", "Connection interrupted"][index],
                                   message: ["Results are arriving.", "Your report is ready.", "Review before continuing.", "Your local changes are safe."][index],
                                   tone: tone, action: tone == .danger ? .init("Retry", perform: {}) : nil, duration: nil))
        }
        return LumenToastStack(center: center).padding(24)
    }

    private func checkToast(_ tone: LumenTone, name: String) {
        let center = LumenToastCenter(now: { 0 }, schedulesTimers: false)
        center.post(LumenToast(title: "A notification title that wraps without losing its meaning", message: "The complete message remains readable.",
                               tone: tone, action: .init("Review", perform: {}), duration: nil))
        check(LumenToastStack(center: center).padding(24), name: name, size: CGSize(width: 420, height: 240))
    }

    private func check<V: View>(_ view: V, name: String, size: CGSize, glass: Bool = false) {
        if glass {
            do { try checkGlass(view, name: name, size: size) }
            catch { XCTFail("\(name): \(error)") }
            return
        }
        let selected = variants.filter(includes)
        guard !selected.isEmpty else { XCTFail("Unknown D4 golden theme selection"); return }
        for variant in selected {
            // Match A1's canvas growth without changing any unscaled capture.
            let scale = LumenRegistry.core.theme(id: variant.themeID)?.metrics?.typeScale ?? 1
            let captureSize = CGSize(width: size.width, height: ceil(size.height * max(1, scale)))
            let outcome = LumenSnapshot.verify(view, named: name, size: captureSize, variant: variant,
                                               registry: .core, goldenDirectory: directory,
                                               renderer: .image)
            if let message = outcome.failureMessage { XCTFail("\(name)@\(variant.label): \(message)") }
        }
    }

    /// System materials require the window server; cacheDisplay drops their compositor layer.
    private func checkGlass<V: View>(_ view: V, name: String, size: CGSize) throws {
        let store = LumenSnapshot.store(for: .init(themeID: LumenThemes.standardID, colorScheme: .dark), registry: .core)
        let root = view.frame(width: size.width, height: size.height)
            .background(store.resolvedPalette()[.bgCanvas])
            .lumenPaletteRoot(store: store).lumenMetrics(.standard)
            .environment(\.colorScheme, .dark).environment(\.displayScale, 2)
            .environment(\.appearsActive, true)
        let host = NSHostingView(rootView: root)
        host.sizingOptions = []
        let window = NSWindow(contentRect: CGRect(origin: .zero, size: size),
                              styleMask: [.borderless], backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.appearance = NSAppearance(named: .darkAqua)
        window.contentView = host
        window.setContentSize(size)
        window.center()
        window.orderFrontRegardless()
        defer { window.close() }
        for _ in 0..<20 {
            host.layoutSubtreeIfNeeded()
            window.displayIfNeeded()
            RunLoop.current.run(until: Date().addingTimeInterval(0.03))
        }
        let captureDirectory = directory.deletingLastPathComponent().deletingLastPathComponent()
            .deletingLastPathComponent().appending(path: ".build/d4-captures")
        try FileManager.default.createDirectory(at: captureDirectory, withIntermediateDirectories: true)
        let captured = captureDirectory.appending(path: "\(name).png")
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        process.arguments = ["-x", "-o", "-l", String(window.windowNumber), captured.path]
        try process.run()
        process.waitUntilExit()
        XCTAssertEqual(process.terminationStatus, 0)
        let actual = try Data(contentsOf: captured)
        let golden = directory.appending(path: "\(name)@standard-dark.png")
        if LumenSnapshot.isRecording {
            try actual.write(to: golden)
            XCTFail("Recorded \(golden.lastPathComponent); review the window-server glass subject")
        } else {
            let difference = LumenSnapshot.compare(actual, try Data(contentsOf: golden))
            XCTAssertFalse(difference.sizeMismatch)
            XCTAssertLessThanOrEqual(difference.differingPixelFraction, 0.005)
            XCTAssertLessThanOrEqual(difference.densestPatchFraction, LumenSnapshot.patchTolerance)
        }
    }

}
