import SwiftUI

struct OnboardingLoveStoryView: View {
    let onNext: () -> Void
    
    @State private var currentScene = 0
    @State private var heartBeats: [HeartBeat] = []
    @State private var showText = false
    
    private let scenes = [
        LoveScene(
            title: "Feel Each Other's Touch",
            subtitle: "Send gentle touches that your partner feels through haptic vibrations",
            icon: "hand.tap.fill"
        ),
        LoveScene(
            title: "Share Your Heart",
            subtitle: "Express emotions with beautiful gestures and loving messages",
            icon: "heart.fill"
        ),
        LoveScene(
            title: "Stay Connected Always",
            subtitle: "Bridge any distance with intimate moments that bring you closer",
            icon: "infinity"
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
            
            // Floating hearts
            ForEach(heartBeats) { heart in
                Image(systemName: "heart.fill")
                    .font(.system(size: heart.size))
                    .foregroundStyle(.white.opacity(heart.opacity))
                    .position(heart.position)
                    .scaleEffect(heart.scale)
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                // Scene content
                TabView(selection: $currentScene) {
                    ForEach(Array(scenes.enumerated()), id: \.offset) { index, scene in
                        VStack(spacing: 32) {
                            // Icon with glow
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                    .blur(radius: 10)
                                
                                Image(systemName: scene.icon)
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            
                            // Text content
                            VStack(spacing: 16) {
                                Text(scene.title)
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                
                                Text(scene.subtitle)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                            }
                            .padding(.horizontal, 40)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 300)
                
                // Page indicators
                HStack(spacing: 8) {
                    ForEach(0..<scenes.count, id: \.self) { index in
                        Circle()
                            .fill(currentScene == index ? .white : .white.opacity(0.4))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentScene == index ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentScene)
                    }
                }
                .padding(.vertical, 32)
                
                Spacer()
                
                // Continue button
                Button(action: {
                    EmberHapticsManager.shared.playMedium()
                    onNext()
                }) {
                    Text("Experience the Magic")
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
            }
        }
        .onAppear {
            startHeartAnimation()
            
            // Auto-advance scenes
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentScene = (currentScene + 1) % scenes.count
                }
            }
        }
    }
    
    private func startHeartAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            createFloatingHeart()
        }
    }
    
    private func createFloatingHeart() {
        let heart = HeartBeat(
            position: CGPoint(
                x: CGFloat.random(in: 50...350),
                y: 800
            ),
            size: CGFloat.random(in: 12...24),
            opacity: Double.random(in: 0.3...0.7),
            scale: 1.0
        )
        
        heartBeats.append(heart)
        
        withAnimation(.easeOut(duration: 4.0)) {
            if let index = heartBeats.firstIndex(where: { $0.id == heart.id }) {
                heartBeats[index].position.y = -50
                heartBeats[index].opacity = 0
                heartBeats[index].scale = 0.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            heartBeats.removeAll { $0.id == heart.id }
        }
    }
}

struct LoveScene {
    let title: String
    let subtitle: String
    let icon: String
}

struct HeartBeat: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
}

#Preview {
    OnboardingLoveStoryView {
        print("Next")
    }
}