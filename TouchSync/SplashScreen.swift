import SwiftUI

struct SplashScreen: View {
    @State private var isAnimating = false
    @State private var showPulse = false
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Premium gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.4, blue: 0.6),
                    Color(red: 1.0, green: 0.6, blue: 0.4),
                    Color(red: 0.95, green: 0.5, blue: 0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background particles
            ForEach(0..<8, id: \.self) { index in
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 20...60))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: Double.random(in: 2...4))
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 32) {
                // App icon with premium effects
                ZStack {
                    // Pulse effect
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 200, height: 200)
                        .scaleEffect(showPulse ? 1.3 : 1.0)
                        .opacity(showPulse ? 0 : 0.3)
                        .animation(
                            .easeOut(duration: 2.0)
                            .repeatForever(autoreverses: false),
                            value: showPulse
                        )
                    
                    // Main icon background
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 140, height: 140)
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 2)
                        )
                    
                    // Heart characters
                    HStack(spacing: -20) {
                        CuteCharacter(
                            character: .touchy,
                            size: 50,
                            customization: CharacterCustomization(
                                colorTheme: .blue,
                                accessory: .none,
                                expression: .love,
                                name: "Touchy"
                            ),
                            isAnimating: true
                        )
                        
                        CuteCharacter(
                            character: .syncee,
                            size: 50,
                            customization: CharacterCustomization(
                                colorTheme: .pink,
                                accessory: .flower,
                                expression: .romantic,
                                name: "Syncee"
                            ),
                            isAnimating: true
                        )
                    }
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .rotationEffect(.degrees(rotationAngle))
                }
                
                // App name and tagline
                VStack(spacing: 12) {
                    Text("TouchSync")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Text("Feel Your Partner's Touch Anywhere")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .opacity(isAnimating ? 1.0 : 0.0)
            }
            
            // Loading indicator
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(.white.opacity(0.8))
                            .frame(width: 8, height: 8)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 1.0)) {
            isAnimating = true
        }
        
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 2.0).repeatForever(autoreverses: false)) {
                showPulse = true
            }
        }
    }
}

#Preview {
    SplashScreen()
}