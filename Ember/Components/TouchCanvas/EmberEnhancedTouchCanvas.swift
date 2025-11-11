import SwiftUI

struct EmberEnhancedTouchCanvas: View {
    @Environment(\.dismiss) var dismiss
    @State private var isDrawing = false
    @State private var showingGestureLibrary = false
    @State private var drawingPaths: [TouchPath] = []
    @State private var currentPath = TouchPath()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                EmberColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                        .padding(.top, 20)
                    
                    canvasView
                        .padding(.horizontal, 24)
                        .padding(.vertical, 32)
                    
                    bottomControls
                        .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(EmberColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearCanvas) {
                        Image(systemName: "trash")
                            .foregroundStyle(EmberColors.textSecondary)
                    }
                }
            }
        }
        .sheet(isPresented: $showingGestureLibrary) {
            gestureLibrarySheet
        }
    }
    
    private var headerView: some View {
        HStack {
            EmberCharacterView(
                character: .touchy,
                size: 50,
                expression: .happy,
                isAnimating: isDrawing
            )
            .shadow(color: EmberColors.roseQuartz.opacity(0.3), radius: 8, x: 0, y: 4)
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Touch Canvas")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Text("Draw your touch")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            
            Spacer()
            
            EmberCharacterView(
                character: .syncee,
                size: 50,
                expression: .happy,
                isAnimating: isDrawing
            )
            .shadow(color: EmberColors.peachyKeen.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 24)
    }
    
    private var canvasView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(EmberColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(EmberColors.border, lineWidth: 1)
                )
                .shadow(
                    color: colorScheme == .dark ? 
                        EmberColors.roseQuartz.opacity(0.1) : 
                        Color.black.opacity(0.05),
                    radius: 10,
                    x: 0,
                    y: 5
                )
            
            drawingArea
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
            if !isDrawing && drawingPaths.isEmpty {
                placeholderView
            }
        }
    }
    
    private var drawingArea: some View {
        Canvas { context, size in
            for path in drawingPaths {
                var contextPath = Path()
                contextPath.addPath(path.path)
                
                context.stroke(
                    contextPath,
                    with: .color(path.color),
                    style: StrokeStyle(
                        lineWidth: path.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
            
            if !currentPath.path.isEmpty {
                var contextPath = Path()
                contextPath.addPath(currentPath.path)
                
                context.stroke(
                    contextPath,
                    with: .color(currentPath.color),
                    style: StrokeStyle(
                        lineWidth: currentPath.lineWidth,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if !isDrawing {
                        isDrawing = true
                        currentPath = TouchPath()
                        currentPath.path.move(to: value.location)
                    } else {
                        currentPath.path.addLine(to: value.location)
                    }
                    
                    EmberHapticsManager.shared.playRealtimeTouch(
                        intensity: 0.3,
                        sharpness: 0.5
                    )
                }
                .onEnded { _ in
                    if !currentPath.path.isEmpty {
                        drawingPaths.append(currentPath)
                        currentPath = TouchPath()
                    }
                }
        )
    }
    
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "hand.draw")
                .font(.system(size: 60))
                .foregroundStyle(EmberColors.textSecondary.opacity(0.3))
            
            Text("Touch and draw to send")
                .font(.title3.weight(.medium))
                .foregroundStyle(EmberColors.textSecondary)
            
            Text("Your partner will feel every stroke")
                .font(.subheadline)
                .foregroundStyle(EmberColors.textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var bottomControls: some View {
        VStack(spacing: 20) {
            Button(action: { showingGestureLibrary = true }) {
                HStack(spacing: 12) {
                    Image(systemName: "hand.tap.fill")
                        .font(.title3)
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    Text("Quick Gestures")
                        .font(.headline.weight(.medium))
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(EmberColors.textSecondary)
                }
                .padding(20)
                .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(EmberColors.border, lineWidth: 1)
                )
            }
            .padding(.horizontal, 24)
            
            Button(action: sendTouch) {
                HStack(spacing: 12) {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                    
                    Text("Send Touch")
                        .font(.headline.weight(.semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(
                    EmberColors.primaryGradient,
                    in: RoundedRectangle(cornerRadius: 16)
                )
                .shadow(
                    color: EmberColors.roseQuartz.opacity(0.4),
                    radius: 10,
                    x: 0,
                    y: 5
                )
            }
            .padding(.horizontal, 24)
            .disabled(!isDrawing && drawingPaths.isEmpty)
            .opacity((isDrawing || !drawingPaths.isEmpty) ? 1.0 : 0.6)
        }
    }
    
    private var gestureLibrarySheet: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(HapticGesture.allGestures, id: \.name) { gesture in
                        Button(action: {
                            EmberHapticsManager.shared.playGesture(gesture)
                            showingGestureLibrary = false
                            dismiss()
                        }) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(EmberColors.roseQuartz.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: gesture.icon)
                                        .font(.title2)
                                        .foregroundStyle(EmberColors.roseQuartz)
                                }
                                
                                VStack(spacing: 4) {
                                    Text(gesture.name)
                                        .font(.headline.weight(.semibold))
                                        .foregroundStyle(EmberColors.textPrimary)
                                    
                                    Text("Haptic gesture")
                                        .font(.caption)
                                        .foregroundStyle(EmberColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(EmberColors.border, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(EmberColors.background)
            .navigationTitle("Quick Gestures")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingGestureLibrary = false
                    }
                }
            }
        }
    }
    
    private func clearCanvas() {
        withAnimation(.easeInOut(duration: 0.3)) {
            drawingPaths.removeAll()
            currentPath = TouchPath()
            isDrawing = false
        }
        EmberHapticsManager.shared.playLight()
    }
    
    private func sendTouch() {
        EmberHapticsManager.shared.playSuccess()
        dismiss()
    }
}

struct TouchPath {
    var path = Path()
    var color = EmberColors.roseQuartz
    var lineWidth: CGFloat = 4.0
}

#Preview {
    EmberEnhancedTouchCanvas()
}