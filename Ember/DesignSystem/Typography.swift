import SwiftUI

// MARK: - Ember Premium Typography System
struct EmberTypography {
    // MARK: - Premium Font Families
    static let displayFont = "SF Pro Display"
    static let headlineFont = "SF Pro Display"
    static let bodyFont = "SF Pro Text"
    static let roundedFont = "SF Pro Rounded"
    static let monoFont = "SF Mono"
    
    // MARK: - Display Styles (Hero Typography)
    static let displayLarge = Font.custom(displayFont, size: 64, relativeTo: .largeTitle)
        .weight(.black)
        .leading(.tight)
    static let displayMedium = Font.custom(displayFont, size: 52, relativeTo: .largeTitle)
        .weight(.heavy)
        .leading(.tight)
    static let displaySmall = Font.custom(displayFont, size: 40, relativeTo: .title)
        .weight(.bold)
        .leading(.tight)
    
    // MARK: - Headline Styles (Premium Hierarchy)
    static let headlineLarge = Font.custom(headlineFont, size: 34, relativeTo: .title)
        .weight(.bold)
    static let headlineMedium = Font.custom(headlineFont, size: 28, relativeTo: .title2)
        .weight(.semibold)
    static let headlineSmall = Font.custom(headlineFont, size: 24, relativeTo: .title3)
        .weight(.semibold)
    
    // MARK: - Title Styles (Refined)
    static let titleLarge = Font.custom(bodyFont, size: 20, relativeTo: .title3)
        .weight(.semibold)
    static let titleMedium = Font.custom(bodyFont, size: 18, relativeTo: .headline)
        .weight(.medium)
    static let titleSmall = Font.custom(bodyFont, size: 16, relativeTo: .subheadline)
        .weight(.medium)
    
    // MARK: - Body Styles (Optimized Readability)
    static let bodyLarge = Font.custom(bodyFont, size: 17, relativeTo: .body)
        .weight(.regular)
    static let bodyMedium = Font.custom(bodyFont, size: 15, relativeTo: .callout)
        .weight(.regular)
    static let bodySmall = Font.custom(bodyFont, size: 13, relativeTo: .caption)
        .weight(.regular)
    
    // MARK: - Label Styles (Refined)
    static let labelLarge = Font.custom(bodyFont, size: 15, relativeTo: .callout)
        .weight(.medium)
    static let labelMedium = Font.custom(bodyFont, size: 13, relativeTo: .caption)
        .weight(.medium)
    static let labelSmall = Font.custom(bodyFont, size: 11, relativeTo: .caption2)
        .weight(.semibold)
    
    // MARK: - Button Styles (Premium)
    static let buttonLarge = Font.custom(roundedFont, size: 17, relativeTo: .body)
        .weight(.semibold)
    static let buttonMedium = Font.custom(roundedFont, size: 15, relativeTo: .callout)
        .weight(.semibold)
    static let buttonSmall = Font.custom(roundedFont, size: 13, relativeTo: .caption)
        .weight(.medium)
    
    // MARK: - Special Styles
    static let caption = Font.custom(bodyFont, size: 12, relativeTo: .caption)
        .weight(.regular)
    static let overline = Font.custom(bodyFont, size: 10, relativeTo: .caption2)
        .weight(.semibold)
    static let monospace = Font.custom(monoFont, size: 14, relativeTo: .callout)
        .weight(.regular)
}

// MARK: - Premium Text Style Modifiers
struct EmberTextStyle: ViewModifier {
    let style: EmberTypography.Style
    let color: Color
    let lineHeight: CGFloat?
    let letterSpacing: CGFloat?
    
    init(style: EmberTypography.Style, color: Color, lineHeight: CGFloat? = nil, letterSpacing: CGFloat? = nil) {
        self.style = style
        self.color = color
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(color)
            .lineSpacing(lineHeight ?? style.defaultLineHeight)
            .kerning(letterSpacing ?? style.defaultLetterSpacing)
    }
}

extension EmberTypography {
    enum Style {
        case displayLarge, displayMedium, displaySmall
        case headlineLarge, headlineMedium, headlineSmall
        case titleLarge, titleMedium, titleSmall
        case bodyLarge, bodyMedium, bodySmall
        case labelLarge, labelMedium, labelSmall
        case buttonLarge, buttonMedium, buttonSmall
        case caption, overline, monospace
        
        var font: Font {
            switch self {
            case .displayLarge: return EmberTypography.displayLarge
            case .displayMedium: return EmberTypography.displayMedium
            case .displaySmall: return EmberTypography.displaySmall
            case .headlineLarge: return EmberTypography.headlineLarge
            case .headlineMedium: return EmberTypography.headlineMedium
            case .headlineSmall: return EmberTypography.headlineSmall
            case .titleLarge: return EmberTypography.titleLarge
            case .titleMedium: return EmberTypography.titleMedium
            case .titleSmall: return EmberTypography.titleSmall
            case .bodyLarge: return EmberTypography.bodyLarge
            case .bodyMedium: return EmberTypography.bodyMedium
            case .bodySmall: return EmberTypography.bodySmall
            case .labelLarge: return EmberTypography.labelLarge
            case .labelMedium: return EmberTypography.labelMedium
            case .labelSmall: return EmberTypography.labelSmall
            case .buttonLarge: return EmberTypography.buttonLarge
            case .buttonMedium: return EmberTypography.buttonMedium
            case .buttonSmall: return EmberTypography.buttonSmall
            case .caption: return EmberTypography.caption
            case .overline: return EmberTypography.overline
            case .monospace: return EmberTypography.monospace
            }
        }
        
        var defaultLineHeight: CGFloat {
            switch self {
            case .displayLarge, .displayMedium, .displaySmall:
                return LineHeight.tight
            case .headlineLarge, .headlineMedium, .headlineSmall:
                return LineHeight.normal
            case .titleLarge, .titleMedium, .titleSmall:
                return LineHeight.normal
            case .bodyLarge, .bodyMedium, .bodySmall:
                return LineHeight.relaxed
            case .labelLarge, .labelMedium, .labelSmall:
                return LineHeight.normal
            case .buttonLarge, .buttonMedium, .buttonSmall:
                return LineHeight.tight
            case .caption, .overline, .monospace:
                return LineHeight.normal
            }
        }
        
        var defaultLetterSpacing: CGFloat {
            switch self {
            case .displayLarge, .displayMedium, .displaySmall:
                return LetterSpacing.tight
            case .headlineLarge, .headlineMedium, .headlineSmall:
                return LetterSpacing.normal
            case .titleLarge, .titleMedium, .titleSmall:
                return LetterSpacing.normal
            case .bodyLarge, .bodyMedium, .bodySmall:
                return LetterSpacing.normal
            case .labelLarge, .labelMedium, .labelSmall:
                return LetterSpacing.normal
            case .buttonLarge, .buttonMedium, .buttonSmall:
                return LetterSpacing.normal
            case .overline:
                return LetterSpacing.wide
            case .caption, .monospace:
                return LetterSpacing.normal
            }
        }
    }
}

// MARK: - Premium View Extensions
extension View {
    func emberText(_ style: EmberTypography.Style, color: Color = EmberColors.textPrimary, lineHeight: CGFloat? = nil, letterSpacing: CGFloat? = nil) -> some View {
        modifier(EmberTextStyle(style: style, color: color, lineHeight: lineHeight, letterSpacing: letterSpacing))
    }
    
    // MARK: - Display Styles
    func emberDisplayLarge(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.displayLarge, color: color)
    }
    
    func emberDisplayMedium(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.displayMedium, color: color)
    }
    
    func emberDisplaySmall(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.displaySmall, color: color)
    }
    
    // MARK: - Headline Styles
    func emberHeadlineLarge(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.headlineLarge, color: color)
    }
    
    func emberHeadline(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.headlineMedium, color: color)
    }
    
    func emberHeadlineSmall(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.headlineSmall, color: color)
    }
    
    // MARK: - Title Styles
    func emberTitleLarge(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.titleLarge, color: color)
    }
    
    func emberTitle(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.titleMedium, color: color)
    }
    
    func emberTitleSmall(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.titleSmall, color: color)
    }
    
    // MARK: - Body Styles
    func emberBodyLarge(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.bodyLarge, color: color)
    }
    
    func emberBody(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.bodyMedium, color: color)
    }
    
    func emberBodySmall(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.bodySmall, color: color)
    }
    
    // MARK: - Label Styles
    func emberLabelLarge(color: Color = EmberColors.textSecondary) -> some View {
        emberText(.labelLarge, color: color)
    }
    
    func emberLabel(color: Color = EmberColors.textSecondary) -> some View {
        emberText(.labelMedium, color: color)
    }
    
    func emberLabelSmall(color: Color = EmberColors.textSecondary) -> some View {
        emberText(.labelSmall, color: color)
    }
    
    // MARK: - Button Styles
    func emberButtonLarge(color: Color = EmberColors.textOnGradient) -> some View {
        emberText(.buttonLarge, color: color)
    }
    
    func emberButton(color: Color = EmberColors.textOnGradient) -> some View {
        emberText(.buttonMedium, color: color)
    }
    
    func emberButtonSmall(color: Color = EmberColors.textOnGradient) -> some View {
        emberText(.buttonSmall, color: color)
    }
    
    // MARK: - Special Styles
    func emberCaption(color: Color = EmberColors.textSecondary) -> some View {
        emberText(.caption, color: color)
    }
    
    func emberOverline(color: Color = EmberColors.textSecondary) -> some View {
        emberText(.overline, color: color)
            .textCase(.uppercase)
    }
    
    func emberMonospace(color: Color = EmberColors.textPrimary) -> some View {
        emberText(.monospace, color: color)
    }
}

// MARK: - Premium Line Height & Spacing
extension EmberTypography {
    struct LineHeight {
        static let tight: CGFloat = 2
        static let normal: CGFloat = 4
        static let relaxed: CGFloat = 6
        static let loose: CGFloat = 8
    }
    
    struct LetterSpacing {
        static let tight: CGFloat = -0.8
        static let normal: CGFloat = 0
        static let wide: CGFloat = 1.2
        static let extraWide: CGFloat = 2.0
    }
    
    // MARK: - Premium Text Effects
    struct TextEffect {
        static func gradient(_ colors: [Color]) -> LinearGradient {
            LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
        }
        
        static let primaryGradient = gradient([EmberColors.roseQuartz, EmberColors.peachyKeen])
        static let accentGradient = gradient([EmberColors.coralPop, EmberColors.roseQuartzLight])
    }
}

// MARK: - Text Effect Modifiers
extension View {
    func emberGradientText(_ gradient: LinearGradient = EmberTypography.TextEffect.primaryGradient) -> some View {
        self
            .overlay(gradient)
            .mask(self)
    }
    
    func emberShadowText(color: Color = .black.opacity(0.1), radius: CGFloat = 2, x: CGFloat = 0, y: CGFloat = 1) -> some View {
        self
            .shadow(color: color, radius: radius, x: x, y: y)
    }
    
    func emberGlowText(color: Color = EmberColors.roseQuartz, radius: CGFloat = 4) -> some View {
        self
            .shadow(color: color.opacity(0.3), radius: radius)
            .shadow(color: color.opacity(0.2), radius: radius * 2)
    }
}