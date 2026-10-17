import SwiftUI
import XCTest
import LumenTokens
import LumenUI
@testable import LumenConformance

/// PRINCIPLES §8, the widened scan (steps of 2 to 60), the opt-in header comparison, and panes drawn
/// in a real window so AppKit-backed SwiftUI is scanned as shipped.
@MainActor
final class LumenSurfaceScanWindowTests: XCTestCase {
    let size = [CGSize(width: 420, height: 240)]

    private func split(_ left: (Double, Double, Double), _ right: (Double, Double, Double)) -> some View {
        HStack(spacing: 0) {
            Color(red: left.0 / 255, green: left.1 / 255, blue: left.2 / 255).frame(width: 120)
            Color(red: right.0 / 255, green: right.1 / 255, blue: right.2 / 255)
        }
    }

    func testAStepOfAbout2Point5IsReported() {
        let findings = LumenConformance.surfaceSteps(sizes: size) { split((40, 40, 80), (42, 41, 81)) }
        XCTAssertEqual(findings.map(\.message), ["the background steps at x = 120 pt (240 pt tall)"])
    }

    func testAStepOf50IsReported() {
        let findings = LumenConformance.surfaceSteps(sizes: size) { split((40, 40, 80), (90, 40, 80)) }
        XCTAssertEqual(findings.map(\.message), ["the background steps at x = 120 pt (240 pt tall)"])
    }

    /// A one-pixel line between two different surfaces doesn't hide the step: the
    /// line is allowed, the two surfaces either side of it aren't.
    func testAHairlineBetweenTwoSurfacesStillReportsTheStep() {
        let grey = { (v: Double) in Color(red: v / 255, green: v / 255, blue: v / 255) }
        let findings = LumenConformance.surfaceSteps(sizes: [CGSize(width: 200, height: 200)]) {
            HStack(spacing: 0) {
                grey(0x20).frame(width: 40)
                Color.black.frame(width: 1)
                grey(0x28)
            }
        }
        XCTAssertEqual(findings.map(\.message), ["the background steps at x = 40 pt (200 pt tall)"])
        // The same line on one surface is a hairline, not a step.
        XCTAssertEqual(LumenConformance.surfaceSteps(sizes: [CGSize(width: 200, height: 200)]) {
            HStack(spacing: 0) { grey(0x20).frame(width: 40); Color.black.frame(width: 1); grey(0x20) }
        }, [])
    }

    private func pane(header: Color) -> some View {
        VStack(spacing: 0) {
            header.frame(height: 28)
            Color(red: 0.10, green: 0.10, blue: 0.21)
        }
    }

    func testAHeaderOnItsOwnSurfaceIsReportedOnlyWhenAskedFor() {
        let header = Color(red: 0.14, green: 0.13, blue: 0.27)
        XCTAssertEqual(LumenConformance.surfaceSteps(sizes: size) { pane(header: header) }, [])
        let findings = LumenConformance.surfaceSteps(sizes: size, headerHeight: 28) { pane(header: header) }
        XCTAssertEqual(findings.count, 1, "\(findings)")
        XCTAssertTrue(findings.first?.message.hasPrefix("the header's surface differs from the pane's") ?? false, "\(findings)")
    }

    func testAHeaderOnThePanesSurfacePasses() {
        let findings = LumenConformance.surfaceSteps(sizes: size, headerHeight: 28) {
            pane(header: Color(red: 0.10, green: 0.10, blue: 0.21))
                .overlay(alignment: .topLeading) { Text("Name").padding(6) }
        }
        XCTAssertEqual(findings, [])
    }

    /// A List (NSTableView underneath) whose rows tint a leading column: the window capture sees
    /// it; ImageRenderer, which can't draw AppKit-backed views, doesn't.
    func testAListWithATintedLeadingColumnIsReported() {
        let surface = Color(red: 0.10, green: 0.10, blue: 0.21)
        let gutter = Color(red: 0.14, green: 0.13, blue: 0.27)
        let list = {
            List(0..<12, id: \.self) { row in
                Text("Row \(row)")
                    .listRowBackground(HStack(spacing: 0) { gutter.frame(width: 48); surface })
            }
            .scrollContentBackground(.hidden)
            .background(surface)
        }
        let findings = LumenConformance.surfaceSteps(sizes: size, of: list)
        XCTAssertFalse(findings.isEmpty, "the window capture missed the tinted column")
        let imageRendered = LumenConformance.surfaceScan(sizes: size, variant: .init(themeID: LumenThemes.standardID, colorScheme: .dark),
                                                         registry: .core, headerHeight: nil, renderer: .imageRenderer, of: list)
        XCTAssertEqual(imageRendered, [], "ImageRenderer drew the List after all; the window capture isn't needed for it")
    }
}
