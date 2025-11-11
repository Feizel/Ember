import SwiftUI

// MARK: - Premium Typography System
struct PremiumTypography {
    
    // MARK: - Font Weights
    enum FontWeight {
        case ultraLight, light, regular, medium, semibold, bold, heavy, black
        
        var systemWeight: Font.Weight {
            switch self {
            case .ultraLight: return .ultraLight
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .black: return .black
            }
        }
    }
    
    // MARK: - Typography Styles
    static func posterDisplay(weight: FontWeight = .black) -> Font {
        .system(size: 88, weight: weight.systemWeight, design: .default)
    }
    
    static func heroDisplay(weight: FontWeight = .heavy) -> Font {
        .system(size: 72, weight: weight.systemWeight, design: .default)
    }
    
    static func displayLarge(weight: FontWeight = .bold) -> Font {
        .system(size: 64, weight: weight.systemWeight, design: .default)
    }
    
    static func displayMedium(weight: FontWeight = .bold) -> Font {
        .system(size: 52, weight: weight.systemWeight, design: .default)
    }
    
    static func displaySmall(weight: FontWeight = .semibold) -> Font {
        .system(size: 40, weight: weight.systemWeight, design: .default)
    }
    
    static func headlineLarge(weight: FontWeight = .semibold) -> Font {
        .system(size: 32, weight: weight.systemWeight, design: .default)
    }
    
    static func headlineMedium(weight: FontWeight = .medium) -> Font {
        .system(size: 24, weight: weight.systemWeight, design: .default)
    }
    
    static func headlineSmall(weight: FontWeight = .medium) -> Font {
        .system(size: 20, weight: weight.systemWeight, design: .default)
    }
    
    static func title(weight: FontWeight = .medium) -> Font {
        .system(size: 18, weight: weight.systemWeight, design: .default)
    }
    
    static func body(weight: FontWeight = .regular) -> Font {
        .system(size: 16, weight: weight.systemWeight, design: .default)
    }
    
    static func label(weight: FontWeight = .medium) -> Font {
        .system(size: 14, weight: weight.systemWeight, design: .default)
    }
    
    static func caption(weight: FontWeight = .regular) -> Font {
        .system(size: 12, weight: weight.systemWeight, design: .default)
    }
}

// MARK: - Typography View Modifiers
extension View {
    
    // Poster Display (88pt)
    func emberPosterDisplay(weight: PremiumTypography.FontWeight = .black, color: Color = .primary) -> some View {
        self.font(PremiumTypography.posterDisplay(weight: weight))
            .foregroundStyle(color)
    }
    
    // Hero Display (72pt)
    func emberHeroDisplay(weight: PremiumTypography.FontWeight = .heavy, color: Color = .primary) -> some View {
        self.font(PremiumTypography.heroDisplay(weight: weight))
            .foregroundStyle(color)
    }
    
    // Display Large (64pt)
    func emberDisplayLarge(weight: PremiumTypography.FontWeight = .bold, color: Color = .primary) -> some View {
        self.font(PremiumTypography.displayLarge(weight: weight))
            .foregroundStyle(color)
    }
    
    // Display Medium (52pt)
    func emberDisplayMedium(weight: PremiumTypography.FontWeight = .bold, color: Color = .primary) -> some View {
        self.font(PremiumTypography.displayMedium(weight: weight))
            .foregroundStyle(color)
    }
    
    // Headline Large (32pt)
    func emberHeadlineLarge(weight: PremiumTypography.FontWeight = .semibold, color: Color = .primary) -> some View {
        self.font(PremiumTypography.headlineLarge(weight: weight))
            .foregroundStyle(color)
    }
    
    // Headline Medium (24pt)
    func emberHeadlineMedium(weight: PremiumTypography.FontWeight = .medium, color: Color = .primary) -> some View {
        self.font(PremiumTypography.headlineMedium(weight: weight))
            .foregroundStyle(color)
    }
    
    // Title (18pt)
    func emberTitle(weight: PremiumTypography.FontWeight = .medium, color: Color = .primary) -> some View {
        self.font(PremiumTypography.title(weight: weight))
            .foregroundStyle(color)
    }
    
    // Body (16pt)
    func emberBody(weight: PremiumTypography.FontWeight = .regular, color: Color = .primary) -> some View {
        self.font(PremiumTypography.body(weight: weight))
            .foregroundStyle(color)
    }
    
    // Label (14pt)
    func emberLabel(weight: PremiumTypography.FontWeight = .medium, color: Color = .primary) -> some View {
        self.font(PremiumTypography.label(weight: weight))
            .foregroundStyle(color)
    }
    
    // Caption (12pt)
    func emberCaption(weight: PremiumTypography.FontWeight = .regular, color: Color = .secondary) -> some View {
        self.font(PremiumTypography.caption(weight: weight))
            .foregroundStyle(color)
    }
}



// MARK: - Kinetic Typography Animations
extension View {
    func emberKineticReveal(delay: Double = 0) -> some View {
        modifier(KineticRevealModifier(delay: delay))
    }
    
    func emberTextPulse(duration: Double = 2.0) -> some View {
        modifier(TextPulseModifier(duration: duration))
    }
}

// MARK: - Animation Modifiers
struct KineticRevealModifier: ViewModifier {
    let delay: Double
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(delay)) {
                    isVisible = true
                }
            }
    }
}

struct TextPulseModifier: ViewModifier {
    let duration: Double
    @State private var isPulsing = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
    }
}