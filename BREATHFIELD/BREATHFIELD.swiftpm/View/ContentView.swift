/// Root SwiftUI view that manages initial intro and navigation to details.
///
/// Shows a brief splash/intro (`CalmIntroView`) and then transitions to
/// `CalmDetailsView` inside a `NavigationStack`.
import SwiftUI

struct ContentView: View {

    /// Controls whether the intro splash is visible.
    @State private var showIntro = true

    /// Path for programmatic navigation within the `NavigationStack`.
    @State private var navigationPath = NavigationPath()

    /// Hosts the navigation and handles the cross-fade between intro and details.
    var body: some View {
        NavigationStack(path: $navigationPath) {
            // Cross-fade between the intro and the details screen.
            ZStack {
                if showIntro {
                    CalmIntroView()
                        .transition(.opacity)
                } else {
                    CalmDetailsView(navigationPath: $navigationPath)
                        .transition(.opacity)
                }
            }
        }
        /// Smooth fade animation tied to the `showIntro` state.
        .animation(.easeInOut(duration: 2.5), value: showIntro)
        /// Start the splash timer on first appearance.
        .onAppear {
            if showIntro {
                startSplashTimer()
            }
        }
    }

    /// Delays for a few seconds, then hides the intro with animation.
    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                showIntro = false
            }
        }
    }
}

#Preview {
    ContentView()
}
