import SwiftUI
import CoreHaptics

// MARK: - Haptic-Visual Sync System
struct HapticVisualSync {
    static func trigger(_ type: HapticVisualType, at location: CGPoint = .zero) {
        EmberHapticsManager.shared.playGesture(type.hapticGesture)
        NotificationCenter.default.post(
            name: .hapticVisualTriggered,
            object: HapticVisualEvent(type: type, location: location)
        )
    }
}

enum HapticVisualType {
    case touch, press, release, swipe, pinch, selection
    
    var hapticGesture: HapticGesture {
        switch self {
        case .touch: return .sparkle
        case .press: return .pulse
        case .release: return .kiss
        case .swipe: return .wave
        case .pinch: return .hug
        case .selection: return .loveTap
        }
    }
}

struct HapticVisualEvent {
    let type: HapticVisualType
    let location: CGPoint
    let timestamp = Date()
}

// MARK: - Elastic Animation Library
struct ElasticAnimations {
    static let spring = Animation.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.2)
    static let bounce = Animation.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.1)
    static let magnetic = Animation.spring(response: 0.2, dampingFraction: 0.8, blendDuration: 0.15)
    static let breathing = Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)
}

// MARK: - Magnetic Button
struct MagneticButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    @State private var dragOffset = CGSize.zero
    @State private var isNearby = false
    @State private var scale: CGFloat = 1.0
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        content
            .scaleEffect(scale)
            .offset(dragOffset)
            .gesture(
                DragGesture(coordinateSpace: .local)
                    .onChanged { value in
                        let distance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                        
                        if distance < 50 && !isNearby {
                            withAnimation(ElasticAnimations.magnetic) {
                                isNearby = true
                                scale = 1.1
                                dragOffset = CGSize(
                                    width: value.translation.width * 0.3,
                                    height: value.translation.height * 0.3
                                )
                            }
                            EmberHapticsManager.shared.playLight()
                        } else if distance >= 50 && isNearby {
                            withAnimation(ElasticAnimations.spring) {
                                isNearby = false
                                scale = 1.0
                                dragOffset = .zero
                            }
                        }
                    }
                    .onEnded { _ in
                        withAnimation(ElasticAnimations.bounce) {
                            dragOffset = .zero
                            scale = 1.0
                            isNearby = false
                        }
                        
                        if isNearby {
                            action()
                            EmberHapticsManager.shared.playMedium()
                        }
                    }
            )
    }
}

// MARK: - Breathing Component
struct BreathingView<Content: View>: View {
    let content: Content
    let intensity: CGFloat
    
    @State private var breathingScale: CGFloat = 1.0
    
    init(intensity: CGFloat = 0.05, @ViewBuilder content: () -> Content) {
        self.intensity = intensity
        self.content = content()
    }
    
    var body: some View {
        content
            .scaleEffect(breathingScale)
            .onAppear {
                withAnimation(ElasticAnimations.breathing) {
                    breathingScale = 1.0 + intensity
                }
            }
    }
}

// MARK: - Morphing Elements
struct MorphingShape: View {
    let fromShape: EmberAnyShape
    let toShape: EmberAnyShape
    let progress: CGFloat
    
    var body: some View {
        ZStack {
            fromShape
                .opacity(1 - progress)
            toShape
                .opacity(progress)
        }
    }
}

extension Shape {
    func asAnyShape() -> EmberAnyShape {
        EmberAnyShape(self)
    }
}

struct EmberAnyShape: Shape {
    private let _path: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - Gesture Trail System
struct GestureTrail: View {
    let points: [CGPoint]
    let color: Color
    let width: CGFloat
    
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        Canvas { context, size in
            guard points.count > 1 else { return }
            
            var path = Path()
            path.move(to: points[0])
            
            for i in 1..<points.count {
                let progress = CGFloat(i) / CGFloat(points.count - 1)
                if progress <= animationProgress {
                    path.addLine(to: points[i])
                }
            }
            
            context.stroke(
                path,
                with: .color(color),
                style: StrokeStyle(lineWidth: width, lineCap: .round, lineJoin: .round)
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                animationProgress = 1.0
            }
        }
    }
}

// MARK: - Pressure Sensitivity Simulator
struct PressureSensitiveView<Content: View>: View {
    let content: Content
    let onPressureChange: (CGFloat) -> Void
    
    @State private var pressure: CGFloat = 0
    @State private var longPressTimer: Timer?
    
    init(onPressureChange: @escaping (CGFloat) -> Void, @ViewBuilder content: () -> Content) {
        self.onPressureChange = onPressureChange
        self.content = content()
    }
    
    var body: some View {
        content
            .scaleEffect(1.0 - pressure * 0.1)
            .onLongPressGesture(
                minimumDuration: 0,
                maximumDistance: .infinity,
                pressing: { pressing in
                    if pressing {
                        startPressureSimulation()
                    } else {
                        stopPressureSimulation()
                    }
                },
                perform: {}
            )
    }
    
    private func startPressureSimulation() {
        longPressTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.05)) {
                pressure = min(pressure + 0.1, 1.0)
            }
            onPressureChange(pressure)
        }
    }
    
    private func stopPressureSimulation() {
        longPressTimer?.invalidate()
        longPressTimer = nil
        
        withAnimation(.easeOut(duration: 0.2)) {
            pressure = 0
        }
        onPressureChange(0)
    }
}

// MARK: - Notification Extensions
extension Notification.Name {
    static let hapticVisualTriggered = Notification.Name("hapticVisualTriggered")
}
