import SwiftUI
import RealityKit

struct Ember3DCharacterShowcase: View {
    let size: CGFloat
    let isAnimating: Bool
    let showControls: Bool
    
    @State private var rotationAngle: Double = 0
    @State private var isUserRotating = false
    @State private var lastRotation: Double = 0
    
    init(size: CGFloat = 300, isAnimating: Bool = true, showControls: Bool = true) {
        self.size = size
        self.isAnimating = isAnimating
        self.showControls = showControls
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Main 3D Character Display
            ZStack {
                // Premium background with glow
                RoundedRectangle(cornerRadius: size * 0.08)
                    .fill(
                        RadialGradient(
                            colors: [
                                EmberColors.roseQuartz.opacity(0.15),
                                EmberColors.peachyKeen.opacity(0.1),
                                .clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.8
                        )
                    )
                    .frame(width: size * 1.1, height: size * 1.1)
                
                // 3D Character
                Ember3DCharacterView(
                    size: size,
                    isAnimating: isAnimating && !isUserRotating
                )
                .rotation3DEffect(
                    .degrees(rotationAngle),
                    axis: (x: 0, y: 1, z: 0)
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isUserRotating = true
                            let rotation = Double(value.translation.width) * 0.5
                            rotationAngle = lastRotation + rotation
                        }
                        .onEnded { _ in
                            lastRotation = rotationAngle
                            withAnimation(.easeOut(duration: 1.0)) {
                                isUserRotating = false
                            }
                        }
                )
                
                // Interaction hint
                if showControls {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            VStack(spacing: 4) {
                                Image(systemName: "hand.draw")
                                    .font(.caption)
                                Text("Drag to rotate")
                                    .font(.caption2)
                            }
                            .foregroundStyle(EmberColors.textSecondary.opacity(0.6))
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding()
                }
            }
            
            if showControls {
                // Character Info
                VStack(spacing: 12) {
                    Text("Touchy & Syncee")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Your adorable love companions")
                        .font(.subheadline)
                        .foregroundStyle(EmberColors.textSecondary)
                    
                    // Character features
                    HStack(spacing: 16) {
                        featureTag("3D Animated", icon: "cube.fill")
                        featureTag("Interactive", icon: "hand.tap.fill")
                        featureTag("Expressive", icon: "heart.fill")
                    }
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            rotationAngle += 90
                            lastRotation = rotationAngle
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("Rotate")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(EmberColors.roseQuartz)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(EmberColors.roseQuartz.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            rotationAngle = 0
                            lastRotation = 0
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(EmberColors.peachyKeen)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(EmberColors.peachyKeen.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
    }
    
    private func featureTag(_ text: String, icon: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption.weight(.medium))
        }
        .foregroundStyle(EmberColors.textSecondary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    VStack(spacing: 40) {
        Ember3DCharacterShowcase(size: 250)
        
        HStack(spacing: 20) {
            Ember3DCharacterShowcase(size: 150, showControls: false)
            Ember3DCharacterShowcase(size: 150, isAnimating: false, showControls: false)
        }
    }
    .padding()
}
