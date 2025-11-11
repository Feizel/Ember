import SwiftUI

// MARK: - Enhanced Ember Colors with Dark Mode Support
struct EmberColors {
    
    // MARK: - Core Brand Colors
    static let roseQuartz = Color(hex: "#F97B7B")
    static let roseQuartzLight = Color(hex: "#FFB3B3")
    static let roseQuartzDark = Color(hex: "#E55555")
    static let roseQuartzUltraLight = Color(hex: "#FFE8E8")
    
    static let peachyKeen = Color(hex: "#FF9F7A")
    static let peachyKeenLight = Color(hex: "#FFBFA0")
    static let peachyKeenDark = Color(hex: "#E67F5A")
    static let peachyKeenUltraLight = Color(hex: "#FFF0E8")
    
    static let coralPop = Color(hex: "#FFD4B8")
    static let coralPopLight = Color(hex: "#FFE4D0")
    static let coralPopDark = Color(hex: "#E6B498")
    static let coralPopUltraLight = Color(hex: "#FFF8F0")
    
    static let lavenderMist = Color(hex: "#B8A9FF")
    
    // MARK: - Light Mode Colors
    static let lightBackground = Color(red: 0.996, green: 0.996, blue: 0.996) // #FEFEFE
    static let lightSurface = Color(red: 0.973, green: 0.976, blue: 0.980) // #F8F9FA
    static let lightElevated = Color(red: 0.949, green: 0.957, blue: 0.965) // #F2F4F6
    static let lightBorder = Color(red: 0.914, green: 0.925, blue: 0.937) // #E9ECEF
    
    // MARK: - Dark Mode Colors (Deep & Elegant)
    static let darkBackground = Color(red: 0.039, green: 0.039, blue: 0.043) // #0A0A0B
    static let darkSurface = Color(red: 0.110, green: 0.110, blue: 0.118) // #1C1C1E
    static let darkElevated = Color(red: 0.173, green: 0.173, blue: 0.180) // #2C2C2E
    static let darkBorder = Color(red: 0.220, green: 0.220, blue: 0.227) // #38383A
    
    // MARK: - System-Adaptive Colors
    static var background: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor(darkBackground) : UIColor(lightBackground)
        })
    }
    
    static var surface: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor(darkSurface) : UIColor(lightSurface)
        })
    }
    
    static var elevated: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor(darkElevated) : UIColor(lightElevated)
        })
    }
    
    static var border: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor(darkBorder) : UIColor(lightBorder)
        })
    }
    
    // MARK: - Text Colors (Adaptive)
    static var textPrimary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor.white : UIColor(Color(hex: "#0A0A0A"))
        })
    }
    
    static var textSecondary: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor(Color(hex: "#D0D0D0")) : UIColor(Color(hex: "#6B6B6B"))
        })
    }
    
    static let textTertiary = Color(hex: "#9B9B9B")
    static let textQuaternary = Color(hex: "#C7C7C7")
    static var textOnGradient: Color { .white }
    static var textOnDark: Color { .white }
    static let textOnLight = Color(hex: "#0A0A0A")
    
    // MARK: - Dark Mode Glow Effects
    static let roseQuartzGlow = roseQuartz.opacity(0.4)
    static let peachyKeenGlow = peachyKeen.opacity(0.3)
    static let coralPopGlow = coralPop.opacity(0.25)
    
    // MARK: - Enhanced Gradients
    static let primaryGradient = LinearGradient(
        colors: [roseQuartz, peachyKeen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let emberGradient = LinearGradient(
        colors: [roseQuartz, peachyKeen, coralPop],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let headerGradient = LinearGradient(
        colors: [roseQuartz.opacity(0.9), peachyKeen.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Dark Mode Enhanced Gradients
    static var darkEmberGradient: LinearGradient {
        LinearGradient(
            colors: [roseQuartz.opacity(0.8), peachyKeen.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Semantic Colors
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    // MARK: - Background Variants
    static let backgroundPrimary = background
    static let backgroundSecondary = surface
    static let backgroundTertiary = elevated
    
    // MARK: - Semantic State Colors
    static let successLight = Color(hex: "#D1FAE5")
    static let warningLight = Color(hex: "#FEF3C7")
    static let errorLight = Color(hex: "#FEE2E2")
    static let infoLight = Color(hex: "#DBEAFE")
    
    // MARK: - Border & Divider System
    static var divider: Color {
        Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? 
                UIColor(Color(hex: "#1A1A1A")) : UIColor(Color(hex: "#F0F0F0"))
        })
    }
    
    // MARK: - Adaptive Color Methods
    static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkBackground : lightBackground
    }
    
    static func adaptiveSurface(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkSurface : lightSurface
    }
    
    static func adaptiveElevated(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkElevated : lightElevated
    }
    
    static func adaptiveBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? darkBorder : lightBorder
    }
    
    static func adaptiveText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white : Color(hex: "#0A0A0A")
    }
    
    static func adaptiveSecondaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color(hex: "#D0D0D0") : Color(hex: "#6B6B6B")
    }
    
    // MARK: - Glassmorphism Effects
    static let glassBackground = Color.white.opacity(0.25)
    static let glassBorder = Color.white.opacity(0.3)
    static let glassOverlay = Color.white.opacity(0.1)
}

// MARK: - Enhanced Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Glow Effect System
struct EmberGlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: colorScheme == .dark ? color.opacity(0.6) : .clear,
                radius: radius,
                x: 0, y: 0
            )
            .shadow(
                color: colorScheme == .dark ? color.opacity(0.3) : .clear,
                radius: radius * 2,
                x: 0, y: 0
            )
    }
}

// MARK: - Glow Extensions
extension View {
    func emberGlow(_ color: Color = EmberColors.roseQuartz, radius: CGFloat = 8) -> some View {
        modifier(EmberGlowEffect(color: color, radius: radius))
    }
    
    func emberRoseGlow(radius: CGFloat = 8) -> some View {
        emberGlow(EmberColors.roseQuartz, radius: radius)
    }
    
    func emberPeachGlow(radius: CGFloat = 8) -> some View {
        emberGlow(EmberColors.peachyKeen, radius: radius)
    }
    
    func emberCoralGlow(radius: CGFloat = 8) -> some View {
        emberGlow(EmberColors.coralPop, radius: radius)
    }
}