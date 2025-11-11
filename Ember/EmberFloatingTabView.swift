import SwiftUI

struct EmberFloatingTabView: View {
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    private let tabs = [
        TabItem(icon: "house.fill", title: "Home", tag: 0),
        TabItem(icon: "heart.fill", title: "Memories", tag: 1),
        TabItem(icon: "hand.draw.fill", title: "Touch", tag: 2),
        TabItem(icon: "person.fill", title: "Profile", tag: 3)
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.tag) { tab in
                    tabButton(for: tab)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    // Glassmorphism background
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                    
                    // Border
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(EmberColors.border.opacity(0.5), lineWidth: 0.5)
                    
                    // Dark mode glow
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        EmberColors.roseQuartz.opacity(0.3),
                                        EmberColors.peachyKeen.opacity(0.2),
                                        EmberColors.coralPop.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                }
            )
            .shadow(
                color: colorScheme == .dark ? 
                    EmberColors.roseQuartz.opacity(0.1) : 
                    Color.black.opacity(0.1),
                radius: 20,
                x: 0,
                y: 10
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
    }
    
    private func tabButton(for tab: TabItem) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab.tag
            }
            EmberHapticsManager.shared.playLight()
        }) {
            VStack(spacing: 6) {
                ZStack {
                    // Selection background
                    if selectedTab == tab.tag {
                        Circle()
                            .fill(EmberColors.primaryGradient)
                            .frame(width: 40, height: 40)
                            .scaleEffect(selectedTab == tab.tag ? 1.0 : 0.8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: selectedTab)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(
                            selectedTab == tab.tag ? 
                                .white : 
                                EmberColors.textSecondary
                        )
                        .scaleEffect(selectedTab == tab.tag ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                }
                
                Text(tab.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(
                        selectedTab == tab.tag ? 
                            EmberColors.textPrimary : 
                            EmberColors.textSecondary
                    )
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
            }
        }
        .buttonStyle(.plain)
    }
}

struct EmberFloatingActionButtonView: View {
    @Binding var selectedTab: Int
    @State private var showingTouchCanvas = false
    @State private var isPressed = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    EmberHapticsManager.shared.playMedium()
                    showingTouchCanvas = true
                }) {
                    ZStack {
                        // Outer glow ring (dark mode only)
                        if colorScheme == .dark {
                            Circle()
                                .fill(EmberColors.roseQuartz.opacity(0.2))
                                .frame(width: 80, height: 80)
                                .scaleEffect(isPressed ? 0.9 : 1.0)
                                .animation(.easeInOut(duration: 0.1), value: isPressed)
                        }
                        
                        // Main button
                        Circle()
                            .fill(EmberColors.primaryGradient)
                            .frame(width: 64, height: 64)
                            .scaleEffect(isPressed ? 0.95 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isPressed)
                        
                        // Icon
                        Image(systemName: "hand.wave.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isPressed)
                    }
                    .shadow(
                        color: colorScheme == .dark ? 
                            EmberColors.roseQuartz.opacity(0.4) : 
                            Color.black.opacity(0.2),
                        radius: 12,
                        x: 0,
                        y: 6
                    )
                }
                .buttonStyle(.plain)
                .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                    isPressed = pressing
                }, perform: {})
                .padding(.trailing, 32)
                .padding(.bottom, 120)
            }
        }
        .fullScreenCover(isPresented: $showingTouchCanvas) {
            EmberEnhancedTouchCanvas()
        }
    }
}

// MARK: - Supporting Types
struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

#Preview {
    ZStack {
        EmberColors.background
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            EmberFloatingTabView(selectedTab: .constant(0))
        }
    }
}