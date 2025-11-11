import SwiftUI

struct SendView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingTouchCanvas = false
    @State private var showingLoveNoteComposer = false
    @State private var showingVoiceMessage = false
    @State private var showingPhotoMessage = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Send Love")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(.primary)
                            
                            Text("Choose how you want to connect")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                        
                        // Quick Gestures
                        QuickGesturesSection()
                        
                        // Main Send Options
                        VStack(spacing: 16) {
                            SendOptionCard(
                                title: "Touch Canvas",
                                subtitle: "Draw your touch with your finger",
                                icon: "hand.draw.fill",
                                color: ColorPalette.sensualRed,
                                isPremium: false,
                                action: { showingTouchCanvas = true }
                            )
                            
                            SendOptionCard(
                                title: "Love Note",
                                subtitle: "Send a heartfelt message",
                                icon: "heart.text.square.fill",
                                color: ColorPalette.roseGold,
                                isPremium: false,
                                action: { showingLoveNoteComposer = true }
                            )
                            
                            SendOptionCard(
                                title: "Voice Message",
                                subtitle: "Record your voice for them",
                                icon: "mic.fill",
                                color: ColorPalette.sunsetOrange,
                                isPremium: true,
                                action: { showingVoiceMessage = true }
                            )
                            
                            SendOptionCard(
                                title: "Photo Message",
                                subtitle: "Share a moment with them",
                                icon: "camera.fill",
                                color: ColorPalette.goldenYellow,
                                isPremium: true,
                                action: { showingPhotoMessage = true }
                            )
                            
                            SendOptionCard(
                                title: "Heartbeat",
                                subtitle: "Send your actual heartbeat",
                                icon: "heart.circle.fill",
                                color: ColorPalette.crimson,
                                isPremium: true,
                                action: {}
                            )
                            
                            SendOptionCard(
                                title: "Location Share",
                                subtitle: "Let them know where you are",
                                icon: "location.fill",
                                color: ColorPalette.passionRed,
                                isPremium: true,
                                action: {}
                            )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(ColorPalette.crimson)
                }
            }
        }
        .fullScreenCover(isPresented: $showingTouchCanvas) {
            TouchCanvasView()
        }
        .sheet(isPresented: $showingLoveNoteComposer) {
            LoveNoteComposerView()
        }
        .sheet(isPresented: $showingVoiceMessage) {
            VoiceMessageView()
        }
        .sheet(isPresented: $showingPhotoMessage) {
            PhotoMessageView()
        }
    }
}

struct QuickGesturesSection: View {
    let gestures = [
        ("heart.fill", "Kiss", ColorPalette.sensualRed),
        ("hands.sparkles.fill", "Hug", ColorPalette.sunsetOrange),
        ("hand.wave.fill", "Wave", ColorPalette.passionRed),
        ("bolt.heart.fill", "Love", ColorPalette.goldenYellow)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Gestures")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Text("Tap to send")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(gestures.enumerated()), id: \.offset) { index, gesture in
                    Button(action: {
                        HapticsManager.shared.playGesture(HapticGesture.allGestures[index])
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(gesture.2.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: gesture.0)
                                    .font(.title3)
                                    .foregroundStyle(gesture.2)
                            }
                            
                            Text(gesture.1)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct SendOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isPremium: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.headline.weight(.medium))
                            .foregroundColor(.primary)
                        
                        if isPremium {
                            Text("PRO")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(ColorPalette.goldenYellow, in: Capsule())
                        }
                    }
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isPremium ? ColorPalette.goldenYellow.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// Placeholder views for new features
struct VoiceMessageView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Voice Message")
                    .font(.title)
                Text("Coming Soon")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Voice Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct PhotoMessageView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Photo Message")
                    .font(.title)
                Text("Coming Soon")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Photo Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SendView()
}