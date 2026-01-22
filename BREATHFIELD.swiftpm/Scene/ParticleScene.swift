/// SpriteKit scene responsible for rendering and updating particle nodes based on input gestures.

import SpriteKit

/// Manages SpriteKit nodes that visualize the particle system and responds to touch and Apple Pencil input.
final class ParticleScene: SKScene {
    
    /// Source of truth for particle simulation data and logic.
    private let viewModel: ParticleViewModel
    
    /// Lookup from particle identifiers to their corresponding SpriteKit shape nodes.
    private var nodes: [UUID: SKShapeNode] = [:]
    
    /// Tracks and analyzes the current gesture to influence the simulation (speed, smoothness, pressure).
    private let gestureVM = GestureViewModel()
    
    /// Creates a new scene bound to a particle view model.
    /// - Parameter viewModel: The view model that drives the particle system.
    init(viewModel: ParticleViewModel) {
        self.viewModel = viewModel
        super.init(size: .zero)
    }
    
    /// Unavailable: this scene is intended to be created programmatically.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Called when the scene is presented by a view. Sets up background, configures the model, and creates nodes.
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.96, green: 0.97, blue: 0.98, alpha: 1)
        viewModel.configure(bounds: size)
        createNodes()
    }
    
    /// Builds visual nodes for each particle and adds them to the scene.
    private func createNodes() {
        for particle in viewModel.particles {
            let node = SKShapeNode(circleOfRadius: particle.radius)
            node.fillColor = SKColor(cgColor: particle.currentColor)
            node.strokeColor = .clear
            node.glowWidth = 1.5
            node.position = particle.position
            
            addChild(node)
            nodes[particle.id] = node
        }
    }
    
    /// Per-frame update: advances the simulation, applies gesture influence, and syncs node state.
    override func update(_ currentTime: TimeInterval) {
        viewModel.update()
        viewModel.applyGesture(
            speed: gestureVM.currentSpeed,
            smoothness: gestureVM.smoothness
        )
        syncNodes()
    }
    
    /// Propagates model state to SpriteKit nodes (position and color).
    private func syncNodes() {
        for particle in viewModel.particles {
            if let node = nodes[particle.id] {
                node.position = particle.position
                node.fillColor = SKColor(cgColor: particle.currentColor)
            }
        }
    }
    
    /// Starts a new stroke for gesture analysis when the user touches the scene.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        
        let location = t.location(in: self)
        let isPencil = t.type == .pencil
        let pressure = isPencil ? t.force / t.maximumPossibleForce : 1.0
        
        gestureVM.beginStroke(
            at: location,
            time: t.timestamp,
            pressure: pressure,
            isPencil: isPencil
        )
    }
    
    /// Updates the current stroke with new points as the user moves their finger or Apple Pencil.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let t = touches.first else { return }
        
        let location = t.location(in: self)
        let isPencil = t.type == .pencil
        let pressure = isPencil ? t.force / t.maximumPossibleForce : 1.0
        
        gestureVM.addPoint(
            location,
            time: t.timestamp,
            pressure: pressure,
            isPencil: isPencil
        )
    }
    
    /// Ends the current stroke and resets gesture metrics.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gestureVM.endStroke()
    }
    
}
