import SwiftUI

struct AdaptiveTheme {
    // MARK: - Primary Colors (Adaptive)
    static let primary: Color = Color("PrimaryColor")
    static let secondary: Color = Color("SecondaryColor") 
    static let accent: Color = Color("AccentColor")
    
    // MARK: - Background Colors
    static let background: Color = Color("BackgroundColor")
    static let surface: Color = Color("SurfaceColor")
    static let surfaceSecondary: Color = Color("SurfaceSecondaryColor")
    static let cardBackground: Color = Color("CardBackgroundColor")
    
    // MARK: - Text Colors
    static let textPrimary: Color = Color("TextPrimaryColor")
    static let textSecondary: Color = Color("TextSecondaryColor")
    static let textTertiary: Color = Color("TextTertiaryColor")
    static let textOnPrimary: Color = Color.white
    
    // MARK: - Glassmorphism Colors
    static let glassMaterial: Color = Color("GlassMaterialColor")
    static let glassBorder: Color = Color("GlassBorderColor")
    
    // MARK: - Gradients (Adaptive)
    static let primaryGradient = LinearGradient(
        colors: [primary, primary.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [secondary, secondary.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let fabGradient: LinearGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.42, blue: 0.21), Color(red: 1.0, green: 0.85, blue: 0.49)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let fabGradientDark: LinearGradient = LinearGradient(
        colors: [Color(red: 1.0, green: 0.34, blue: 0.13), Color(red: 1.0, green: 0.76, blue: 0.03)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Shadow Colors
    static let shadowLight = Color.black.opacity(0.1)
    static let shadowMedium = Color.black.opacity(0.2)
    static let shadowHeavy = Color.black.opacity(0.3)
}

// MARK: - Environment-aware colors
extension AdaptiveTheme {
    static func fabGradient(for colorScheme: ColorScheme) -> LinearGradient {
        colorScheme == .dark ? fabGradientDark : fabGradient
    }
    
    static func shadowColor(for colorScheme: ColorScheme, intensity: ShadowIntensity = .light) -> Color {
        let baseOpacity: Double = colorScheme == .dark ? 0.4 : 0.1
        switch intensity {
        case .light: return Color.black.opacity(baseOpacity)
        case .medium: return Color.black.opacity(baseOpacity * 2)
        case .heavy: return Color.black.opacity(baseOpacity * 3)
        }
    }
}

enum ShadowIntensity {
    case light, medium, heavy
}

// MARK: - Adaptive Modifiers
struct AdaptiveGlassmorphismModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                colorScheme == .dark 
                                    ? Color.white.opacity(0.1)
                                    : Color.white.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: AdaptiveTheme.shadowColor(for: colorScheme),
                radius: 10,
                x: 0,
                y: 5
            )
    }
}

struct AdaptiveCardModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(AdaptiveTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                colorScheme == .dark
                                    ? Color.white.opacity(0.05)
                                    : Color.black.opacity(0.05),
                                lineWidth: 1
                            )
                    )
            )
            .shadow(
                color: AdaptiveTheme.shadowColor(for: colorScheme),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}

// MARK: - View Extensions
extension View {
    func adaptiveGlassmorphism(cornerRadius: CGFloat = 16) -> some View {
        modifier(AdaptiveGlassmorphismModifier(cornerRadius: cornerRadius))
    }
    
    func adaptiveCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(AdaptiveCardModifier(cornerRadius: cornerRadius))
    }
}

