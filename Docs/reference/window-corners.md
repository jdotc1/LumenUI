# Window corners on macOS 27

Lumen requires macOS 27. `LumenRadius.window` is approximately **16 pt**, measured on
macOS 27.2. It is a measured reference for explicit container shapes, not a
replacement for the system's live corner geometry.

## Measurement method

The reference `screencapture -l` welcome-window PNG is a 2× capture. The
comparison used its alpha channel at pixels `x=46..<126, y=32..<112`, an 80×80-pixel
region at the upper-left window corner. `measure-corners.swift` rendered white SwiftUI
continuous rounded rectangles at 2×, with radii 12 through 30 pt in 0.5 pt increments.
The top-left 80×80 alpha samples of each reference were compared with the native crop.
Alpha values at least 0.98 counted as inside; the score was the mean squared difference
between those binary masks (the fraction of disagreeing pixels).

The best fit was 16.0 pt, score 0.00375 (24 of 6,400 pixels); 16.5 pt scored 0.004375
(28 pixels), and 17.0 pt scored 0.0053125 (34 pixels). The half-point sampling and edge
antialiasing support an approximate 16–16.5 pt fit, not an exact system constant.

## Implementation

- Sheets and both welcome components clip directly with `ConcentricRectangle()`.
- Floating status uses `ConcentricRectangle()` for its opaque background and
  `GeometryProxy.concentricCornerRadii` for its inset border. Without a rounded container,
  its geometry is rectangular; there is no older-system radius-ramp path.
- `LumenConcentricTextView` and `LumenConcentricGlassView` declare
  `.corners(radius: .containerConcentric)`. Both apply `effectiveCornerRadii` through a
  layer mask during layout and `viewDidChangeEffectiveCornerRadii()`. Text-view flipping
  maps the AppKit top/bottom radii into the shape's coordinates.
- Lumen's code-pane API accepts client-owned `NSTextView`s; it creates none itself.
  Clients use `LumenConcentricTextView` when constructing a native editor and then install
  `LumenLineNumberRuler` normally. The Catalog's listing is SwiftUI. Likewise, the native
  glass subclass is available to AppKit hosts; Lumen's own glass surfaces use SwiftUI.

The selected macOS 27.2 SDK's `NSView.h` declares the read-only corner configuration and
instructs subclasses to apply changed effective radii. `NSViewCornerConfiguration.h`
declares the independent per-corner configuration. `SwiftUICore.swiftinterface` declares
`GeometryProxy.concentricCornerRadii` at macOS 27 and `ConcentricRectangle` at macOS 26;
all are used directly under the package's macOS 27 floor.

## Visual coverage

The new `welcome-concentric-27` subject supplies an explicit 16 pt continuous container
and uses the window renderer in all six built-in appearances. The subject sets
`lumenRendersOffscreen` to pause the starfield; the actual window renderer still supplies
geometry. The recents background is explicitly rectangular to keep the interior seam square. This isolates container
propagation; the live welcome and sheet screenshots cover actual native windows.
Existing welcome, welcome-panel and sheet/process goldens are compared without blanket
re-recording. The floating status intentionally changes from a capsule to container-relative
corners and has no existing dedicated golden subject.
