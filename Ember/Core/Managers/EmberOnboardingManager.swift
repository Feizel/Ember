import SwiftUI
import Combine

enum EmberOnboardingStep: Int, CaseIterable {
    case welcome = 0
    case uvpDemo = 1
    case permissions = 2
    case partnerSetup = 3
    
    var title: String {
        switch self {
        case .welcome: return "Welcome to Ember"
        case .uvpDemo: return "Feel the Magic"
        case .permissions: return "Enable Features"
        case .partnerSetup: return "Connect Together"
        }
    }
    
    var subtitle: String {
        switch self {
        case .welcome: return "Stay connected through touch"
        case .uvpDemo: return "Experience haptic touch technology"
        case .permissions: return "Allow notifications and haptics"
        case .partnerSetup: return "Link with your partner"
        }
    }
}

@MainActor
class EmberOnboardingManager: ObservableObject {
    @Published var currentStep: EmberOnboardingStep = .welcome
    @Published var isCompleted = false
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        isCompleted = userDefaults.bool(forKey: "emberOnboardingCompleted")
    }
    
    func nextStep() {
        if let nextStep = EmberOnboardingStep(rawValue: currentStep.rawValue + 1) {
            currentStep = nextStep
        } else {
            completeOnboarding()
        }
    }
    
    func previousStep() {
        if let previousStep = EmberOnboardingStep(rawValue: currentStep.rawValue - 1) {
            currentStep = previousStep
        }
    }
    
    func completeOnboarding() {
        isCompleted = true
        userDefaults.set(true, forKey: "emberOnboardingCompleted")
    }
    
    func skipToEnd() {
        completeOnboarding()
    }
}