//
//  InteractiveFieldView.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 20/01/26
//


import SwiftUI

/// The interactive screen where the user manipulates the particle field.
///
/// Hosts a SpriteKit-backed field and forwards drag gestures to the view model
/// to influence the simulation's order and chaos.
struct InteractiveFieldView: View {
    /// Environment presentation mode, used to dismiss when the field is stable.
    @Environment(\.presentationMode) private var presentationMode
    /// View model driving the particle field's state and metrics.
    @StateObject private var viewModel = FieldViewModel()
    /// Tracks the last touch location if needed for additional interactions.
    @State private var lastLocation: CGPoint?
    
    /// Main layout: background, header, and the interactive SpriteKit field.
    var body: some View {
        ZStack {
            /// Full-screen background image.
            Image("background")
                .resizable()
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                header
                
                /// Card container for the field with rounded corners and gesture handling.
                ZStack {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.black)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    SpriteKitView(scene: viewModel.scene)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                        /// Forward drag gestures to the view model to drive the simulation.
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let velocity = hypot(
                                        value.translation.width,
                                        value.translation.height
                                    )

                                    viewModel.registerGesture(
                                        velocity: velocity,
                                        location: value.location,
                                        translation: value.translation
                                    )
                                }
                                .onEnded { _ in
                                    viewModel.stopGesture()
                                }
                        )
                }
                .padding(.horizontal)
            }
            
            /// Present completion/stability overlay when the field reaches stability.
            if viewModel.showStableInfo {
                StableFieldView {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        /// Smoothly animate changes tied to the field state.
        .animation(.easeInOut(duration: 1.2), value: viewModel.state)
        /// Hide the default navigation UI for an immersive experience.
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    /// Header showing the title and the current field state.
    private var header: some View {
        VStack(spacing: 0) {
            /// Title and section label.
            HStack(spacing:5){
                
                
                Text("Calm your mind")
                    .foregroundStyle(.black)
                    .font(.system(size: 17, weight: .semibold, design: .serif))
                    .padding(.horizontal)
                
                Spacer()
                Text("State")
                    .padding(.horizontal, -115)
                    .foregroundStyle(.black)
                    .font(.system(size: 17, weight: .semibold, design: .serif))
            }
            /// Current state description styled by its representative color.
            HStack(spacing: 0){
                Spacer()
                Text(viewModel.state.description)
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundStyle(viewModel.state.color)
                    .padding(.horizontal, -115)
                
            }
        }
        .padding(.top, 18)
    }
}

#Preview {
    InteractiveFieldView()
}
