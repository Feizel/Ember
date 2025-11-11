import SwiftUI
import UserNotifications
import CoreHaptics
import AVFoundation

// MARK: - Permission Card Data
struct PermissionCard {
    let icon: String
    let title: String
    let description: String
    let required: Bool
}

// MARK: - Onboarding Permissions Screen
struct OnboardingPermissionsView: View {
    @State private var cardsVisible = false
    @State private var ctaVisible = false
    @State private var isRequestingPermissions = false
    @Environment(\.colorScheme) var colorScheme
    
    let onContinue: () -> Void
    let onSkip: () -> Void
    
    private let permissionCards = [
        PermissionCard(
            icon: "bell.badge.fill",
            title: "Notifications",
            description: "Get notified when your partner sends a touch",
            required: true
        ),
        PermissionCard(
            icon: "hand.wave.fill",
            title: "Haptics",
            description: "Feel your partner's touch through vibrations",
            required: true
        ),
        PermissionCard(
            icon: "mic.fill",
            title: "Microphone (Optional)",
            description: "Send voice messages to your partner",
            required: false
        )
    ]
    
    var body: some View {
        ZStack {
            // Background
            backgroundView
            
            VStack(spacing: 32) {
                Spacer()
                
                // Headline
                headlineSection
                
                // Permission cards
                permissionCardsSection
                
                Spacer()
                
                // CTA buttons
                ctaSection
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .onAppear {
            startPermissionsAnimation()
        }
    }
    
    // MARK: - Background
    private var backgroundView: some View {
        LinearGradient(
            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Headline Section
    private var headlineSection: some View {
        VStack(spacing: 12) {
            Text("We need a few permissions")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            Text("To give you the best experience")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Permission Cards Section
    private var permissionCardsSection: some View {
        VStack(spacing: 16) {
            ForEach(Array(permissionCards.enumerated()), id: \.offset) { index, card in
                PermissionCardView(card: card)
                    .offset(y: cardsVisible ? 0 : 30)
                    .opacity(cardsVisible ? 1.0 : 0.0)
                    .animation(
                        .easeOut(duration: 0.4).delay(Double(index) * 0.1),
                        value: cardsVisible
                    )
            }
        }
    }
    
    // MARK: - CTA Section
    private var ctaSection: some View {
        VStack(spacing: 16) {
            // Primary CTA
            Button(action: {
                requestPermissions()
            }) {
                HStack {
                    if isRequestingPermissions {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(height: 56)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [EmberColors.roseQuartz, EmberColors.coralPop],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(
                    color: EmberColors.roseQuartz.opacity(0.3),
                    radius: 8,
                    x: 0,
                    y: 4
                )
            }
            .buttonStyle(EmberPressableButtonStyle())
            .disabled(isRequestingPermissions)
            
            // Skip button
            Button("Skip for now") {
                EmberHapticsManager.shared.playLight()
                onSkip()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(.white.opacity(0.7))
        }
        .scaleEffect(ctaVisible ? 1.0 : 0.9)
        .opacity(ctaVisible ? 1.0 : 0.0)
    }
    
    // MARK: - Animation Sequence
    private func startPermissionsAnimation() {
        // Staggered card entrance
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            cardsVisible = true
        }
        
        // CTA appears after cards
        withAnimation(.easeOut(duration: 0.3).delay(0.8)) {
            ctaVisible = true
        }
    }
    
    // MARK: - Permission Requests
    private func requestPermissions() {
        isRequestingPermissions = true
        EmberHapticsManager.shared.playLight()
        
        // Only request notifications - skip haptics and microphone to avoid TCC crash
        requestNotificationPermission()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isRequestingPermissions = false
            EmberHapticsManager.shared.playSuccess()
            self.onContinue()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
}

// MARK: - Permission Card View
struct PermissionCardView: View {
    let card: PermissionCard
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Card tap feedback
            EmberHapticsManager.shared.playSelection()
            // TODO: Add soft_tap.mp3
        }) {
            HStack(spacing: 16) {
                // Icon
                Image(systemName: card.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(EmberColors.roseQuartz)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.white.opacity(0.2))
                    )
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(card.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        if card.required {
                            Text("Required")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(EmberColors.roseQuartz)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(.white.opacity(0.2))
                                )
                        }
                        
                        Spacer()
                    }
                    
                    Text(card.description)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.15))
                    .shadow(
                        color: .black.opacity(0.1),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
        }
        .buttonStyle(PermissionCardButtonStyle())
    }
}

// MARK: - Permission Card Button Style
struct PermissionCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingPermissionsView(
        onContinue: { print("Continue tapped") },
        onSkip: { print("Skip tapped") }
    )
}