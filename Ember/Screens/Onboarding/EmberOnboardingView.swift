import SwiftUI

struct EmberOnboardingView: View {
    @StateObject private var authManager = EmberAuthManager.shared
    @State private var currentStep = 0
    @State private var pairingCode = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            EmberColors.backgroundPrimary.ignoresSafeArea()
            
            LinearGradient(
                colors: [EmberColors.backgroundPrimary, EmberColors.coralPop.opacity(0.3)],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                HStack(spacing: 20) {
                    EmberCharacterView(
                        character: .touchy,
                        size: 100,
                        expression: .happy,
                        isAnimating: true
                    )
                    
                    EmberCharacterView(
                        character: .syncee,
                        size: 100,
                        expression: .romantic,
                        isAnimating: true
                    )
                }
                
                if currentStep == 0 {
                    VStack(spacing: 16) {
                        Text("Welcome to Ember")
                            .emberText(.displayMedium)
                            .multilineTextAlignment(.center)
                        
                        Text("Stay connected with your loved one through gentle touches")
                            .emberBody(color: EmberColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    VStack(spacing: 16) {
                        Text("Connect with Partner")
                            .emberText(.headlineLarge)
                        
                        EmberTextField(
                            "Pairing Code",
                            placeholder: "Enter 6-digit code",
                            text: $pairingCode,
                            keyboardType: .numberPad
                        )
                        .frame(maxWidth: 200)
                        
                        if isLoading {
                            ProgressView().tint(EmberColors.roseQuartz)
                        }
                    }
                }
                
                Spacer()
                
                if currentStep == 0 {
                    EmberButton("Get Started") {
                        withAnimation(.spring()) { currentStep = 1 }
                    }
                } else {
                    EmberButton("Connect") {
                        Task {
                            isLoading = true
                            try? await authManager.linkPartner(withCode: pairingCode)
                            isLoading = false
                        }
                    }
                    .disabled(pairingCode.count != 6 || isLoading)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    EmberOnboardingView()
}