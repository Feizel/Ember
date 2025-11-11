import SwiftUI

struct OnboardingFlowView: View {
    @State private var currentStep = 0
    @Environment(\.dismiss) private var dismiss
    
    let onComplete: () -> Void
    
    private let steps: [OnboardingStep] = [
        .welcome,
        .loveStory,
        .connection,
        .touchDemo,
        .partnerSetup,
        .permissions
    ]
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            TabView(selection: $currentStep) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    stepView(for: step, at: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func stepView(for step: OnboardingStep, at index: Int) -> some View {
        switch step {
        case .welcome:
            OnboardingWelcomeView(onNext: nextStep)
        case .loveStory:
            OnboardingLoveStoryView(onNext: nextStep)
        case .connection:
            OnboardingConnectionView(onNext: nextStep)
        case .touchDemo:
            OnboardingTouchDemoView(onNext: nextStep, onSkip: nextStep)
        case .partnerSetup:
            OnboardingRomanticPartnerSetupView(onNext: nextStep, onSkip: nextStep)
        case .permissions:
            OnboardingPermissionsStepView(onNext: onComplete, onSkip: onComplete)
        }
    }
    
    private func nextStep() {
        if currentStep < steps.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep += 1
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

enum OnboardingStep: CaseIterable {
    case welcome, loveStory, connection, touchDemo, partnerSetup, permissions
}

#Preview {
    OnboardingFlowView {
        print("Onboarding completed")
    }
}