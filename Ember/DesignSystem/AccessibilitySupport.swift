import SwiftUI

// MARK: - Accessibility Support System
struct AccessibleButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    let accessibilityLabel: String
    let accessibilityHint: String?
    let hapticFeedback: Bool
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State private var isPressed = false
    
    init(
        accessibilityLabel: String,
        accessibilityHint: String? = nil,
        hapticFeedback: Bool = true,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.hapticFeedback = hapticFeedback
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            if hapticFeedback {
                EmberHapticsManager.shared.playLight()
            }
            action()
        }) {
            content
                .scaleEffect(isPressed && !reduceMotion ? 0.95 : 1.0)
                .animation(reduceMotion ? nil : .easeInOut(duration: 0.1), value: isPressed)
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(accessibilityHint ?? "")
        .accessibilityAddTraits(.isButton)
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                isPressed = pressing
            },
            perform: {}
        )
    }
}

// MARK: - Dynamic Type Support
struct DynamicTypeText: View {
    let text: String
    let style: Font.TextStyle
    let color: Color
    let maxSize: CGFloat?
    
    @Environment(\.sizeCategory) var sizeCategory
    
    init(_ text: String, style: Font.TextStyle = .body, color: Color = .primary, maxSize: CGFloat? = nil) {
        self.text = text
        self.style = style
        self.color = color
        self.maxSize = maxSize
    }
    
    var body: some View {
        Text(text)
            .font(.system(style, design: .default))
            .foregroundColor(color)
            .lineLimit(nil)
            .minimumScaleFactor(0.8)
            .allowsTightening(true)
            .dynamicTypeSize(...(maxSize.map { _ in DynamicTypeSize.accessibility1 } ?? .accessibility5))
    }
}

// MARK: - High Contrast Support
struct HighContrastCard<Content: View>: View {
    let content: Content
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.colorScheme) var colorScheme
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
    }
    
    private var backgroundColor: Color {
        return colorScheme == .dark ? Color(UIColor.systemGray6) : Color(UIColor.systemBackground)
    }
    
    private var borderColor: Color {
        if differentiateWithoutColor {
            return colorScheme == .dark ? .white : .black
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        differentiateWithoutColor ? 2 : 0
    }
}

// MARK: - VoiceOver Navigation
struct VoiceOverContainer<Content: View>: View {
    let content: Content
    let accessibilityLabel: String
    let accessibilityValue: String?
    let accessibilityHint: String?
    
    init(
        accessibilityLabel: String,
        accessibilityValue: String? = nil,
        accessibilityHint: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityValue = accessibilityValue
        self.accessibilityHint = accessibilityHint
        self.content = content()
    }
    
    var body: some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(accessibilityValue ?? "")
            .accessibilityHint(accessibilityHint ?? "")
    }
}

// MARK: - Reduced Motion Animations
struct ReducedMotionAnimation: ViewModifier {
    let animation: Animation
    let reducedAnimation: Animation
    
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    func body(content: Content) -> some View {
        content
            .animation(reduceMotion ? reducedAnimation : animation, value: UUID())
    }
}

extension View {
    func reducedMotionAnimation(
        _ animation: Animation,
        reduced: Animation? = nil
    ) -> some View {
        modifier(ReducedMotionAnimation(animation: animation, reducedAnimation: reduced ?? .linear(duration: 0)))
    }
}

// MARK: - Color Blind Support
struct ColorBlindFriendlyIndicator: View {
    let isActive: Bool
    let activeColor: Color
    let inactiveColor: Color
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isActive ? activeColor : inactiveColor)
                .frame(width: 8, height: 8)
            
            if differentiateWithoutColor {
                Image(systemName: isActive ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 12))
                    .foregroundColor(isActive ? activeColor : inactiveColor)
            }
        }
    }
}

// MARK: - Haptic Accessibility
struct HapticAccessibilityManager {
    static func playAccessibleFeedback(for action: AccessibilityAction) {
        guard !UserDefaults.standard.bool(forKey: "reduceHapticFeedback") else { return }
        
        switch action {
        case .buttonTap:
            EmberHapticsManager.shared.playLight()
        case .success:
            EmberHapticsManager.shared.playSuccess()
        case .error:
            EmberHapticsManager.shared.playMedium()
        case .selection:
            EmberHapticsManager.shared.playSelection()
        }
    }
}

enum AccessibilityAction {
    case buttonTap, success, error, selection
}

// MARK: - Focus Management
struct FocusableView<Content: View>: View {
    let content: Content
    let focusValue: String
    
    @FocusState private var isFocused: Bool
    @AccessibilityFocusState private var isAccessibilityFocused: Bool
    
    init(focusValue: String, @ViewBuilder content: () -> Content) {
        self.focusValue = focusValue
        self.content = content()
    }
    
    var body: some View {
        content
            .focused($isFocused)
            .accessibilityFocused($isAccessibilityFocused)
    }
}

// MARK: - Screen Reader Announcements
struct ScreenReaderAnnouncement: ViewModifier {
    let message: String
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIAccessibility.post(notification: .announcement, argument: message)
                }
            }
    }
}

extension View {
    func announceForScreenReader(_ message: String) -> some View {
        modifier(ScreenReaderAnnouncement(message: message))
    }
}
