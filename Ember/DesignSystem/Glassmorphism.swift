import SwiftUI

// MARK: - Glassmorphism System
struct GlassmorphicCard<Content: View>: View {
    let content: Content
    let style: GlassStyle
    let cornerRadius: CGFloat
    
    init(
        style: GlassStyle = .standard,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(
                ZStack {
                    // Base glass effect
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(style.backgroundColor)
                    
                    // Frosted glass overlay
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .opacity(style.materialOpacity)
                    
                    // Border
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(style.borderGradient, lineWidth: style.borderWidth)
                }
            )
            .shadow(
                color: style.shadowColor,
                radius: style.shadowRadius,
                x: 0,
                y: style.shadowOffset
            )
    }
}

enum GlassStyle {
    case standard
    case elevated
    case interactive
    case premium
    case subtle
    
    var backgroundColor: Color {
        switch self {
        case .standard: return .white.opacity(0.1)
        case .elevated: return .white.opacity(0.15)
        case .interactive: return .white.opacity(0.2)
        case .premium: return EmberColors.roseQuartz.opacity(0.1)
        case .subtle: return .white.opacity(0.05)
        }
    }
    
    var materialOpacity: Double {
        switch self {
        case .standard: return 0.6
        case .elevated: return 0.7
        case .interactive: return 0.8
        case .premium: return 0.5
        case .subtle: return 0.4
        }
    }
    
    var borderGradient: LinearGradient {
        switch self {
        case .standard:
            return LinearGradient(
                colors: [.white.opacity(0.3), .white.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .elevated:
            return LinearGradient(
                colors: [.white.opacity(0.4), .white.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .interactive:
            return LinearGradient(
                colors: [EmberColors.roseQuartz.opacity(0.4), EmberColors.peachyKeen.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .premium:
            return LinearGradient(
                colors: [EmberColors.roseQuartz.opacity(0.6), EmberColors.coralPop.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .subtle:
            return LinearGradient(
                colors: [.white.opacity(0.2), .white.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .standard: return 1
        case .elevated: return 1.5
        case .interactive: return 2
        case .premium: return 2
        case .subtle: return 0.5
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .standard: return .black.opacity(0.1)
        case .elevated: return .black.opacity(0.15)
        case .interactive: return EmberColors.roseQuartz.opacity(0.2)
        case .premium: return EmberColors.roseQuartz.opacity(0.3)
        case .subtle: return .black.opacity(0.05)
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .standard: return 8
        case .elevated: return 12
        case .interactive: return 16
        case .premium: return 20
        case .subtle: return 4
        }
    }
    
    var shadowOffset: CGFloat {
        switch self {
        case .standard: return 4
        case .elevated: return 6
        case .interactive: return 8
        case .premium: return 10
        case .subtle: return 2
        }
    }
}

// MARK: - Interactive Glass
struct InteractiveGlass<Content: View>: View {
    let content: Content
    @State private var isPressed = false
    @State private var hoverIntensity: CGFloat = 0
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    // Dynamic glass background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .opacity(0.6 + hoverIntensity * 0.2)
                    
                    // Interactive border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    EmberColors.roseQuartz.opacity(0.3 + hoverIntensity * 0.3),
                                    EmberColors.peachyKeen.opacity(0.2 + hoverIntensity * 0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1 + hoverIntensity * 2
                        )
                }
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .animation(.easeInOut(duration: 0.2), value: hoverIntensity)
            .onLongPressGesture(
                minimumDuration: 0,
                maximumDistance: .infinity,
                pressing: { pressing in
                    isPressed = pressing
                    hoverIntensity = pressing ? 1.0 : 0.0
                },
                perform: {}
            )
    }
}

// MARK: - Smart Shadows
struct SmartShadow: ViewModifier {
    let content: ShadowContent
    let isElevated: Bool
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: self.content.color.opacity(isElevated ? 0.3 : 0.15),
                radius: isElevated ? self.content.radius * 1.5 : self.content.radius,
                x: 0,
                y: isElevated ? self.content.offset * 1.5 : self.content.offset
            )
    }
}

struct ShadowContent {
    let color: Color
    let radius: CGFloat
    let offset: CGFloat
    
    static let soft = ShadowContent(color: .black, radius: 8, offset: 4)
    static let medium = ShadowContent(color: .black, radius: 12, offset: 6)
    static let strong = ShadowContent(color: .black, radius: 16, offset: 8)
    static let brand = ShadowContent(color: EmberColors.roseQuartz, radius: 12, offset: 6)
}

extension View {
    func smartShadow(_ content: ShadowContent, elevated: Bool = false) -> some View {
        modifier(SmartShadow(content: content, isElevated: elevated))
    }
}

// MARK: - Elevated Surface System
struct ElevatedSurface<Content: View>: View {
    let content: Content
    let level: ElevationLevel
    @State private var isHovered = false
    
    init(level: ElevationLevel = .medium, @ViewBuilder content: () -> Content) {
        self.level = level
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    // Base surface
                    RoundedRectangle(cornerRadius: level.cornerRadius)
                        .fill(level.backgroundColor)
                    
                    // Elevation layers
                    ForEach(0..<level.layerCount, id: \.self) { index in
                        RoundedRectangle(cornerRadius: level.cornerRadius)
                            .fill(.white.opacity(level.layerOpacity))
                            .offset(y: CGFloat(index) * -0.5)
                    }
                }
            )
            .smartShadow(level.shadow, elevated: isHovered)
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isHovered)
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

enum ElevationLevel {
    case low, medium, high, floating
    
    var layerCount: Int {
        switch self {
        case .low: return 1
        case .medium: return 2
        case .high: return 3
        case .floating: return 4
        }
    }
    
    var layerOpacity: Double {
        switch self {
        case .low: return 0.05
        case .medium: return 0.08
        case .high: return 0.12
        case .floating: return 0.15
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .low: return .white.opacity(0.8)
        case .medium: return .white.opacity(0.9)
        case .high: return .white.opacity(0.95)
        case .floating: return .white
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .low: return 12
        case .medium: return 16
        case .high: return 20
        case .floating: return 24
        }
    }
    
    var shadow: ShadowContent {
        switch self {
        case .low: return .soft
        case .medium: return .medium
        case .high: return .strong
        case .floating: return .brand
        }
    }
}