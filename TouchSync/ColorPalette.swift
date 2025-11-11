import SwiftUI

struct ColorPalette {
    // Updated to use modern palette
    static let sensualRed = ModernColorPalette.primary
    static let passionRed = ModernColorPalette.secondary
    static let goldenYellow = ModernColorPalette.accent
    static let warmYellow = ModernColorPalette.accent
    static let sunsetOrange = ModernColorPalette.secondary
    
    // Legacy colors updated to sensual palette
    static let vibrantOrange = sunsetOrange
    static let sunnyYellow = goldenYellow
    static let coralOrange = passionRed
    static let warmAccent = warmYellow
    static let coralPink = sensualRed
    static let deepOrange = passionRed
    static let lightYellow = warmYellow
    static let peachOrange = sunsetOrange
    
    // Legacy colors for backward compatibility
    static let crimson = ModernColorPalette.primary
    static let roseGold = ModernColorPalette.secondary
    static let amber = ModernColorPalette.accent
    static let deepPurple = ModernColorPalette.primary
    
    // Premium Neutrals
    static let charcoal = ModernColorPalette.textPrimary
    static let charcoalLight = ModernColorPalette.textSecondary
    
    // Modern gradients
    static let sensualGradient = ModernColorPalette.primaryGradient
    
    static let primaryGradient = ModernColorPalette.primaryGradient
    
    static let secondaryGradient = ModernColorPalette.secondaryGradient
    
    static let warmGradient = LinearGradient(
        colors: [sunsetOrange, goldenYellow, warmYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let iconGradient = primaryGradient
    
    // Legacy gradient
    static let loveGradient = primaryGradient
    
    // Background Colors
    static let backgroundLight = ModernColorPalette.background
    static let backgroundDark = ModernColorPalette.textPrimary
    
    // Text Colors
    static let textPrimary = ModernColorPalette.textPrimary
    static let textSecondary = ModernColorPalette.textSecondary
    static let textOnGradient = Color.white
    static let darkCharcoal = ModernColorPalette.textPrimary
}

extension Color {
    // TouchSync Color Palette (for backward compatibility)
    static let touchSyncCrimson = ColorPalette.crimson
    static let touchSyncRoseGold = ColorPalette.roseGold
    static let touchSyncAmber = ColorPalette.amber
    static let touchSyncPurple = ColorPalette.deepPurple
    static let touchSyncCharcoal = ColorPalette.charcoal
    static let touchSyncCharcoalLight = ColorPalette.charcoalLight
}

struct PremiumCardModifier: ViewModifier {
    let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat = 16) {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct GlassmorphismModifier: ViewModifier {
    let opacity: Double
    let blur: CGFloat
    let borderOpacity: Double
    
    init(opacity: Double = 0.15, blur: CGFloat = 20, borderOpacity: Double = 0.2) {
        self.opacity = opacity
        self.blur = blur
        self.borderOpacity = borderOpacity
    }
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial.opacity(opacity))
            .background(Color.white.opacity(0.05))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(borderOpacity), lineWidth: 1)
            )
    }
}

extension View {
    func premiumCard(cornerRadius: CGFloat = 16) -> some View {
        modifier(PremiumCardModifier(cornerRadius: cornerRadius))
    }
    
    func glassmorphism(opacity: Double = 0.15, blur: CGFloat = 20, borderOpacity: Double = 0.2) -> some View {
        modifier(GlassmorphismModifier(opacity: opacity, blur: blur, borderOpacity: borderOpacity))
    }
}