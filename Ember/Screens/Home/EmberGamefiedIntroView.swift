import SwiftUI

struct EmberGamefiedIntroView: View {
    let onComplete: () -> Void
    
    @State private var currentStep = 0
    @State private var showCharacters = false
    @State private var sparkles: [IntroSparkle] = []
    @State private var progress: Double = 0
    
    private let introSteps = [
        IntroStep(
            title: "Welcome to Your Love Journey",
            subtitle: "Meet Touchy and Syncee, your companions in love",
            icon: "heart.fill",
            color: EmberColors.roseQuartz
        ),
        IntroStep(
            title: "Send Your First Touch",
            subtitle: "Tap the heart to send love to your partner",
            icon: "hand.tap.fill",
            color: EmberColors.peachyKeen
        ),
        IntroStep(
            title: "Feel the Connection",
            subtitle: "Experience how your love transcends distance",
            icon: "infinity",
            color: EmberColors.coralPop
        )
    ]
    
    var body: some View {
        ZStack {
            // Romantic gradient
            LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Sparkle effects
            ForEach(sparkles) { sparkle in
                Image(systemName: "sparkle")
                    .font(.system(size: sparkle.size))
                    .foregroundStyle(sparkle.color)
                    .position(sparkle.position)
                    .opacity(sparkle.opacity)
                    .scaleEffect(sparkle.scale)
            }
            
            VStack(spacing: 0) {
                // Progress bar
                VStack(spacing: 16) {
                    HStack {
                        ForEach(0..<introSteps.count, id: \.self) { index in
                            Circle()
                                .fill(index <= currentStep ? .white : .white.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .scaleEffect(index == currentStep ? 1.3 : 1.0)
                                .animation(.spring(response: 0.4), value: currentStep)
                            
                            if index < introSteps.count - 1 {
                                Rectangle()
                                    .fill(index < currentStep ? .white : .white.opacity(0.3))
                                    .frame(height: 2)
                                    .animation(.easeInOut(duration: 0.3), value: currentStep)
                            }
                        }
                    }
                    .padding(.horizontal, 60)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Characters
                if showCharacters {
                    HStack(spacing: 40) {
                        // Touchy
                        VStack(spacing: 12) {
                            Image("touchy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .scaleEffect(showCharacters ? 1.0 : 0.8)
                            
                            Text("Touchy")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        // Connection heart
                        ZStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white.opacity(0.3))
                                .blur(radius: 8)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                        
                        // Syncee
                        VStack(spacing: 12) {
                            Image("syncee")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .scaleEffect(showCharacters ? 1.0 : 0.8)
                            
                            Text("Syncee")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Current step content
                VStack(spacing: 24) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .blur(radius: 10)
                        
                        Image(systemName: introSteps[currentStep].icon)
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    
                    // Text content
                    VStack(spacing: 12) {
                        Text(introSteps[currentStep].title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(introSteps[currentStep].subtitle)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Action button
                VStack(spacing: 20) {
                    if currentStep < introSteps.count - 1 {
                        Button(action: nextStep) {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(.white.opacity(0.2))
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.4), lineWidth: 1)
                                )
                        }
                        .buttonStyle(EmberPressableButtonStyle())
                    } else {
                        Button(action: {
                            EmberHapticsManager.shared.playSuccess()
                            createCelebrationSparkles()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                onComplete()
                            }
                        }) {
                            Text("Begin Love Story")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [.white.opacity(0.3), .white.opacity(0.2)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.5), lineWidth: 1)
                                )
                        }
                        .buttonStyle(EmberPressableButtonStyle())
                    }
                    
                    Button("Skip Intro") {
                        onComplete()
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startIntroAnimation()
        }
    }
    
    private func startIntroAnimation() {
        // Show characters
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
            showCharacters = true
        }
        
        // Start sparkle animation
        createSparkles()
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            createSparkles()
        }
    }
    
    private func nextStep() {
        EmberHapticsManager.shared.playMedium()
        
        withAnimation(.easeInOut(duration: 0.4)) {
            currentStep += 1
        }
        
        createSparkles()
    }
    
    private func createSparkles() {
        let colors = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop]
        
        for _ in 0..<5 {
            let sparkle = IntroSparkle(
                position: CGPoint(
                    x: CGFloat.random(in: 50...350),
                    y: CGFloat.random(in: 200...600)
                ),
                size: CGFloat.random(in: 8...16),
                color: colors.randomElement() ?? EmberColors.roseQuartz,
                opacity: 0.8,
                scale: 1.0
            )
            
            sparkles.append(sparkle)
            
            withAnimation(.easeOut(duration: 2.0)) {
                if let index = sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                    sparkles[index].position.y -= CGFloat.random(in: 50...100)
                    sparkles[index].opacity = 0
                    sparkles[index].scale = 0.3
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sparkles.removeAll { sparkle in
                sparkle.opacity <= 0.1
            }
        }
    }
    
    private func createCelebrationSparkles() {
        let colors = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop]
        
        for _ in 0..<20 {
            let sparkle = IntroSparkle(
                position: CGPoint(
                    x: CGFloat.random(in: 100...300),
                    y: CGFloat.random(in: 300...500)
                ),
                size: CGFloat.random(in: 12...20),
                color: colors.randomElement() ?? EmberColors.roseQuartz,
                opacity: 1.0,
                scale: 1.0
            )
            
            sparkles.append(sparkle)
            
            withAnimation(.easeOut(duration: 1.5)) {
                if let index = sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                    sparkles[index].position.y -= CGFloat.random(in: 100...200)
                    sparkles[index].opacity = 0
                    sparkles[index].scale = 0.2
                }
            }
        }
    }
}

struct IntroStep {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

struct IntroSparkle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var scale: CGFloat
}

#Preview {
    EmberGamefiedIntroView {
        print("Intro completed")
    }
}