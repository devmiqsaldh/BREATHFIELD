/// Application entry point. Sets up the main window group and presents `ContentView`.
import SwiftUI

/// Main application type for the particle gesture demo.
@main
struct MyApp: App {
    /// Scene configuration for the app's window.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
