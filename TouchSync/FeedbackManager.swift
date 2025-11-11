import SwiftUI
import CoreHaptics
import Combine

@MainActor
class FeedbackManager: ObservableObject {
    static let shared = FeedbackManager()
    
    private let hapticsManager = HapticsManager.shared
    
    private init() {}
    
    // MARK: - Button Feedback
    func buttonTap() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func buttonPress() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func buttonHeavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Navigation Feedback
    func tabSwitch() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func menuOpen() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func menuClose() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Success/Error Feedback
    func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        hapticsManager.playSuccess()
    }
    
    func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
    
    func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    // MARK: - Touch Gestures Feedback
    func gestureStart() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func gestureSent() {
        success()
    }
    
    func gestureReceived() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Connection Feedback
    func connectionEstablished() {
        hapticsManager.playConnectionEstablished()
    }
    
    func connectionLost() {
        error()
    }
    
    // MARK: - Level Up/Achievement Feedback
    func levelUp() {
        hapticsManager.playSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.hapticsManager.playSuccess()
        }
    }
    
    func achievementUnlocked() {
        success()
    }
}

// MARK: - Visual Feedback Modifiers
struct PulseEffect: ViewModifier {
    @State private var isPulsing = false
    let duration: Double
    let scale: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? scale : 1.0)
            .animation(.easeInOut(duration: duration).repeatForever(autoreverses: true), value: isPulsing)
            .onAppear {
                isPulsing = true
            }
    }
}

struct ShakeEffect: ViewModifier {
    @State private var shakeOffset: CGFloat = 0
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: shakeOffset)
            .onChange(of: trigger) { _, _ in
                withAnimation(.easeInOut(duration: 0.1).repeatCount(3, autoreverses: true)) {
                    shakeOffset = 10
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    shakeOffset = 0
                }
            }
    }
}

struct BounceEffect: ViewModifier {
    @State private var bounceScale: CGFloat = 1.0
    let trigger: Bool
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(bounceScale)
            .onChange(of: trigger) { _, _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.3)) {
                    bounceScale = 1.2
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8).delay(0.1)) {
                    bounceScale = 1.0
                }
            }
    }
}

// MARK: - View Extensions
extension View {
    func pulseEffect(duration: Double = 1.5, scale: CGFloat = 1.05) -> some View {
        modifier(PulseEffect(duration: duration, scale: scale))
    }
    
    func shakeEffect(trigger: Bool) -> some View {
        modifier(ShakeEffect(trigger: trigger))
    }
    
    func bounceEffect(trigger: Bool) -> some View {
        modifier(BounceEffect(trigger: trigger))
    }
    
    func feedbackTap() -> some View {
        onTapGesture {
            FeedbackManager.shared.buttonTap()
        }
    }
    
    func feedbackPress() -> some View {
        simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    FeedbackManager.shared.buttonPress()
                }
        )
    }
}