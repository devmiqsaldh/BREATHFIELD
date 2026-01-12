/// Analyzes user strokes (touch or Apple Pencil) to derive speed, smoothness, and pressure metrics.

import Foundation
import CoreGraphics

/// Maintains the current stroke and computes derived gesture metrics to influence the particle system.
final class GestureViewModel {

    /// The sampled points of the current stroke.
    private(set) var points: [StrokePoint] = []

    /// Estimated instantaneous drawing speed (points per second).
    var currentSpeed: CGFloat = 0
    /// Normalized measure of path smoothness in the range [0, 1].
    var smoothness: CGFloat = 0
    /// Average input pressure across the current stroke.
    var averagePressure: CGFloat = 0

    /// Begins a new stroke with an initial point.
    /// - Parameters:
    ///   - point: Location in scene coordinates.
    ///   - time: Timestamp of the touch event.
    ///   - pressure: Normalized pressure value.
    ///   - isPencil: Whether the input source is Apple Pencil.
    func beginStroke(at point: CGPoint, time: TimeInterval, pressure: CGFloat, isPencil: Bool) {
        points = [StrokePoint(
            position: point,
            timestamp: time,
            pressure: pressure,
            isPencil: isPencil
        )]
    }

    /// Adds a point to the current stroke, updating speed, smoothness, and pressure metrics.
    /// - Parameters are the same as `beginStroke`.
    func addPoint(_ point: CGPoint, time: TimeInterval, pressure: CGFloat, isPencil: Bool) {
        guard let last = points.last else { return }

        let dx = point.x - last.position.x
        let dy = point.y - last.position.y
        let distance = sqrt(dx*dx + dy*dy)
        let dt = CGFloat(time - last.timestamp)

        if dt > 0 {
            currentSpeed = distance / dt
        }

        points.append(StrokePoint(
            position: point,
            timestamp: time,
            pressure: pressure,
            isPencil: isPencil
        ))

        analyzeSmoothness()
        analyzePressure()
    }

    /// Ends the current stroke and resets computed metrics.
    func endStroke() {
        points.removeAll()
        currentSpeed = 0
        smoothness = 0
        averagePressure = 0
    }

    /// Computes a heuristic smoothness metric based on changes in the stroke's turning angle.
    private func analyzeSmoothness() {
        guard points.count > 4 else { return }

        var angleChange: CGFloat = 0

        for i in 2..<points.count {
            let a = points[i-2].position
            let b = points[i-1].position
            let c = points[i].position

            let v1 = CGVector(dx: b.x - a.x, dy: b.y - a.y)
            let v2 = CGVector(dx: c.x - b.x, dy: c.y - b.y)

            let dot = v1.dx * v2.dx + v1.dy * v2.dy
            let mag = hypot(v1.dx, v1.dy) * hypot(v2.dx, v2.dy)

            if mag > 0 {
                let cos = dot / mag
                angleChange += abs(acos(min(max(cos, -1), 1)))
            }
        }

        let pencilBonus = points.last?.isPencil == true ? 0.2 : 0
        smoothness = min(1, max(0, 1 - angleChange / 10 + pencilBonus))
    }

    /// Computes the average pressure across collected stroke points.
    private func analyzePressure() {
        guard !points.isEmpty else { return }
        let total = points.reduce(CGFloat(0)) { $0 + $1.pressure }
        averagePressure = total / CGFloat(points.count)
    }
}
