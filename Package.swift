// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "Lumen",
    platforms: [.macOS("27.0")],
    products: [
        .library(name: "LumenTokens", targets: ["LumenTokens"]),
        .library(name: "LumenUI", targets: ["LumenUI"]),
        .library(name: "LumenConformance", targets: ["LumenConformance"]),
        .executable(name: "lumen-theme", targets: ["lumen-theme"]),
        .executable(name: "LumenCatalog", targets: ["LumenCatalog"]),
    ],
    targets: [
        // Tokens, themes, the validator and export: plain Swift, no UI.
        .target(name: "LumenTokens"),
        // SwiftUI and AppKit: the theme store, palette environment, scales, components, and the
        // theme gallery, editor and library.
        // Resources: Lumen's custom SF Symbols (an asset catalog of symbol templates).
        .target(name: "LumenUI", dependencies: ["LumenTokens"], resources: [.process("Resources")]),
        // Checks an app runs in its own tests at each pin bump: themes, layout, shortcuts, coverage.
        // For app test targets; the Catalog also links check metadata for its conformance page.
        .target(name: "LumenConformance", dependencies: ["LumenTokens", "LumenUI"]),
        // Validates theme files and exports the reference artifacts from the command line.
        .executableTarget(name: "lumen-theme", dependencies: ["LumenTokens"]),
        // Every component in a real Mac app, including native menus and the Settings window.
        .executableTarget(name: "LumenCatalog", dependencies: ["LumenTokens", "LumenUI", "LumenConformance", "WorkbenchLumen"]),
        .testTarget(name: "LumenTokensTests", dependencies: ["LumenTokens"]),
        // A standalone example pack with custom themes and semantic roles.
        // Not a product: other apps never see it.
        .target(name: "WorkbenchLumen", dependencies: ["LumenTokens", "LumenConformance"], path: "Examples/WorkbenchLumen"),
        .testTarget(name: "WorkbenchLumenTests", dependencies: ["WorkbenchLumen", "LumenConformance"], path: "Examples/WorkbenchLumenTests",
                    resources: [.copy("workbench-expected.json")]),
        // LumenConformance: the golden views also pass the design-rule checks.
        .testTarget(name: "LumenUITests", dependencies: ["LumenUI", "LumenConformance"], exclude: ["Goldens"]),
        // The Catalog's windows never cut their content off: each page fits its column's minimum.
        .testTarget(name: "LumenConformanceTests", dependencies: ["LumenConformance", "LumenUI", "LumenTokens"]),
        .testTarget(name: "LumenCatalogTests", dependencies: ["LumenCatalog", "LumenUI", "LumenConformance"]),
    ],
    swiftLanguageModes: [.v6]
)
