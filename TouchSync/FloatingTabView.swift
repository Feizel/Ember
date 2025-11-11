import SwiftUI

struct FloatingTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "heart.fill", title: "Home", index: 0),
        TabItem(icon: "heart.text.square.fill", title: "Memories", index: 1),
        TabItem(icon: "hand.tap.fill", title: "Touch", index: 2),
        TabItem(icon: "gear", title: "Settings", index: 3)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                FloatingTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    action: { selectedTab = tab.index }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .adaptiveGlassmorphism(cornerRadius: 50)
        .shadow(color: AdaptiveTheme.shadowColor(for: colorScheme, intensity: .medium), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
        .padding(.bottom, 34)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

struct FloatingTabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticsManager.shared.playButtonTap()
            action()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorPalette.crimson.opacity(0.2))
                            .frame(width: 32, height: 32)
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(isSelected ? ColorPalette.crimson : .secondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(isSelected ? ColorPalette.crimson : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack {
            Spacer()
            FloatingTabView(selectedTab: .constant(0))
        }
    }
}