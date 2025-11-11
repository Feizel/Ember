//
//  ContentView.swift
//  Ember
//
//  Created by Feizel Maduna on 2025/11/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = EmberAuthManager.shared
    @State private var showSplash = true
    @State private var showLoading = false
    @State private var onboardingCompleted = false
    
    var body: some View {
        Group {
            if showSplash {
                EmberSplashScreen {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            } else if showLoading {
                EmberLoadingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showLoading = false
                        onboardingCompleted = true
                    }
                }
            } else if onboardingCompleted || (authManager.isAuthenticated && authManager.partnerId != nil) {
                EmberMainTabView()
            } else {
                EmberOnboardingView()
                    .onReceive(authManager.$isAuthenticated) { isAuthenticated in
                        if isAuthenticated && authManager.partnerId != nil {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showLoading = true
                            }
                        }
                    }
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    ContentView()
}
