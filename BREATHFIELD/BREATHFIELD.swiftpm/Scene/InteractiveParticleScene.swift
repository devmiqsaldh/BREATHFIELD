//
//  InteractiveParticleScene.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import SpriteKit

/// An interactive SpriteKit scene that simulates a particle field reacting
/// to user gestures and a notion of calmness/order.
///
/// The scene maintains two high-level metrics:
/// - `fieldOrder`: a smooth, quickly adapting measure of the current calmness
///   target that pulls particle motion toward order.
/// - `structuralOrder`: a slower, longer-term measure indicating how stable
///   and organized the overall field structure is.
///
/// User gestures can inject chaos or help guide the particles into a more
/// coherent ring formation in the center of the scene.
@MainActor
final class InteractiveParticleScene: SKScene {

    /// Snapshot of high-level scene metrics, reported to observers.
    struct Metrics {
        /// Smooth order value (0...1) that follows the current target.
        let fieldOrder: CGFloat
        /// Slow-changing stability value (0...1) for the whole field.
        let structuralOrder: CGFloat
        /// Whether a gesture is currently influencing the field.
        let isGestureActive: Bool
    }

    /// Simulation state for each logical particle (position/velocity/base).
    private var particles: [Particle] = []
    /// SpriteKit nodes that render the particles on screen.
    private var nodes: [SKShapeNode] = []


    /// Current smooth order (0...1) approaching `targetOrder`.
    private(set) var fieldOrder: CGFloat = 0
    /// Current structural stability (0...1) of the overall field.
    private(set) var structuralOrder: CGFloat = 0

    /// Desired calmness/order (0...1) influenced by user input.
    private var targetOrder: CGFloat = 0
    /// Amount of randomness/instability (0...1) injected into motion.
    private var chaosEnergy: CGFloat = 1

    /// Latest gesture translation vector applied to nearby particles.
    private var gestureVector = CGVector.zero
    /// Latest gesture location in scene coordinates.
    private var gestureLocation = CGPoint.zero
    /// Timestamp of the most recent gesture interaction.
    private var lastGestureTime = Date()
    /// Flag indicating whether gesture effects are currently applied.
    private var isGestureActive = false

    /// Callback invoked after each update cycle with current scene metrics.
    var onMetricsUpdate: ((Metrics) -> Void)?

    /// Convenience for the scene's geometric center.
    private var center: CGPoint {
        CGPoint(x: size.width / 2, y: size.height / 2)
    }

    /// Scene setup when presented by an `SKView`.
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
        createParticles()
    }

    /// Initializes particle arrays and creates corresponding render nodes.
    private func createParticles() {
        removeAllChildren()
        particles.removeAll()
        nodes.removeAll()

        for _ in 0..<260 {
            let p = randomPoint()

            let particle = Particle(
                position: p,
                velocity: .zero,
                basePosition: p
            )

            let node = SKShapeNode(circleOfRadius: 2)
            node.fillColor = .white
            node.strokeColor = .clear
            node.alpha = 0.55
            node.position = p

            addChild(node)
            particles.append(particle)
            nodes.append(node)
        }
    }

    /// Applies a user gesture to influence the particle field.
    /// - Parameters:
    ///   - location: Touch location in scene coordinates.
    ///   - translation: Gesture translation vector.
    ///   - calmness: Target calmness/order (0...1) derived from input.
    ///   - velocity: Gesture speed used to inject chaos.
    func applyGesture(
        location: CGPoint,
        translation: CGVector,
        calmness: CGFloat,
        velocity: CGFloat
    ) {
        guard structuralOrder < 0.95 else { return }

        lastGestureTime = Date()
        isGestureActive = true

        gestureLocation = location
        gestureVector = translation

        let normalizedVelocity = (velocity / 900).clamped(to: 0...1)

        chaosEnergy += normalizedVelocity * 0.12
        chaosEnergy -= calmness * 0.06
        chaosEnergy = chaosEnergy.clamped(to: 0...1)

        targetOrder = calmness
    }

    /// Ends the current gesture influence.
    func stopGesture() {
        isGestureActive = false
        gestureVector = .zero
    }

    /// Resets all state and metrics to initial values.
    func reset() {
        fieldOrder = 0
        structuralOrder = 0
        targetOrder = 0
        chaosEnergy = 1
        isGestureActive = false
    }

    /// Main simulation loop: updates metrics and integrates particle motion.
    override func update(_ currentTime: TimeInterval) {

        if structuralOrder >= 0.95 {
            onMetricsUpdate?(
                Metrics(
                    fieldOrder: fieldOrder,
                    structuralOrder: structuralOrder,
                    isGestureActive: false
                )
            )
            return
        }

        let timeWithoutGesture = Date().timeIntervalSince(lastGestureTime)

        if timeWithoutGesture > 0.4 {
            targetOrder = 0
            chaosEnergy += 0.015
        }

        chaosEnergy = chaosEnergy.clamped(to: 0...1)

        fieldOrder += (targetOrder - fieldOrder) * 0.018

        if fieldOrder > 0.6 && chaosEnergy < 0.35 {
            structuralOrder += 0.002
        } else {
            structuralOrder -= 0.002
        }

        structuralOrder = structuralOrder.clamped(to: 0...1)

        let ringRadius = size.width * 0.38

        for i in particles.indices {
            var p = particles[i]
            let node = nodes[i]

            let baseDrift: CGFloat = 0.15
            p.velocity.dx += .random(in: -baseDrift...baseDrift)
            p.velocity.dy += .random(in: -baseDrift...baseDrift)

            let chaos = chaosEnergy * (1 - structuralOrder)
            p.velocity.dx += .random(in: -1.6...1.6) * chaos
            p.velocity.dy += .random(in: -1.6...1.6) * chaos

            if isGestureActive {
                let dx = p.position.x - gestureLocation.x
                let dy = p.position.y - gestureLocation.y
                let distance = hypot(dx, dy)

                if distance < 160 {
                    let influence = (1 - distance / 160)

                    let flow = influence * (1 - chaosEnergy) * 0.35
                    let scatter = influence * chaosEnergy * 1.2

                    p.velocity.dx += gestureVector.dx * flow
                    p.velocity.dy += gestureVector.dy * flow

                    p.velocity.dx += .random(in: -1...1) * scatter
                    p.velocity.dy += .random(in: -1...1) * scatter
                }
            }

            if structuralOrder > 0.3 {
                let dx = p.position.x - center.x
                let dy = p.position.y - center.y
                let distance = hypot(dx, dy)

                let delta = distance - ringRadius
                let ringForce = -delta * structuralOrder * 0.0035

                let nx = dx / max(distance, 0.001)
                let ny = dy / max(distance, 0.001)

                p.velocity.dx += nx * ringForce
                p.velocity.dy += ny * ringForce
            }

            let damping = structuralOrder < 0.7
                ? 0.96
                : 0.9 + structuralOrder * 0.08

            p.velocity.dx *= damping
            p.velocity.dy *= damping

            if structuralOrder > 0.92 {
                p.velocity.dx *= 0.3
                p.velocity.dy *= 0.3
            }

            p.position.x += p.velocity.dx
            p.position.y += p.velocity.dy

            wrap(&p.position)
            node.position = p.position
            particles[i] = p
        }

        onMetricsUpdate?(
            Metrics(
                fieldOrder: fieldOrder,
                structuralOrder: structuralOrder,
                isGestureActive: isGestureActive
            )
        )
    }

    /// Wraps a point around scene bounds to keep particles on-screen.
    private func wrap(_ p: inout CGPoint) {
        if p.x < 0 { p.x = size.width }
        if p.x > size.width { p.x = 0 }
        if p.y < 0 { p.y = size.height }
        if p.y > size.height { p.y = 0 }
    }

    /// Generates a random point inside the scene's bounds.
    private func randomPoint() -> CGPoint {
        CGPoint(
            x: .random(in: 0...size.width),
            y: .random(in: 0...size.height)
        )
    }
}

