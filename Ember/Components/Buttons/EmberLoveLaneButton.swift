import SwiftUI

struct EmberLoveLaneButton: View {
    let title: String
    let onComplete: () -> Void
    
    @State private var isPressed = false
    @State private var progress: Double = 0
    @State private var vibrationIntensity: Float = 0.1
    @State private var vibrationTimer: Timer?
    
    private let holdDuration: Double = 3.0
    
    var body: some View {
        Button(action: {}) {
            ZStack {
                // Background
                Capsule()
                    .fill(.white.opacity(0.2))
                    .frame(height: 56)
                
                // Progress fill
                GeometryReader { geometry in
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 56)
                }
                .clipShape(Capsule())
                
                // Text
                Text(isPressed ? "Setting up your Love Lane..." : title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .scaleEffect(isPressed ? 0.95 : 1.0)
                
                // Progress indicator
                if isPressed {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 3)
                                .frame(width: 24, height: 24)
                            
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 24, height: 24)
                                .rotationEffect(.degrees(-90))
                        }
                        .padding(.trailing, 20)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                if pressing {
                    startHoldProgress()
                } else {
                    cancelHoldProgress()
                }
            },
            perform: {}
        )
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.4), lineWidth: 1)
        )
    }
    
    private func startHoldProgress() {
        isPressed = true
        progress = 0
        vibrationIntensity = 0.1
        
        // Start progressive vibration
        startProgressiveVibration()
        
        // Animate progress
        withAnimation(.linear(duration: holdDuration)) {
            progress = 1.0
        }
        
        // Complete after hold duration
        DispatchQueue.main.asyncAfter(deadline: .now() + holdDuration) {
            if isPressed {
                completeSetup()
            }
        }
    }
    
    private func cancelHoldProgress() {
        isPressed = false
        progress = 0
        vibrationTimer?.invalidate()
        vibrationTimer = nil
        
        withAnimation(.easeOut(duration: 0.3)) {
            progress = 0
        }
    }
    
    private func startProgressiveVibration() {
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // Increase vibration intensity based on progress
            vibrationIntensity = Float(0.1 + (progress * 0.9)) // From 0.1 to 1.0
            
            // Play haptic with current intensity
            EmberHapticsManager.shared.playRealtimeTouch(
                intensity: vibrationIntensity,
                sharpness: 0.5
            )
        }
    }
    
    private func completeSetup() {
        vibrationTimer?.invalidate()
        vibrationTimer = nil
        
        // Final strong vibration
        EmberHapticsManager.shared.playSuccess()
        
        // Complete with animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            isPressed = false
            progress = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onComplete()
        }
    }
}

#Preview {
    VStack {
        EmberLoveLaneButton(title: "Begin Our Love Story") {
            print("Love Lane setup complete!")
        }
        .padding()
    }
    .background(
        LinearGradient(
            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}