//
//  SpriteKitView.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 21/01/26.
//

import SwiftUI
import SpriteKit

/// A SwiftUI wrapper for presenting a SpriteKit scene using `SKView`.
struct SpriteKitView: UIViewRepresentable {

    /// The SpriteKit scene to render.
    let scene: SKScene

    /// Creates and configures the underlying `SKView`.
    func makeUIView(context: Context) -> SKView {
        let view = SKView()

        // Enable transparency so the scene can overlay SwiftUI content.
        view.isOpaque = false
        view.backgroundColor = .clear
        view.allowsTransparency = true

        // Match the scene size to the device screen; adjust as needed for layout.
        scene.size = UIScreen.main.bounds.size  
        view.presentScene(scene)

        return view
    }

    /// Updates the `SKView` when SwiftUI state changes.
    /// No-op for now; the scene is already presented and driven by SpriteKit.
    func updateUIView(_ uiView: SKView, context: Context) {}
}

