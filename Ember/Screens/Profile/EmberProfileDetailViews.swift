import SwiftUI

// MARK: - Profile Edit View
struct EmberProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = "Sarah"
    @State private var lastName = "Johnson"
    @State private var email = "sarah@example.com"
    @State private var birthday = Date()
    @State private var bio = "Love spending time with my amazing partner! ❤️"
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Photo Section
                    profilePhotoSection
                    
                    // Basic Info Section
                    basicInfoSection
                    
                    // Bio Section
                    bioSection
                    
                    // Save Button
                    saveButton
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Edit Profile")
                        .emberHeadline()
                }
            }
        }
    }
    
    private var profilePhotoSection: some View {
        VStack(spacing: 16) {
            Button(action: { showingImagePicker = true }) {
                ZStack {
                    Circle()
                        .fill(EmberColors.roseQuartz.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    EmberCharacterView(
                        character: .touchy,
                        size: 80,
                        expression: .happy,
                        isAnimating: true
                    )
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(EmberColors.roseQuartz)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            
            Text("Tap to change photo")
                .emberCaption(color: EmberColors.textSecondary)
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .emberHeadline()
            
            VStack(spacing: 16) {
                inputField(title: "First Name", text: $firstName)
                inputField(title: "Last Name", text: $lastName)
                inputField(title: "Email", text: $email)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Birthday")
                        .emberLabel()
                    
                    DatePicker("", selection: $birthday, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(12)
                        .background(EmberColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About You")
                .emberHeadline()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Bio")
                    .emberLabel()
                
                TextEditor(text: $bio)
                    .frame(minHeight: 100)
                    .padding(12)
                    .background(EmberColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(EmberColors.border, lineWidth: 1)
                    )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveProfile) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Save Changes")
            }
            .emberLabel(color: .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(EmberColors.roseQuartz)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    private func inputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .emberLabel()
            
            TextField("", text: text)
                .textFieldStyle(.plain)
                .padding(12)
                .background(EmberColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(EmberColors.border, lineWidth: 1)
                )
        }
    }
    
    private func saveProfile() {
        EmberHapticsManager.shared.playMedium()
        // Save profile logic here
        dismiss()
    }
}

// MARK: - Partner Connection View
struct EmberPartnerConnectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var connectionCode = "EMBER-2024"
    @State private var partnerName = "Alex"
    @State private var isConnected = true
    @State private var showingDisconnectAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Connection Status
                    connectionStatusSection
                    
                    // Partner Info
                    if isConnected {
                        partnerInfoSection
                    }
                    
                    // Connection Actions
                    connectionActionsSection
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Partner Connection")
                        .emberHeadline()
                }
            }
        }
        .alert("Disconnect Partner?", isPresented: $showingDisconnectAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Disconnect", role: .destructive) {
                disconnectPartner()
            }
        } message: {
            Text("This will end your connection with \(partnerName). You can reconnect later.")
        }
    }
    
    private var connectionStatusSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(isConnected ? EmberColors.success.opacity(0.1) : EmberColors.error.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: isConnected ? "heart.fill" : "heart.slash.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(isConnected ? EmberColors.success : EmberColors.error)
            }
            
            VStack(spacing: 8) {
                Text(isConnected ? "Connected" : "Not Connected")
                    .emberHeadline(color: isConnected ? EmberColors.success : EmberColors.error)
                
                if isConnected {
                    Text("You and \(partnerName) are connected")
                        .emberBody(color: EmberColors.textSecondary)
                        .multilineTextAlignment(.center)
                } else {
                    Text("Share your connection code to connect with your partner")
                        .emberBody(color: EmberColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(24)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var partnerInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Partner Information")
                .emberHeadline()
            
            HStack(spacing: 16) {
                Circle()
                    .fill(EmberColors.peachyKeen.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        EmberCharacterView(
                            character: .syncee,
                            size: 45,
                            expression: .happy,
                            isAnimating: true
                        )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(partnerName)
                        .emberLabel()
                    Text("Connected 89 days ago")
                        .emberCaption(color: EmberColors.textSecondary)
                    Text("Last active: 2 minutes ago")
                        .emberCaption(color: EmberColors.success)
                }
                
                Spacer()
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var connectionActionsSection: some View {
        VStack(spacing: 16) {
            // Connection Code
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Connection Code")
                    .emberHeadline()
                
                HStack {
                    Text(connectionCode)
                        .emberLabel()
                        .padding(12)
                        .background(EmberColors.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    Button(action: copyConnectionCode) {
                        Image(systemName: "doc.on.doc.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(EmberColors.roseQuartz)
                    }
                }
                
                Text("Share this code with your partner to connect")
                    .emberCaption(color: EmberColors.textSecondary)
            }
            
            // Action Buttons
            VStack(spacing: 12) {
                if isConnected {
                    Button(action: { showingDisconnectAlert = true }) {
                        HStack {
                            Image(systemName: "link.badge.minus")
                            Text("Disconnect Partner")
                        }
                        .emberLabel(color: .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(EmberColors.error)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                } else {
                    Button(action: connectPartner) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Connect Partner")
                        }
                        .emberLabel(color: .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(EmberColors.roseQuartz)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func copyConnectionCode() {
        EmberHapticsManager.shared.playLight()
        // Copy to clipboard logic
    }
    
    private func connectPartner() {
        EmberHapticsManager.shared.playMedium()
        // Connect partner logic
    }
    
    private func disconnectPartner() {
        EmberHapticsManager.shared.playMedium()
        isConnected = false
    }
}

// MARK: - Premium View
struct EmberPremiumView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PremiumPlan = .monthly
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Premium Header
                    premiumHeader
                    
                    // Features List
                    featuresSection
                    
                    // Pricing Plans
                    pricingSection
                    
                    // Subscribe Button
                    subscribeButton
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.yellow)
                        Text("Premium")
                            .emberHeadline()
                    }
                }
            }
        }
    }
    
    private var premiumHeader: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.yellow.opacity(0.3), .orange.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "crown.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.yellow)
            }
            
            VStack(spacing: 12) {
                Text("Unlock Premium")
                    .emberHeadline()
                
                Text("Get access to exclusive features and enhance your connection")
                    .emberBody(color: EmberColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(24)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(LinearGradient(
                    colors: [.yellow.opacity(0.3), .orange.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 2)
        )
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Premium Features")
                .emberHeadline()
            
            VStack(spacing: 12) {
                premiumFeature(icon: "mic.fill", title: "Voice Messages", description: "Send voice notes to your partner")
                premiumFeature(icon: "location.fill", title: "Location Sharing", description: "Share your location in real-time")
                premiumFeature(icon: "star.fill", title: "Milestone Tracking", description: "Create and track special moments")
                premiumFeature(icon: "cloud.fill", title: "Cloud Backup", description: "Never lose your memories")
                premiumFeature(icon: "wand.and.stars", title: "AI Highlights", description: "Auto-generated memory highlights")
                premiumFeature(icon: "heart.fill", title: "Advanced Patterns", description: "Unlock premium touch patterns")
            }
        }
    }
    
    private func premiumFeature(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.yellow)
                .frame(width: 40, height: 40)
                .background(.yellow.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .emberLabel()
                Text(description)
                    .emberCaption(color: EmberColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 20))
                .foregroundStyle(.green)
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var pricingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose Your Plan")
                .emberHeadline()
            
            VStack(spacing: 12) {
                pricingPlan(.monthly, price: "$4.99", period: "per month", savings: nil)
                pricingPlan(.yearly, price: "$39.99", period: "per year", savings: "Save 33%")
            }
        }
    }
    
    private func pricingPlan(_ plan: PremiumPlan, price: String, period: String, savings: String?) -> some View {
        Button(action: { selectedPlan = plan }) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(plan.title)
                            .emberLabel()
                        if let savings = savings {
                            Text(savings)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.green)
                                .clipShape(Capsule())
                        }
                    }
                    Text(period)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Text(price)
                    .emberHeadlineSmall()
                
                Circle()
                    .fill(selectedPlan == plan ? EmberColors.roseQuartz : EmberColors.border)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(selectedPlan == plan ? 1 : 0)
                    )
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPlan == plan ? EmberColors.roseQuartz : EmberColors.border, lineWidth: selectedPlan == plan ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var subscribeButton: some View {
        Button(action: subscribeToPremium) {
            HStack {
                Image(systemName: "crown.fill")
                    .foregroundStyle(.yellow)
                Text("Start Premium - \(selectedPlan.price)")
            }
            .emberLabel(color: .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(EmberColors.roseQuartz)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    private func subscribeToPremium() {
        EmberHapticsManager.shared.playMedium()
        // Subscription logic here
        dismiss()
    }
}

enum PremiumPlan: CaseIterable {
    case monthly, yearly
    
    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        }
    }
    
    var price: String {
        switch self {
        case .monthly: return "$4.99"
        case .yearly: return "$39.99"
        }
    }
}

// MARK: - Additional Views (Simplified)
struct EmberPreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var autoConnect = true
    @State private var showOnlineStatus = true
    @State private var allowScreenshots = false
    @State private var dataUsage: DataUsage = .wifi
    @State private var language: AppLanguage = .english
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Connection Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Connection")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            toggleSetting("Auto-connect on launch", isOn: $autoConnect)
                            toggleSetting("Show online status", isOn: $showOnlineStatus)
                        }
                    }
                    
                    // Privacy Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Privacy")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            toggleSetting("Allow screenshots", isOn: $allowScreenshots)
                        }
                    }
                    
                    // Data & Storage
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Data & Storage")
                            .emberHeadline()
                        
                        pickerSetting("Data usage", selection: $dataUsage, options: DataUsage.self)
                    }
                    
                    // Language
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Language")
                            .emberHeadline()
                        
                        pickerSetting("App language", selection: $language, options: AppLanguage.self)
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Preferences")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { savePreferences() }
                }
            }
        }
    }
    
    private func toggleSetting(_ title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .emberLabel()
            Spacer()
            Toggle("", isOn: isOn)
                .tint(EmberColors.roseQuartz)
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func pickerSetting<T: CaseIterable & Hashable & RawRepresentable>(_ title: String, selection: Binding<T>, options: T.Type) -> some View where T.RawValue == String {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .emberLabel()
            
            Picker("", selection: selection) {
                ForEach(Array(options.allCases), id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func savePreferences() {
        EmberHapticsManager.shared.playMedium()
        dismiss()
    }
}

enum DataUsage: String, CaseIterable {
    case wifiOnly = "Wi-Fi Only"
    case wifi = "Wi-Fi + Cellular"
    case always = "Always"
}

enum AppLanguage: String, CaseIterable {
    case english = "English"
    case spanish = "Spanish"
    case french = "French"
}

struct EmberNotificationSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var touchNotifications = true
    @State private var messageNotifications = true
    @State private var dailyReminders = true
    @State private var weeklyStats = false
    @State private var partnerOnline = true
    @State private var soundEnabled = true
    @State private var vibrationEnabled = true
    @State private var quietHours = false
    @State private var quietStart = Date()
    @State private var quietEnd = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Touch Notifications
                    notificationSection("Touch Notifications", [
                        ("Touch alerts", $touchNotifications),
                        ("Message notifications", $messageNotifications)
                    ])
                    
                    // Reminders
                    notificationSection("Reminders", [
                        ("Daily connection reminders", $dailyReminders),
                        ("Weekly relationship stats", $weeklyStats)
                    ])
                    
                    // Partner Activity
                    notificationSection("Partner Activity", [
                        ("When partner comes online", $partnerOnline)
                    ])
                    
                    // Notification Style
                    notificationSection("Notification Style", [
                        ("Sound", $soundEnabled),
                        ("Vibration", $vibrationEnabled)
                    ])
                    
                    // Quiet Hours
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quiet Hours")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            toggleSetting("Enable quiet hours", isOn: $quietHours)
                            
                            if quietHours {
                                timeSetting("Start time", time: $quietStart)
                                timeSetting("End time", time: $quietEnd)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Notifications")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveSettings() }
                }
            }
        }
    }
    
    private func notificationSection(_ title: String, _ settings: [(String, Binding<Bool>)]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .emberHeadline()
            
            VStack(spacing: 12) {
                ForEach(Array(settings.enumerated()), id: \.offset) { _, setting in
                    toggleSetting(setting.0, isOn: setting.1)
                }
            }
        }
    }
    
    private func toggleSetting(_ title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .emberLabel()
            Spacer()
            Toggle("", isOn: isOn)
                .tint(EmberColors.roseQuartz)
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func timeSetting(_ title: String, time: Binding<Date>) -> some View {
        HStack {
            Text(title)
                .emberLabel()
            Spacer()
            DatePicker("", selection: time, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func saveSettings() {
        EmberHapticsManager.shared.playMedium()
        dismiss()
    }
}

struct EmberThemesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTheme: AppTheme = .ember
    @State private var selectedAccent: AccentColor = .roseQuartz
    @State private var darkMode: DarkModePreference = .system
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App Theme
                    VStack(alignment: .leading, spacing: 16) {
                        Text("App Theme")
                            .emberHeadline()
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(AppTheme.allCases, id: \.self) { theme in
                                themeCard(theme)
                            }
                        }
                    }
                    
                    // Accent Color
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Accent Color")
                            .emberHeadline()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(AccentColor.allCases, id: \.self) { accent in
                                    accentColorButton(accent)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Dark Mode
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Dark Mode")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            ForEach(DarkModePreference.allCases, id: \.self) { mode in
                                darkModeOption(mode)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Themes")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { saveTheme() }
                }
            }
        }
    }
    
    private func themeCard(_ theme: AppTheme) -> some View {
        Button(action: { selectedTheme = theme }) {
            VStack(spacing: 12) {
                // Theme Preview
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.primaryColor.opacity(0.2))
                    .frame(height: 80)
                    .overlay(
                        VStack(spacing: 4) {
                            Circle()
                                .fill(theme.primaryColor)
                                .frame(width: 20, height: 20)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<3) { _ in
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(theme.secondaryColor)
                                        .frame(width: 16, height: 4)
                                }
                            }
                        }
                    )
                
                VStack(spacing: 4) {
                    Text(theme.name)
                        .emberLabel()
                    Text(theme.description)
                        .emberCaption(color: EmberColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedTheme == theme ? EmberColors.roseQuartz : EmberColors.border, lineWidth: selectedTheme == theme ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func accentColorButton(_ accent: AccentColor) -> some View {
        Button(action: { selectedAccent = accent }) {
            VStack(spacing: 8) {
                Circle()
                    .fill(accent.color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle()
                            .stroke(.white, lineWidth: selectedAccent == accent ? 3 : 0)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                Text(accent.name)
                    .emberCaption()
            }
        }
        .buttonStyle(.plain)
    }
    
    private func darkModeOption(_ mode: DarkModePreference) -> some View {
        Button(action: { darkMode = mode }) {
            HStack(spacing: 12) {
                Image(systemName: mode.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(mode.color)
                    .frame(width: 44, height: 44)
                    .background(mode.color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.title)
                        .emberLabel()
                    Text(mode.description)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Circle()
                    .fill(darkMode == mode ? EmberColors.roseQuartz : EmberColors.border)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(darkMode == mode ? 1 : 0)
                    )
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    private func saveTheme() {
        EmberHapticsManager.shared.playMedium()
        // Save theme preferences
        dismiss()
    }
}

enum AppTheme: CaseIterable {
    case ember, sunset, ocean, forest
    
    var name: String {
        switch self {
        case .ember: return "Ember"
        case .sunset: return "Sunset"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        }
    }
    
    var description: String {
        switch self {
        case .ember: return "Warm & romantic"
        case .sunset: return "Golden & vibrant"
        case .ocean: return "Cool & calming"
        case .forest: return "Natural & earthy"
        }
    }
    
    var primaryColor: Color {
        switch self {
        case .ember: return EmberColors.roseQuartz
        case .sunset: return .orange
        case .ocean: return .blue
        case .forest: return .green
        }
    }
    
    var secondaryColor: Color {
        switch self {
        case .ember: return EmberColors.peachyKeen
        case .sunset: return .yellow
        case .ocean: return .cyan
        case .forest: return .mint
        }
    }
}

enum AccentColor: CaseIterable {
    case roseQuartz, peachyKeen, coralPop, lavenderMist, ocean, forest
    
    var name: String {
        switch self {
        case .roseQuartz: return "Rose"
        case .peachyKeen: return "Peach"
        case .coralPop: return "Coral"
        case .lavenderMist: return "Lavender"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        }
    }
    
    var color: Color {
        switch self {
        case .roseQuartz: return EmberColors.roseQuartz
        case .peachyKeen: return EmberColors.peachyKeen
        case .coralPop: return EmberColors.coralPop
        case .lavenderMist: return EmberColors.lavenderMist
        case .ocean: return .blue
        case .forest: return .green
        }
    }
}

enum DarkModePreference: CaseIterable {
    case light, dark, system
    
    var title: String {
        switch self {
        case .light: return "Light Mode"
        case .dark: return "Dark Mode"
        case .system: return "System"
        }
    }
    
    var description: String {
        switch self {
        case .light: return "Always use light appearance"
        case .dark: return "Always use dark appearance"
        case .system: return "Match system settings"
        }
    }
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "gear"
        }
    }
    
    var color: Color {
        switch self {
        case .light: return .yellow
        case .dark: return .purple
        case .system: return EmberColors.textSecondary
        }
    }
}

struct EmberSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingFAQ = false
    @State private var showingContact = false
    @State private var showingTutorial = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Quick Help
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Help")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            supportItem("Frequently Asked Questions", "Get answers to common questions", "questionmark.circle.fill", EmberColors.roseQuartz) {
                                showingFAQ = true
                            }
                            
                            supportItem("App Tutorial", "Learn how to use Ember", "play.circle.fill", EmberColors.peachyKeen) {
                                showingTutorial = true
                            }
                            
                            supportItem("Troubleshooting", "Fix common issues", "wrench.and.screwdriver.fill", EmberColors.coralPop) {
                                // Troubleshooting action
                            }
                        }
                    }
                    
                    // Contact Support
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Support")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            supportItem("Send Feedback", "Share your thoughts with us", "envelope.fill", EmberColors.lavenderMist) {
                                showingContact = true
                            }
                            
                            supportItem("Report a Bug", "Help us improve the app", "ladybug.fill", EmberColors.error) {
                                showingContact = true
                            }
                            
                            supportItem("Feature Request", "Suggest new features", "lightbulb.fill", .yellow) {
                                showingContact = true
                            }
                        }
                    }
                    
                    // Community
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Community")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            supportItem("Join Discord", "Connect with other couples", "message.circle.fill", .purple) {
                                // Discord link
                            }
                            
                            supportItem("Follow on Twitter", "Stay updated with news", "at.circle.fill", .blue) {
                                // Twitter link
                            }
                        }
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Help & Support")
                        .emberHeadline()
                }
            }
        }
        .sheet(isPresented: $showingFAQ) {
            EmberFAQView()
        }
        .sheet(isPresented: $showingContact) {
            EmberContactView()
        }
        .sheet(isPresented: $showingTutorial) {
            EmberTutorialView()
        }
    }
    
    private func supportItem(_ title: String, _ subtitle: String, _ icon: String, _ color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(EmberColors.textTertiary)
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

struct EmberPrivacyView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dataCollection = true
    @State private var analytics = false
    @State private var crashReports = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Data & Privacy
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Data & Privacy")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            privacyItem("Privacy Policy", "Read our privacy policy", "doc.text.fill", EmberColors.roseQuartz) {
                                // Open privacy policy
                            }
                            
                            privacyItem("Terms of Service", "View terms and conditions", "doc.plaintext.fill", EmberColors.peachyKeen) {
                                // Open terms
                            }
                            
                            privacyItem("Data Export", "Download your data", "square.and.arrow.down.fill", EmberColors.coralPop) {
                                // Export data
                            }
                        }
                    }
                    
                    // Privacy Settings
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Privacy Settings")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            toggleSetting("Allow data collection for app improvement", isOn: $dataCollection)
                            toggleSetting("Share anonymous usage analytics", isOn: $analytics)
                            toggleSetting("Send crash reports", isOn: $crashReports)
                        }
                    }
                    
                    // Account Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Account Actions")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "trash.fill")
                                        .foregroundStyle(.white)
                                    Text("Delete Account")
                                        .emberLabel(color: .white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(EmberColors.error)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Privacy & Security")
                        .emberHeadline()
                }
            }
        }
    }
    
    private func privacyItem(_ title: String, _ subtitle: String, _ icon: String, _ color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
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
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(EmberColors.textTertiary)
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    private func toggleSetting(_ title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .emberLabel()
            Spacer()
            Toggle("", isOn: isOn)
                .tint(EmberColors.roseQuartz)
        }
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    EmberProfileEditView()
}
