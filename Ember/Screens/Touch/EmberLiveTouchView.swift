import SwiftUI

struct EmberLiveTouchView: View {
    let connectionStatus: ConnectionStatus
    @Environment(\.dismiss) private var dismiss
    @State private var touchPoints: [TouchPoint] = []
    @State private var selectedPattern: LiveTouchPattern = .gentle
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [EmberColors.backgroundPrimary, EmberColors.backgroundSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Done") {
                        dismiss()
                    }
                    .emberLabel(color: EmberColors.roseQuartz)
                    
                    Spacer()
                    
                    Text("Live Touch")
                        .emberHeadline()
                    
                    Spacer()
                    
                    Circle()
                        .fill(connectionStatus.color)
                        .frame(width: 12, height: 12)
                }
                .padding()
                
                // Touch Canvas
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(EmberColors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(EmberColors.roseQuartz.opacity(0.3), lineWidth: 2)
                        )
                    
                    // Touch points
                    ForEach(touchPoints) { point in
                        Circle()
                            .fill(selectedPattern.color.opacity(0.6))
                            .frame(width: selectedPattern.size, height: selectedPattern.size)
                            .position(point.location)
                            .scaleEffect(point.scale)
                            .opacity(point.opacity)
                    }
                    
                    if touchPoints.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "hand.tap.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(EmberColors.textSecondary)
                            
                            Text("Touch anywhere to connect")
                                .emberBody(color: EmberColors.textSecondary)
                            
                            Text("Current: \(selectedPattern.name)")
                                .emberCaption(color: selectedPattern.color)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            addTouchPoint(at: value.location)
                        }
                )
                .padding()
                
                // Pattern Selector
                VStack(spacing: 12) {
                    Text("Touch Patterns")
                        .emberLabel()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(LiveTouchPattern.allCases, id: \.self) { pattern in
                                Button(action: {
                                    selectedPattern = pattern
                                    pattern.performHaptic()
                                }) {
                                    VStack(spacing: 8) {
                                        Circle()
                                            .fill(selectedPattern == pattern ? pattern.color : pattern.color.opacity(0.2))
                                            .frame(width: 50, height: 50)
                                            .overlay(
                                                Image(systemName: pattern.icon)
                                                    .font(.system(size: 20))
                                                    .foregroundStyle(selectedPattern == pattern ? .white : pattern.color)
                                            )
                                        
                                        Text(pattern.name)
                                            .emberCaption(color: selectedPattern == pattern ? pattern.color : EmberColors.textSecondary)
                                        
                                        // Intensity indicator
                                        HStack(spacing: 2) {
                                            ForEach(0..<5) { index in
                                                Circle()
                                                    .fill(index < pattern.intensity ? pattern.color : pattern.color.opacity(0.2))
                                                    .frame(width: 4, height: 4)
                                            }
                                        }
                                    }
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
                .background(EmberColors.surface.opacity(0.8))
            }
        }
    }
    
    private func addTouchPoint(at location: CGPoint) {
        let newPoint = TouchPoint(location: location)
        touchPoints.append(newPoint)
        
        // Play haptic based on selected pattern
        selectedPattern.performHaptic()
        
        // Animate and remove point
        withAnimation(.easeOut(duration: selectedPattern.duration)) {
            if let index = touchPoints.firstIndex(where: { $0.id == newPoint.id }) {
                touchPoints[index].scale = selectedPattern.scale
                touchPoints[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + selectedPattern.duration) {
            touchPoints.removeAll { $0.id == newPoint.id }
        }
    }
}

struct TouchPoint: Identifiable {
    let id = UUID()
    let location: CGPoint
    var scale: CGFloat = 0.5
    var opacity: Double = 1.0
}

// MARK: - Live Touch Patterns
enum LiveTouchPattern: CaseIterable {
    case gentle, medium, strong, intense, passionate
    
    var name: String {
        switch self {
        case .gentle: return "Gentle"
        case .medium: return "Medium"
        case .strong: return "Strong"
        case .intense: return "Intense"
        case .passionate: return "Passionate"
        }
    }
    
    var icon: String {
        switch self {
        case .gentle: return "hand.tap"
        case .medium: return "hand.tap.fill"
        case .strong: return "heart"
        case .intense: return "heart.fill"
        case .passionate: return "bolt.heart.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .gentle: return EmberColors.roseQuartz.opacity(0.6)
        case .medium: return EmberColors.roseQuartz
        case .strong: return EmberColors.peachyKeen
        case .intense: return EmberColors.coralPop
        case .passionate: return .red
        }
    }
    
    var size: CGFloat {
        switch self {
        case .gentle: return 40
        case .medium: return 50
        case .strong: return 60
        case .intense: return 70
        case .passionate: return 80
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .gentle: return 1.2
        case .medium: return 1.4
        case .strong: return 1.6
        case .intense: return 1.8
        case .passionate: return 2.0
        }
    }
    
    var duration: Double {
        switch self {
        case .gentle: return 0.6
        case .medium: return 0.8
        case .strong: return 1.0
        case .intense: return 1.2
        case .passionate: return 1.5
        }
    }
    
    var intensity: Int {
        switch self {
        case .gentle: return 1
        case .medium: return 2
        case .strong: return 3
        case .intense: return 4
        case .passionate: return 5
        }
    }
    
    func performHaptic() {
        switch self {
        case .gentle:
            EmberHapticsManager.shared.playLight()
        case .medium:
            EmberHapticsManager.shared.playLight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                EmberHapticsManager.shared.playLight()
            }
        case .strong:
            EmberHapticsManager.shared.playMedium()
        case .intense:
            EmberHapticsManager.shared.playMedium()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                EmberHapticsManager.shared.playMedium()
            }
        case .passionate:
            EmberHapticsManager.shared.playHeavy()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                EmberHapticsManager.shared.playMedium()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                EmberHapticsManager.shared.playHeavy()
            }
        }
    }
}

#Preview {
    EmberLiveTouchView(connectionStatus: .connected)
}