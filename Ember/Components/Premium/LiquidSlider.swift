import SwiftUI

// MARK: - Liquid Slider
struct LiquidSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let onEditingChanged: (Bool) -> Void
    
    @State private var isDragging = false
    @State private var thumbPosition: CGFloat = 0
    
    init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.onEditingChanged = onEditingChanged
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track background
                Capsule()
                    .fill(.ultraThinMaterial)
                    .frame(height: 8)
                    .overlay(
                        Capsule()
                            .stroke(.white.opacity(0.2), lineWidth: 1)
                    )
                
                // Liquid fill
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * normalizedValue, height: 8)
                
                // Thumb
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                            center: .center,
                            startRadius: 0,
                            endRadius: 15
                        )
                    )
                    .frame(width: 30, height: 30)
                    .shadow(color: EmberColors.roseQuartz.opacity(0.3), radius: 8, x: 0, y: 4)
                    .scaleEffect(isDragging ? 1.2 : 1.0)
                    .position(x: thumbPosition, y: geometry.size.height / 2)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isDragging)
            }
            .onAppear {
                updateThumbPosition(geometry: geometry)
            }
            .onChange(of: value) {
                updateThumbPosition(geometry: geometry)
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if !isDragging {
                            isDragging = true
                            onEditingChanged(true)
                            EmberHapticsManager.shared.playLight()
                        }
                        
                        let newPosition = max(15, min(geometry.size.width - 15, gesture.location.x))
                        thumbPosition = newPosition
                        
                        let newValue = range.lowerBound + (range.upperBound - range.lowerBound) * Double((newPosition - 15) / (geometry.size.width - 30))
                        
                        if let step = step {
                            value = round(newValue / step) * step
                        } else {
                            value = newValue
                        }
                    }
                    .onEnded { _ in
                        isDragging = false
                        onEditingChanged(false)
                        EmberHapticsManager.shared.playMedium()
                    }
            )
        }
        .frame(height: 30)
    }
    
    private var normalizedValue: Double {
        (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }
    
    private func updateThumbPosition(geometry: GeometryProxy) {
        thumbPosition = 15 + (geometry.size.width - 30) * normalizedValue
    }
}

// MARK: - Floating Element
struct FloatingElement<Content: View>: View {
    let content: Content
    let amplitude: CGFloat
    let frequency: Double
    
    @State private var offset: CGFloat = 0
    
    init(
        amplitude: CGFloat = 10,
        frequency: Double = 2.0,
        @ViewBuilder content: () -> Content
    ) {
        self.amplitude = amplitude
        self.frequency = frequency
        self.content = content()
    }
    
    var body: some View {
        content
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: frequency).repeatForever(autoreverses: true)) {
                    offset = amplitude
                }
            }
    }
}

// MARK: - Context-Aware Animation
struct ContextAwareAnimation: ViewModifier {
    let context: AnimationContext
    @State private var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : context.initialScale)
            .offset(y: isVisible ? 0 : context.initialOffset)
            .animation(context.animation, value: isVisible)
            .onAppear {
                withAnimation {
                    isVisible = true
                }
            }
    }
}

struct AnimationContext {
    let animation: Animation
    let initialScale: CGFloat
    let initialOffset: CGFloat
    
    static let slideUp = AnimationContext(
        animation: .spring(response: 0.6, dampingFraction: 0.8),
        initialScale: 1.0,
        initialOffset: 20
    )
    
    static let scaleIn = AnimationContext(
        animation: .spring(response: 0.5, dampingFraction: 0.7),
        initialScale: 0.8,
        initialOffset: 0
    )
    
    static let fadeIn = AnimationContext(
        animation: .easeOut(duration: 0.4),
        initialScale: 1.0,
        initialOffset: 0
    )
}

extension View {
    func contextAwareAnimation(_ context: AnimationContext) -> some View {
        modifier(ContextAwareAnimation(context: context))
    }
}