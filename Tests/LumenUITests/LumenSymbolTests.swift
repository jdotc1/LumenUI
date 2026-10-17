import AppKit
import SwiftUI
import XCTest
@testable import LumenUI

/// Every Lumen glyph draws as an SF Symbol: Apple's where one fits, a custom symbol from LumenUI's
/// catalog otherwise (PRINCIPLES §7; Docs/research/icon-research-2026-10-12.md).
final class LumenSymbolTests: XCTestCase {
    func testEveryBuiltInGlyphHasASymbol() {
        for glyph in LumenGlyph.builtIns {
            let name = glyph.symbolName
            XCTAssertTrue(LumenGlyph.customSymbols.contains(name) || LumenGlyph.sfEquivalents[name] != nil, "\(name) has no SF Symbol")
        }
    }

    func testCustomSymbolsLoadFromTheCatalog() {
        for name in LumenGlyph.customSymbols.union(LumenGlyph.customFillSymbols).sorted() {
            XCTAssertNotNil(NSImage(symbolName: name, bundle: .module, variableValue: 1), "\(name) didn't load from LumenUI's catalog")
        }
    }

    func testSFEquivalentsExist() {
        for (name, symbol) in LumenGlyph.sfEquivalents.sorted(by: { $0.key < $1.key }) {
            XCTAssertNotNil(NSImage(systemSymbolName: symbol, accessibilityDescription: nil), "\(name) → \(symbol) isn't an SF Symbol")
            if let fill = LumenGlyph.sfFillOverrides[symbol] {
                XCTAssertNotNil(NSImage(systemSymbolName: fill, accessibilityDescription: nil), "\(symbol) → \(fill) isn't an SF Symbol")
            }
        }
    }
}
