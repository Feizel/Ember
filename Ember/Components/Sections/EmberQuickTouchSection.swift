import SwiftUI

// MARK: - Quick Touch Section
struct EmberQuickTouchSection: View {
    @Binding var showingTouchCanvas: Bool
    let onGestureTap: (String) -> Void
    
    private let quickGestures = [
        ("Kiss", "lips.fill", EmberColors.roseQuartz),
        ("Hug", "hands.sparkles.fill", EmberColors.peachyKeen),
        ("Wave", "hand.wave.fill", EmberColors.coralPop),
        ("Love", "heart.fill", EmberColors.roseQuartz)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Gestures")
                    .emberHeadline()
                
                Spacer()
            }
            
            HStack(spacing: 12) {
                ForEach(quickGestures, id: \.0) { gesture in
                    EmberQuickGestureButton(
                        title: gesture.0,
                        icon: gesture.1,
                        color: gesture.2,
                        onTap: { onGestureTap(gesture.0) }
                    )
                }
            }
        }
    }
}

// MARK: - Quick Gesture Button
struct EmberQuickGestureButton: View {
    let title: String
    let icon: String
    let color: Color
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .emberIconMedium()
                        .foregroundStyle(color)
                }
                
                Text(title)
                    .emberCaption()
            }
            .frame(maxWidth: .infinity)
            .emberComponentPadding()
            .background(EmberColors.adaptiveSurface(for: .light), in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    EmberQuickTouchSection(
        showingTouchCanvas: .constant(false),
        onGestureTap: { gesture in
            print("Tapped: \(gesture)")
        }
    )
    .padding()
}