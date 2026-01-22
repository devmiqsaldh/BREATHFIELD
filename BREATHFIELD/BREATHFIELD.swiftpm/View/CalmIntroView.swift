//
//  WelcomeView.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 20/01/26.
//

import SwiftUI

/// An introductory screen that displays a calming background,
/// animated particle effects, and a motivational message.
///
/// The particle animation is driven by `AnimatedParticleViewModel` and
/// rendered using `SpriteKitView`. The background image fills the
/// entire screen.
struct CalmIntroView: View {

    /// Manages the SpriteKit scene that renders the animated particles.
    @State private var viewModel = AnimatedParticleViewModel()

    /// The view hierarchy for the intro screen.
    var body: some View {
        ZStack {
            // Full-screen background image.
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Renders the particle animation from the view model's scene.
            SpriteKitView(scene: viewModel.scene)
                .ignoresSafeArea()
            
            // Centered motivational message.
            Text("Empty your mind\nand let the calm flow")
                .multilineTextAlignment(.center)
                .font(.system(size: 26, weight: .bold, design: .serif))
                .foregroundColor(.black)
        }
    }
}

/// Preview for Xcode canvas.
#Preview {
    CalmIntroView()
}

