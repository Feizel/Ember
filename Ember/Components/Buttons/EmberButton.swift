import SwiftUI

// MARK: - Ember Button Component
struct EmberButton: View {
    let title: String
    let style: ButtonStyle
    let size: ButtonSize
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    @State private var isPressed = false
    
    init(_ title: String, style: ButtonStyle = .primary, size: ButtonSize = .medium, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: size.iconSpacing) {
                Text(title)
                    .font(size.font)
                    .fontWeight(.semibold)
            }
            .foregroundColor(textColor)
            .frame(height: size.height)
            .frame(maxWidth: .infinity)
            .background(backgroundView)
            .overlay(overlayView)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return EmberColors.textOnGradient
        case .secondary:
            return EmberColors.roseQuartz
        case .tertiary:
            return EmberColors.textPrimary
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            EmberColors.primaryGradient
        case .secondary:
            EmberColors.adaptiveSurface(for: colorScheme)
        case .tertiary:
            Color.clear
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .primary:
            EmptyView()
        case .secondary:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(EmberColors.roseQuartz, lineWidth: 1)
        case .tertiary:
            EmptyView()
        }
    }
}

// MARK: - Button Styles
extension EmberButton {
    enum ButtonStyle {
        case primary
        case secondary
        case tertiary
    }
    
    enum ButtonSize {
        case small
        case medium
        case large
        
        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 48
            case .large: return 56
            }
        }
        
        var font: Font {
            switch self {
            case .small: return EmberTypography.buttonSmall
            case .medium: return EmberTypography.buttonMedium
            case .large: return EmberTypography.buttonLarge
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }
        
        var iconSpacing: CGFloat {
            switch self {
            case .small: return 6
            case .medium: return 8
            case .large: return 10
            }
        }
    }
}

// MARK: - Icon Button Variant
struct EmberIconButton: View {
    let icon: String
    let title: String?
    let style: EmberButton.ButtonStyle
    let size: EmberButton.ButtonSize
    let action: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled
    @State private var isPressed = false
    
    init(icon: String, title: String? = nil, style: EmberButton.ButtonStyle = .primary, size: EmberButton.ButtonSize = .medium, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.style = style
        self.size = size
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: size.iconSpacing) {
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .medium))
                
                if let title = title {
                    Text(title)
                        .font(size.font)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(textColor)
            .frame(height: size.height)
            .frame(maxWidth: title != nil ? .infinity : size.height)
            .background(backgroundView)
            .overlay(overlayView)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        }, perform: {})
    }
    
    private var iconSize: CGFloat {
        switch size {
        case .small: return 14
        case .medium: return 16
        case .large: return 18
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary:
            return EmberColors.textOnGradient
        case .secondary:
            return EmberColors.roseQuartz
        case .tertiary:
            return EmberColors.textPrimary
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            EmberColors.primaryGradient
        case .secondary:
            EmberColors.adaptiveSurface(for: colorScheme)
        case .tertiary:
            Color.clear
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch style {
        case .primary:
            EmptyView()
        case .secondary:
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .stroke(EmberColors.roseQuartz, lineWidth: 1)
        case .tertiary:
            EmptyView()
        }
    }
}

// MARK: - Floating Action Button
struct EmberFloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(EmberColors.textOnGradient)
                .frame(width: 64, height: 64)
                .background(EmberColors.primaryGradient)
                .clipShape(Circle())
                .shadow(color: EmberColors.roseQuartz.opacity(0.3), radius: 8, x: 0, y: 4)
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        EmberButton("Primary Button", style: .primary) {}
        EmberButton("Secondary Button", style: .secondary) {}
        EmberButton("Tertiary Button", style: .tertiary) {}
        
        HStack(spacing: 16) {
            EmberIconButton(icon: "heart.fill", title: "Like") {}
            EmberIconButton(icon: "share", style: .secondary) {}
            EmberIconButton(icon: "bookmark", style: .tertiary) {}
        }
        
        EmberFloatingActionButton(icon: "plus") {}
    }
    .padding()
}