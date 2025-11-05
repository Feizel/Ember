import SwiftUI

struct EmberAnimations {
    // MARK: - Transitions
    static let screenTransition = Animation.spring(response: 0.5, dampingFraction: 0.9)
    static let buttonPress = Animation.easeInOut(duration: 0.15)
    static let stateChange = Animation.easeInOut(duration: 0.2)
    
    // MARK: - Micro-interactions
    static let fabTap = Animation.spring(response: 0.3, dampingFraction: 0.6)
    static let cardTap = Animation.easeInOut(duration: 0.15)
    static let heartbeat = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
}

// MARK: - Animation Modifiers
struct EmberScaleEffect: ViewModifier {
    let isPressed: Bool
    let scale: CGFloat
    
    func body(content: Content) -> some View {
        content.scaleEffect(isPressed ? scale : 1.0)
    }
}

extension View {
    func emberPressAnimation(isPressed: Bool, scale: CGFloat = 0.95) -> some View {
        modifier(EmberScaleEffect(isPressed: isPressed, scale: scale))
    }
}