/// Application entry point.
///
/// Configures the main window group and presents `ContentView` as the
/// root view of the app.
import SwiftUI

/// Main application type for BREATHFIELD.
@main
struct MyApp: App {
    /// Declares the app's scenes.
    ///
    /// The primary scene is a `WindowGroup` that hosts `ContentView`.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
