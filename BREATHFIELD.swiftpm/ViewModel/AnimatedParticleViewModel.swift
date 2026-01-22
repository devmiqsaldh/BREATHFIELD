
//
//  AnimatedParticleScene.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import SwiftUI
/// View model responsible for configuring and exposing an `AnimatedParticleScene` for SwiftUI/SpriteKit integration.
@MainActor
/// An observable view model that prepares a transparent `AnimatedParticleScene` for rendering.
final class AnimatedParticleViewModel: ObservableObject {
    /// The SpriteKit scene displayed by the UI.
    let scene: AnimatedParticleScene

    /// Initializes the view model and configures the scene.
    /// The scene's background is set to `.clear` so it can overlay SwiftUI content seamlessly.
    init() {
        let scene = AnimatedParticleScene()
        scene.backgroundColor = .clear
        self.scene = scene
    }
}

