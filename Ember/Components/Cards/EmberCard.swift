import SwiftUI
import Combine

// MARK: - Ember Card Component
struct EmberCard<Content: View>: View {
    let style: CardStyle
    let content: Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    init(style: CardStyle = .normal, @ViewBuilder content: () -> Content) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(16)
            .background(backgroundView)
            .overlay(overlayView)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .normal:
            EmberColors.adaptiveSurface(for: colorScheme)
        case .elevated:
            ElevatedSurface(level: .medium) {
                EmberColors.adaptiveSurface(for: colorScheme)
            }
        case .glassmorphic:
            GlassmorphicCard(style: .standard) {
                EmptyView()
            }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .normal:
            RoundedRectangle(cornerRadius: 16)
                .stroke(EmberColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
        case .elevated, .glassmorphic:
            EmptyView()
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .normal:
            return Color.black.opacity(colorScheme == .dark ? 0.4 : 0.08)
        case .elevated:
            return Color.black.opacity(colorScheme == .dark ? 0.4 : 0.12)
        case .glassmorphic:
            return Color.black.opacity(colorScheme == .dark ? 0.4 : 0.08)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .normal: return 2
        case .elevated: return 4
        case .glassmorphic: return 2
        }
    }
    
    private var shadowOffset: CGFloat {
        switch style {
        case .normal: return 2
        case .elevated: return 4
        case .glassmorphic: return 2
        }
    }
}

// MARK: - Card Styles
enum CardStyle {
    case normal
    case elevated
    case glassmorphic
}

// MARK: - Specialized Card Components

// MARK: - Gradient Header Card
struct EmberGradientCard<Content: View>: View {
    let gradient: LinearGradient
    let content: Content
    
    init(gradient: LinearGradient = EmberColors.headerGradient, @ViewBuilder content: () -> Content) {
        self.gradient = gradient
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: EmberColors.roseQuartz.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Stats Card
struct EmberStatsCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    let style: CardStyle
    
    init(title: String, value: String, subtitle: String, color: Color = EmberColors.roseQuartz, style: CardStyle = .elevated) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
        self.style = style
    }
    
    var body: some View {
        EmberCard(style: style) {
            VStack(spacing: 8) {
                Text(title)
                    .emberLabel(color: EmberColors.textSecondary)
                
                Text(value)
                    .emberText(.headlineSmall, color: color)
                
                Text(subtitle)
                    .emberText(.labelSmall, color: EmberColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Feature Card
struct EmberFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        InteractiveButton(
            hapticType: .touch,
            style: .gentle,
            action: action
        ) {
            EmberCard(style: .elevated) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(EmberColors.roseQuartz.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        AnimatedIcon(.touch, size: 24, color: EmberColors.roseQuartz, isActive: isPressed)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        DynamicTypeText(title, style: .headline)
                        
                        DynamicTypeText(description, style: .body, color: EmberColors.textSecondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    GlowIcon("chevron.right", size: 16, color: EmberColors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Memory Card
struct EmberMemoryCard: View {
    let title: String
    let date: String
    let description: String?
    let imageName: String?
    
    var body: some View {
        EmberCard(style: .elevated) {
            VStack(alignment: .leading, spacing: 12) {
                if let imageName = imageName {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .emberTitle()
                    
                    Text(date)
                        .emberLabel(color: EmberColors.textSecondary)
                    
                    if let description = description {
                        Text(description)
                            .emberBody(color: EmberColors.textSecondary)
                            .lineLimit(3)
                    }
                }
            }
        }
    }
}

// MARK: - Connection Status Card
struct EmberConnectionCard: View {
    let isConnected: Bool
    let partnerName: String
    let lastSeen: String
    
    var body: some View {
        EmberCard(style: .glassmorphic) {
            HStack(spacing: 16) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(EmberColors.peachyKeen.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        // Character placeholder - would be replaced with Rive animation
                        Image(systemName: "heart.fill")
                            .font(.title)
                            .foregroundColor(EmberColors.peachyKeen)
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(isConnected ? .green : .orange)
                            .frame(width: 6, height: 6)
                        
                        Text(isConnected ? "Connected" : "Away")
                            .emberText(.labelSmall, color: isConnected ? .green : .orange)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(partnerName)
                        .emberTitle()
                    
                    Text("Last seen: \(lastSeen)")
                        .emberLabel(color: EmberColors.textSecondary)
                    
                    Text("Connection strength: Strong")
                        .emberText(.labelSmall, color: EmberColors.roseQuartz)
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            EmberCard {
                Text("Normal Card")
                    .emberTitle()
            }
            
            EmberCard(style: .elevated) {
                Text("Elevated Card")
                    .emberTitle()
            }
            
            EmberCard(style: .glassmorphic) {
                Text("Glassmorphic Card")
                    .emberTitle()
            }
            
            EmberGradientCard {
                VStack {
                    Text("Gradient Header")
                        .emberHeadline(color: .white)
                    Text("Beautiful gradient background")
                        .emberBody(color: .white.opacity(0.8))
                }
            }
            
            HStack(spacing: 12) {
                EmberStatsCard(title: "Touches", value: "24", subtitle: "today")
                EmberStatsCard(title: "Streak", value: "12", subtitle: "days", color: EmberColors.peachyKeen)
                EmberStatsCard(title: "Goal", value: "30", subtitle: "daily", color: EmberColors.coralPop)
            }
            
            EmberFeatureCard(
                icon: "hand.draw.fill",
                title: "Touch Canvas",
                description: "Draw your touch with your finger"
            ) {}
            
            EmberConnectionCard(
                isConnected: true,
                partnerName: "Your Love",
                lastSeen: "Just now"
            )
        }
        .padding()
    }
}
