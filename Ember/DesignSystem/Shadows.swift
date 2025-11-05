import SwiftUI

// MARK: - Ember Premium Shadow System
struct EmberShadows {
    // MARK: - Elevation Shadows (Material Design Inspired)
    static let none = Shadow(color: .clear, radius: 0, x: 0, y: 0)
    
    static let xs = Shadow(
        color: Color.black.opacity(0.05),
        radius: 2,
        x: 0,
        y: 1
    )
    
    static let sm = Shadow(
        color: Color.black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )
    
    static let md = Shadow(
        color: Color.black.opacity(0.1),
        radius: 8,
        x: 0,
        y: 4
    )
    
    static let lg = Shadow(
        color: Color.black.opacity(0.12),
        radius: 16,
        x: 0,
        y: 8
    )
    
    static let xl = Shadow(
        color: Color.black.opacity(0.15),
        radius: 24,
        x: 0,
        y: 12
    )
    
    static let xxl = Shadow(
        color: Color.black.opacity(0.18),
        radius: 32,
        x: 0,
        y: 16
    )
    
    // MARK: - Semantic Shadows
    struct Component {
        static let button = Shadow(
            color: Color.black.opacity(0.08),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let buttonPressed = Shadow(
            color: Color.black.opacity(0.12),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let card = Shadow(
            color: Color.black.opacity(0.06),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let cardElevated = Shadow(
            color: Color.black.opacity(0.1),
            radius: 16,
            x: 0,
            y: 8
        )
        
        static let input = Shadow(
            color: Color.black.opacity(0.04),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let inputFocused = Shadow(
            color: EmberColors.roseQuartz.opacity(0.2),
            radius: 8,
            x: 0,
            y: 0
        )
    }
    
    // MARK: - Brand Shadows (Colored)
    struct Brand {
        static let primary = Shadow(
            color: EmberColors.roseQuartz.opacity(0.3),
            radius: 12,
            x: 0,
            y: 6
        )
        
        static let secondary = Shadow(
            color: EmberColors.peachyKeen.opacity(0.25),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let accent = Shadow(
            color: EmberColors.coralPop.opacity(0.2),
            radius: 6,
            x: 0,
            y: 3
        )
        
        static let glow = Shadow(
            color: EmberColors.roseQuartz.opacity(0.4),
            radius: 20,
            x: 0,
            y: 0
        )
    }
    
    // MARK: - Dark Mode Shadows
    struct DarkMode {
        static let xs = Shadow(
            color: Color.black.opacity(0.3),
            radius: 2,
            x: 0,
            y: 1
        )
        
        static let sm = Shadow(
            color: Color.black.opacity(0.4),
            radius: 4,
            x: 0,
            y: 2
        )
        
        static let md = Shadow(
            color: Color.black.opacity(0.5),
            radius: 8,
            x: 0,
            y: 4
        )
        
        static let lg = Shadow(
            color: Color.black.opacity(0.6),
            radius: 16,
            x: 0,
            y: 8
        )
        
        static let card = Shadow(
            color: Color.black.opacity(0.4),
            radius: 12,
            x: 0,
            y: 6
        )
        
        static let cardElevated = Shadow(
            color: Color.black.opacity(0.6),
            radius: 20,
            x: 0,
            y: 10
        )
    }
}

// MARK: - Shadow Data Structure
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - Shadow Modifiers
extension View {
    func emberShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    // MARK: - Elevation Shadows
    func emberShadowXS() -> some View {
        emberShadow(EmberShadows.xs)
    }
    
    func emberShadowSM() -> some View {
        emberShadow(EmberShadows.sm)
    }
    
    func emberShadowMD() -> some View {
        emberShadow(EmberShadows.md)
    }
    
    func emberShadowLG() -> some View {
        emberShadow(EmberShadows.lg)
    }
    
    func emberShadowXL() -> some View {
        emberShadow(EmberShadows.xl)
    }
    
    // MARK: - Component Shadows
    func emberButtonShadow(isPressed: Bool = false) -> some View {
        emberShadow(isPressed ? EmberShadows.Component.buttonPressed : EmberShadows.Component.button)
    }
    
    func emberCardShadow(elevated: Bool = false) -> some View {
        emberShadow(elevated ? EmberShadows.Component.cardElevated : EmberShadows.Component.card)
    }
    
    func emberInputShadow(focused: Bool = false) -> some View {
        emberShadow(focused ? EmberShadows.Component.inputFocused : EmberShadows.Component.input)
    }
    
    // MARK: - Brand Shadows
    func emberPrimaryShadow() -> some View {
        emberShadow(EmberShadows.Brand.primary)
    }
    
    func emberSecondaryShadow() -> some View {
        emberShadow(EmberShadows.Brand.secondary)
    }
    
    func emberAccentShadow() -> some View {
        emberShadow(EmberShadows.Brand.accent)
    }
    
    func emberGlowShadow() -> some View {
        emberShadow(EmberShadows.Brand.glow)
    }
    
    // MARK: - Adaptive Shadows
    func emberAdaptiveShadow(_ shadow: Shadow, darkShadow: Shadow, colorScheme: ColorScheme) -> some View {
        emberShadow(colorScheme == .dark ? darkShadow : shadow)
    }
    
    func emberAdaptiveCardShadow(colorScheme: ColorScheme, elevated: Bool = false) -> some View {
        let lightShadow = elevated ? EmberShadows.Component.cardElevated : EmberShadows.Component.card
        let darkShadow = elevated ? EmberShadows.DarkMode.cardElevated : EmberShadows.DarkMode.card
        return emberAdaptiveShadow(lightShadow, darkShadow: darkShadow, colorScheme: colorScheme)
    }
}

// MARK: - Multi-Layer Shadows
extension View {
    func emberMultiShadow(_ shadows: [Shadow]) -> some View {
        shadows.reduce(AnyView(self)) { view, shadow in
            AnyView(view.emberShadow(shadow))
        }
    }
    
    func emberPremiumCardShadow() -> some View {
        emberMultiShadow([
            Shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1),
            Shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4),
            Shadow(color: Color.black.opacity(0.04), radius: 16, x: 0, y: 8)
        ])
    }
    
    func emberHeroShadow() -> some View {
        emberMultiShadow([
            Shadow(color: EmberColors.roseQuartz.opacity(0.2), radius: 20, x: 0, y: 10),
            Shadow(color: Color.black.opacity(0.1), radius: 40, x: 0, y: 20)
        ])
    }
}

// MARK: - Inner Shadows (Inset Effect)
struct InnerShadow: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(color, lineWidth: radius)
                    .blur(radius: radius)
                    .offset(x: x, y: y)
                    .mask(content)
            )
    }
}

extension View {
    func emberInnerShadow(color: Color = Color.black.opacity(0.1), radius: CGFloat = 2, x: CGFloat = 0, y: CGFloat = 1) -> some View {
        modifier(InnerShadow(color: color, radius: radius, x: x, y: y))
    }
}