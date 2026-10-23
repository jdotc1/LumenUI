import AppKit
import SwiftUI

/// Opt-in measurements for the isolated Catalog preview's real Settings scene.
/// It observes only its own window and never changes toolbar items or geometry.
struct CatalogSettingsWindowReceipt: NSViewRepresentable {
    static var engineControlFrames: [String: CGRect] = [:]

    func makeNSView(context: Context) -> ReceiptView { ReceiptView() }
    func updateNSView(_ nsView: ReceiptView, context: Context) {}

    final class ReceiptView: NSView {
        private var scheduled = false
        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            guard !scheduled, window != nil,
                  let destination = ProcessInfo.processInfo.environment["LUMEN_CATALOG_SETTINGS_RECEIPT"] else { return }
            scheduled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let window = self?.window else { return }
                let items = window.toolbar?.items ?? []
                let receipt: [String: Any] = [
                    "windowID": window.windowNumber,
                    "engineControlTrailingEdges": CatalogSettingsWindowReceipt.engineControlFrames.mapValues { $0.maxX },
                    "title": window.title,
                    "frameWidth": window.frame.width,
                    "frameHeight": window.frame.height,
                    "contentWidth": window.contentLayoutRect.width,
                    "contentHeight": window.contentLayoutRect.height,
                    "bandHeight": window.frame.height - window.contentLayoutRect.height,
                    "backingScale": window.backingScaleFactor,
                    "toolbarStyle": window.toolbarStyle.rawValue,
                    "toolbarItems": items.map { $0.itemIdentifier.rawValue },
                    "sidebarToggleCount": items.filter {
                        $0.itemIdentifier.rawValue.contains("toggleSidebar") ||
                        $0.itemIdentifier.rawValue.contains("lumen.settings.sidebar")
                    }.count
                ]
                do {
                    let data = try JSONSerialization.data(withJSONObject: receipt, options: [.prettyPrinted, .sortedKeys])
                    try data.write(to: URL(fileURLWithPath: destination), options: .atomic)
                } catch {
                    NSLog("Settings window receipt failed: %@", error.localizedDescription)
                }
            }
        }
    }
}
