import SwiftUI

struct EmberLoadingView: View {
    @State private var progress: Double = 0
    @State private var showCharacters = false
    @State private var charactersScale: CGFloat = 0.5
    @State private var glowIntensity: Double = 0
    @State private var sparkles: [Sparkle] = []
    @State private var loadingText = "Connecting hearts..."
    
    let onComplete: () -> Void
    
    private let loadingSteps = [
        "Connecting hearts...",
        "Syncing emotions...",
        "Preparing your love space...",
        "Almost ready..."
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Sparkle particles
            ForEach(sparkles) { sparkle in
                Circle()
                    .fill(.white.opacity(sparkle.opacity))
                    .frame(width: sparkle.size, height: sparkle.size)
                    .position(sparkle.position)
                    .scaleEffect(sparkle.scale)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // Characters with glow effect
                if showCharacters {
                    ZStack {
                        // Glow effect
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [.white.opacity(glowIntensity * 0.3), .clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 240, height: 240)
                        
                        // Characters
                        Image("TouchyAndSyncee")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180, height: 180)
                            .scaleEffect(charactersScale)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
                
                // Loading content
                VStack(spacing: 24) {
                    // Loading text
                    Text(loadingText)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    
                    // Progress bar
                    VStack(spacing: 8) {
                        ZStack(alignment: .leading) {
                            // Background
                            Capsule()
                                .fill(.white.opacity(0.2))
                                .frame(height: 6)
                            
                            // Progress
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.white, .white.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: max(0, progress * 280), height: 6)
                        }
                        .frame(width: 280)
                        
                        // Progress percentage
                        Text("\(Int(progress * 100))%")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startLoadingAnimation()
        }
    }
    
    private func startLoadingAnimation() {
        // Show characters
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showCharacters = true
            charactersScale = 1.0
        }
        
        // Start sparkles
        createSparkles()
        
        // Animate progress and text changes
        animateProgress()
        
        // Character breathing animation
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            charactersScale = 1.05
        }
        
        // Glow pulsing
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            glowIntensity = 1.0
        }
    }
    
    private func animateProgress() {
        let totalDuration: Double = 3.0
        let stepDuration = totalDuration / Double(loadingSteps.count)
        
        for (index, step) in loadingSteps.enumerated() {
            let delay = Double(index) * stepDuration
            let targetProgress = Double(index + 1) / Double(loadingSteps.count)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                // Update text
                withAnimation(.easeInOut(duration: 0.3)) {
                    loadingText = step
                }
                
                // Update progress
                withAnimation(.easeOut(duration: stepDuration * 0.8)) {
                    progress = targetProgress
                }
                
                // Haptic feedback
                EmberHapticsManager.shared.playLight()
            }
        }
        
        // Complete loading
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.5) {
            EmberHapticsManager.shared.playSuccess()
            
            withAnimation(.easeInOut(duration: 0.5)) {
                charactersScale = 1.2
                glowIntensity = 2.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onComplete()
            }
        }
    }
    
    private func createSparkles() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if sparkles.count < 15 {
                let sparkle = Sparkle(
                    position: CGPoint(
                        x: CGFloat.random(in: 50...350),
                        y: CGFloat.random(in: 100...700)
                    ),
                    size: CGFloat.random(in: 2...6),
                    opacity: Double.random(in: 0.3...0.8),
                    scale: 1.0
                )
                sparkles.append(sparkle)
                
                // Animate sparkle
                withAnimation(.easeOut(duration: 2.0)) {
                    if let index = sparkles.firstIndex(where: { $0.id == sparkle.id }) {
                        sparkles[index].opacity = 0
                        sparkles[index].scale = 0.5
                        sparkles[index].position.y -= 100
                    }
                }
                
                // Remove sparkle
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    sparkles.removeAll { $0.id == sparkle.id }
                }
            }
            
            if progress >= 1.0 {
                timer.invalidate()
            }
        }
    }
}

struct Sparkle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
}

#Preview {
    EmberLoadingView {
        print("Loading completed")
    }
}