import Foundation
import LumenConformance
import WorkbenchLumen
import XCTest

@MainActor
final class WorkbenchStyleRatchetTests: XCTestCase {
    func testCustomCheckPassesAtBudgetAndFailsAboveItThroughRunner() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let directory = root.appendingPathComponent(".build/a3-fixtures/\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let file = directory.appendingPathComponent("Sample.swift")
        try "Text(\"Name\").foregroundStyle(.primary)\nText(\"Detail\").foregroundStyle(.secondary)"
            .write(to: file, atomically: true, encoding: .utf8)
        let accepted = WorkbenchStyleRatchet(files: [file], budget: 2)
        XCTAssertEqual(accepted.owner, "Workbench")
        XCTAssertEqual(LumenConformance.run([accepted], in: [.init()]), [])
        let exceeded = WorkbenchStyleRatchet(files: [file], budget: 1)
        XCTAssertEqual(LumenConformance.run([exceeded], in: [.init()]).map(\.description),
                       ["coverage · Workbench: system foreground styles occur 2 time(s); budget is 1"])
        let unreadable = WorkbenchStyleRatchet(files: [directory.appendingPathComponent("missing")], budget: 120)
        XCTAssertEqual(LumenConformance.run([unreadable], in: [.init()]).count, 1)
    }
}
