import SwiftUI
import CoreHaptics

struct FloatingActionButton: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isExpanded = false
    @State private var isPulsing = false
    @StateObject private var hapticsManager = HapticsManager.shared
    @StateObject private var feedbackManager = FeedbackManager.shared
    private var selectedTab: Binding<Int>
    
    init(selectedTab: Binding<Int>) {
        self.selectedTab = selectedTab
    }
    
    private let menuItems = [
        FABMenuItem(id: "kiss", icon: "heart.fill", iconColor: Color(hex: "7B7BFF"), background: Color(hex: "E8E8FF"), label: "Kiss", angle: 135),
        FABMenuItem(id: "hug", icon: "person.2.fill", iconColor: Color(hex: "FF6B9D"), background: Color(hex: "FFE8F0"), label: "Hug", angle: 90),
        FABMenuItem(id: "wave", icon: "hand.wave.fill", iconColor: Color(hex: "FF6B9D"), background: Color(hex: "FFE8F0"), label: "Wave", angle: 45),
        FABMenuItem(id: "love", icon: "heart.circle.fill", iconColor: Color(hex: "5BFF5B"), background: Color(hex: "E8FFE8"), label: "Love", angle: 180),
        FABMenuItem(id: "more", icon: "ellipsis", iconColor: Color(hex: "8E8E93"), background: Color(hex: "F2F2F7"), label: "More", angle: 0)
    ]
    
    var body: some View {
        ZStack {
            // Background overlay when expanded
            if isExpanded {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded = false
                        }
                    }
            }
            
            // Menu items
            ForEach(Array(menuItems.enumerated()), id: \.element.id) { index, item in
                FABMenuItemView(
                    item: item,
                    index: index,
                    isExpanded: isExpanded,
                    action: {
                        if item.id == "more" {
                            feedbackManager.tabSwitch()
                            selectedTab.wrappedValue = 2 // Navigate to Touch tab
                        } else {
                            feedbackManager.gestureStart()
                            sendGesture(for: item.id)
                        }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded = false
                        }
                    }
                )
            }
            
            // Main FAB button
            Button(action: {
                if isExpanded {
                    feedbackManager.menuClose()
                } else {
                    feedbackManager.menuOpen()
                }
                
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(colorScheme == .dark ? AdaptiveTheme.fabGradientDark : AdaptiveTheme.fabGradient)
                        .frame(width: 64, height: 64)
                        .shadow(color: AdaptiveTheme.shadowColor(for: colorScheme, intensity: .medium), radius: 20, x: 0, y: 8)
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isExpanded ? 45 : 0))
                }
            }
            .scaleEffect(isExpanded ? 1.1 : 1.0)
            .pulseEffect(duration: 2.0, scale: 1.03)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isExpanded)
        }
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 220)
    }
    
    private func sendGesture(for gestureId: String) {
        switch gestureId {
        case "kiss":
            hapticsManager.playGesture(.foreheadKiss)
            feedbackManager.gestureSent()
        case "hug":
            hapticsManager.playGesture(.hug)
            feedbackManager.gestureSent()
        case "wave":
            hapticsManager.playGesture(.shoulderTap)
            feedbackManager.gestureSent()
        case "love":
            hapticsManager.playGesture(.heartTrace)
            feedbackManager.gestureSent()
        default:
            break
        }
    }
}

struct FABMenuItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let item: FABMenuItem
    let index: Int
    let isExpanded: Bool
    let action: () -> Void
    
    private var offset: CGSize {
        if isExpanded {
            let radius: CGFloat = 120
            let radians = item.angle * .pi / 180
            return CGSize(
                width: cos(radians) * radius,
                height: -sin(radians) * radius
            )
        }
        return .zero
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(item.background)
                        .frame(width: 56, height: 56)
                        .shadow(color: AdaptiveTheme.shadowColor(for: colorScheme), radius: 8, x: 0, y: 4)
                        .scaleEffect(isExpanded ? 1.0 : 0.8)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(item.iconColor)
                        .scaleEffect(isExpanded ? 1.0 : 0.8)
                }
                
                if isExpanded {
                    Text(item.label)
                        .font(.caption2.weight(.medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.7), in: Capsule())
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .buttonStyle(.plain)
        .offset(offset)
        .scaleEffect(isExpanded ? 1.0 : 0.0)
        .opacity(isExpanded ? 1.0 : 0.0)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(isExpanded ? Double(index) * 0.05 : 0), value: isExpanded)
    }
}

struct FABMenuItem: Identifiable, Equatable {
    let id: String
    let icon: String
    let iconColor: Color
    let background: Color
    let label: String
    let angle: Double
}



#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        FloatingActionButton(selectedTab: .constant(0))
    }
}