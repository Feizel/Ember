import SwiftUI

struct PremiumSettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingCustomization = false
    @State private var showingHapticSettings = false
    @State private var showingGoalSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    // Profile Header
                    profileHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    // Settings Groups
                    VStack(spacing: 24) {
                        customizationGroup
                        experienceGroup
                        notificationsGroup
                        accountGroup
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 32)
                    
                    Spacer(minLength: 120)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingCustomization) {
            PremiumCustomizationView()
                .environmentObject(settingsManager)
        }
        .sheet(isPresented: $showingHapticSettings) {
            HapticSettingsView()
                .environmentObject(settingsManager)
        }
        .sheet(isPresented: $showingGoalSettings) {
            GoalSettingsView()
                .environmentObject(settingsManager)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 20) {
            HStack(spacing: 16) {
                CuteCharacter(
                    character: .touchy,
                    size: 60,
                    customization: settingsManager.characterCustomization,
                    isAnimating: true
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("TouchSync")
                        .font(.title2.weight(.bold))
                        .foregroundColor(.primary)
                    
                    if let email = authManager.currentUser?.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Connected")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                CuteCharacter(
                    character: .syncee,
                    size: 60,
                    customization: CharacterCustomization(
                        colorTheme: .pink,
                        accessory: .flower,
                        expression: .love,
                        name: "Partner"
                    ),
                    isAnimating: true
                )
            }
            .padding(20)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var customizationGroup: some View {
        SettingsGroup(title: "Personalization") {
            PremiumSettingsRow(
                icon: "paintbrush.pointed.fill",
                iconColor: .purple,
                title: "Customize Character",
                subtitle: settingsManager.characterCustomization.colorTheme.displayName,
                action: { showingCustomization = true }
            )
        }
    }
    
    private var experienceGroup: some View {
        SettingsGroup(title: "Experience") {
            PremiumToggleRow(
                icon: "iphone.radiowaves.left.and.right",
                iconColor: .blue,
                title: "Haptic Feedback",
                subtitle: "Feel every touch",
                isOn: $settingsManager.hapticFeedbackEnabled
            )
            
            PremiumSettingsRow(
                icon: "slider.horizontal.3",
                iconColor: .indigo,
                title: "Haptic Intensity",
                subtitle: settingsManager.hapticIntensity.displayName,
                isDisabled: !settingsManager.hapticFeedbackEnabled,
                action: { showingHapticSettings = true }
            )
            
            PremiumSettingsRow(
                icon: "target",
                iconColor: .orange,
                title: "Daily Goal",
                subtitle: "\(settingsManager.dailyGoal) touches per day",
                action: { showingGoalSettings = true }
            )
        }
    }
    
    private var notificationsGroup: some View {
        SettingsGroup(title: "Notifications") {
            PremiumToggleRow(
                icon: "bell.fill",
                iconColor: .red,
                title: "Touch Notifications",
                subtitle: "When partner sends touch",
                isOn: $settingsManager.notificationsEnabled
            )
            
            PremiumToggleRow(
                icon: "clock.fill",
                iconColor: .green,
                title: "Daily Reminders",
                subtitle: "Stay connected reminders",
                isOn: $settingsManager.remindersEnabled
            )
        }
    }
    
    private var accountGroup: some View {
        SettingsGroup(title: "Account") {
            PremiumSettingsRow(
                icon: "person.crop.circle.fill",
                iconColor: .cyan,
                title: "Profile",
                subtitle: "Edit your information"
            )
            
            PremiumSettingsRow(
                icon: "heart.text.square.fill",
                iconColor: .pink,
                title: "Partner Connection",
                subtitle: authManager.partnerId != nil ? "Connected" : "Not connected"
            )
            
            PremiumSettingsRow(
                icon: "crown.fill",
                iconColor: .yellow,
                title: "TouchSync Premium",
                subtitle: "Unlock all features"
            )
            
            PremiumSettingsRow(
                icon: "arrow.right.square.fill",
                iconColor: .red,
                title: "Sign Out",
                subtitle: nil,
                action: { authManager.signOut() }
            )
        }
    }
}

struct SettingsGroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            VStack(spacing: 1) {
                content
            }
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct PremiumSettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let isDisabled: Bool
    let action: (() -> Void)?
    
    init(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String? = nil,
        isDisabled: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1.0)
    }
}

struct PremiumToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.medium))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(iconColor)
                .onChange(of: isOn) { _, _ in
                    HapticsManager.shared.playButtonTap()
                }
        }
        .padding(16)
    }
}

#Preview {
    PremiumSettingsView()
        .environmentObject(AuthManager())
        .environmentObject(SettingsManager.shared)
}