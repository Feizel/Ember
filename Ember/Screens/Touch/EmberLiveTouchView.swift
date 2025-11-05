import SwiftUI

struct EmberLiveTouchView: View {
    let connectionStatus: ConnectionStatus
    @Environment(\.dismiss) private var dismiss
    @State private var touchPoints: [TouchPoint] = []
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [EmberColors.backgroundPrimary, EmberColors.backgroundSecondary],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
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
                            .fill(EmberColors.roseQuartz.opacity(0.6))
                            .frame(width: 60, height: 60)
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
            }
        }
    }
    
    private func addTouchPoint(at location: CGPoint) {
        let newPoint = TouchPoint(location: location)
        touchPoints.append(newPoint)
        
        EmberHapticsManager.shared.playLight()
        
        // Animate and remove point
        withAnimation(.easeOut(duration: 0.8)) {
            if let index = touchPoints.firstIndex(where: { $0.id == newPoint.id }) {
                touchPoints[index].scale = 1.5
                touchPoints[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
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

#Preview {
    EmberLiveTouchView(connectionStatus: .connected)
}