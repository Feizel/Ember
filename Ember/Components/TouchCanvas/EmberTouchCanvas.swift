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
                        // Quick gestures
                        Button(action: { showingGestureLibrary = true }) {
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
                        
                        // Send button
                        Button(action: {
                            EmberHapticsManager.shared.playSuccess()
                            dismiss()
                        }) {
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

// MARK: - Ember Drawing Canvas
struct EmberDrawingCanvas: View {
    @Binding var isActive: Bool
    @State private var paths: [Path] = []
    @State private var currentPath = Path()
    
    var body: some View {
        ZStack {
            // Drawing surface
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isActive {
                                isActive = true
                                currentPath = Path()
                                currentPath.move(to: value.location)
                            } else {
                                currentPath.addLine(to: value.location)
                            }
                        }
                        .onEnded { _ in
                            paths.append(currentPath)
                            currentPath = Path()
                        }
                )
            
            // Render all paths
            ForEach(Array(paths.enumerated()), id: \.offset) { index, path in
                path
                    .stroke(
                        LinearGradient(
                            colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                    )
            }
            
            // Render current path
            currentPath
                .stroke(
                    LinearGradient(
                        colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                )
        }
    }
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
                            Button(action: {
                                EmberHapticsManager.shared.playSuccess()
                                dismiss()
                            }) {
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
                            .buttonStyle(.plain)
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