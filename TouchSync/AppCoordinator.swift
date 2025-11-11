import SwiftUI

struct AppCoordinator: View {
    @StateObject private var appStateManager = AppStateManager.shared
    @StateObject private var authManager = AuthManager()
    @StateObject private var settingsManager = SettingsManager.shared
    
    var body: some View {
        Group {
            switch appStateManager.appState {
            case .splash:
                SplashScreen()
                    .transition(.opacity)
                
            case .onboarding:
                OnboardingView()
                    .transition(.slide)
                
            case .main:
                if authManager.isAuthenticated {
                    MainTabView()
                        .environmentObject(authManager)
                        .environmentObject(settingsManager)
                        .transition(.opacity)
                } else {
                    AuthenticationView()
                        .environmentObject(authManager)
                        .transition(.slide)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appStateManager.appState)
        .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
    }
}

#Preview {
    AppCoordinator()
}