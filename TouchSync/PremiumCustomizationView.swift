import SwiftUI

struct PremiumCustomizationView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    @State private var previewCustomization: CharacterCustomization
    @State private var selectedTab = 0
    
    init() {
        self._previewCustomization = State(initialValue: SettingsManager.shared.characterCustomization)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Preview Section
                previewSection
                    .padding(.top, 20)
                
                // Tab Selector
                customizationTabs
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                
                // Content
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case 0: colorThemeSection
                        case 1: expressionSection
                        case 2: accessorySection
                        default: colorThemeSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Customize")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        settingsManager.characterCustomization = previewCustomization
                        HapticsManager.shared.playSuccess()
                        dismiss()
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(ColorPalette.crimson, in: Capsule())
                }
            }
        }
    }
    
    private var previewSection: some View {
        VStack(spacing: 16) {
            CuteCharacter(
                character: .touchy,
                size: 100,
                customization: previewCustomization,
                isAnimating: true
            )
            
            VStack(spacing: 4) {
                Text(previewCustomization.name)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                
                Text(previewCustomization.expression.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(previewCustomization.colorTheme.displayName)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            colors: previewCustomization.colorTheme.colors,
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: Capsule()
                    )
            }
        }
        .padding(24)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
    
    private var customizationTabs: some View {
        HStack(spacing: 0) {
            TabButton(title: "Colors", icon: "paintpalette.fill", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            TabButton(title: "Expression", icon: "face.smiling.fill", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            TabButton(title: "Accessory", icon: "crown.fill", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .padding(4)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private var colorThemeSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(CharacterColorTheme.allCases, id: \.self) { theme in
                ColorThemeCard(
                    theme: theme,
                    isSelected: previewCustomization.colorTheme == theme,
                    action: {
                        previewCustomization.colorTheme = theme
                        HapticsManager.shared.playButtonTap()
                    }
                )
            }
        }
    }
    
    private var expressionSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(CharacterExpression.allCases, id: \.self) { expression in
                ExpressionCard(
                    expression: expression,
                    isSelected: previewCustomization.expression == expression,
                    action: {
                        previewCustomization.expression = expression
                        HapticsManager.shared.playButtonTap()
                    }
                )
            }
        }
    }
    
    private var accessorySection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            ForEach(CharacterAccessory.allCases, id: \.self) { accessory in
                AccessoryCard(
                    accessory: accessory,
                    isSelected: previewCustomization.accessory == accessory,
                    action: {
                        previewCustomization.accessory = accessory
                        HapticsManager.shared.playButtonTap()
                    }
                )
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(title)
                    .font(.caption.weight(.medium))
            }
            .foregroundStyle(isSelected ? .white : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? ColorPalette.crimson : Color.clear,
                in: RoundedRectangle(cornerRadius: 8)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ColorThemeCard: View {
    let theme: CharacterColorTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                HStack(spacing: 4) {
                    ForEach(theme.colors.prefix(3), id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                    }
                }
                
                VStack(spacing: 4) {
                    Text(theme.displayName)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Text(theme.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorPalette.crimson : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ExpressionCard: View {
    let expression: CharacterExpression
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                CuteCharacter(
                    character: .touchy,
                    size: 40,
                    customization: CharacterCustomization(
                        colorTheme: .blue,
                        accessory: .none,
                        expression: expression,
                        name: "Preview"
                    ),
                    isAnimating: false
                )
                
                VStack(spacing: 4) {
                    Text(expression.name)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Text(expression.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorPalette.crimson : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

struct AccessoryCard: View {
    let accessory: CharacterAccessory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: accessory.icon)
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: accessory.colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 24)
                
                Text(accessory.displayName)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorPalette.crimson : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PremiumCustomizationView()
        .environmentObject(SettingsManager.shared)
}