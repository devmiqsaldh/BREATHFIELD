//
//  AnimatedParticleScene.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import SpriteKit

/// A lightweight SpriteKit scene that renders and animates floating particles.
///
/// Particles are drawn as small circles and animated with a back-and-forth
/// movement using `SKAction` to create a subtle breathing/flow effect.
final class AnimatedParticleScene: SKScene {

    /// Called when the scene is presented by a view. Sets up visuals and particles.
    override func didMove(to view: SKView) {
        /// Transparent background so the scene overlays underlying content.
        backgroundColor = .clear
        /// Resize with the SKView to fill available space.
        scaleMode = .resizeFill

        /// Create and animate the particle nodes.
        createParticles()
    }

    /// Creates a batch of particle nodes with random positions and starts their animations.
    private func createParticles() {
        /// Adjust the count to control density/performance.
        for _ in 0..<120 {
            /// Small circular node representing one particle.
            let particle = SKShapeNode(circleOfRadius: 1.5)
            particle.fillColor = .black
            particle.strokeColor = .clear
            particle.alpha = 0.6

            /// Randomize initial position within the scene's bounds.
            particle.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            )

            /// Add to the scene graph and start a floating animation.
            addChild(particle)
            applyFloatingAnimation(to: particle)
        }
    }

    /// Applies a gentle back-and-forth movement to a node using a repeated sequence.
    private func applyFloatingAnimation(to node: SKNode) {
        /// Randomize movement vector and duration for organic variation.
        let dx = CGFloat.random(in: -200...200)
        let dy = CGFloat.random(in: -200...200)
        let duration = 4.0

        /// Move out and then reverse to create a ping-pong effect.
        let move = SKAction.moveBy(x: dx, y: dy, duration: duration)
        move.timingMode = .easeInEaseOut

        let reverse = move.reversed()
        let sequence = SKAction.sequence([move, reverse])

        node.run(.repeatForever(sequence))
    }
}

