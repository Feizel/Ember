import SwiftUI

struct TouchHistoryCard: View {
    let touch: TouchRecord
    let onReplay: () -> Void
    let onFavorite: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Gesture Icon with Heart Character Reaction
            VStack {
                Text(touch.gestureIcon)
                    .font(.title2)
                
                // Small heart character reaction
                CuteCharacter(
                    character: touch.isFromCurrentUser ? .touchy : .syncee,
                    size: 30,
                    customization: CharacterCustomization(
                        colorTheme: touch.isFromCurrentUser ? .default : .pink,
                        accessory: .none,
                        expression: .happy,
                                        name: "My Heart"
                    ),
                    isAnimating: false
                )
            }
            
            // Touch Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(touch.gestureType)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(touch.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(touch.isFromCurrentUser ? "You sent" : "Partner sent")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let intensity = touch.intensity {
                        Text("• \(Int(intensity * 100))% intensity")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Action Buttons
            VStack(spacing: 8) {
                Button(action: onReplay) {
                    Image(systemName: "play.circle.fill")
                        .font(.title3)
                        .foregroundColor(.touchSyncAmber)
                }
                
                Button(action: onFavorite) {
                    Image(systemName: touch.isFavorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(touch.isFavorite ? .red : .secondary)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    (touch.isFromCurrentUser ? ColorPalette.crimson : ColorPalette.roseGold).opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(
                    color: (touch.isFromCurrentUser ? ColorPalette.crimson : ColorPalette.roseGold).opacity(0.2),
                    radius: 8,
                    x: 0,
                    y: 4
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .onTapGesture {
            onReplay()
        }
        .onLongPressGesture(minimumDuration: 0) {
            // Long press for preview
        } onPressingChanged: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        // Preview with mock data
        Text("Touch History Card Preview")
            .foregroundColor(.white)
    }
    .padding()
    .background(Color.black)
}