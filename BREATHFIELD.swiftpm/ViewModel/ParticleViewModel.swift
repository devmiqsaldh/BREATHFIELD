/// View model that owns and updates the particle simulation, and applies gesture-driven effects.

import CoreGraphics
import Foundation

/// Manages a collection of particles, advancing their motion and responding to gesture metrics.
final class ParticleViewModel {

    /// The current set of particles rendered in the scene. Exposed as read-only to external callers.
    private(set) var particles: [Particle] = []

    /// Number of particles to create for the simulation.
    private let particleCount = 120
    /// Initial random velocity range applied to each particle on creation.
    private let movementRange: ClosedRange<CGFloat> = -0.15...0.15
    /// Scene bounds used for spawning particles and wrapping positions.
    private var bounds: CGSize = .zero

    /// Normalized energy derived from drawing speed, used to scale jitter and color effects.
    private var gestureEnergy: CGFloat = 0
    /// Normalized smoothness metric used to modulate chaos and color saturation.
    private var gestureSmoothness: CGFloat = 0

    /// Configures the simulation with the scene bounds and creates the initial particle set.
    /// - Parameter bounds: The size of the rendering area.
    func configure(bounds: CGSize) {
        self.bounds = bounds
        createParticles()
    }

    /// Initializes the particle array with randomized positions, velocities, and base colors.
    private func createParticles() {
        particles = (0..<particleCount).map { _ in
            let color = CGColor(red: 0.6, green: 0.7, blue: 0.75, alpha: 0.6)
            return Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...bounds.width),
                    y: CGFloat.random(in: 0...bounds.height)
                ),
                velocity: CGVector(
                    dx: CGFloat.random(in: movementRange),
                    dy: CGFloat.random(in: movementRange)
                ),
                radius: CGFloat.random(in: 2...4),
                baseColor: color,
                currentColor: color
            )
        }
    }

    /// Advances the simulation by one tick: moves particles, applies damping, wraps positions, and blends colors back toward base.
    func update() {
        for i in particles.indices {
            particles[i].position.x += particles[i].velocity.dx
            particles[i].position.y += particles[i].velocity.dy

            wrap(&particles[i])

            particles[i].velocity.dx *= 0.98
            particles[i].velocity.dy *= 0.98

            particles[i].currentColor = interpolate(
                from: particles[i].currentColor,
                to: particles[i].baseColor,
                factor: 0.05
            )
        }
    }

    /// Applies gesture-derived influences to particle motion and color.
    /// - Parameters:
    ///   - speed: Current input speed used to compute energy.
    ///   - smoothness: Normalized smoothness used to reduce chaos and boost saturation.
    func applyGesture(speed: CGFloat, smoothness: CGFloat) {
        gestureEnergy = min(speed / 800, 1)
        gestureSmoothness = smoothness

        for i in particles.indices {
            let chaos = 1 - gestureSmoothness

            let jitterX = CGFloat.random(in: -0.3...0.3) * chaos
            let jitterY = CGFloat.random(in: -0.3...0.3) * chaos

            particles[i].velocity.dx += jitterX * gestureEnergy
            particles[i].velocity.dy += jitterY * gestureEnergy

            let saturationBoost = gestureSmoothness * gestureEnergy
            particles[i].currentColor = CGColor(
                red: 0.6 + saturationBoost * 0.3,
                green: 0.7 + saturationBoost * 0.2,
                blue: 0.75 + saturationBoost * 0.1,
                alpha: 0.6
            )
        }
    }

    /// Wraps a particle's position so it re-enters from the opposite side when leaving the bounds.
    private func wrap(_ particle: inout Particle) {
        if particle.position.x < 0 { particle.position.x = bounds.width }
        if particle.position.x > bounds.width { particle.position.x = 0 }
        if particle.position.y < 0 { particle.position.y = bounds.height }
        if particle.position.y > bounds.height { particle.position.y = 0 }
    }

    /// Linearly interpolates between two colors.
    /// - Parameters:
    ///   - from: Starting color.
    ///   - to: Target color.
    ///   - factor: Interpolation factor in [0, 1].
    /// - Returns: The interpolated color.
    private func interpolate(from: CGColor, to: CGColor, factor: CGFloat) -> CGColor {
        let f = max(0, min(factor, 1))
        let fc = from.components ?? [0,0,0,0]
        let tc = to.components ?? [0,0,0,0]

        return CGColor(
            red: fc[0] + (tc[0] - fc[0]) * f,
            green: fc[1] + (tc[1] - fc[1]) * f,
            blue: fc[2] + (tc[2] - fc[2]) * f,
            alpha: fc[3] + (tc[3] - fc[3]) * f
        )
    }
}

