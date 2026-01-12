/// Root SwiftUI view that hosts the SpriteKit scene rendering the particle system.
import SwiftUI
import SpriteKit

/// Displays a `SpriteView` backed by `ParticleScene`, filling the screen.
struct ContentView: View {

    /// Backing view model that manages the particle simulation state and updates.
    private let viewModel = ParticleViewModel()

    /// The main view hierarchy. Renders a `SpriteView` and ignores safe areas for full-bleed content.
    var body: some View {
        SpriteView(scene: makeScene())
            .ignoresSafeArea()
    }

    /// Creates and configures the SpriteKit scene used by the `SpriteView`.
    /// - Returns: A `ParticleScene` configured to resize with the view.
    private func makeScene() -> SKScene {
        let scene = ParticleScene(viewModel: viewModel)
        scene.scaleMode = .resizeFill
        return scene
    }
}
