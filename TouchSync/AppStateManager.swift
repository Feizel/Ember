import Foundation
import Combine

@MainActor
class AppStateManager: ObservableObject {
    static let shared = AppStateManager()
    
    @Published var appState: AppState = .splash
    @Published var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    private init() {
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        // Start with splash screen
        startSplashSequence()
    }
    
    private func startSplashSequence() {
        appState = .splash
        
        // Show splash for 2.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.completeSplash()
        }
    }
    
    private func completeSplash() {
        if hasCompletedOnboarding {
            appState = .main
        } else {
            appState = .onboarding
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        appState = .main
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        appState = .onboarding
    }
}

enum AppState {
    case splash
    case onboarding
    case main
}