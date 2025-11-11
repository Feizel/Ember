import SwiftUI

struct OnboardingReadyView: View {
    let onComplete: () -> Void
    
    @State private var showContent = false
    @State private var showButton = false
    @State private var celebrationParticles: [CelebrationParticle] = []
    
    var body: some View {
        ZStack {
            // Celebration particles
            ForEach(celebrationParticles) { particle in
                Image(systemName: "heart.fill")
                    .font(.system(size: particle.size))
                    .foregroundStyle(particle.color)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
                    .rotationEffect(.degrees(particle.rotation))
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Success content
                if showContent {
                    VStack(spacing: 32) {
                        // Success icon
                        ZStack {
                            Circle()
                                .fill(.green.opacity(0.2))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60, weight: .medium))
                                .foregroundStyle(.green)
                        }
                        .transition(.scale.combined(with: .opacity))
                        
                        // Text content
                        VStack(spacing: 16) {
                            Text("You're All Set!")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Start sending touches and stay connected with your partner")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        
                        // Features preview
                        VStack(spacing: 16) {
                            FeaturePreviewRow(
                                icon: "hand.tap.fill",
                                title: "Send Touch Patterns",
                                description: "Kiss, hug, wave, and more"
                            )
                            
                            FeaturePreviewRow(
                                icon: "message.fill",
                                title: "Love Notes",
                                description: "Sweet messages with animations"
                            )
                            
                            FeaturePreviewRow(
                                icon: "chart.line.uptrend.xyaxis",
                                title: "Connection Streaks",
                                description: "Track your daily connection goals"
                            )
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                
                Spacer()
                
                // Start button
                if showButton {
                    VStack(spacing: 16) {
                        Button(action: {
                            EmberHapticsManager.shared.playSuccess()
                            createCelebration()
                            onComplete()
                        }) {
                            Text("Begin Our Love Story")
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
                        
                        Text("Welcome to Ember 🔥")
                            .font(.footnote)
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            showContent = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.4)) {
                showButton = true
            }
        }
        
        EmberHapticsManager.shared.playSuccess()
    }
    
    private func createCelebration() {
        let colors: [Color] = [.red, .pink, .orange, .yellow, .green, .blue, .purple]
        
        for _ in 0..<20 {
            let particle = CelebrationParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 50...350),
                    y: CGFloat.random(in: 200...600)
                ),
                size: CGFloat.random(in: 12...24),
                color: colors.randomElement() ?? .red,
                opacity: 1.0,
                scale: 1.0,
                rotation: Double.random(in: 0...360)
            )
            celebrationParticles.append(particle)
        }
        
        // Animate particles
        withAnimation(.easeOut(duration: 2.0)) {
            for i in celebrationParticles.indices {
                celebrationParticles[i].position.y -= CGFloat.random(in: 100...300)
                celebrationParticles[i].opacity = 0.0
                celebrationParticles[i].scale = 0.5
                celebrationParticles[i].rotation += Double.random(in: 180...540)
            }
        }
        
        // Remove particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            celebrationParticles.removeAll()
        }
    }
}

struct FeaturePreviewRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(description)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct CelebrationParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var scale: CGFloat
    var rotation: Double
}

#Preview {
    OnboardingReadyView {
        print("Onboarding completed")
    }
}