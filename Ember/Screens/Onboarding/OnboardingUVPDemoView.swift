import SwiftUI
import Combine

// MARK: - UVP Demo Screen
struct OnboardingUVPDemoView: View {
    @State private var isDrawing = false
    @State private var touchPath: [CGPoint] = []
    @State private var showSuccess = false
    @State private var demoComplete = false
    @Environment(\.colorScheme) var colorScheme
    
    let onContinue: () -> Void
    
    var body: some View {
        ZStack {
            // Background
            backgroundView
            
            VStack(spacing: 32) {
                // Headline
                headlineSection
                
                // Touch Canvas Demo
                touchCanvasSection
                
                // Instructions
                instructionsSection
                
                Spacer()
                
                // CTA
                ctaSection
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
            // Success overlay
            if showSuccess {
                successOverlay
            }
        }
        .onAppear {
            EmberHapticsManager.shared.playLight()
        }
    }
    
    // MARK: - Background
    private var backgroundView: some View {
        LinearGradient(
            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Headline Section
    private var headlineSection: some View {
        VStack(spacing: 12) {
            Text("Try your first touch")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            
            Text("Draw on the canvas below")
                .font(.system(size: 17, weight: .regular))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
    }
    
    // MARK: - Touch Canvas Section
    private var touchCanvasSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Canvas background
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.2))
                    .frame(height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.3), lineWidth: 2)
                    )
                
                // Touch trail
                Canvas { context, size in
                    if touchPath.count > 1 {
                        var path = Path()
                        path.move(to: touchPath[0])
                        for point in touchPath.dropFirst() {
                            path.addLine(to: point)
                        }
                        
                        context.stroke(
                            path,
                            with: .linearGradient(
                                Gradient(colors: [.white, .white.opacity(0.6)]),
                                startPoint: CGPoint(x: 0, y: 0),
                                endPoint: CGPoint(x: size.width, y: size.height)
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round)
                        )
                    }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isDrawing {
                                isDrawing = true
                                touchPath = [value.location]
                                EmberHapticsManager.shared.playLight()
                            } else {
                                touchPath.append(value.location)
                                // Continuous light haptic while drawing
                                if touchPath.count % 5 == 0 {
                                    EmberHapticsManager.shared.playLight()
                                }
                            }
                        }
                        .onEnded { _ in
                            isDrawing = false
                            if touchPath.count > 10 {
                                triggerSuccess()
                            }
                        }
                )
                
                // Placeholder text when empty
                if touchPath.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "hand.draw")
                            .font(.system(size: 40))
                            .foregroundStyle(.white.opacity(0.6))
                        
                        Text("Draw here to feel haptic feedback")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
            }
            
            // Clear button
            if !touchPath.isEmpty {
                Button("Clear") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        touchPath = []
                        showSuccess = false
                        demoComplete = false
                    }
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
            }
        }
    }
    
    // MARK: - Instructions Section
    private var instructionsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(EmberColors.coralPop)
                
                Text("Feel the vibration as you draw")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            
            HStack(spacing: 12) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(EmberColors.coralPop)
                
                Text("This is how you'll send touches to your partner")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
    }
    
    // MARK: - CTA Section
    private var ctaSection: some View {
        Button(action: {
            EmberHapticsManager.shared.playMedium()
            onContinue()
        }) {
            Text(demoComplete ? "Continue" : "Skip Demo")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(height: 56)
                .frame(maxWidth: .infinity)
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
    }
    
    // MARK: - Success Overlay
    private var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)
                    .scaleEffect(showSuccess ? 1.0 : 0.5)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showSuccess)
                
                Text("Great! You felt the magic ✨")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .scaleEffect(showSuccess ? 1.0 : 0.8)
            .opacity(showSuccess ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showSuccess)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showSuccess = false
            }
        }
    }
    
    // MARK: - Success Trigger
    private func triggerSuccess() {
        EmberHapticsManager.shared.playSuccess()
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            showSuccess = true
            demoComplete = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showSuccess = false
            }
        }
    }
}

#Preview {
    OnboardingUVPDemoView {
        print("Continue tapped")
    }
}
