import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var notificationManager: CoupleNotificationManager
    @State private var showingSettings = false
    @State private var showingTouchCanvas = false
    @State private var showingStatusPicker = false
    @State private var showingNotifications = false
    @State private var currentUserStatus = UserStatus()
    @State private var partnerStatus = UserStatus(status: .romantic, customMessage: "Missing you! 💕")
    @State private var currentStreak = 12
    @State private var todayTouches = 8
    @State private var goalTouches = 10
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Enhanced Header with Status
                        EnhancedHeaderView(userStatus: currentUserStatus, partnerStatus: partnerStatus)
                        
                        // Heart Connection Display with Status
                        HeartConnectionView(userStatus: currentUserStatus, partnerStatus: partnerStatus)
                        
                        // Today's Progress
                        TodayProgressView(current: todayTouches, goal: goalTouches, streak: currentStreak)
                        
                        // Touch Actions - Primary CTA
                        PremiumTouchActionsView(showingTouchCanvas: $showingTouchCanvas)
                        
                        // Quick Gestures - Secondary Actions
                        PremiumGestureLibraryView()
                        
                        // Love Notes Section
                        LoveNotesSection()
                        
                        // Recent Activity
                        RecentActivitySection()
                        
                        // Partner's Last Activity
                        PartnerActivitySection(partnerStatus: partnerStatus)
                        
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
                    NotificationBellView(showingNotifications: $showingNotifications)
                }
                
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("TouchSync")
                            .font(.headline.weight(.semibold))
                        Text("Connected")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingStatusPicker = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: currentUserStatus.status.icon)
                                .font(.caption2)
                                .foregroundStyle(currentUserStatus.status.color)
                            
                            Text(currentUserStatus.status.displayName)
                                .font(.caption.weight(.medium))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(currentUserStatus.status.color.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $showingNotifications) {
            NotificationCenterView()
        }
        .fullScreenCover(isPresented: $showingTouchCanvas) {
            TouchCanvasView()
        }
        .sheet(isPresented: $showingStatusPicker) {
            StatusPickerSheet(currentStatus: $currentUserStatus)
        }
    }
}

// MARK: - Enhanced Components

struct EnhancedHeaderView: View {
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
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(greeting)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text("Ready to connect?")
                        .font(.title2.weight(.semibold))
                }
                
                Spacer()
                
                // Connection strength indicator
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(ColorPalette.crimson)
                            .frame(width: 4, height: 4)
                            .opacity(index < 3 ? 1.0 : 0.3)
                    }
                    
                    Text("Strong")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
            }
        }
    }
}

struct HeartConnectionView: View {
    let userStatus: UserStatus
    let partnerStatus: UserStatus
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Status cards with characters
            HStack(spacing: 20) {
                // User status card
                VStack(spacing: 12) {
                    CuteCharacter(
                        character: .touchy,
                        size: 70,
                        customization: CharacterCustomization(
                            colorTheme: .blue,
                            accessory: .none,
                            expression: statusToExpression(userStatus.status),
                            name: "My Heart"
                        ),
                        isAnimating: true
                    )
                    
                    VStack(spacing: 4) {
                        Text("You")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: userStatus.status.icon)
                                .font(.caption2)
                                .foregroundStyle(userStatus.status.color)
                            
                            Text(userStatus.status.displayName)
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.primary)
                        }
                        
                        if let message = userStatus.customMessage {
                            Text(message)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                
                // Connection indicator
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(ColorPalette.roseGold.opacity(0.3), lineWidth: 2)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(ColorPalette.crimson)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                    }
                    
                    Text("12")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.secondary)
                }
                
                // Partner status card
                VStack(spacing: 12) {
                    CuteCharacter(
                        character: .syncee,
                        size: 70,
                        customization: CharacterCustomization(
                            colorTheme: .pink,
                            accessory: .flower,
                            expression: statusToExpression(partnerStatus.status),
                            name: "Partner's Heart"
                        ),
                        isAnimating: true
                    )
                    
                    VStack(spacing: 4) {
                        Text("Partner")
                            .font(.caption.weight(.medium))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Image(systemName: partnerStatus.status.icon)
                                .font(.caption2)
                                .foregroundStyle(partnerStatus.status.color)
                            
                            Text(partnerStatus.status.displayName)
                                .font(.caption2.weight(.medium))
                                .foregroundColor(.primary)
                        }
                        
                        if let message = partnerStatus.customMessage {
                            Text(message)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
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
        case .available: return .happy
        case .busy: return .waiting
        case .sleeping: return .sleeping
        case .romantic: return .romantic
        case .missing: return .sad
        case .excited: return .excited
        case .working: return .waiting
        case .relaxing: return .warmSmile
        case .feelingBlue: return .sad
        case .thatTimeOfMonth: return .sad
        case .underTheWeather: return .sad
        }
    }
}

struct TodayProgressView: View {
    let current: Int
    let goal: Int
    let streak: Int
    
    private var progress: Double {
        min(Double(current) / Double(goal), 1.0)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Today's Connection")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(ColorPalette.crimson)
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(ColorPalette.iconGradient)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 8)
            
            // Stats grid
            HStack(spacing: 16) {
                StatCard(title: "Sent", value: "\(current)", subtitle: "touches", color: ColorPalette.crimson)
                StatCard(title: "Streak", value: "\(streak)", subtitle: "days", color: ColorPalette.sunsetOrange)
                StatCard(title: "Goal", value: "\(goal)", subtitle: "daily", color: ColorPalette.goldenYellow)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct PremiumTouchActionsView: View {
    @Binding var showingTouchCanvas: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Send Touch")
                    .font(.headline.weight(.semibold))
                
                Spacer()
            }
            
            Button(action: { showingTouchCanvas = true }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(ColorPalette.sensualRed.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "hand.draw.fill")
                            .font(.title2)
                            .foregroundStyle(ColorPalette.sensualRed)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Touch Canvas")
                            .font(.headline.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        Text("Draw your touch with your finger")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(20)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}

struct PremiumGestureLibraryView: View {
    let gestures = [
        ("heart.fill", "Kiss", ColorPalette.sensualRed),
        ("hands.sparkles.fill", "Hug", ColorPalette.sunsetOrange),
        ("hand.wave.fill", "Wave", ColorPalette.passionRed),
        ("bolt.heart.fill", "Love", ColorPalette.goldenYellow)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Gestures")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Text("Tap to send")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(Array(gestures.enumerated()), id: \.offset) { index, gesture in
                    Button(action: {
                        HapticsManager.shared.playGesture(HapticGesture.allGestures[index])
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(gesture.2.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: gesture.0)
                                    .font(.title3)
                                    .foregroundStyle(gesture.2)
                            }
                            
                            Text(gesture.1)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.primary)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct LoveNotesSection: View {
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
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Button("Write One") {
                    showingLoveNotes = true
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(ColorPalette.crimson)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(loveNotes.enumerated()), id: \.offset) { index, note in
                        LoveNoteCard(note: note, isFromPartner: index % 2 == 0)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .sheet(isPresented: $showingLoveNotes) {
            LoveNoteComposerView()
        }
    }
}

struct LoveNoteCard: View {
    let note: String
    let isFromPartner: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(note)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Text(isFromPartner ? "From your love" : "From you")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 160)
        .padding(16)
        .background(
            LinearGradient(
                colors: isFromPartner ? 
                    [ColorPalette.roseGold.opacity(0.2), ColorPalette.crimson.opacity(0.1)] :
                    [ColorPalette.goldenYellow.opacity(0.2), ColorPalette.sunsetOrange.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct RecentActivitySection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Touches")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Button("View All") {}
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(ColorPalette.crimson)
            }
            
            VStack(spacing: 8) {
                ActivityRow(type: "Hug", time: "2 min ago", isReceived: true, icon: "hands.sparkles.fill")
                ActivityRow(type: "Kiss", time: "5 min ago", isReceived: false, icon: "heart.fill")
                ActivityRow(type: "Heart Trace", time: "12 min ago", isReceived: true, icon: "scribble.variable")
            }
        }
    }
}

struct ActivityRow: View {
    let type: String
    let time: String
    let isReceived: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(isReceived ? ColorPalette.roseGold.opacity(0.2) : ColorPalette.crimson.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(isReceived ? ColorPalette.roseGold : ColorPalette.crimson)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(type)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                
                Text(isReceived ? "Received from partner" : "Sent to partner")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}

struct PartnerActivitySection: View {
    let partnerStatus: UserStatus
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Partner Activity")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(.green)
                        .frame(width: 6, height: 6)
                    
                    Text("Online")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.green)
                }
            }
            
            HStack(spacing: 12) {
                CuteCharacter(
                    character: .syncee,
                    size: 40,
                    customization: CharacterCustomization(
                        colorTheme: .pink,
                        accessory: .flower,
                        expression: statusToExpression(partnerStatus.status),
                        name: "Partner's Heart"
                    ),
                    isAnimating: true
                )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Currently \(partnerStatus.status.displayName.lowercased())")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    if let message = partnerStatus.customMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("Last seen: Just now")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundStyle(ColorPalette.crimson)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(partnerStatus.status.color.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private func statusToExpression(_ status: CoupleStatus) -> CharacterExpression {
        switch status {
        case .available: return .happy
        case .busy: return .waiting
        case .sleeping: return .sleeping
        case .romantic: return .romantic
        case .missing: return .sad
        case .excited: return .excited
        case .working: return .waiting
        case .relaxing: return .warmSmile
        case .feelingBlue: return .sad
        case .thatTimeOfMonth: return .sad
        case .underTheWeather: return .sad
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(MockAuthManager())
}