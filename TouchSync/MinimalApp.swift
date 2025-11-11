import SwiftUI

// Minimal app for testing - rename this to TouchSyncApp if needed
struct MinimalTestApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("TouchSync")
                    .font(.largeTitle)
                Text("App is running!")
                    .foregroundColor(.green)
            }
            .padding()
        }
    }
}