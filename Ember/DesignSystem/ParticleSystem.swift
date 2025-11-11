import SwiftUI

// MARK: - Particle System
struct ParticleSystem: View {
    let type: ParticleType
    let isActive: Bool
    let particleCount: Int
    
    @State private var particles: [Particle] = []
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                ParticleView(particle: particle)
            }
        }
        .onAppear {
            if isActive {
                startEmission()
            }
        }
        .onDisappear {
            stopEmission()
        }
        .onChange(of: isActive) {
            if isActive {
                startEmission()
            } else {
                stopEmission()
            }
        }
    }
    
    private func startEmission() {
        timer = Timer.scheduledTimer(withTimeInterval: type.emissionRate, repeats: true) { _ in
            emitParticle()
        }
    }
    
    private func stopEmission() {
        timer?.invalidate()
        timer = nil
    }
    
    private func emitParticle() {
        guard particles.count < particleCount else { return }
        
        let particle = Particle(
            position: CGPoint(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: UIScreen.main.bounds.height + 50
            ),
            velocity: CGPoint(
                x: CGFloat.random(in: -50...50),
                y: CGFloat.random(in: -200...(-100))
            ),
            size: CGFloat.random(in: type.sizeRange),
            color: type.colors.randomElement() ?? .white,
            opacity: 1.0,
            rotation: 0,
            rotationSpeed: CGFloat.random(in: (-180)...180),
            lifespan: type.lifespan,
            age: 0
        )
        
        particles.append(particle)
        
        // Animate particle
        withAnimation(.linear(duration: type.lifespan)) {
            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                particles[index].position.x += particle.velocity.x * type.lifespan
                particles[index].position.y += particle.velocity.y * type.lifespan
                particles[index].opacity = 0
                particles[index].rotation += particle.rotationSpeed * type.lifespan
                particles[index].age = type.lifespan
            }
        }
        
        // Remove particle after lifespan
        DispatchQueue.main.asyncAfter(deadline: .now() + type.lifespan) {
            particles.removeAll { $0.id == particle.id }
        }
    }
}

struct ParticleView: View {
    let particle: Particle
    
    var body: some View {
        Image(systemName: particle.type.icon)
            .font(.system(size: particle.size))
            .foregroundStyle(particle.color)
            .opacity(particle.opacity)
            .rotationEffect(.degrees(particle.rotation))
            .position(particle.position)
    }
}

// MARK: - Particle Types
enum ParticleType {
    case floatingHearts
    case touchSparkles
    case emberParticles
    case connectionTrails
    
    var icon: String {
        switch self {
        case .floatingHearts: return "heart.fill"
        case .touchSparkles: return "sparkle"
        case .emberParticles: return "flame.fill"
        case .connectionTrails: return "circle.fill"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .floatingHearts:
            return [EmberColors.roseQuartz, EmberColors.peachyKeen, .pink]
        case .touchSparkles:
            return [.white, .yellow, EmberColors.coralPop]
        case .emberParticles:
            return [.orange, .red, EmberColors.coralPop]
        case .connectionTrails:
            return [EmberColors.roseQuartz.opacity(0.6)]
        }
    }
    
    var sizeRange: ClosedRange<CGFloat> {
        switch self {
        case .floatingHearts: return 8...16
        case .touchSparkles: return 4...12
        case .emberParticles: return 6...14
        case .connectionTrails: return 2...6
        }
    }
    
    var emissionRate: TimeInterval {
        switch self {
        case .floatingHearts: return 0.8
        case .touchSparkles: return 0.1
        case .emberParticles: return 0.3
        case .connectionTrails: return 0.2
        }
    }
    
    var lifespan: TimeInterval {
        switch self {
        case .floatingHearts: return 4.0
        case .touchSparkles: return 1.5
        case .emberParticles: return 3.0
        case .connectionTrails: return 2.0
        }
    }
}

// MARK: - Particle Model
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var rotation: CGFloat
    var rotationSpeed: CGFloat
    var lifespan: TimeInterval
    var age: TimeInterval
    
    var type: ParticleType {
        // Determine type based on color/size for icon selection
        if color == EmberColors.roseQuartz || color == .pink {
            return .floatingHearts
        } else if color == .white || color == .yellow {
            return .touchSparkles
        } else if color == .orange || color == .red {
            return .emberParticles
        } else {
            return .connectionTrails
        }
    }
}

// MARK: - Touch Ripple Effect
struct TouchRipple: View {
    let center: CGPoint
    let maxRadius: CGFloat
    
    @State private var radius: CGFloat = 0
    @State private var opacity: Double = 0.8
    
    var body: some View {
        Circle()
            .stroke(EmberColors.roseQuartz.opacity(opacity), lineWidth: 2)
            .frame(width: radius * 2, height: radius * 2)
            .position(center)
            .onAppear {
                withAnimation(.easeOut(duration: 0.6)) {
                    radius = maxRadius
                    opacity = 0
                }
            }
    }
}

// MARK: - Connection Trail Between Characters
struct ConnectionTrail: View {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let isActive: Bool
    
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        Path { path in
            path.move(to: startPoint)
            
            let controlPoint1 = CGPoint(
                x: startPoint.x + (endPoint.x - startPoint.x) * 0.3,
                y: startPoint.y - 50
            )
            let controlPoint2 = CGPoint(
                x: startPoint.x + (endPoint.x - startPoint.x) * 0.7,
                y: endPoint.y - 50
            )
            
            path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
        }
        .trim(from: 0, to: isActive ? 1 : 0)
        .stroke(
            LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [5, 5])
        )
        .overlay(
            // Animated dots along the path
            Circle()
                .fill(EmberColors.coralPop)
                .frame(width: 8, height: 8)
                .offset(x: animationOffset)
                .opacity(isActive ? 1 : 0)
        )
        .onAppear {
            if isActive {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    animationOffset = endPoint.x - startPoint.x
                }
            }
        }
    }
}

// MARK: - Ambient Particle Background
struct AmbientParticleBackground: View {
    @State private var particles: [AmbientParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color.opacity(particle.opacity))
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .blur(radius: particle.blur)
            }
        }
        .onAppear {
            createAmbientParticles()
        }
    }
    
    private func createAmbientParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        for _ in 0..<20 {
            let particle = AmbientParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                size: CGFloat.random(in: 20...60),
                color: [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop].randomElement() ?? EmberColors.roseQuartz,
                opacity: Double.random(in: 0.1...0.3),
                blur: CGFloat.random(in: 10...30)
            )
            particles.append(particle)
        }
        
        // Animate particles floating
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: true)) {
            for i in particles.indices {
                particles[i].position.x += CGFloat.random(in: (-100)...100)
                particles[i].position.y += CGFloat.random(in: (-100)...100)
            }
        }
    }
}

struct AmbientParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var blur: CGFloat
}
