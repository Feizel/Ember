//
//  EmberApp.swift
//  Ember - Premium Couple Connection App
//
//  Created by Feizel Maduna on 2025/11/04.
//

import SwiftUI
import CoreData

@main
struct EmberApp: App {
    let persistenceController = EmberPersistenceController.shared
    @StateObject private var authManager = EmberAuthManager.shared
    @StateObject private var touchRepository = EmberTouchRepository.shared
    @StateObject private var streakManager = EmberStreakManager.shared
    @StateObject private var hapticsManager = EmberHapticsManager.shared
    @StateObject private var notificationManager = EmberNotificationManager.shared
    
    init() {
        // Initialize premium design system
        setupPremiumDesignSystem()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(authManager)
                .environmentObject(touchRepository)
                .environmentObject(streakManager)
                .environmentObject(hapticsManager)
                .environmentObject(notificationManager)
                .preferredColorScheme(.light) // Force light mode for premium look
                .onAppear {
                    Task {
                        await notificationManager.requestPermission()
                    }
                }
        }
    }
    
    // MARK: - Premium Design System Setup
    private func setupPremiumDesignSystem() {
        // Configure navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor.clear
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.shadowColor = UIColor.black.withAlphaComponent(0.1)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Configure overall app tint
        UIView.appearance().tintColor = UIColor(EmberColors.roseQuartz)
    }
}
