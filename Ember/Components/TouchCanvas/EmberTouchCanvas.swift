import SwiftUI

// MARK: - Ember Touch Canvas View
struct EmberTouchCanvasView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDrawing = false
    @State private var showingGestureLibrary = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium dark background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.black.opacity(0.95),
                        EmberColors.backgroundSecondary.opacity(0.1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with characters watching
                    HStack {
                        EmberCharacterView(
                            character: .touchy,
                            size: 50,
                            expression: .happy,
                            isAnimating: isDrawing
                        )
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Touch Canvas")
                                .emberHeadline(color: .white)
                            
                            Text("Draw your touch")
                                .emberCaption(color: .white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        EmberCharacterView(
                            character: .syncee,
                            size: 50,
                            expression: .happy,
                            isAnimating: isDrawing
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Main drawing canvas
                    ZStack {
                        // Canvas background
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        // Drawing area
                        EmberDrawingCanvas(isActive: $isDrawing)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                        // Placeholder when not drawing
                        if !isDrawing {
                            VStack(spacing: 16) {
                                Image(systemName: "hand.draw")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white.opacity(0.3))
                                
                                Text("Touch and draw to send")
                                    .emberTitleLarge(color: .white.opacity(0.6))
                                
                                Text("Your partner will feel every stroke")
                                    .emberBody(color: .white.opacity(0.4))
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 32)
                    
                    // Bottom controls
                    VStack(spacing: 20) {
                        // Quick gestures with magnetic interaction
                        MagneticButton(action: { showingGestureLibrary = true }) {
                            HStack(spacing: 12) {
                                Image(systemName: "hand.tap.fill")
                                    .emberIconLarge()
                                    .foregroundStyle(.white)
                                
                                Text("Quick Gestures")
                                    .emberHeadline(color: .white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.up")
                                    .emberIconMedium()
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .emberCardPadding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Send button with breathing animation
                        BreathingView(intensity: 0.03) {
                            InteractiveButton(
                                hapticType: .press,
                                style: .intense,
                                action: {
                                    EmberHapticsManager.shared.playSuccess()
                                    dismiss()
                                }
                            ) {
                                HStack(spacing: 12) {
                                    Image(systemName: "paperplane.fill")
                                        .emberIconLarge()
                                    
                                    Text("Send Touch")
                                        .emberHeadline()
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .emberCardPadding()
                                .background(
                                    EmberColors.primaryGradient,
                                    in: RoundedRectangle(cornerRadius: 16)
                                )
                                .emberPrimaryShadow()
                            }
                        }
                        .padding(.horizontal, 24)
                        .disabled(!isDrawing)
                        .opacity(isDrawing ? 1.0 : 0.6)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Clear canvas
                    }) {
                        Image(systemName: "trash")
                            .foregroundStyle(.white.opacity(0.7))
                    }
                }
            }
        }
        .sheet(isPresented: $showingGestureLibrary) {
            EmberGestureLibrarySheet()
        }
    }
}

// MARK: - Enhanced Drawing Canvas with Micro-interactions
struct EmberDrawingCanvas: View {
    @Binding var isActive: Bool
    @State private var paths: [DrawingPath] = []
    @State private var currentPath = Path()
    @State private var currentPoints: [CGPoint] = []
    @State private var touchParticles: [CanvasTouchParticle] = []
    @State private var pressure: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            // Touch particles
            ForEach(touchParticles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
                    .scaleEffect(particle.scale)
            }
            
            // Drawing surface with gesture recognition
            GestureRecognitionView { gesture in
                EmberHapticsManager.shared.playGesture(gesture.hapticPattern)
            } content: {
                PressureSensitiveView { newPressure in
                    pressure = newPressure
                } content: {
                    Rectangle()
                        .fill(Color.clear)
                        .contentShape(Rectangle())
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        handleTouchChanged(at: value.location)
                    }
                    .onEnded { _ in
                        handleTouchEnded()
                    }
            )
            
            // Render all paths with trails
            ForEach(paths) { drawingPath in
                GestureTrail(
                    points: drawingPath.points,
                    color: drawingPath.color,
                    width: drawingPath.width
                )
            }
            
            // Render current path
            if !currentPoints.isEmpty {
                GestureTrail(
                    points: currentPoints,
                    color: EmberColors.roseQuartz,
                    width: 4 + pressure * 6
                )
            }
        }
    }
    
    private func handleTouchChanged(at location: CGPoint) {
        if !isActive {
            isActive = true
            currentPoints = [location]
            EmberHapticsManager.shared.playLight()
        } else {
            currentPoints.append(location)
        }
        
        // Create touch particles
        createTouchParticles(at: location)
        
        // Trigger haptic feedback based on drawing speed
        HapticVisualSync.trigger(.touch, at: location)
    }
    
    private func handleTouchEnded() {
        guard !currentPoints.isEmpty else { return }
        
        let drawingPath = DrawingPath(
            points: currentPoints,
            color: EmberColors.roseQuartz,
            width: 4 + pressure * 6
        )
        paths.append(drawingPath)
        currentPoints.removeAll()
        
        EmberHapticsManager.shared.playMedium()
    }
    
    private func createTouchParticles(at location: CGPoint) {
        let colors = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop]
        
        for _ in 0..<3 {
            let particle = CanvasTouchParticle(
                position: CGPoint(
                    x: location.x + CGFloat.random(in: -10...10),
                    y: location.y + CGFloat.random(in: -10...10)
                ),
                size: CGFloat.random(in: 4...8),
                color: colors.randomElement() ?? EmberColors.roseQuartz,
                opacity: 0.8,
                scale: 1.0
            )
            touchParticles.append(particle)
            
            // Animate particle
            withAnimation(.easeOut(duration: 0.5)) {
                if let index = touchParticles.firstIndex(where: { $0.id == particle.id }) {
                    touchParticles[index].opacity = 0
                    touchParticles[index].scale = 0.3
                    touchParticles[index].position.y -= 20
                }
            }
        }
        
        // Clean up particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            touchParticles.removeAll { particle in
                particle.opacity <= 0.1
            }
        }
    }
}

struct DrawingPath: Identifiable {
    let id = UUID()
    let points: [CGPoint]
    let color: Color
    let width: CGFloat
}

struct CanvasTouchParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var opacity: Double
    var scale: CGFloat
}

// MARK: - Ember Gesture Library Sheet
struct EmberGestureLibrarySheet: View {
    @Environment(\.dismiss) var dismiss
    
    let gestures = [
        ("heart.fill", "Kiss", "Send a loving kiss", EmberColors.roseQuartz),
        ("hands.sparkles.fill", "Hug", "Warm embrace", EmberColors.peachyKeen),
        ("hand.wave.fill", "Wave", "Gentle hello", EmberColors.coralPop),
        ("bolt.heart.fill", "Love Pulse", "Heartbeat rhythm", EmberColors.roseQuartzDark),
        ("star.fill", "Sparkle", "Magical touch", EmberColors.coralPopDark),
        ("moon.fill", "Goodnight", "Sweet dreams", EmberColors.peachyKeenDark)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                EmberColors.backgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(Array(gestures.enumerated()), id: \.offset) { index, gesture in
                            InteractiveButton(
                                hapticType: .press,
                                style: .gentle,
                                action: {
                                    EmberHapticsManager.shared.playSuccess()
                                    dismiss()
                                }
                            ) {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(gesture.3.opacity(0.2))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: gesture.0)
                                            .emberIconXL()
                                            .foregroundStyle(gesture.3)
                                    }
                                    
                                    VStack(spacing: 4) {
                                        Text(gesture.1)
                                            .emberHeadlineSmall()
                                        
                                        Text(gesture.2)
                                            .emberCaption(color: EmberColors.textSecondary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .emberCardPadding()
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .emberScreenPadding()
                }
            }
            .navigationTitle("Quick Gestures")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EmberTouchCanvasView()
}