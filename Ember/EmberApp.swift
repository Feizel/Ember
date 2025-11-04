//
//  EmberApp.swift
//  Ember
//
//  Created by Feizel Maduna on 2025/11/04.
//

import SwiftUI
import CoreData

@main
struct EmberApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
