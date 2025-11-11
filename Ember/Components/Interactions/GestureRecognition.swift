import SwiftUI

// MARK: - Gesture Recognition System
struct GestureRecognitionView<Content: View>: View {
    let content: Content
    let onGestureRecognized: (RecognizedGesture) -> Void
    
    @State private var touchPoints: [CGPoint] = []
    @State private var gestureTimer: Timer?
    
    init(
        onGestureRecognized: @escaping (RecognizedGesture) -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onGestureRecognized = onGestureRecognized
        self.content = content()
    }
    
    var body: some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        touchPoints.append(value.location)
                        
                        gestureTimer?.invalidate()
                        gestureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                            analyzeGesture()
                        }
                    }
                    .onEnded { _ in
                        gestureTimer?.invalidate()
                        analyzeGesture()
                    }
            )
    }
    
    private func analyzeGesture() {
        guard touchPoints.count > 5 else {
            touchPoints.removeAll()
            return
        }
        
        let gesture = classifyGesture(points: touchPoints)
        onGestureRecognized(gesture)
        touchPoints.removeAll()
    }
    
    private func classifyGesture(points: [CGPoint]) -> RecognizedGesture {
        let totalDistance = calculateTotalDistance(points: points)
        let boundingBox = calculateBoundingBox(points: points)
        let aspectRatio = boundingBox.width / boundingBox.height
        
        if totalDistance < 50 {
            return .tap
        } else if aspectRatio > 2.0 {
            return .swipe
        } else if isCircular(points: points) {
            return .circle
        } else {
            return .unknown
        }
    }
    
    private func calculateTotalDistance(points: [CGPoint]) -> CGFloat {
        guard points.count > 1 else { return 0 }
        
        var distance: CGFloat = 0
        for i in 1..<points.count {
            let dx = points[i].x - points[i-1].x
            let dy = points[i].y - points[i-1].y
            distance += sqrt(dx*dx + dy*dy)
        }
        return distance
    }
    
    private func calculateBoundingBox(points: [CGPoint]) -> CGRect {
        guard !points.isEmpty else { return .zero }
        
        let minX = points.map(\.x).min() ?? 0
        let maxX = points.map(\.x).max() ?? 0
        let minY = points.map(\.y).min() ?? 0
        let maxY = points.map(\.y).max() ?? 0
        
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    private func isCircular(points: [CGPoint]) -> Bool {
        let boundingBox = calculateBoundingBox(points: points)
        let aspectRatio = boundingBox.width / boundingBox.height
        return aspectRatio > 0.7 && aspectRatio < 1.3
    }
}

enum RecognizedGesture {
    case tap, swipe, circle, heart, unknown
    
    var hapticPattern: HapticGesture {
        switch self {
        case .tap: return .sparkle
        case .swipe: return .wave
        case .circle: return .hug
        case .heart: return .kiss
        case .unknown: return .pulse
        }
    }
}