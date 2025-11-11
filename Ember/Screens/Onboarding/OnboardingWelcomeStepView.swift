import SwiftUI

struct OnboardingWelcomeStepView: View {
    let onNext: () -> Void
    
    @State private var showCharacters = false
    @State private var showText = false
    @State private var showButton = false
    @State private var particles: [FloatingParticle] = []
    
    var body: some View {
        ZStack {
            // Floating particles background
            ForEach(particles) { particle in
                Image(systemName: particle.icon)
                    .font(.system(size: particle.size))
                    .foregroundStyle(particle.color.opacity(particle.opacity))
                    .position(particle.position)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // 3D Characters
                ZStack {
                    if showCharacters {
                        Ember3DCharacterView()
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .frame(height: 300)
            
            Spacer().frame(height: 40)
            
            // Text content
            VStack(spacing: 16) {
                if showText {
                    Text("Stay connected through touch")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    
                    Text("No matter the distance")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Action button
            VStack(spacing: 16) {
                if showButton {
                    Button(action: {
                        EmberHapticsManager.shared.playMedium()
                        onNext()
                    }) {
                        Text("Experience the Magic")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [EmberColors.roseQuartz, EmberColors.coralPop],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(
                                color: EmberColors.roseQuartz.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    }
                    .buttonStyle(EmberPressableButtonStyle())
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // Terms & Privacy
                HStack(spacing: 4) {
                    Text("By continuing, you agree to our")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Button("Terms") {}
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("&")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Button("Privacy") {}
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Start particle system
        createFloatingParticles()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showCharacters = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.4)) {
                showText = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.4)) {
                showButton = true
            }
        }
        
        EmberHapticsManager.shared.playLight()
    }
    
    private func createFloatingParticles() {
        let icons = ["heart.fill", "sparkles", "flame.fill", "star.fill"]
        let colors = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop, .white]
        
        func addParticle() {
            if particles.count < 12 {
                let particle = FloatingParticle(
                    position: CGPoint(
                        x: CGFloat.random(in: 0...400),
                        y: CGFloat.random(in: 600...900)
                    ),
                    size: CGFloat.random(in: 8...16),
                    color: colors.randomElement() ?? .white,
                    opacity: Double.random(in: 0.3...0.7),
                    scale: 1.0,
                    rotation: Double.random(in: 0...360),
                    icon: icons.randomElement() ?? "heart.fill"
                )
                particles.append(particle)
                
                withAnimation(.linear(duration: Double.random(in: 8...12))) {
                    if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                        particles[index].position.y -= CGFloat.random(in: 800...1000)
                        particles[index].opacity = 0
                        particles[index].scale = 0.5
                        particles[index].rotation += Double.random(in: 180...360)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                    particles.removeAll { $0.id == particle.id }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                addParticle()
            }
        }
        
        addParticle()
    }
}

struct FloatingParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var scale: CGFloat
    var rotation: Double
    var icon: String
}

#Preview {
    OnboardingWelcomeStepView {
        print("Next tapped")
    }
}
