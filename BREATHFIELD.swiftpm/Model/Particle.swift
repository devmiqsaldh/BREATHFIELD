/// Data model representing a particle in the simulation.

import Foundation
import CoreGraphics

/// A single particle with position, velocity, radius, and color information.
struct Particle {
    /// Stable identifier used to match model particles to SpriteKit nodes.
    let id: UUID = UUID()
    /// Current position in scene coordinates.
    var position: CGPoint
    /// Current velocity vector applied during simulation updates.
    var velocity: CGVector
    /// Visual radius of the particle.
    var radius: CGFloat
    /// Default color of the particle used as a baseline for effects.
    var baseColor: CGColor = CGColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 0.6)
    /// The dynamically updated color reflecting simulation and gesture effects.
    var currentColor: CGColor = CGColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 0.6)
}
