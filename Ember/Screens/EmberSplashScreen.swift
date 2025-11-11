import SwiftUI

// MARK: - Cinematic Splash Screen
struct EmberSplashScreen: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var particlesOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var backgroundGradient: Double = 0
    @State private var showCharacters = false
    @State private var isComplete = false
    @Environment(\.colorScheme) var colorScheme
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Dynamic Background
            backgroundView
            
            // Particle System
            particleSystem
            
            // Main Content
            VStack(spacing: 40) {
                Spacer()
                
                // Logo Animation
                logoSection
                
                // Brand Text
                brandTextSection
                
                // 3D Characters with USDZ fallback to PNG
                if showCharacters {
                    Group {
                        if Bundle.main.url(forResource: "touchy&syncee3d", withExtension: "usdz") != nil {
                            // Use USDZ 3D model if available
                            Image("3dcharacters")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 280, height: 280)
                        } else {
                            // Fallback to PNG image
                            Image("TouchyAndSyncee")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 280, height: 280)
                        }
                    }
                    .opacity(showCharacters ? 1 : 0)
                    .scaleEffect(showCharacters ? 1 : 0.8)
                }
                
                Spacer()
                
                // Loading Indicator
                loadingSection
            }
            .padding()
        }
        .onAppear {
            startSplashAnimation()
        }
    }
    
    // MARK: - Background
    private var backgroundView: some View {
        // Linear gradient from rose_quartz to peachy_keen per spec
        LinearGradient(
            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Particle System
    private var particleSystem: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                EmberParticle(
                    delay: Double(index) * 0.1,
                    color: [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop].randomElement() ?? EmberColors.roseQuartz
                )
            }
        }
        .opacity(particlesOpacity)
    }
    
    // MARK: - Logo Section
    private var logoSection: some View {
        ZStack {
            // Enhanced glow effect for dark mode
            Circle()
                .fill(EmberColors.roseQuartzGlow)
                .frame(width: 160, height: 160)
                .blur(radius: 30)
                .opacity(colorScheme == .dark ? logoOpacity * 0.8 : 0)
            
            Circle()
                .fill(EmberColors.peachyKeenGlow)
                .frame(width: 120, height: 120)
                .blur(radius: 20)
                .opacity(colorScheme == .dark ? logoOpacity * 0.6 : 0)
            
            // 3D App Icon
            Image("app_icon3d")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120) // 120x120pt per spec
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .emberRoseGlow(radius: colorScheme == .dark ? 20 : 0)
        }
    }
    
    // MARK: - Brand Text
    private var brandTextSection: some View {
        VStack(spacing: 12) {
            Text("Ember")
                .font(.system(size: 34, weight: .bold)) // title_large per spec
                .foregroundStyle(.white)
                .scaleEffect(textOpacity)
            
            Text("Where distance disappears")
                .font(.system(size: 12, weight: .regular)) // caption per spec
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .opacity(textOpacity)
    }
    

    
    // MARK: - Loading Section
    private var loadingSection: some View {
        VStack(spacing: 16) {
            // Progress indicator
            EmberLoadingIndicator()
            
            Text("Igniting connection...")
                .emberCaption(color: EmberColors.textSecondary)
        }
        .opacity(textOpacity)
    }
    
    // MARK: - Animation Sequence
    private func startSplashAnimation() {
        // Haptic feedback
        EmberHapticsManager.shared.playLight()
        
        // Background fade in
        withAnimation(.easeOut(duration: 0.5)) {
            backgroundGradient = 1.0
        }
        
        // Logo gentle pulse animation per spec
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            logoScale = 1.05
        }
        
        withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
            logoOpacity = 1.0
        }
        
        // Particles
        withAnimation(.easeIn(duration: 1.0).delay(0.5)) {
            particlesOpacity = 1.0
        }
        
        // Text reveal
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.8)) {
            textOpacity = 1.0
        }
        
        // Character introduction
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            EmberHapticsManager.shared.playMedium()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                showCharacters = true
            }
        }
        
        // Complete splash after 1.5s per spec
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isComplete = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onComplete()
            }
        }
    }
}

// MARK: - Ember Particle
struct EmberParticle: View {
    let delay: Double
    let color: Color
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        Circle()
            .fill(color.opacity(0.6))
            .frame(width: CGFloat.random(in: 2...6))
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(offset)
            .onAppear {
                startAnimation()
            }
    }
    
    private func startAnimation() {
        let randomX = CGFloat.random(in: -150...150)
        let randomY = CGFloat.random(in: -200...200)
        
        withAnimation(
            .easeInOut(duration: Double.random(in: 2...4))
            .delay(delay)
            .repeatForever(autoreverses: true)
        ) {
            offset = CGSize(width: randomX, height: randomY)
            opacity = Double.random(in: 0.3...0.8)
            scale = CGFloat.random(in: 0.8...1.2)
        }
    }
}

// MARK: - Loading Indicator
struct EmberLoadingIndicator: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(EmberColors.border, lineWidth: 3)
                .frame(width: 24, height: 24)
            
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(EmberColors.primaryGradient, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 24, height: 24)
                .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    EmberSplashScreen {
        print("Splash completed")
    }
}
