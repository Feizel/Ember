import SwiftUI

struct EmberOnboardingView: View {
    @StateObject private var onboardingManager = EmberOnboardingManager()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        OnboardingFlowView {
            onboardingManager.completeOnboarding()
            
            // Authenticate immediately when "Begin Our Love Story" is clicked
            EmberAuthManager.shared.authenticateUser(userId: "demo_user")
            EmberAuthManager.shared.setPartnerId("demo_partner")
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    EmberOnboardingView()
}