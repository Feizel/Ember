import SwiftUI

// MARK: - Animated Icon System
struct AnimatedIcon: View {
    let icon: IconType
    let size: CGFloat
    let color: Color
    let isActive: Bool
    
    @State private var animationPhase: CGFloat = 0
    @State private var isAnimating = false
    
    init(_ icon: IconType, size: CGFloat = 24, color: Color = .primary, isActive: Bool = false) {
        self.icon = icon
        self.size = size
        self.color = color
        self.isActive = isActive
    }
    
    var body: some View {
        ZStack {
            switch icon {
            case .heart:
                heartIcon
            case .message:
                messageIcon
            case .touch:
                touchIcon
            case .notification:
                notificationIcon
            case .connection:
                connectionIcon
            }
        }
        .frame(width: size, height: size)
        .onChange(of: isActive) {
            if isActive {
                startAnimation()
            } else {
                stopAnimation()
            }
        }
    }
    
    private var heartIcon: some View {
        ZStack {
            Image(systemName: "heart.fill")
                .font(.system(size: size * 0.8))
                .foregroundStyle(color)
                .scaleEffect(isActive ? 1.2 : 1.0)
                .opacity(isActive ? 0.8 : 1.0)
            
            if isActive {
                ForEach(0..<3, id: \.self) { index in
                    let baseAngle = Double(index) * 2 * .pi / 3
                    let rotationAngle = Double(animationPhase) * 2 * .pi
                    let totalAngle = baseAngle + rotationAngle
                    let radius = size * 0.3
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundStyle(color.opacity(0.6))
                        .scaleEffect(animationPhase)
                        .opacity(1 - animationPhase)
                        .offset(
                            x: CGFloat(cos(totalAngle)) * radius,
                            y: CGFloat(sin(totalAngle)) * radius
                        )
                }
            }
        }
        .animation(.easeInOut(duration: 0.6), value: isActive)
    }
    
    private var messageIcon: some View {
        ZStack {
            Image(systemName: "message.fill")
                .font(.system(size: size * 0.8))
                .foregroundStyle(color)
                .rotationEffect(.degrees(isActive ? 10 : 0))
            
            if isActive {
                Image(systemName: "ellipsis")
                    .font(.system(size: size * 0.3))
                    .foregroundStyle(color.opacity(0.8))
                    .scaleEffect(animationPhase)
                    .opacity(1 - animationPhase)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isActive)
    }
    
    private var touchIcon: some View {
        ZStack {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: size * 0.8))
                .foregroundStyle(color)
                .scaleEffect(isActive ? 0.9 : 1.0)
            
            if isActive {
                Circle()
                    .stroke(color.opacity(0.4), lineWidth: 2)
                    .scaleEffect(animationPhase * 2)
                    .opacity(1 - animationPhase)
            }
        }
        .animation(.easeOut(duration: 0.8), value: isActive)
    }
    
    private var notificationIcon: some View {
        ZStack {
            Image(systemName: "bell.fill")
                .font(.system(size: size * 0.8))
                .foregroundStyle(color)
                .rotationEffect(.degrees(isActive ? 15 : 0))
            
            if isActive {
                Circle()
                    .fill(EmberColors.roseQuartz)
                    .frame(width: size * 0.3, height: size * 0.3)
                    .offset(x: size * 0.3, y: -size * 0.3)
                    .scaleEffect(animationPhase)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isActive)
    }
    
    private var connectionIcon: some View {
        ZStack {
            Image(systemName: "link")
                .font(.system(size: size * 0.8))
                .foregroundStyle(color)
                .rotationEffect(.degrees(animationPhase * 360))
            
            if isActive {
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [color, color.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .scaleEffect(1 + animationPhase * 0.5)
                    .opacity(1 - animationPhase)
            }
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
            animationPhase = 1.0
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        withAnimation(.easeOut(duration: 0.3)) {
            animationPhase = 0
        }
    }
}

enum IconType {
    case heart, message, touch, notification, connection
}

// MARK: - Icon Morphing
struct MorphingIcon: View {
    let fromIcon: String
    let toIcon: String
    let progress: CGFloat
    let size: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            Image(systemName: fromIcon)
                .font(.system(size: size))
                .foregroundStyle(color)
                .opacity(1 - progress)
                .scaleEffect(1 - progress * 0.5)
            
            Image(systemName: toIcon)
                .font(.system(size: size))
                .foregroundStyle(color)
                .opacity(progress)
                .scaleEffect(0.5 + progress * 0.5)
        }
    }
}

// MARK: - Contextual Icon
struct ContextualIcon: View {
    let baseIcon: String
    let context: IconContext
    let size: CGFloat
    
    @State private var currentIcon: String
    @State private var animationTimer: Timer?
    
    init(_ baseIcon: String, context: IconContext, size: CGFloat = 24) {
        self.baseIcon = baseIcon
        self.context = context
        self.size = size
        self._currentIcon = State(initialValue: baseIcon)
    }
    
    var body: some View {
        AnimatedIcon(
            iconTypeFromString(currentIcon),
            size: size,
            color: context.color,
            isActive: context.isActive
        )
        .onAppear {
            startContextualAnimation()
        }
        .onDisappear {
            stopContextualAnimation()
        }
    }
    
    private func startContextualAnimation() {
        guard context.isActive else { return }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: context.interval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentIcon = context.alternateIcons.randomElement() ?? baseIcon
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentIcon = baseIcon
                }
            }
        }
    }
    
    private func stopContextualAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    private func iconTypeFromString(_ iconString: String) -> IconType {
        switch iconString {
        case "heart.fill": return .heart
        case "message.fill": return .message
        case "hand.tap.fill": return .touch
        case "bell.fill": return .notification
        case "link": return .connection
        default: return .heart
        }
    }
}

struct IconContext {
    let color: Color
    let isActive: Bool
    let alternateIcons: [String]
    let interval: TimeInterval
    
    static let heartbeat = IconContext(
        color: EmberColors.roseQuartz,
        isActive: true,
        alternateIcons: ["heart", "heart.fill"],
        interval: 1.2
    )
    
    static let messaging = IconContext(
        color: EmberColors.peachyKeen,
        isActive: true,
        alternateIcons: ["message", "message.fill"],
        interval: 2.0
    )
    
    static let connection = IconContext(
        color: EmberColors.coralPop,
        isActive: true,
        alternateIcons: ["wifi", "antenna.radiowaves.left.and.right"],
        interval: 3.0
    )
}

// MARK: - Dark Mode Icons with Glow
struct GlowIcon: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let glowRadius: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    init(_ icon: String, size: CGFloat = 24, color: Color = .primary, glowRadius: CGFloat = 8) {
        self.icon = icon
        self.size = size
        self.color = color
        self.glowRadius = glowRadius
    }
    
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                // Glow effect for dark mode
                Image(systemName: icon)
                    .font(.system(size: size))
                    .foregroundStyle(color)
                    .blur(radius: glowRadius)
                    .opacity(0.8)
            }
            
            Image(systemName: icon)
                .font(.system(size: size))
                .foregroundStyle(color)
        }
    }
}