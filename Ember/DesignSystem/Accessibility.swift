import SwiftUI

// MARK: - Ember Accessibility
struct EmberAccessibility {
    // MARK: - Touch Targets
    static let minimumTouchTarget: CGFloat = 48
    
    // MARK: - Font Sizes
    static let minimumFontSize: CGFloat = 12
    
    // MARK: - Contrast Ratios
    struct ContrastRatio {
        static let primaryText: Double = 7.2
        static let secondaryText: Double = 6.5
        static let buttons: Double = 8.1
    }
}

// MARK: - Accessibility Modifiers
struct EmberAccessibilityModifier: ViewModifier {
    let label: String
    let hint: String?
    let traits: AccessibilityTraits
    
    func body(content: Content) -> some View {
        content
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
    }
}

extension View {
    func emberAccessibility(label: String, hint: String? = nil, traits: AccessibilityTraits = []) -> some View {
        modifier(EmberAccessibilityModifier(label: label, hint: hint, traits: traits))
    }
    
    func emberMinimumTouchTarget() -> some View {
        frame(minWidth: EmberAccessibility.minimumTouchTarget, minHeight: EmberAccessibility.minimumTouchTarget)
    }
}