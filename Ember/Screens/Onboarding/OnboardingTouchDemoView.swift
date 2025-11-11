import SwiftUI

struct OnboardingTouchDemoView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @State private var currentIndex = 0
    @State private var touchedPatterns: Set<Int> = []
    @State private var showInstructions = false
    @State private var particles: [TouchParticle] = []
    
    private let hapticPatterns = HapticGesture.allGestures.prefix(5)
    
    var demoCompleted: Bool {
        touchedPatterns.count >= 3
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    Button("Skip") {
                        onSkip()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                    
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    Text("Feel Your Partner's Touch")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Experience the intimate haptic patterns that will connect your hearts")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            Spacer()
            
            // Scrollable touch patterns
            VStack(spacing: 32) {
                TabView(selection: $currentIndex) {
                    ForEach(Array(hapticPatterns.enumerated()), id: \.offset) { index, gesture in
                        PremiumHapticCard(
                            gesture: gesture,
                            index: index,
                            isTouched: touchedPatterns.contains(index),
                            onTap: {
                                EmberHapticsManager.shared.playGesture(gesture)
                                touchedPatterns.insert(index)
                                createTouchParticles()
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 280)
                
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<hapticPatterns.count, id: \.self) { index in
                        Circle()
                            .fill(currentIndex == index ? .white : .white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentIndex == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
                
                // Progress feedback
                if !demoCompleted {
                    VStack(spacing: 8) {
                        Text("\(touchedPatterns.count)/3 patterns explored")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                        
                        ProgressView(value: Double(touchedPatterns.count), total: 3.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: .white))
                            .frame(width: 120)
                    }
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 20))
                        
                        Text("Beautiful! You felt the love")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            
            Spacer()
            
            // Continue button
            VStack(spacing: 16) {
                Button(action: {
                    EmberHapticsManager.shared.playMedium()
                    onNext()
                }) {
                    Text(demoCompleted ? "Ready to Connect Hearts" : "I'll Feel This Later")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: demoCompleted ? 
                                    [EmberColors.roseQuartz, EmberColors.coralPop] :
                                    [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.3), lineWidth: demoCompleted ? 0 : 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .overlay(
            // Particle effects
            ForEach(particles) { particle in
                Image(systemName: "heart.fill")
                    .font(.system(size: particle.size))
                    .foregroundStyle(particle.color)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }
        )
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.2)) {
                showInstructions = true
            }
        }
    }
    
    private func createTouchParticles() {
        let colors: [Color] = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop]
        
        for _ in 0..<8 {
            let particle = TouchParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 100...300),
                    y: CGFloat.random(in: 300...500)
                ),
                size: CGFloat.random(in: 12...20),
                color: colors.randomElement() ?? EmberColors.roseQuartz,
                opacity: 1.0,
                scale: 1.0
            )
            particles.append(particle)
        }
        
        withAnimation(.easeOut(duration: 1.5)) {
            for i in particles.indices {
                particles[i].position.y -= CGFloat.random(in: 50...150)
                particles[i].opacity = 0.0
                particles[i].scale = 0.3
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            particles.removeAll()
        }
    }
}

struct PremiumHapticCard: View {
    let gesture: HapticGesture
    let index: Int
    let isTouched: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            EmberHapticsManager.shared.playLight()
            onTap()
            
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                pulseScale = 1.1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    pulseScale = 1.0
                }
            }
        }) {
            VStack(spacing: 20) {
                // Icon with animated background
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    .white.opacity(0.3),
                                    .white.opacity(0.1)
                                ],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.4), lineWidth: 2)
                        )
                        .scaleEffect(pulseScale)
                    
                    Image(systemName: gesture.icon)
                        .font(.system(size: 40, weight: .medium))
                        .foregroundStyle(.white)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                    
                    if isTouched {
                        Circle()
                            .stroke(.green, lineWidth: 3)
                            .frame(width: 130, height: 130)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                // Text content
                VStack(spacing: 8) {
                    Text(gesture.name)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Tap to feel this loving touch")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                
                // Touch indicator
                if isTouched {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        Text("Felt it!")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.green)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct TouchParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var scale: CGFloat
}

#Preview {
    OnboardingTouchDemoView(
        onNext: { print("Next") },
        onSkip: { print("Skip") }
    )
}