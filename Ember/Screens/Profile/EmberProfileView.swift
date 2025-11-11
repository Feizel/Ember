import SwiftUI

// MARK: - Ember Profile View
struct EmberProfileView: View {
    @State private var showingCharacterCustomization = false
    @State private var showingPreferences = false
    @State private var showingNotificationSettings = false
    @State private var showingProfileEdit = false
    @State private var showingPartnerConnection = false
    @State private var showingPremium = false
    @State private var showingThemes = false
    @State private var showingSupport = false
    @State private var showingPrivacy = false
    
    // Settings states
    @State private var touchNotifications = true
    @State private var dailyReminders = true
    @State private var soundEnabled = true
    @State private var hapticFeedback = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Enhanced Profile Header
                    profileHeader
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Your Characters Section
                    charactersSection
                    
                    // Account & Settings
                    accountSection
                    
                    // App Settings
                    appSettingsSection
                    
                    // Support & Info
                    supportSection
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        HStack(spacing: 8) {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 16))
                            Text("Your Love Profile")
                        }
                        .emberHeadline(color: EmberColors.textOnGradient)
                        
                        Text("Customize your romantic journey")
                            .font(.caption2)
                            .foregroundStyle(EmberColors.textOnGradient.opacity(0.7))
                    }
                }
            }
            .toolbarBackground(EmberColors.headerGradient, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .sheet(isPresented: $showingCharacterCustomization) {
            EmberCharacterCustomizationView()
        }
        .sheet(isPresented: $showingPreferences) {
            EmberPreferencesView()
        }
        .sheet(isPresented: $showingNotificationSettings) {
            EmberNotificationSettingsView()
        }
        .sheet(isPresented: $showingProfileEdit) {
            EmberProfileEditView()
        }
        .sheet(isPresented: $showingPartnerConnection) {
            EmberPartnerConnectionView()
        }
        .sheet(isPresented: $showingPremium) {
            EmberPremiumView()
        }
        .sheet(isPresented: $showingThemes) {
            EmberThemesView()
        }
        .sheet(isPresented: $showingSupport) {
            EmberSupportView()
        }
        .sheet(isPresented: $showingPrivacy) {
            EmberPrivacyView()
        }
    }
    
    private func performAction(title: String) {
        EmberHapticsManager.shared.playMedium()
        print("Profile action: \(title)")
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 0) {
            // Profile Info Card
            VStack(spacing: 20) {
                // Avatar and Connection Status
                HStack(spacing: 16) {
                    ZStack {
                        // Use simple 3D-like character
                        EmberSimple3DCharacters(
                            character: .touchy,
                            size: 80,
                            isAnimating: true
                        )
                        
                        // Connection indicator
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(.green)
                                    .frame(width: 20, height: 20)
                                    .overlay(
                                        Circle()
                                            .stroke(.white, lineWidth: 2)
                                    )
                            }
                            Spacer()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Sarah & Alex")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(1.2)
                                
                                Text("Deeply Connected")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.green)
                            }
                            
                            HStack(spacing: 6) {
                                Image(systemName: "heart.fill")
                                    .font(.caption)
                                    .foregroundStyle(EmberColors.roseQuartz)
                                
                                Text("89 beautiful days together")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(EmberColors.textSecondary)
                            }
                        }
                        
                        Button(action: {
                            showingProfileEdit = true
                        }) {
                            Text("Edit Profile")
                                .emberCaption(color: EmberColors.roseQuartz)
                        }
                    }
                    
                    Spacer()
                }
                
                // Stats Row
                HStack(spacing: 24) {
                    statItem(value: "1,247", label: "Love Touches", icon: "hand.tap.fill")
                    statItem(value: "47", label: "Love Streak", icon: "flame.fill")
                    statItem(value: "247", label: "Sweet Memories", icon: "heart.fill")
                }
            }
            .padding(20)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
    }
    
    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(EmberColors.roseQuartz)
            
            Text(value)
                .emberHeadlineSmall(color: EmberColors.roseQuartz)
            
            Text(label)
                .emberCaption(color: EmberColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Quick Actions Section
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Express Yourself")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Text("Customize your love experience")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            
            HStack(spacing: 12) {
                quickActionButton(
                    icon: "person.2.fill",
                    title: "Love Avatars",
                    color: EmberColors.roseQuartz,
                    action: { showingCharacterCustomization = true }
                )
                
                quickActionButton(
                    icon: "crown.fill",
                    title: "Premium Love",
                    color: .yellow,
                    action: { showingPremium = true }
                )
                
                quickActionButton(
                    icon: "bell.fill",
                    title: "Love Alerts",
                    color: EmberColors.peachyKeen,
                    action: { showingNotificationSettings = true }
                )
                
                quickActionButton(
                    icon: "gear",
                    title: "Love Settings",
                    color: EmberColors.coralPop,
                    action: { showingPreferences = true }
                )
            }
        }
    }
    
    private func quickActionButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(color)
                }
                
                Text(title)
                    .emberCaption()
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Characters Section
    private var charactersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Love Avatars")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    Text("Choose how you appear to your love")
                        .font(.caption)
                        .foregroundStyle(EmberColors.textSecondary)
                }
                Spacer()
                Button("Customize") {
                    showingCharacterCustomization = true
                }
                .emberCaption(color: EmberColors.roseQuartz)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    characterCard(character: .touchy, name: "Touchy", isSelected: true)
                    characterCard(character: .syncee, name: "Syncee", isSelected: false)
                    characterCard(character: .harmony, name: "Harmony", isSelected: false)
                    characterCard(character: .flux, name: "Flux", isSelected: false)
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func characterCard(character: CharacterType, name: String, isSelected: Bool) -> some View {
        Button(action: {
            performAction(title: "Select \(name)")
        }) {
            VStack(spacing: 12) {
                ZStack {
                    // Use simple 3D-like character
                    EmberSimple3DCharacters(
                        character: character,
                        size: 60,
                        isAnimating: isSelected
                    )
                    
                    if isSelected {
                        VStack {
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(.green)
                                    .frame(width: 16, height: 16)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 8, weight: .bold))
                                            .foregroundStyle(.white)
                                    )
                            }
                            Spacer()
                        }
                    }
                }
                
                Text(name)
                    .emberCaption()
            }
            .frame(width: 80)
            .padding(12)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? EmberColors.roseQuartz : EmberColors.border, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? EmberColors.roseQuartz.opacity(0.2) : .clear, radius: isSelected ? 4 : 0)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Account Section
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Love Connection")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Text("Manage your romantic bond")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            
            VStack(spacing: 12) {
                settingsRow(
                    icon: "person.fill",
                    title: "Edit Love Profile",
                    subtitle: "Update your romantic information",
                    color: EmberColors.roseQuartz,
                    action: { showingProfileEdit = true }
                )
                
                settingsRow(
                    icon: "link",
                    title: "Heart Connection",
                    subtitle: "Manage your bond with Alex 💕",
                    color: EmberColors.peachyKeen,
                    action: { showingPartnerConnection = true }
                )
                
                settingsRow(
                    icon: "crown.fill",
                    title: "Premium Love Experience",
                    subtitle: "Unlock exclusive romantic features",
                    color: .yellow,
                    action: { showingPremium = true },
                    showBadge: true
                )
            }
        }
    }
    
    // MARK: - App Settings Section
    private var appSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Love Experience")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Text("Customize how love feels")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            
            VStack(spacing: 12) {
                settingsRow(
                    icon: "bell.fill",
                    title: "Love Notifications",
                    subtitle: "Sweet alerts and romantic reminders",
                    color: EmberColors.coralPop,
                    action: { showingNotificationSettings = true }
                )
                
                settingsRow(
                    icon: "paintbrush.fill",
                    title: "Love Themes",
                    subtitle: "Make your app as beautiful as your love",
                    color: EmberColors.lavenderMist,
                    action: { showingThemes = true }
                )
                
                settingsRow(
                    icon: "slider.horizontal.3",
                    title: "Love Preferences",
                    subtitle: "Personalize your romantic experience",
                    color: EmberColors.peachyKeen,
                    action: { showingPreferences = true }
                )
            }
            
            // Toggle Settings
            VStack(spacing: 12) {
                toggleRow(
                    icon: "speaker.wave.2.fill",
                    title: "Love Sounds",
                    subtitle: "Hear the magic of your connection",
                    color: EmberColors.coralPop,
                    isOn: $soundEnabled
                )
                
                toggleRow(
                    icon: "iphone.radiowaves.left.and.right",
                    title: "Feel Every Touch",
                    subtitle: "Experience your partner's love through haptics",
                    color: EmberColors.roseQuartz,
                    isOn: $hapticFeedback
                )
            }
        }
    }
    
    // MARK: - Support Section
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Love Support")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Text("We're here to help your love grow")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            
            VStack(spacing: 12) {
                settingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Love Help & Support",
                    subtitle: "Get help with your romantic journey",
                    color: EmberColors.peachyKeen,
                    action: { showingSupport = true }
                )
                
                settingsRow(
                    icon: "lock.shield.fill",
                    title: "Love Privacy & Security",
                    subtitle: "Keep your intimate moments safe",
                    color: EmberColors.lavenderMist,
                    action: { showingPrivacy = true }
                )
                
                // App Version
                HStack {
                    HStack(spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(EmberColors.textSecondary)
                            .frame(width: 44, height: 44)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ember Love App")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(EmberColors.textPrimary)
                            
                            Text("v1.0.0 - Spreading love through touch 💕")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(EmberColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                }
                .padding(16)
                .background(EmberColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
            }
        }
    }
    
    private func settingsRow(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void, showBadge: Bool = false) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .emberLabel()
                        if showBadge {
                            Text("NEW")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.yellow)
                                .clipShape(Capsule())
                        }
                    }
                    Text(subtitle)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(EmberColors.textTertiary)
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
    
    private func toggleRow(icon: String, title: String, subtitle: String, color: Color, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .emberLabel()
                Text(subtitle)
                    .emberCaption(color: EmberColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .tint(color)
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
}

#Preview {
    EmberProfileView()
}