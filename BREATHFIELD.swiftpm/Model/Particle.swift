//
//  Particle.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 12/01/26.
//

import CoreGraphics

/// A single particle used in the field simulation.
///
/// Stores its current `position`, current `velocity`, and an immutable
/// `basePosition` that represents the particle's original/resting location.
struct Particle {
    /// Current position in the simulation coordinate space.
    var position: CGPoint
    /// Current velocity (dx, dy) applied each update tick.
    var velocity: CGVector
    /// The particle's initial/resting position, used as an anchor or target.
    let basePosition: CGPoint
}
