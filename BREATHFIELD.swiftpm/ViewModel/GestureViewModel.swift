//
//  GestureViewModel.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 12/01/26.
//

import SwiftUI

/// A lightweight helper that tracks touch locations over time
/// and computes the instantaneous gesture velocity in points per second.
///
/// Call `velocity(from:)` with each new touch location to get the
/// current velocity. Use `reset()` to clear the internal state when a
/// gesture begins or is cancelled.
final class GestureViewModel {

    /// The most recent touch location recorded, or `nil` if none.
    private var lastLocation: CGPoint?
    /// The timestamp associated with `lastLocation`, or `nil` if none.
    private var lastTime: Date?

    /// Returns the velocity between the last recorded location and the
    /// provided `location` in points per second.
    ///
    /// - Parameter location: The current touch location.
    /// - Returns: The computed velocity. Returns `0` if there is no prior
    ///   location or if the elapsed time is zero.
    func velocity(from location: CGPoint) -> CGFloat {
        /// Update state after computing velocity so the next call has a baseline.
        defer {
            lastLocation = location
            lastTime = Date()
        }

        /// If there is no previous sample, report zero; the `defer` will seed the baseline
        /// for the next call so we can compute a delta then.
        guard let lastLocation, let lastTime else { return 0 }

        let distance = hypot(
            location.x - lastLocation.x,
            location.y - lastLocation.y
        )

        let time = Date().timeIntervalSince(lastTime)
        return time > 0 ? distance / CGFloat(time) : 0
    }

    /// Clears any previously recorded location and timestamp.
    ///
    /// Call this when a gesture starts, ends, or is cancelled to avoid
    /// mixing samples from different gesture sequences.
    func reset() {
        lastLocation = nil
        lastTime = nil
    }
}

