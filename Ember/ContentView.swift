//
//  ContentView.swift
//  Ember
//
//  Created by Feizel Maduna on 2025/11/04.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = EmberAuthManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated && authManager.partnerId != nil {
                EmberMainTabView()
            } else {
                EmberOnboardingView()
            }
        }
        .environmentObject(authManager)
    }
}

#Preview {
    ContentView()
}
