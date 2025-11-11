import SwiftUI

// MARK: - Interactive Button with Micro-interactions
struct InteractiveButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    let hapticType: HapticVisualType
    let style: InteractiveButtonStyle
    
    @State private var isPressed = false
    @State private var ripples: [TouchRipple] = []
    @State private var particles: [InteractionParticle] = []
    
    init(
        hapticType: HapticVisualType = .touch,
        style: InteractiveButtonStyle = .standard,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.hapticType = hapticType
        self.style = style
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Ripple effects
            ForEach(Array(ripples.enumerated()), id: \.offset) { _, ripple in
                TouchRipple(center: ripple.center, maxRadius: ripple.maxRadius)
            }
            
            // Particle effects
            ForEach(particles) { particle in
                Image(systemName: "sparkle")
                    .font(.system(size: particle.size))
                    .foregroundStyle(particle.color)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }
            
            // Button content
            content
                .scaleEffect(isPressed ? style.pressedScale : 1.0)
                .brightness(isPressed ? style.pressedBrightness : 0)
                .animation(ElasticAnimations.bounce, value: isPressed)
        }
        .onTapGesture { location in
            handleTap(at: location)
        }
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                withAnimation(ElasticAnimations.spring) {
                    isPressed = pressing
                }
                
                if pressing {
                    HapticVisualSync.trigger(hapticType)
                }
            },
            perform: {}
        )
    }
    
    private func handleTap(at location: CGPoint) {
        HapticVisualSync.trigger(hapticType, at: location)
        createRipple(at: location)
        createParticleBurst(at: location)
        action()
    }
    
    private func createRipple(at location: CGPoint) {
        let ripple = TouchRipple(center: location, maxRadius: 50)
        ripples.append(ripple)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if let index = ripples.firstIndex(where: { $0.center == ripple.center }) {
                ripples.remove(at: index)
            }
        }
    }
    
    private func createParticleBurst(at location: CGPoint) {
        let colors = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop]
        
        for _ in 0..<8 {
            let angle = Double.random(in: 0...2 * .pi)
            let distance = CGFloat.random(in: 20...60)
            
            let particle = InteractionParticle(
                position: location,
                targetPosition: CGPoint(
                    x: location.x + CGFloat(cos(angle)) * distance,
                    y: location.y + CGFloat(sin(angle)) * distance
                ),
                size: CGFloat.random(in: 8...16),
                color: colors.randomElement() ?? EmberColors.roseQuartz,
                opacity: 1.0,
                scale: 1.0
            )
            
            particles.append(particle)
            
            withAnimation(.easeOut(duration: 0.8)) {
                if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                    particles[index].position = particle.targetPosition
                    particles[index].opacity = 0
                    particles[index].scale = 0.3
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            particles.removeAll()
        }
    }
}

enum InteractiveButtonStyle {
    case standard, gentle, intense
    
    var pressedScale: CGFloat {
        switch self {
        case .standard: return 0.95
        case .gentle: return 0.98
        case .intense: return 0.90
        }
    }
    
    var pressedBrightness: Double {
        switch self {
        case .standard: return -0.1
        case .gentle: return -0.05
        case .intense: return -0.15
        }
    }
}

struct InteractionParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let targetPosition: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var scale: CGFloat
}