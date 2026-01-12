/// A sampled input point captured during a touch or Apple Pencil stroke.

import Foundation
import CoreGraphics

/// Captures spatial, temporal, and pressure data for a single input sample.
struct StrokePoint {
    /// Location of the input in scene coordinates.
    let position: CGPoint
    /// Time at which the sample was recorded.
    let timestamp: TimeInterval
    /// Normalized input pressure for the sample.
    let pressure: CGFloat    
    /// Indicates whether this sample originated from Apple Pencil.
    let isPencil: Bool
}
