import SwiftUI

struct TouchView: View {
    @State private var selectedGesture: String?
    
    private let quickGestures: [QuickGesture] = [
        QuickGesture(id: "kiss", icon: "heart.fill", iconColor: Color(red: 0.48, green: 0.48, blue: 1.0), iconBackground: Color(red: 0.91, green: 0.91, blue: 1.0), label: "Kiss"),
        QuickGesture(id: "hug", icon: "person.2.fill", iconColor: Color(red: 1.0, green: 0.42, blue: 0.62), iconBackground: Color(red: 1.0, green: 0.91, blue: 0.94), label: "Hug"),
        QuickGesture(id: "wave", icon: "hand.wave.fill", iconColor: Color(red: 1.0, green: 0.42, blue: 0.62), iconBackground: Color(red: 1.0, green: 0.91, blue: 0.94), label: "Wave"),
        QuickGesture(id: "love", icon: "heart.circle.fill", iconColor: Color(red: 0.36, green: 1.0, blue: 0.36), iconBackground: Color(red: 0.91, green: 1.0, blue: 0.91), label: "Love")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    // Header
                    HeaderSection()
                    
                    // Quick Gestures
                    TouchQuickGesturesSection(gestures: quickGestures, selectedGesture: $selectedGesture)
                    
                    // Navigation Cards
                    NavigationCardsSection()
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 16)
            }
            .background(AdaptiveTheme.background)
            .navigationTitle("Touch")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Send Love")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Text("Choose how you want to connect")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

struct TouchQuickGesturesSection: View {
    let gestures: [QuickGesture]
    @Binding var selectedGesture: String?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Gestures")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text("Tap to send")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(gestures) { gesture in
                    QuickGestureButton(gesture: gesture, selectedGesture: $selectedGesture)
                }
            }
        }
    }
}

struct QuickGestureButton: View {
    let gesture: QuickGesture
    @Binding var selectedGesture: String?
    
    var body: some View {
        Button(action: {
            selectedGesture = gesture.id
            // Send gesture immediately
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(gesture.iconBackground)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: gesture.icon)
                        .font(.title3)
                        .foregroundStyle(gesture.iconColor)
                }
                
                Text(gesture.label)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(16)
            .frame(height: 80)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .scaleEffect(selectedGesture == gesture.id ? 0.95 : 1.0)
        .animation(.spring(response: 0.3), value: selectedGesture)
    }
}

struct NavigationCardsSection: View {
    var body: some View {
        VStack(spacing: 12) {
            NavigationCard(
                icon: "scribble",
                iconColor: Color(red: 0.48, green: 0.48, blue: 1.0),
                iconBackground: Color(red: 0.91, green: 0.91, blue: 1.0),
                title: "Touch Canvas",
                subtitle: "Draw your touch with your finger",
                isPremium: false,
                action: { /* Navigate to canvas */ }
            )
            
            NavigationCard(
                icon: "note.text",
                iconColor: Color(red: 1.0, green: 0.42, blue: 0.62),
                iconBackground: Color(red: 1.0, green: 0.91, blue: 0.94),
                title: "Love Note",
                subtitle: "Send a heartfelt message",
                isPremium: false,
                action: { /* Navigate to love note */ }
            )
            
            NavigationCard(
                icon: "mic.fill",
                iconColor: Color(red: 1.0, green: 0.42, blue: 0.62),
                iconBackground: Color(red: 1.0, green: 0.91, blue: 0.94),
                title: "Voice Message",
                subtitle: "Record your voice for them",
                isPremium: true,
                action: { /* Navigate to voice recording */ }
            )
            
            NavigationCard(
                icon: "camera.fill",
                iconColor: Color(red: 0.36, green: 1.0, blue: 0.36),
                iconBackground: Color(red: 0.91, green: 1.0, blue: 0.91),
                title: "Photo Message",
                subtitle: "Share a moment with them",
                isPremium: true,
                action: { /* Open photo picker */ }
            )
            
            NavigationCard(
                icon: "waveform.path.ecg",
                iconColor: Color(red: 0.48, green: 0.48, blue: 1.0),
                iconBackground: Color(red: 0.91, green: 0.91, blue: 1.0),
                title: "Heartbeat",
                subtitle: "Send your actual heartbeat",
                isPremium: true,
                action: { /* Navigate to heartbeat */ }
            )
            
            NavigationCard(
                icon: "location.fill",
                iconColor: Color(red: 1.0, green: 0.42, blue: 0.62),
                iconBackground: Color(red: 1.0, green: 0.91, blue: 0.94),
                title: "Location Share",
                subtitle: "Let them know where you are",
                isPremium: true,
                action: { /* Request location and share */ }
            )
        }
    }
}

struct NavigationCard: View {
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let title: String
    let subtitle: String
    let isPremium: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(iconColor)
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
            .padding(16)
            .frame(height: 80)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Data Models

struct QuickGesture: Identifiable {
    let id: String
    let icon: String
    let iconColor: Color
    let iconBackground: Color
    let label: String
}

#Preview {
    TouchView()
}