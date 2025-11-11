import SwiftUI

struct OnboardingConnectionView: View {
    let onNext: () -> Void
    
    @State private var glowOpacity: Double = 0.5
    @State private var connectionLines: [ConnectionLine] = []
    @State private var showCharacters = false
    @State private var textOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Romantic gradient
            LinearGradient(
                colors: [EmberColors.peachyKeen, EmberColors.coralPop],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Connection visualization
            ForEach(connectionLines) { line in
                Path { path in
                    path.move(to: line.start)
                    path.addLine(to: line.end)
                }
                .stroke(.white.opacity(line.opacity), lineWidth: 2)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Title
                VStack(spacing: 16) {
                    Text("Love Knows No Distance")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Connect with your partner and feel their presence wherever you are")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                .opacity(textOpacity)
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Connection visualization
                HStack(spacing: 60) {
                    // Left character (You)
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image("touchy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                        
                        Text("You")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .scaleEffect(showCharacters ? 1.0 : 0.8)
                    .opacity(showCharacters ? 1.0 : 0)
                    
                    // Connection heart
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white.opacity(glowOpacity))
                            .blur(radius: 8)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    }
                    
                    // Right character (Partner)
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image("syncee")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                        
                        Text("Partner")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .scaleEffect(showCharacters ? 1.0 : 0.8)
                    .opacity(showCharacters ? 1.0 : 0)
                }
                .padding(.vertical, 40)
                
                Spacer()
                
                // Features list
                VStack(spacing: 20) {
                    FeatureRow(icon: "waveform.path", text: "Feel each other's touch in real-time")
                    FeatureRow(icon: "message.fill", text: "Share loving messages instantly")
                    FeatureRow(icon: "heart.circle.fill", text: "Express emotions through haptics")
                }
                .opacity(textOpacity)
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    EmberHapticsManager.shared.playMedium()
                    onNext()
                }) {
                    Text("Let's Connect Hearts")
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
        // Gentle glow animation
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            glowOpacity = 0.8
        }
        
        // Text fade in
        withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
            textOpacity = 1.0
        }
        
        // Characters appear
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5)) {
            showCharacters = true
        }
        
        // Connection lines
        createConnectionLines()
    }
    
    private func createConnectionLines() {
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            let line = ConnectionLine(
                start: CGPoint(x: 150, y: 400),
                end: CGPoint(x: 250, y: 400),
                opacity: 0.8
            )
            
            connectionLines.append(line)
            
            withAnimation(.easeOut(duration: 2.0)) {
                if let index = connectionLines.firstIndex(where: { $0.id == line.id }) {
                    connectionLines[index].opacity = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                connectionLines.removeAll { $0.id == line.id }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

struct ConnectionLine: Identifiable {
    let id = UUID()
    let start: CGPoint
    let end: CGPoint
    var opacity: Double
}

#Preview {
    OnboardingConnectionView {
        print("Next")
    }
}