import SwiftUI
import UniformTypeIdentifiers
import LumenTokens
import LumenUI

/// A deliberately sparse host example: every row and section uses the public settings pieces.
struct CatalogEngineSettings: View {
    @State private var usesExternalEngine = false
    @State private var enginePath = ""
    @State private var status = "Ready to use."
    @State private var choosesEngine = false
    @Environment(\.lumenMetrics) private var metrics

    var body: some View {
        LumenSettingsPane("Engine", systemImage: "cpu", hue: .hueViolet,
                          summary: "Choose the engine used for local analysis.", style: .rich) {
            LumenFormSection("Analysis engine") {
                LumenSettingsRow("Bundled engine", description: status) {
                    Button("Check") { status = "Bundled engine is available." }
                        .modifier(CatalogEngineControlMeasure(name: "Check"))
                }
                LumenSettingsRow("Use external engine") {
                    Toggle("Use external engine", isOn: $usesExternalEngine)
                        .toggleStyle(.switch)
                        .modifier(CatalogEngineControlMeasure(name: "Toggle"))
                }
                LumenFormRow("Engine path") {
                    HStack {
                        LumenTextField("Bundled engine", text: $enginePath, monospaced: true)
                        Button("Choose…") { choosesEngine = true }
                        Button("Reset") { enginePath = "" }
                            .modifier(CatalogEngineControlMeasure(name: "Reset"))
                    }
                }
                .disabled(!usesExternalEngine)
                Text("The bundled engine works offline. An external engine is used only when enabled and a folder is selected.")
                    .font(metrics.typography.caption)
                    .foregroundStyle(.lumen(.fgTertiary))
                    .fixedSize(horizontal: false, vertical: true)
                DisclosureGroup("Engine details") {
                    LumenSettingsRow("Processing", description: "Analysis runs on this Mac.") {
                        Text("Local")
                    }
                }
            }
        }
        .fileImporter(isPresented: $choosesEngine, allowedContentTypes: [.folder]) { result in
            if case .success(let url) = result {
                enginePath = url.path
            }
        }
    }
}

struct CatalogReportSettings: View {
    @State private var includesSummary = true
    @State private var includesDiagnostics = false

    var body: some View {
        LumenSettingsPane("Reports", systemImage: "doc.text", hue: .hueBlue,
                          summary: "Choose what to include in exported reports.", style: .rich) {
            LumenFormSection("Report contents") {
                LumenSettingsRow("Include summary", description: "Begin with the analysis findings.") {
                    Toggle("Include summary", isOn: $includesSummary).toggleStyle(.switch)
                }
                LumenSettingsRow("Include diagnostics", description: "Append engine details to the report.") {
                    Toggle("Include diagnostics", isOn: $includesDiagnostics).toggleStyle(.switch)
                }
            }
        }
    }
}

/// Layout-only instrumentation shared by the live regression and opt-in preview receipt.
private struct CatalogEngineControlMeasurementKey: EnvironmentKey {
    static let defaultValue = ProcessInfo.processInfo.environment["LUMEN_CATALOG_SETTINGS_RECEIPT"] != nil
}

extension EnvironmentValues {
    var measuresCatalogEngineControls: Bool {
        get { self[CatalogEngineControlMeasurementKey.self] }
        set { self[CatalogEngineControlMeasurementKey.self] = newValue }
    }
}

private struct CatalogEngineControlMeasure: ViewModifier {
    let name: String
    @Environment(\.measuresCatalogEngineControls) private var measuresControls

    func body(content: Content) -> some View {
        content.background {
            if measuresControls {
                Color.clear.onGeometryChange(for: CGRect.self) { geometry in
                    geometry.frame(in: .global)
                } action: { frame in
                    guard frame.width > 0, frame.height > 0 else { return }
                    CatalogSettingsWindowReceipt.engineControlFrames[name] = frame
                }
            }
        }
    }
}
