import SwiftUI

struct ModernSettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingHapticIntensity = false
    @State private var showingDailyGoal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Profile header with cute characters
                        VStack(spacing: 20) {
                            HStack(spacing: 24) {
                                CuteCharacter(
                                    character: .touchy,
                                    size: 70,
                                    customization: settingsManager.characterCustomization,
                                    isAnimating: true
                                )
                                
                                VStack(spacing: 6) {
                                    Text("TouchSync")
                                        .font(.title2.weight(.bold))
                                        .foregroundStyle(ModernColorPalette.textPrimary)
                                    
                                    if let email = authManager.currentUser?.email {
                                        Text(email)
                                            .font(.subheadline)
                                            .foregroundStyle(ModernColorPalette.textSecondary)
                                    }
                                }
                                
                                CuteCharacter(
                                    character: .syncee,
                                    size: 70,
                                    customization: CharacterCustomization(
                                        colorTheme: .pink,
                                        accessory: .flower,
                                        expression: .love,
                                        name: "Partner's Heart"
                                    ),
                                    isAnimating: true
                                )
                            }
                        }
                        .padding(.top, 20)
                        
                        // Premium banner
                        ModernPremiumBanner()
                        
                        // Settings sections
                        VStack(spacing: 20) {
                            ModernSettingsSection(title: "Customization") {
                                NavigationLink(destination: CharacterCustomizationView(settingsManager: settingsManager)) {
                                    ModernSettingsRow(
                                        icon: "paintbrush.pointed.fill",
                                        title: "Customize Character",
                                        subtitle: "Colors, expressions & accessories",
                                        color: ModernColorPalette.primary
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            
                            ModernSettingsSection(title: "Connection") {
                                ModernSettingsRow(
                                    icon: "person.2.fill",
                                    title: "Partner",
                                    subtitle: authManager.partnerId != nil ? "Connected ❤️" : "Not connected",
                                    color: ModernColorPalette.secondary
                                )
                                
                                Button(action: { showingDailyGoal = true }) {
                                    ModernSettingsRow(
                                        icon: "target",
                                        title: "Daily Goal",
                                        subtitle: "\(settingsManager.dailyGoal) touches per day",
                                        color: ModernColorPalette.accent
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                            
                            ModernSettingsSection(title: "Experience") {
                                ModernToggleRow(
                                    icon: "iphone.radiowaves.left.and.right",
                                    title: "Haptic Feedback",
                                    color: ModernColorPalette.primary,
                                    isOn: $settingsManager.hapticFeedbackEnabled
                                )
                                
                                Button(action: { showingHapticIntensity = true }) {
                                    ModernSettingsRow(
                                        icon: "slider.horizontal.3",
                                        title: "Haptic Intensity",
                                        subtitle: settingsManager.hapticIntensity.displayName,
                                        color: ModernColorPalette.secondary
                                    )
                                }
                                .buttonStyle(.plain)
                                .disabled(!settingsManager.hapticFeedbackEnabled)
                            }
                            
                            ModernSettingsSection(title: "Notifications") {
                                ModernToggleRow(
                                    icon: "bell.fill",
                                    title: "Touch Received",
                                    color: ModernColorPalette.accent,
                                    isOn: $settingsManager.notificationsEnabled
                                )
                                
                                ModernToggleRow(
                                    icon: "clock.fill",
                                    title: "Reminders",
                                    color: ModernColorPalette.primary,
                                    isOn: $settingsManager.remindersEnabled
                                )
                            }
                            
                            ModernSettingsSection(title: "Account") {
                                ModernSettingsRow(
                                    icon: "person.crop.circle.fill",
                                    title: "Profile",
                                    subtitle: "Edit your information",
                                    color: ModernColorPalette.secondary
                                )
                                
                                ModernSettingsRow(
                                    icon: "arrow.right.square.fill",
                                    title: "Sign Out",
                                    color: .red,
                                    action: { authManager.signOut() }
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingHapticIntensity) {
            HapticIntensitySheet(settingsManager: settingsManager)
        }
        .sheet(isPresented: $showingDailyGoal) {
            DailyGoalSheet(settingsManager: settingsManager)
        }
    }
}

struct CharacterCustomizationView: View {
    let settingsManager: SettingsManager
    @State private var selectedTab = 0
    @State private var previewCustomization: CharacterCustomization
    @Environment(\.dismiss) private var dismiss
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        self._previewCustomization = State(initialValue: settingsManager.characterCustomization)
    }
    
    var body: some View {
        ZStack {
            ModernColorPalette.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 24) {
                    // Preview section
                    VStack(spacing: 20) {
                        Text("Your Character")
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(ModernColorPalette.textPrimary)
                        
                        CuteCharacter(
                            size: 120,
                            isAnimating: true,
                            customization: previewCustomization
                        )
                        
                        VStack(spacing: 8) {
                            Text(previewCustomization.name)
                                .font(.headline.weight(.medium))
                                .foregroundStyle(ModernColorPalette.textPrimary)
                            
                            Text(previewCustomization.expression.name)
                                .font(.subheadline)
                                .foregroundStyle(ModernColorPalette.textSecondary)
                            
                            Text(previewCustomization.colorTheme.displayName)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    LinearGradient(
                                        colors: [previewCustomization.primaryColor, previewCustomization.secondaryColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    in: Capsule()
                                )
                        }
                    }
                    .padding(24)
                    .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
                    
                    // Customization tabs
                    ModernCustomizationTabs(selectedTab: $selectedTab)
                    
                    // Content based on selected tab
                    Group {
                        switch selectedTab {
                        case 0:
                            ModernColorThemeSection(previewCustomization: $previewCustomization)
                        case 1:
                            ModernExpressionSection(previewCustomization: $previewCustomization)
                        case 2:
                            ModernAccessorySection(previewCustomization: $previewCustomization)
                        default:
                            ModernColorThemeSection(previewCustomization: $previewCustomization)
                        }
                    }
                    
                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationTitle("Customize")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    settingsManager.characterCustomization = previewCustomization
                    HapticsManager.shared.playSuccess()
                    dismiss()
                }
                .font(.headline.weight(.medium))
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(ModernColorPalette.primaryGradient, in: Capsule())
            }
        }
    }
}

struct ModernCustomizationTabs: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            CustomizationTabButton(title: "Colors", icon: "paintpalette.fill", isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            CustomizationTabButton(title: "Expression", icon: "face.smiling.fill", isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            CustomizationTabButton(title: "Accessory", icon: "crown.fill", isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .padding(4)
        .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct CustomizationTabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(isSelected ? .white : ModernColorPalette.textSecondary)
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isSelected ? .white : ModernColorPalette.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ? AnyShapeStyle(ModernColorPalette.primaryGradient) : AnyShapeStyle(Color.clear),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ModernColorThemeSection: View {
    @Binding var previewCustomization: CharacterCustomization
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Color Themes")
                .font(.headline.weight(.semibold))
                .foregroundStyle(ModernColorPalette.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(CharacterColorTheme.allCases, id: \.self) { theme in
                    ModernColorThemeCard(
                        theme: theme,
                        isSelected: previewCustomization.colorTheme == theme,
                        action: { previewCustomization.colorTheme = theme }
                    )
                }
            }
        }
    }
}

struct ModernColorThemeCard: View {
    let theme: CharacterColorTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 16, height: 16)
                    
                    Circle()
                        .fill(theme.secondaryColor)
                        .frame(width: 16, height: 16)
                }
                
                VStack(spacing: 4) {
                    Text(theme.displayName)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(ModernColorPalette.textPrimary)
                    
                    Text(theme.description)
                        .font(.caption2)
                        .foregroundStyle(ModernColorPalette.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(16)
            .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? theme.primaryColor : .clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

struct ModernExpressionSection: View {
    @Binding var previewCustomization: CharacterCustomization
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Expressions")
                .font(.headline.weight(.semibold))
                .foregroundStyle(ModernColorPalette.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(CharacterExpression.allCases, id: \.self) { expression in
                    ModernExpressionCard(
                        expression: expression,
                        isSelected: previewCustomization.expression == expression,
                        action: { previewCustomization.expression = expression }
                    )
                }
            }
        }
    }
}

struct ModernExpressionCard: View {
    let expression: CharacterExpression
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                CuteCharacter(
                    size: 40,
                    isAnimating: false,
                    customization: CharacterCustomization(
                        colorTheme: .blue,
                        accessory: .none,
                        expression: expression,
                        name: "Preview"
                    )
                )
                
                VStack(spacing: 4) {
                    Text(expression.name)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(ModernColorPalette.textPrimary)
                    
                    Text(expression.description)
                        .font(.caption2)
                        .foregroundStyle(ModernColorPalette.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(16)
            .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? ModernColorPalette.primary : .clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

struct ModernAccessorySection: View {
    @Binding var previewCustomization: CharacterCustomization
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Accessories")
                .font(.headline.weight(.semibold))
                .foregroundStyle(ModernColorPalette.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(CharacterAccessory.allCases, id: \.self) { accessory in
                    ModernAccessoryCard(
                        accessory: accessory,
                        isSelected: previewCustomization.accessory == accessory,
                        action: { previewCustomization.accessory = accessory }
                    )
                }
            }
        }
    }
}

struct ModernAccessoryCard: View {
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
                    .foregroundStyle(ModernColorPalette.textPrimary)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? ModernColorPalette.primary : .clear,
                        lineWidth: 2
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

struct ModernPremiumBanner: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(ModernColorPalette.primaryGradient)
                    .frame(width: 44, height: 44)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("TouchSync Premium")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(ModernColorPalette.textPrimary)
                
                Text("Unlock premium themes & features")
                    .font(.subheadline)
                    .foregroundStyle(ModernColorPalette.textSecondary)
            }
            
            Spacer()
            
            Button("Upgrade") {
                // Handle premium upgrade
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(ModernColorPalette.secondaryGradient, in: Capsule())
        }
        .padding(20)
        .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ModernColorPalette.primary.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct ModernSettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(ModernColorPalette.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                content
            }
        }
    }
}

struct ModernSettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let color: Color
    let action: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        color: Color,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(ModernColorPalette.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(ModernColorPalette.textSecondary)
                    }
                }
                
                Spacer()
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(ModernColorPalette.textTertiary)
                }
            }
            .padding(16)
            .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

struct ModernToggleRow: View {
    let icon: String
    let title: String
    let color: Color
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(color)
            }
            
            Text(title)
                .font(.body.weight(.medium))
                .foregroundStyle(ModernColorPalette.textPrimary)
            
            Spacer()
            
            Toggle(isOn: $isOn) {
                EmptyView()
            }
            .tint(color)
            .onChange(of: isOn) { _, _ in
                HapticsManager.shared.playButtonTap()
            }
        }
        .padding(16)
        .background(ModernColorPalette.surface, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    ModernSettingsView()
        .environmentObject(AuthManager())
        .environmentObject(SettingsManager.shared)
}