import SwiftUI

struct OnboardingWelcomeView: View {
    let onNext: () -> Void
    
    @State private var heartPulse: CGFloat = 1.0
    @State private var textOpacity: Double = 0
    @State private var charactersScale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            // Romantic gradient background
            LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Animated heart with glow
                ZStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80, weight: .medium))
                        .foregroundStyle(.white.opacity(0.3))
                        .blur(radius: 20)
                        .scaleEffect(heartPulse * 1.2)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(.white)
                        .scaleEffect(heartPulse)
                }
                .padding(.bottom, 40)
                
                // Welcome text
                VStack(spacing: 16) {
                    Text("Welcome to Ember")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Where love transcends distance")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                .opacity(textOpacity)
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Characters
                Image("TouchyAndSyncee")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .scaleEffect(charactersScale)
                    .opacity(textOpacity)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    EmberHapticsManager.shared.playMedium()
                    onNext()
                }) {
                    Text("Begin Your Journey")
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
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(textOpacity)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Heart pulse
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            heartPulse = 1.1
        }
        
        // Text fade in
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            textOpacity = 1.0
        }
        
        // Characters scale in
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
            charactersScale = 1.0
        }
    }
}

#Preview {
    OnboardingWelcomeView {
        print("Next")
    }
}