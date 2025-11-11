import SwiftUI
import UserNotifications
import Combine

struct OnboardingPermissionsStepView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @State private var notificationStatus: PermissionStatus = .notRequested
    @State private var hapticsStatus: PermissionStatus = .notRequested
    @State private var microphoneStatus: PermissionStatus = .notRequested
    @State private var isRequesting = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    Button("Skip") {
                        onSkip()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    Text("Complete Your Love Story")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Allow us to create intimate moments between you and your beloved")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            Spacer()
            
            // Permission cards
            VStack(spacing: 16) {
                OnboardingPermissionCard(
                    icon: "bell.badge.fill",
                    title: "Love Notifications",
                    description: "Feel your partner's presence with gentle alerts when they reach out",
                    status: notificationStatus,
                    isRequired: true,
                    onTap: requestNotifications
                )
                
                OnboardingPermissionCard(
                    icon: "hand.tap.fill",
                    title: "Intimate Touch",
                    description: "Experience your partner's loving touch through gentle haptic feedback",
                    status: hapticsStatus,
                    isRequired: true,
                    onTap: checkHaptics
                )
                
                OnboardingPermissionCard(
                    icon: "mic.fill",
                    title: "Sweet Whispers",
                    description: "Share tender voice messages that speak from your heart",
                    status: microphoneStatus,
                    isRequired: false,
                    onTap: requestMicrophone
                )
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            // Continue button
            VStack(spacing: 16) {
if allRequiredGranted {
                    EmberLoveLaneButton(title: "Begin Our Love Story") {
                        onNext()
                    }
                } else {
                    Button(action: {
                        EmberHapticsManager.shared.playMedium()
                        onNext()
                    }) {
                        Text("Start Without Some Magic")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .buttonStyle(EmberPressableButtonStyle())
                    .disabled(isRequesting)
                }
                
                if !allRequiredGranted {
                    Text("Your love story will be more magical with all permissions")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .onAppear {
            checkInitialPermissions()
        }
    }
    
    private var allRequiredGranted: Bool {
        notificationStatus == .granted && hapticsStatus == .granted
    }
    
    private func checkInitialPermissions() {
        // Haptics don't require permission, just check availability
        hapticsStatus = EmberHapticsManager.shared.isHapticsAvailable ? .granted : .denied
        
        // Check notifications
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    notificationStatus = .granted
                case .denied:
                    notificationStatus = .denied
                default:
                    notificationStatus = .notRequested
                }
            }
        }
    }
    
    private func requestNotifications() {
        guard notificationStatus == .notRequested else { return }
        
        isRequesting = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                notificationStatus = granted ? .granted : .denied
                isRequesting = false
                if granted {
                    EmberHapticsManager.shared.playSuccess()
                }
            }
        }
    }
    
    private func checkHaptics() {
        hapticsStatus = .granted
        EmberHapticsManager.shared.playMedium()
    }
    
    private func requestMicrophone() {
        // Implementation for microphone permission
        microphoneStatus = .granted
    }
}

struct OnboardingPermissionCard: View {
    let icon: String
    let title: String
    let description: String
    let status: PermissionStatus
    let isRequired: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(iconColor)
                }
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        if isRequired {
                            Text("Required")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.white.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        
                        Spacer()
                    }
                    
                    Text(description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                
                // Status
                statusIcon
            }
            .padding(20)
            .background(.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(status == .granted)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var iconColor: Color {
        switch status {
        case .granted: return .green
        case .denied: return .red
        case .notRequested: return .white
        }
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        switch status {
        case .granted:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.green)
        case .denied:
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.red)
        case .notRequested:
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}

enum PermissionStatus {
    case notRequested, granted, denied
}

#Preview {
    OnboardingPermissionsStepView(
        onNext: { print("Next") },
        onSkip: { print("Skip") }
    )
}
