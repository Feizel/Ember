import SwiftUI

struct TouchCanvasView: View {
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
                        Color(.systemGray6).opacity(0.1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with hearts watching
                    HStack {
                        CuteCharacter(
                            character: .touchy,
                            size: 50,
                            customization: CharacterCustomization(
                                colorTheme: .default,
                                accessory: .none,
                                expression: .happy,
                                        name: "My Heart"
                            ),
                            isAnimating: isDrawing
                        )
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Touch Canvas")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.white)
                            
                            Text("Draw your touch")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        CuteCharacter(
                            character: .syncee,
                            size: 50,
                            customization: CharacterCustomization(
                                colorTheme: .lavender,
                                accessory: .none,
                                expression: .happy,
                                        name: "My Heart"
                            ),
                            isAnimating: isDrawing
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    // Main drawing canvas
                    ZStack {
                        // Canvas background with subtle pattern
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                        
                        // Drawing area
                        DrawingCanvasView(isActive: $isDrawing)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                        
                        // Placeholder when not drawing
                        if !isDrawing {
                            VStack(spacing: 16) {
                                Image(systemName: "hand.draw")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white.opacity(0.3))
                                
                                Text("Touch and draw to send")
                                    .font(.title3.weight(.medium))
                                    .foregroundStyle(.white.opacity(0.6))
                                
                                Text("Your partner will feel every stroke")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.4))
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
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                
                                Text("Quick Gestures")
                                    .font(.headline.weight(.medium))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.up")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            .padding(20)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 24)
                        
                        // Send button
                        Button(action: {
                            // Send touch logic
                            HapticsManager.shared.playSuccess()
                            dismiss()
                        }) {
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
                                LinearGradient(
                                    colors: [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                            .shadow(color: .pink.opacity(0.4), radius: 10, x: 0, y: 5)
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
            PremiumGestureLibrarySheet()
        }
    }
}

struct PremiumGestureLibrarySheet: View {
    @Environment(\.dismiss) var dismiss
    
    let gestures = [
        ("heart.fill", "Kiss", "Send a loving kiss", Color.pink),
        ("hands.sparkles.fill", "Hug", "Warm embrace", Color.orange),
        ("hand.wave.fill", "Wave", "Gentle hello", Color.blue),
        ("bolt.heart.fill", "Love Pulse", "Heartbeat rhythm", Color.red),
        ("star.fill", "Sparkle", "Magical touch", Color.yellow),
        ("moon.fill", "Goodnight", "Sweet dreams", Color.indigo)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).ignoresSafeArea()
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                        ForEach(Array(gestures.enumerated()), id: \.offset) { index, gesture in
                            Button(action: {
                                HapticsManager.shared.playGesture(HapticGesture.allGestures[min(index, HapticGesture.allGestures.count - 1)])
                                dismiss()
                            }) {
                                VStack(spacing: 16) {
                                    ZStack {
                                        Circle()
                                            .fill(gesture.3.opacity(0.2))
                                            .frame(width: 60, height: 60)
                                        
                                        Image(systemName: gesture.0)
                                            .font(.title2)
                                            .foregroundStyle(gesture.3)
                                    }
                                    
                                    VStack(spacing: 4) {
                                        Text(gesture.1)
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        
                                        Text(gesture.2)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(20)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
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
    TouchCanvasView()
}