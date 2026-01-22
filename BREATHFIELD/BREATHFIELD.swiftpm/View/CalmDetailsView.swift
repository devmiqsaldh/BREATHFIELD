//
//  IntrusionsView.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 20/01/26.
//

import SwiftUI

/// A details screen introducing the interactive calm field experience.
///
/// Presents guidance text, a themed background, and a button that navigates
/// to the interactive field view.
struct CalmDetailsView: View {

    /// The navigation path bound to the enclosing `NavigationStack`.
    @Binding var navigationPath: NavigationPath

    /// Main view layout composed of background imagery, instructional text,
    /// and a navigation action to begin the interactive experience.
    var body: some View {
        ZStack {

            // Full-screen background image for visual context.
            Image("background2")
                .resizable()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Title and subtitle copy.
            VStack(spacing: 19) {

                Text("Empty your mind\nand let the calm flow")
                    .font(.system(size: 26, weight: .bold, design: .serif))
                    .padding(.top, -330)

                Text("Intrusions")
                    .font(.system(size: 23, weight: .bold, design: .serif))
                    .padding(.top, -120)
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(.black)

            // Instructional tips about interacting with the field.
            VStack(spacing: 16) {
                Text("Touch the field, move it slowly, and\nobserve how it reacts")

                Text("Slow movements allow the field to organize\nitself, while abrupt movements disorganize it")
            }
            .frame(width: 360, height: 120)
            .background(Color(.newColor2))
            .multilineTextAlignment(.center)
            .font(.system(size: 16, weight: .regular, design: .serif))
            .foregroundStyle(.white)
            .cornerRadius(15)

            // Call-to-action to start the interactive field.
            VStack {
                NavigationLink(value: "interactive") {
                    Text("Begin")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 44)
                        .background(Color.green)
                        .cornerRadius(22)
                }
                .padding(.top, 450)
            }
        }
        /// Navigation destination for string-based routes.
        .navigationDestination(for: String.self) { route in
            if route == "interactive" {
                InteractiveFieldView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CalmDetailsView(navigationPath: .constant(NavigationPath()))
    }
}

