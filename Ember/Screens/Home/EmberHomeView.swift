import SwiftUI

// MARK: - Ember Home Dashboard
struct EmberHomeView: View {
    @StateObject private var touchRepository = EmberTouchRepository.shared
    @StateObject private var streakManager = EmberStreakManager.shared
    @State private var showingNotifications = false
    @State private var showingTouchCanvas = false
    @State private var showingStatusPicker = false
    @State private var showingAnalytics = false

    @State private var isConnected = true
    @State private var currentUserStatus = UserStatus(status: .available)
    @State private var partnerStatus = UserStatus(status: .romantic, customMessage: "Missing you! 💕")
    
    var body: some View {
        NavigationView {
            ZStack {
                EmberColors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Partner Online Status
                        EmberPartnerOnlineStatusView(partnerStatus: partnerStatus, isConnected: isConnected)
                        
                        // Enhanced Header with Status
                        EmberEnhancedHeaderView(userStatus: currentUserStatus, partnerStatus: partnerStatus)
                        
                        // Heart Connection Display with Characters
                        EmberHeartConnectionView(userStatus: currentUserStatus, partnerStatus: partnerStatus)
                        

                        
                        // Today's Progress with Premium Design (Clickable)
                        EmberTodayProgressView(
                            current: touchRepository.todayTouches,
                            goal: touchRepository.dailyGoal,
                            streak: streakManager.currentStreak
                        )
                        
                        // Touch Actions - Primary CTA
                        EmberPremiumTouchActionsView(showingTouchCanvas: $showingTouchCanvas)
                        
                        // Quick Gestures - Secondary Actions
                        EmberQuickTouchSection(
                            showingTouchCanvas: $showingTouchCanvas,
                            onGestureTap: sendGesture
                        )
                        
                        // Love Notes Section
                        EmberLoveNotesSection()
                        
                        // Heartbeat Sync Section
                        EmberHeartbeatSyncSection()
                        
                        // Voice Messages Section
                        EmberVoiceMessagesSection()
                        
                        // Location Sharing Section
                        EmberLocationSharingSection()
                        
                        // Recent Activity
                        EmberRecentActivitySection()
                        

                        
                        // Bottom spacing for tab bar
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EmberNotificationBellView(showingNotifications: $showingNotifications)
                }
                
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Ember")
                            .emberHeadlineSmall(color: EmberColors.textOnGradient)
                        Text(isConnected ? "Connected" : "Connecting...")
                            .emberCaption(color: EmberColors.textOnGradient.opacity(0.8))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingStatusPicker = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: currentUserStatus.status.icon)
                                .emberIconSmall()
                                .foregroundStyle(currentUserStatus.status.color)
                            
                            Text(currentUserStatus.status.displayName)
                                .emberCaption()
                        }
                        .emberComponentPadding()
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(currentUserStatus.status.color.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
            .toolbarBackground(EmberColors.headerGradient, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .sheet(isPresented: $showingNotifications) {
            EmberNotificationView()
        }
        .fullScreenCover(isPresented: $showingTouchCanvas) {
            EmberTouchCanvasView()
        }
        .sheet(isPresented: $showingStatusPicker) {
            EmberStatusPickerSheet(currentStatus: $currentUserStatus)
        }
        .sheet(isPresented: $showingAnalytics) {
            EmberRelationshipAnalyticsView()
        }

    }
    
    private func sendGesture(_ gestureName: String) {
        guard let partnerId = EmberAuthManager.shared.partnerId else { return }
        
        let touchType: TouchType
        switch gestureName {
        case "Kiss": touchType = .kiss
        case "Hug": touchType = .hug
        case "Wave": touchType = .wave
        case "Love": touchType = .love
        default: touchType = .kiss
        }
        
        touchRepository.sendTouch(touchType, to: partnerId)
        EmberHapticsManager.shared.playSuccess()
    }
}

// MARK: - Partner Online Status View
struct EmberPartnerOnlineStatusView: View {
    let partnerStatus: UserStatus
    let isConnected: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(isConnected ? .green : .orange)
                .frame(width: 8, height: 8)
            
            Text(isConnected ? "Partner is online" : "Partner was online 2 min ago")
                .emberBody(color: EmberColors.textSecondary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: partnerStatus.status.icon)
                    .emberIconSmall()
                    .foregroundStyle(partnerStatus.status.color)
                
                Text(partnerStatus.status.displayName)
                    .emberCaption(color: partnerStatus.status.color)
            }
        }
        .emberComponentPadding()
        .background(EmberColors.surface.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Enhanced Header View
struct EmberEnhancedHeaderView: View {
    let userStatus: UserStatus
    let partnerStatus: UserStatus
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<22: return "Good evening"
        default: return "Good night"
        }
    }
    
    var body: some View {
        EmberGradientCard(gradient: EmberColors.headerGradient) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(greeting)
                            .emberBody(color: EmberColors.textOnGradient.opacity(0.8))
                        
                        Text("Your love awaits")
                            .emberHeadline(color: EmberColors.textOnGradient)
                    }
                    
                    Spacer()
                    
                    // Connection strength indicator
                    HStack(spacing: 6) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(EmberColors.textOnGradient)
                                .frame(width: 4, height: 4)
                                .opacity(index < 3 ? 1.0 : 0.3)
                        }
                        
                        Text("Strong")
                            .emberCaption(color: EmberColors.textOnGradient.opacity(0.8))
                    }
                    .emberComponentPadding()
                    .background(Color.white.opacity(0.2), in: Capsule())
                }
            }
        }
    }
}

// MARK: - Heart Connection View
struct EmberHeartConnectionView: View {
    let userStatus: UserStatus
    let partnerStatus: UserStatus
    @State private var isAnimating = false
    
    var body: some View {
        EmberCard(style: .glassmorphic) {
            HStack(spacing: 20) {
                // User Character (Touchy)
                VStack(spacing: 12) {
                    EmberCharacterView(
                        character: .touchy,
                        size: 70,
                        expression: statusToExpression(userStatus.status),
                        isAnimating: true
                    )
                    
                    VStack(spacing: 4) {
                        Text("You")
                            .emberLabel()
                        
                        HStack(spacing: 4) {
                            Image(systemName: userStatus.status.icon)
                                .emberIconSmall()
                                .foregroundStyle(userStatus.status.color)
                            
                            Text(userStatus.status.displayName)
                                .emberCaption()
                        }
                        
                        if let message = userStatus.customMessage {
                            Text(message)
                                .emberCaption(color: EmberColors.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Connection Indicator
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(EmberColors.peachyKeen.opacity(0.3), lineWidth: 2)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "heart.fill")
                            .emberIconSmall()
                            .foregroundStyle(EmberColors.peachyKeen)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                    }
                    
                    Text("12")
                        .emberCaption(color: EmberColors.textSecondary)
                        .fontWeight(.bold)
                }
                
                // Partner Character (Syncee)
                VStack(spacing: 12) {
                    EmberCharacterView(
                        character: .syncee,
                        size: 70,
                        expression: statusToExpression(partnerStatus.status),
                        isAnimating: true
                    )
                    
                    VStack(spacing: 4) {
                        Text("Partner")
                            .emberLabel()
                        
                        HStack(spacing: 4) {
                            Image(systemName: partnerStatus.status.icon)
                                .emberIconSmall()
                                .foregroundStyle(partnerStatus.status.color)
                            
                            Text(partnerStatus.status.displayName)
                                .emberCaption()
                        }
                        
                        if let message = partnerStatus.customMessage {
                            Text(message)
                                .emberCaption(color: EmberColors.textSecondary)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
    
    private func statusToExpression(_ status: CoupleStatus) -> CharacterExpression {
        switch status {
        case .romantic: return .romantic
        case .missing: return .sad
        case .inLove: return .love
        case .dreaming: return .warmSmile
        case .happy: return .happy
        case .excited: return .excited
        case .peaceful: return .warmSmile
        case .playful: return .happy
        case .available: return .happy
        case .busy: return .waiting
        case .working: return .waiting
        case .relaxing: return .warmSmile
        case .sleeping: return .sleeping
        case .tired: return .sad
        case .energetic: return .excited
        case .cozy: return .warmSmile
        case .underTheWeather: return .sad
        case .grateful: return .happy
        case .nostalgic: return .warmSmile
        case .hopeful: return .happy
        case .content: return .warmSmile
        case .feelingBlue: return .sad
        case .thatTimeOfTheMonth: return .sad
        }
    }
}



// MARK: - Today's Progress View (Clickable)
struct EmberTodayProgressView: View {
    let current: Int
    let goal: Int
    let streak: Int
    @State private var showingAnalytics = false
    
    private var progress: Double {
        min(Double(current) / Double(goal), 1.0)
    }
    
    var body: some View {
        Button(action: { showingAnalytics = true }) {
            EmberCard(style: .elevated) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Today's Connection")
                            .emberHeadline()
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("\(Int(progress * 100))%")
                                .emberHeadlineSmall(color: EmberColors.roseQuartz)
                            
                            Image(systemName: "chevron.right")
                                .emberIconSmall()
                                .foregroundStyle(EmberColors.textSecondary)
                        }
                    }
                    
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(EmberColors.border)
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(EmberColors.primaryGradient)
                                .frame(width: geometry.size.width * progress, height: 8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                        }
                    }
                    .frame(height: 8)
                    
                    // Stats cards
                    HStack(spacing: 12) {
                        EmberStatsCard(
                            title: "Sent",
                            value: "\(current)",
                            subtitle: "touches",
                            color: EmberColors.roseQuartz
                        )
                        
                        EmberStatsCard(
                            title: "Streak",
                            value: "\(streak)",
                            subtitle: "days",
                            color: EmberColors.peachyKeen
                        )
                        
                        EmberStatsCard(
                            title: "Goal",
                            value: "\(goal)",
                            subtitle: "daily",
                            color: EmberColors.coralPop
                        )
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showingAnalytics) {
            EmberRelationshipAnalyticsView()
        }
    }
}

// MARK: - Premium Touch Actions View
struct EmberPremiumTouchActionsView: View {
    @Binding var showingTouchCanvas: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Send Touch")
                    .emberHeadline()
                
                Spacer()
            }
            
            EmberFeatureCard(
                icon: "hand.draw.fill",
                title: "Touch Canvas",
                description: "Draw your touch with your finger"
            ) {
                showingTouchCanvas = true
            }
        }
    }
}

// MARK: - Love Notes Section
struct EmberLoveNotesSection: View {
    @State private var showingLoveNotes = false
    
    private let loveNotes = [
        "Missing your smile today 😊",
        "Can't wait to see you tonight! 💕",
        "You make my heart skip a beat 💓"
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Love Notes")
                    .emberHeadline()
                
                Spacer()
                
                Button("Write One") {
                    showingLoveNotes = true
                }
                .emberBody(color: EmberColors.roseQuartz)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(loveNotes.enumerated()), id: \.offset) { index, note in
                        EmberLoveNoteCard(note: note, isFromPartner: index % 2 == 0)
                    }
                }
                .emberScreenPadding()
            }
        }
        .sheet(isPresented: $showingLoveNotes) {
            EmberLoveNoteComposerView()
        }
    }
}

// MARK: - Recent Activity Section
struct EmberRecentActivitySection: View {
    let activities = [
        ("Hug", "2 min ago", true, "hands.sparkles.fill"),
        ("Kiss", "5 min ago", false, "heart.fill"),
        ("Heart Trace", "12 min ago", true, "scribble.variable"),
        ("Love Note", "1 hour ago", false, "text.bubble.fill")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Activity")
                    .emberHeadline()
                
                Spacer()
                
                Button("View All") {}
                    .emberBody(color: EmberColors.roseQuartz)
            }
            
            EmberCard(style: .elevated) {
                VStack(spacing: 12) {
                    ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                        EmberActivityRow(
                            type: activity.0,
                            time: activity.1,
                            isReceived: activity.2,
                            icon: activity.3
                        )
                        
                        if index < activities.count - 1 {
                            Divider()
                                .background(EmberColors.divider)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Partner Activity Section
struct EmberPartnerActivitySection: View {
    let partnerStatus: UserStatus
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Partner Activity")
                    .emberHeadline()
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 6, height: 6)
                    
                    Text("Online")
                        .emberCaption(color: .green)
                }
            }
            
            EmberCard(style: .elevated) {
                HStack(spacing: 12) {
                    EmberCharacterView(
                        character: .syncee,
                        size: 40,
                        expression: statusToExpression(partnerStatus.status),
                        isAnimating: true
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Currently \(partnerStatus.status.displayName.lowercased())")
                            .emberBody()
                        
                        if let message = partnerStatus.customMessage {
                            Text(message)
                                .emberCaption(color: EmberColors.textSecondary)
                        }
                        
                        Text("Last seen: Just now")
                            .emberCaption(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "heart.fill")
                            .emberIconLarge()
                            .foregroundStyle(EmberColors.roseQuartz)
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(partnerStatus.status.color.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private func statusToExpression(_ status: CoupleStatus) -> CharacterExpression {
        switch status {
        case .romantic: return .romantic
        case .missing: return .sad
        case .inLove: return .love
        case .dreaming: return .warmSmile
        case .happy: return .happy
        case .excited: return .excited
        case .peaceful: return .warmSmile
        case .playful: return .happy
        case .available: return .happy
        case .busy: return .waiting
        case .working: return .waiting
        case .relaxing: return .warmSmile
        case .sleeping: return .sleeping
        case .tired: return .sad
        case .energetic: return .excited
        case .cozy: return .warmSmile
        case .underTheWeather: return .sad
        case .grateful: return .happy
        case .nostalgic: return .warmSmile
        case .hopeful: return .happy
        case .content: return .warmSmile
        case .feelingBlue: return .sad
        case .thatTimeOfTheMonth: return .sad
        }
    }
}

// MARK: - Heartbeat Sync Section
struct EmberHeartbeatSyncSection: View {
    @State private var isHeartbeating = false
    @State private var partnerHeartRate = 72
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Heartbeat Sync")
                    .emberHeadline()
                
                Spacer()
                
                EmberBadge("PREMIUM", style: .info)
            }
            
            EmberCard(style: .glassmorphic) {
                HStack(spacing: 20) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(EmberColors.roseQuartz.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .scaleEffect(isHeartbeating ? 1.1 : 1.0)
                            
                            Image(systemName: "heart.fill")
                                .emberIconLarge()
                                .foregroundStyle(EmberColors.roseQuartz)
                        }
                        
                        Text("\(partnerHeartRate) BPM")
                            .emberBody(color: EmberColors.roseQuartz)
                            .fontWeight(.semibold)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Partner's Heartbeat")
                            .emberTitle()
                        
                        Text("Elevated - thinking of you 💕")
                            .emberCaption(color: EmberColors.textSecondary)
                        
                        Text("Last synced: Just now")
                            .emberCaption(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isHeartbeating = true
            }
        }
    }
}

// MARK: - Voice Messages Section
struct EmberVoiceMessagesSection: View {
    @State private var showingVoiceRecorder = false
    
    private let voiceMessages = [
        ("Good morning, beautiful! 💕", "0:12", false),
        ("Missing your voice today", "0:08", true)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Voice Messages")
                    .emberHeadline()
                
                Spacer()
                
                Button("Record") {
                    showingVoiceRecorder = true
                }
                .emberBody(color: EmberColors.roseQuartz)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(voiceMessages.enumerated()), id: \.offset) { index, message in
                        EmberVoiceMessageCard(
                            message: message.0,
                            duration: message.1,
                            isFromPartner: message.2
                        )
                    }
                }
                .emberScreenPadding()
            }
        }
        .sheet(isPresented: $showingVoiceRecorder) {
            EmberVoiceRecorderView()
        }
    }
}

// MARK: - Voice Message Card
struct EmberVoiceMessageCard: View {
    let message: String
    let duration: String
    let isFromPartner: Bool
    @State private var isPlaying = false
    
    var body: some View {
        Button(action: { isPlaying.toggle() }) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .emberIconSmall()
                        .foregroundStyle(isFromPartner ? EmberColors.peachyKeen : EmberColors.roseQuartz)
                    
                    Text(duration)
                        .emberCaption()
                }
                
                Text(message)
                    .emberCaption(color: EmberColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 140)
            .emberCardPadding()
            .background(
                LinearGradient(
                    colors: isFromPartner ? 
                        [EmberColors.peachyKeen.opacity(0.1), EmberColors.peachyKeen.opacity(0.05)] :
                        [EmberColors.roseQuartz.opacity(0.1), EmberColors.roseQuartz.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Location Sharing Section
struct EmberLocationSharingSection: View {
    @State private var showingLocationPicker = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Location Sharing")
                    .emberHeadline()
                
                Spacer()
                
                Button("Share") {
                    showingLocationPicker = true
                }
                .emberBody(color: EmberColors.roseQuartz)
            }
            
            EmberCard(style: .elevated) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(EmberColors.coralPop.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "location.fill")
                                .emberIconMedium()
                                .foregroundStyle(EmberColors.coralPop)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Partner is at Coffee Bean")
                            .emberBody()
                        
                        Text("Your favorite spot! 2 min ago")
                            .emberCaption(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "arrow.up.right")
                            .emberIconSmall()
                            .foregroundStyle(EmberColors.coralPop)
                    }
                }
            }
        }
        .sheet(isPresented: $showingLocationPicker) {
            EmberLocationPickerView()
        }
    }
}

// MARK: - Voice Recorder View
struct EmberVoiceRecorderView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isRecording = false
    @State private var recordingTime = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(EmberColors.roseQuartz.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .scaleEffect(isRecording ? 1.1 : 1.0)
                        
                        Image(systemName: "mic.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(EmberColors.roseQuartz)
                    }
                    
                    Text(isRecording ? "Recording..." : "Tap to record")
                        .emberHeadline()
                    
                    if isRecording {
                        Text("0:\(String(format: "%02d", recordingTime))")
                            .emberTitle(color: EmberColors.roseQuartz)
                    }
                }
                
                Button(action: { isRecording.toggle() }) {
                    Circle()
                        .fill(isRecording ? .red : EmberColors.roseQuartz)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                                .font(.title)
                                .foregroundStyle(.white)
                        )
                }
                
                Spacer()
            }
            .navigationTitle("Voice Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Location Picker View
struct EmberLocationPickerView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let locations = [
        ("Current Location", "Share where you are now", "location.fill"),
        ("Home", "Let them know you're home safe", "house.fill"),
        ("Work", "Still at the office", "building.2.fill"),
        ("Favorite Spot", "At our special place", "heart.fill")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ForEach(Array(locations.enumerated()), id: \.offset) { index, location in
                    Button(action: { dismiss() }) {
                        HStack(spacing: 16) {
                            Circle()
                                .fill(EmberColors.roseQuartz.opacity(0.2))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: location.2)
                                        .emberIconMedium()
                                        .foregroundStyle(EmberColors.roseQuartz)
                                )
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(location.0)
                                    .emberTitle()
                                
                                Text(location.1)
                                    .emberCaption(color: EmberColors.textSecondary)
                            }
                            
                            Spacer()
                        }
                        .emberCardPadding()
                        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Share Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EmberHomeView()
}
