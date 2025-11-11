import SwiftUI

@main
struct TouchSyncApp: App {
    @StateObject private var notificationManager = CoupleNotificationManager()
    
    var body: some Scene {
        WindowGroup {
            AppCoordinator()
                .environment(\.managedObjectContext, PersistenceController.shared.context)
                .environmentObject(notificationManager)
        }
    }
}