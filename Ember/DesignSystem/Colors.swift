import SwiftUI

// MARK: - Ember Premium Design System Colors
struct EmberColors {
    // MARK: - Primary Brand Colors (Rose Quartz Family)
    static let roseQuartz = Color(hex: "#F97B7B")
    static let roseQuartzLight = Color(hex: "#FFB3B3")
    static let roseQuartzDark = Color(hex: "#E55555")
    static let roseQuartzUltraLight = Color(hex: "#FFE8E8")
    
    // MARK: - Secondary Brand Colors (Peachy Keen Family)
    static let peachyKeen = Color(hex: "#FF9F7A")
    static let peachyKeenLight = Color(hex: "#FFBFA0")
    static let peachyKeenDark = Color(hex: "#E67F5A")
    static let peachyKeenUltraLight = Color(hex: "#FFF0E8")
    
    // MARK: - Accent Colors (Coral Pop Family)
    static let coralPop = Color(hex: "#FFD4B8")
    static let coralPopLight = Color(hex: "#FFE4D0")
    static let coralPopDark = Color(hex: "#E6B498")
    static let coralPopUltraLight = Color(hex: "#FFF8F0")
    
    // MARK: - Lavender Mist Family
    static let lavenderMist = Color(hex: "#B8A9FF")
    
    // MARK: - Premium Neutral Palette
    static let backgroundPrimary = Color(hex: "#FEFEFE")
    static let backgroundSecondary = Color(hex: "#FAFAFA")
    static let backgroundTertiary = Color(hex: "#F5F5F5")
    
    static let surface = Color(hex: "#FFFFFF")
    static let surfaceElevated = Color(hex: "#FFFFFF")
    static let surfacePressed = Color(hex: "#F8F8F8")
    
    // MARK: - Premium Text Hierarchy
    static let textPrimary = Color(hex: "#0A0A0A")
    static let textSecondary = Color(hex: "#6B6B6B")
    static let textTertiary = Color(hex: "#9B9B9B")
    static let textQuaternary = Color(hex: "#C7C7C7")
    static let textOnGradient = Color.white
    static let textOnDark = Color.white
    static let textOnLight = Color(hex: "#0A0A0A")
    
    // MARK: - Premium Border & Divider System
    static let border = Color(hex: "#E8E8E8")
    static let borderLight = Color(hex: "#F0F0F0")
    static let borderStrong = Color(hex: "#D0D0D0")
    static let divider = Color(hex: "#F0F0F0")
    static let dividerStrong = Color(hex: "#E8E8E8")
    
    // MARK: - Semantic State Colors
    static let success = Color(hex: "#10B981")
    static let successLight = Color(hex: "#D1FAE5")
    static let warning = Color(hex: "#F59E0B")
    static let warningLight = Color(hex: "#FEF3C7")
    static let error = Color(hex: "#EF4444")
    static let errorLight = Color(hex: "#FEE2E2")
    static let info = Color(hex: "#3B82F6")
    static let infoLight = Color(hex: "#DBEAFE")
    
    // MARK: - Premium Gradient System
    static let primaryGradient = LinearGradient(
        colors: [roseQuartz, peachyKeen],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [peachyKeen, coralPop],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [coralPop, coralPopLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let headerGradient = LinearGradient(
        colors: [roseQuartz, peachyKeen, coralPop],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [roseQuartzUltraLight, peachyKeenUltraLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let subtleGradient = LinearGradient(
        colors: [Color.white, backgroundSecondary],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - Glassmorphism Effects
    static let glassBackground = Color.white.opacity(0.25)
    static let glassBorder = Color.white.opacity(0.3)
    static let glassOverlay = Color.white.opacity(0.1)
    
    // MARK: - Premium Dark Mode System
    struct DarkMode {
        static let backgroundPrimary = Color(hex: "#000000")
        static let backgroundSecondary = Color(hex: "#0A0A0A")
        static let backgroundTertiary = Color(hex: "#1A1A1A")
        
        static let surface = Color(hex: "#0F0F0F")
        static let surfaceElevated = Color(hex: "#1A1A1A")
        static let surfacePressed = Color(hex: "#2A2A2A")
        
        static let textPrimary = Color(hex: "#FFFFFF")
        static let textSecondary = Color(hex: "#D0D0D0")
        static let textTertiary = Color(hex: "#A0A0A0")
        static let textQuaternary = Color(hex: "#6B6B6B")
        
        static let border = Color(hex: "#2A2A2A")
        static let borderLight = Color(hex: "#1A1A1A")
        static let borderStrong = Color(hex: "#3A3A3A")
        static let divider = Color(hex: "#1A1A1A")
        static let dividerStrong = Color(hex: "#2A2A2A")
        
        // Dark mode gradients
        static let cardGradient = LinearGradient(
            colors: [Color(hex: "#1A1A1A"), Color(hex: "#0F0F0F")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let glassBackground = Color.white.opacity(0.05)
        static let glassBorder = Color.white.opacity(0.1)
        static let glassOverlay = Color.white.opacity(0.02)
    }
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
    
    // Premium color utilities
    func lighter(by percentage: CGFloat = 0.2) -> Color {
        return self.opacity(1 - percentage)
    }
    
    func darker(by percentage: CGFloat = 0.2) -> Color {
        return Color(
            red: max(0, self.components.red * (1 - percentage)),
            green: max(0, self.components.green * (1 - percentage)),
            blue: max(0, self.components.blue * (1 - percentage))
        )
    }
    
    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        let uiColor = UIColor(self)
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (red: r, green: g, blue: b, alpha: a)
    }
}

// MARK: - Premium Environment-Aware Colors
extension EmberColors {
    static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.backgroundPrimary : backgroundPrimary
    }
    
    static func adaptiveBackgroundSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.backgroundSecondary : backgroundSecondary
    }
    
    static func adaptiveBackgroundTertiary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.backgroundTertiary : backgroundTertiary
    }
    
    static func adaptiveSurface(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.surface : surface
    }
    
    static func adaptiveSurfaceElevated(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.surfaceElevated : surfaceElevated
    }
    
    static func adaptiveText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.textPrimary : textPrimary
    }
    
    static func adaptiveSecondaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.textSecondary : textSecondary
    }
    
    static func adaptiveTertiaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.textTertiary : textTertiary
    }
    
    static func adaptiveBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.border : border
    }
    
    static func adaptiveBorderLight(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.borderLight : borderLight
    }
    
    static func adaptiveDivider(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.divider : divider
    }
    
    static func adaptiveCardGradient(for colorScheme: ColorScheme) -> LinearGradient {
        colorScheme == .dark ? DarkMode.cardGradient : cardGradient
    }
    
    static func adaptiveGlassBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.glassBackground : glassBackground
    }
    
    static func adaptiveGlassBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? DarkMode.glassBorder : glassBorder
    }
}

// MARK: - Premium Color Modifiers
extension View {
    func emberBackground(_ colorScheme: ColorScheme = .light) -> some View {
        self.background(EmberColors.adaptiveBackground(for: colorScheme))
    }
    
    func emberSurface(_ colorScheme: ColorScheme = .light) -> some View {
        self.background(EmberColors.adaptiveSurface(for: colorScheme))
    }
    
    func emberGlassmorphism(_ colorScheme: ColorScheme = .light) -> some View {
        self
            .background(EmberColors.adaptiveGlassBackground(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(EmberColors.adaptiveGlassBorder(for: colorScheme), lineWidth: 1)
            )
            .backdrop(blur: 20, saturation: 1.8)
    }
}

// MARK: - Backdrop Effect
extension View {
    func backdrop(blur: CGFloat, saturation: CGFloat = 1.0) -> some View {
        self.background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .blur(radius: blur / 2)
        )
    }
}