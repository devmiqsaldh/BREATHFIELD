//
//  StableFieldView.swift
//  BREATHFIELD
//
//  Created by Miqueias Saldanha on 20/01/26.
//

import SwiftUI

/// A simple overlay presented when the field is stable.
/// Shows a confirmation message and offers a button to restart the experience.
/// - Parameter onRestart: Closure invoked when the user taps the Restart button.
struct StableFieldView: View {
    
    /// Callback executed when the user chooses to restart
    let onRestart: () -> Void
    
    /// Main view hierarchy for the stable field overlay.
    var body: some View {
        ZStack {
            
            /// Semi-transparent dimming layer behind the content
            Color.black.opacity(0.45)
                .ignoresSafeArea() /// Cover the entire screen, including safe areas
            
            /// Vertical stack for title, subtitle, and action button
            VStack(spacing: 28) {
                
                /// Title message
                Text("The field is stable")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .padding(.vertical, -17) /// Tighten vertical spacing for visual balance
  
                /// Supporting subtitle
                Text("A calm field reflects a calm mind")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 19, weight: .bold, design: .serif))

                /// Primary action to restart the flow
                Button("Restart", action: onRestart)
                    .font(.system(size: 17, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
                    .frame(width: 140, height: 44)
                    .background(Color.green) /// Button fill color
                    .cornerRadius(22) /// Capsule-like rounded corners
                    .padding(.vertical, 15) /// Extra tap target spacing
            }
        }
    }
}

/// MARK: - Preview
#Preview {
    StableFieldView(onRestart: {})
}
