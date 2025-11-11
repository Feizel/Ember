import SwiftUI
import Combine

// MARK: - Enhanced Ember Home View with TouchSync Features
struct EmberHomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingTouchCanvas = false
    @State private var showingProfile = false
    @State private var showingStatusPicker = false
    @State private var showingNotifications = false
    @State private var showingQuickActions = false
    @State private var showingGestureLibrary = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                EmberColors.background
                    .ignoresSafeArea()
                
                // Main content
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Enhanced Header with Status
                        enhancedHeaderView
                        
                        // Heart Connection Display with Characters
                        heartConnectionView
                        
                        // Today's Progress with Streak
                        todayProgressView
                        
                        // Touch Actions - Primary CTA
                        touchActionsView
                        
                        // Quick Gestures - Haptic Library
                        quickGesturesView
                        
                        // Love Notes Section
                        loveNotesSection
                        
                        // Recent Activity
                        recentActivitySection
                        
                        // Partner's Activity
                        partnerActivitySection
                        
                        // Bottom spacing for FAB
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
                
                // Floating Action Button with Quick Gestures
                floatingActionButton
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    notificationBellButton
                }
                
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Ember")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(EmberColors.textPrimary)
                        Text(viewModel.connectionStatusText)
                            .font(.caption2)
                            .foregroundStyle(EmberColors.textSecondary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    statusButton
                }
            }
            
        }
        .onAppear {
            viewModel.loadHomeData()
            EmberHapticsManager.shared.playLight()
        }
        .sheet(isPresented: $showingNotifications) {
            EmberNotificationView()
        }
        .fullScreenCover(isPresented: $showingTouchCanvas) {
            EmberEnhancedTouchCanvas()
        }
        .sheet(isPresented: $showingStatusPicker) {
            EmberStatusPickerSheet(currentStatus: $viewModel.currentUserStatus)
        }

    }
    
    // MARK: - Heart Connection View
    private var heartConnectionView: some View {
        VStack(spacing: 24) {
            // Connection title
            HStack {
                Text("Your Love Connection")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Spacer()
                
                // Days together counter
                VStack(spacing: 2) {
                    Text("247")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(EmberColors.roseQuartz)
                    Text("days")
                        .font(.caption2)
                        .foregroundStyle(EmberColors.textSecondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(EmberColors.roseQuartz.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            }
            
            // Enhanced character connection
            ZStack {
                // Background glow
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                EmberColors.roseQuartz.opacity(0.05),
                                EmberColors.peachyKeen.opacity(0.05),
                                EmberColors.coralPop.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        EmberColors.roseQuartz.opacity(0.3),
                                        EmberColors.peachyKeen.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                VStack(spacing: 20) {
                    HStack(spacing: 0) {
                        // User character with premium styling
                        VStack(spacing: 16) {
                            ZStack {
                                // Character glow
                                Circle()
                                    .fill(EmberColors.roseQuartz.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .blur(radius: 8)
                                
                                // Use simple 3D-like character
                                EmberSimple3DCharacters(
                                    character: .touchy,
                                    size: 80,
                                    isAnimating: true
                                )
                                .shadow(color: EmberColors.roseQuartz.opacity(0.4), radius: 16, x: 0, y: 8)
                            }
                            
                            VStack(spacing: 6) {
                                Text("The Wolf")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(EmberColors.textPrimary)
                                
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 8, height: 8)
                                        .scaleEffect(viewModel.connectionPulse ? 1.2 : 1.0)
                                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                                    
                                    Text("Available & Loving")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(EmberColors.textSecondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Premium connection beam
                        ZStack {
                            // Animated love beam
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            EmberColors.roseQuartz.opacity(0.6),
                                            EmberColors.peachyKeen.opacity(0.8),
                                            EmberColors.roseQuartz.opacity(0.6)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 60, height: 3)
                                .clipShape(Capsule())
                                .scaleEffect(x: viewModel.connectionPulse ? 1.1 : 0.9, y: 1)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                            
                            // Floating hearts along the beam
                            HStack(spacing: 15) {
                                ForEach(0..<3) { index in
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 8))
                                        .foregroundStyle(EmberColors.roseQuartz)
                                        .scaleEffect(viewModel.connectionPulse ? 1.3 : 1.0)
                                        .opacity(viewModel.connectionPulse ? 1.0 : 0.7)
                                        .animation(
                                            .easeInOut(duration: 1.5)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.3),
                                            value: viewModel.connectionPulse
                                        )
                                }
                            }
                            
                            // Connection strength indicator
                            VStack(spacing: 4) {
                                Text("💕")
                                    .font(.title3)
                                    .scaleEffect(viewModel.connectionPulse ? 1.2 : 1.0)
                                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                                
                                Text("Strong")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(EmberColors.roseQuartz)
                            }
                            .offset(y: -25)
                        }
                        .frame(width: 80)
                        
                        // Partner character with premium styling
                        VStack(spacing: 16) {
                            ZStack {
                                // Character glow
                                Circle()
                                    .fill(EmberColors.peachyKeen.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .blur(radius: 8)
                                
                                // Use simple 3D-like character
                                EmberSimple3DCharacters(
                                    character: .syncee,
                                    size: 80,
                                    isAnimating: true
                                )
                                .shadow(color: EmberColors.peachyKeen.opacity(0.4), radius: 16, x: 0, y: 8)
                            }
                            
                            VStack(spacing: 6) {
                                Text(viewModel.partnerName)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(EmberColors.textPrimary)
                                
                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(.pink)
                                        .frame(width: 8, height: 8)
                                        .scaleEffect(viewModel.connectionPulse ? 1.2 : 1.0)
                                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                                    
                                    Text("Feeling Romantic")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(EmberColors.textSecondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Last interaction with hearts
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundStyle(EmberColors.textSecondary)
                        
                        Text(viewModel.lastTouchText)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(EmberColors.textSecondary)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 6))
                                    .foregroundStyle(EmberColors.roseQuartz.opacity(0.6))
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .padding(24)
            }
        }
        .onAppear {
            viewModel.connectionPulse = true
        }
    }
    
    // MARK: - Toolbar Components
    private var notificationBellButton: some View {
        Button(action: { showingNotifications = true }) {
            ZStack {
                Image(systemName: "bell.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Circle()
                    .fill(EmberColors.roseQuartz)
                    .frame(width: 8, height: 8)
                    .offset(x: 8, y: -8)
            }
        }
    }
    
    private var statusButton: some View {
        Button(action: { showingStatusPicker = true }) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .font(.caption2)
                    .foregroundStyle(EmberColors.roseQuartz)
                
                Text("Available")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(EmberColors.textPrimary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(EmberColors.surface, in: Capsule())
        }
    }
    
    // MARK: - Enhanced Header
    private var enhancedHeaderView: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    // Date display
                    Text(viewModel.currentDateString)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(EmberColors.textSecondary)
                    
                    // Sweet time greeting
                    Text(viewModel.sweetTimeGreeting)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    // Affectionate message
                    Text(viewModel.affectionateMessage)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(EmberColors.textPrimary)
                }
                
                Spacer()
                
                // Connection strength with hearts
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Image(systemName: "heart.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(EmberColors.roseQuartz)
                                .scaleEffect(viewModel.connectionPulse ? 1.2 : 1.0)
                                .animation(
                                    .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: viewModel.connectionPulse
                                )
                        }
                    }
                    
                    Text("Strong Bond")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(EmberColors.roseQuartz)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(EmberColors.roseQuartz.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(EmberColors.roseQuartz.opacity(0.3), lineWidth: 1)
                        )
                )
            }
            
            // Love quote of the day
            HStack {
                Image(systemName: "quote.opening")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
                
                Text(viewModel.loveQuoteOfTheDay)
                    .font(.caption.italic())
                    .foregroundStyle(EmberColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                Image(systemName: "quote.closing")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(EmberColors.surface.opacity(0.5))
            )
        }
    }
    
    // MARK: - Today's Progress
    private var todayProgressView: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today's Love Journey")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    Text("Building your connection, one touch at a time")
                        .font(.caption)
                        .foregroundStyle(EmberColors.textSecondary)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("\(Int(viewModel.connectionProgress * 100))%")
                        .font(.title.weight(.bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Complete")
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(EmberColors.textSecondary)
                }
            }
            
            // Enhanced progress bar with hearts
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    Capsule()
                        .fill(EmberColors.border.opacity(0.3))
                        .frame(height: 12)
                    
                    // Progress fill with gradient
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    EmberColors.roseQuartz,
                                    EmberColors.peachyKeen,
                                    EmberColors.coralPop
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * viewModel.connectionProgress, height: 12)
                        .overlay(
                            // Animated shimmer effect
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, .white.opacity(0.3), .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 30)
                                .offset(x: viewModel.connectionPulse ? geometry.size.width : -30)
                                .animation(.linear(duration: 2.0).repeatForever(autoreverses: false), value: viewModel.connectionPulse)
                        )
                        .clipShape(Capsule())
                    
                    // Heart at progress end
                    if viewModel.connectionProgress > 0 {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.white)
                            .offset(x: (geometry.size.width * viewModel.connectionProgress) - 6, y: 0)
                    }
                }
            }
            .frame(height: 12)
            
            // Enhanced stat cards
            HStack(spacing: 12) {
                EnhancedStatCard(
                    icon: "heart.fill",
                    title: "Love Sent",
                    value: "\(viewModel.touchesToday)",
                    color: EmberColors.roseQuartz
                )
                
                EnhancedStatCard(
                    icon: "flame.fill",
                    title: "Love Streak",
                    value: "12 days",
                    color: EmberColors.peachyKeen
                )
                
                EnhancedStatCard(
                    icon: "target",
                    title: "Daily Goal",
                    value: "\(viewModel.dailyGoal)",
                    color: EmberColors.coralPop
                )
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(EmberColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    EmberColors.roseQuartz.opacity(0.2),
                                    EmberColors.peachyKeen.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    // MARK: - Touch Actions
    private var touchActionsView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Send Touch")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Spacer()
            }
            
            Button(action: { showingTouchCanvas = true }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(EmberColors.roseQuartz.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "hand.draw.fill")
                            .font(.title2)
                            .foregroundStyle(EmberColors.roseQuartz)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Touch Canvas")
                            .font(.headline.weight(.medium))
                            .foregroundStyle(EmberColors.textPrimary)
                        
                        Text("Draw your touch with your finger")
                            .font(.subheadline)
                            .foregroundStyle(EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(EmberColors.textSecondary)
                }
                .padding(20)
                .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Quick Gestures
    private var quickGesturesView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Gestures")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Spacer()
                
                Text("Tap to send")
                    .font(.caption)
                    .foregroundStyle(EmberColors.textSecondary)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(QuickAction.allCases, id: \.self) { action in
                    Button(action: {
                        EmberHapticsManager.shared.playMedium()
                        viewModel.sendQuickAction(action)
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(action.color.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: action.icon)
                                    .font(.title3)
                                    .foregroundStyle(action.color)
                            }
                            
                            Text(action.label)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(EmberColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Love Notes
    private var loveNotesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Love Notes")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(EmberColors.textPrimary)
                
                Spacer()
                
                Button("Write One") {}
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(EmberColors.roseQuartz)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { index in
                        VStack(spacing: 8) {
                            Text("Missing your smile today 😊")
                                .font(.subheadline)
                                .foregroundStyle(EmberColors.textPrimary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                            
                            Text("From your love")
                                .font(.caption2)
                                .foregroundStyle(EmberColors.textSecondary)
                        }
                        .frame(width: 160)
                        .padding(16)
                        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    // MARK: - Recent Activity
    private var recentActivitySection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Love Timeline")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    Text("Your recent moments together")
                        .font(.caption)
                        .foregroundStyle(EmberColors.textSecondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.caption.weight(.semibold))
                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundStyle(EmberColors.roseQuartz)
                }
            }
            
            VStack(spacing: 12) {
                ForEach(viewModel.recentActivities, id: \.id) { activity in
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(activity.color.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            Circle()
                                .fill(activity.color.opacity(0.1))
                                .frame(width: 60, height: 60)
                                .blur(radius: 4)
                            
                            Image(systemName: activity.icon)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(activity.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(EmberColors.textPrimary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.caption2)
                                    .foregroundStyle(EmberColors.textSecondary)
                                
                                Text(activity.timeAgo)
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(EmberColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            ForEach(0..<3) { _ in
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 6))
                                    .foregroundStyle(activity.color.opacity(0.6))
                            }
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(EmberColors.surface)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(activity.color.opacity(0.1), lineWidth: 1)
                            )
                    )
                }
            }
        }
    }
    
    // MARK: - Partner Activity
    private var partnerActivitySection: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(viewModel.partnerName)'s Heart")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    Text("What your love is up to")
                        .font(.caption)
                        .foregroundStyle(EmberColors.textSecondary)
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .scaleEffect(viewModel.connectionPulse ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                    
                    Text("Online & Loving")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.green.opacity(0.1), in: Capsule())
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [
                                EmberColors.peachyKeen.opacity(0.1),
                                EmberColors.roseQuartz.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                LinearGradient(
                                    colors: [EmberColors.peachyKeen.opacity(0.3), EmberColors.roseQuartz.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(EmberColors.peachyKeen.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .blur(radius: 6)
                        
                        EmberSimple3DCharacters(
                            character: .syncee,
                            size: 50,
                            isAnimating: true
                        )
                        .shadow(color: EmberColors.peachyKeen.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Feeling deeply romantic")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(EmberColors.textPrimary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "quote.opening")
                                .font(.caption2)
                                .foregroundStyle(EmberColors.textSecondary)
                            
                            Text("Missing you so much! 💕")
                                .font(.caption.italic())
                                .foregroundStyle(EmberColors.textSecondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption2)
                                .foregroundStyle(EmberColors.textSecondary)
                            
                            Text("Active just now")
                                .font(.caption2.weight(.medium))
                                .foregroundStyle(EmberColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        EmberHapticsManager.shared.playMedium()
                    }) {
                        ZStack {
                            Circle()
                                .fill(EmberColors.roseQuartz.opacity(0.2))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(EmberColors.roseQuartz)
                                .scaleEffect(viewModel.connectionPulse ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
    
    // MARK: - Gesture Library Sheet
    private var gestureLibrarySheet: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(QuickAction.allCases, id: \.self) { action in
                        Button(action: {
                            EmberHapticsManager.shared.playMedium()
                            showingGestureLibrary = false
                        }) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(action.color.opacity(0.2))
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: action.icon)
                                        .font(.title2)
                                        .foregroundStyle(action.color)
                                }
                                
                                VStack(spacing: 4) {
                                    Text(action.label)
                                        .font(.headline.weight(.semibold))
                                        .foregroundStyle(EmberColors.textPrimary)
                                    
                                    Text(action.description)
                                        .font(.caption)
                                        .foregroundStyle(EmberColors.textSecondary)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(EmberColors.background)
            .navigationTitle("Quick Gestures")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingGestureLibrary = false
                    }
                }
            }
        }
    }
    
    // MARK: - Dynamic Background
    private var dynamicBackground: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.05, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating particles
            ParticleSystem(
                type: .floatingHearts,
                isActive: true,
                particleCount: 8
            )
            .opacity(0.3)
            
            // Ambient glow
            RadialGradient(
                colors: [
                    EmberColors.roseQuartz.opacity(0.1),
                    Color.clear
                ],
                center: .topTrailing,
                startRadius: 50,
                endRadius: 300
            )
            .offset(x: scrollOffset * 0.1, y: scrollOffset * 0.05)
        }
    }
    
    // MARK: - Hero Header
    private var heroHeader: some View {
        VStack(spacing: 24) {
            // Top bar with profile and status
            HStack {
                // Time greeting
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.timeGreeting)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text(viewModel.connectionStatusText)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(EmberColors.roseQuartz)
                }
                
                Spacer()
                
                // Profile button with glow
                InteractiveButton(
                    hapticType: .selection,
                    style: .gentle,
                    action: { showingProfile = true }
                ) {
                    ZStack {
                        Circle()
                            .fill(EmberColors.primaryGradient)
                            .frame(width: 48, height: 48)
                            .shadow(color: EmberColors.roseQuartz.opacity(0.5), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Connection pulse indicator
            if viewModel.isConnected {
                connectionPulse
            }
        }
    }
    
    private var connectionPulse: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(EmberColors.roseQuartz.opacity(0.2))
                    .frame(width: 24, height: 24)
                    .scaleEffect(viewModel.connectionPulse ? 1.5 : 1.0)
                    .opacity(viewModel.connectionPulse ? 0 : 1)
                    .animation(.easeOut(duration: 1.5).repeatForever(autoreverses: false), value: viewModel.connectionPulse)
                
                Circle()
                    .fill(EmberColors.roseQuartz)
                    .frame(width: 8, height: 8)
            }
            
            Text("Connected to \(viewModel.partnerName)")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.connectionPulse = true
        }
    }
    
    // MARK: - Connection Status Card
    private var connectionStatusCard: some View {
        GlassmorphicCard(style: .elevated) {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Connection")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text("\(viewModel.touchesToday) of \(viewModel.dailyGoal) touches")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Circular progress
                    ZStack {
                        Circle()
                            .stroke(.white.opacity(0.2), lineWidth: 6)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: viewModel.connectionProgress)
                            .stroke(EmberColors.primaryGradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(response: 0.8, dampingFraction: 0.8), value: viewModel.connectionProgress)
                        
                        Text("\(Int(viewModel.connectionProgress * 100))%")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                
                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.2))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(EmberColors.primaryGradient)
                            .frame(width: geo.size.width * viewModel.connectionProgress, height: 8)
                            .animation(.spring(response: 0.8, dampingFraction: 0.8), value: viewModel.connectionProgress)
                    }
                }
                .frame(height: 8)
            }
            .padding(24)
        }
    }
    
    // MARK: - Characters Interaction Card
    private var charactersInteractionCard: some View {
        GlassmorphicCard(style: .interactive) {
            VStack(spacing: 24) {
                // Characters with connection beam
                HStack(spacing: 0) {
                    // User character
                    VStack(spacing: 12) {
                        InteractiveButton(
                            hapticType: .selection,
                            style: .gentle,
                            action: { viewModel.cycleUserExpression() }
                        ) {
                            BreathingView(intensity: 0.03) {
                                EmberCharacterView(
                                    character: .touchy,
                                    size: 100,
                                    expression: .happy,
                                    isAnimating: true
                                )
                                .shadow(color: EmberColors.roseQuartz.opacity(0.3), radius: 12, x: 0, y: 6)
                            }
                        }
                        
                        VStack(spacing: 4) {
                            Text("You")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 6, height: 6)
                                
                                Text("Available")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Connection beam
                    connectionBeam
                    
                    Spacer()
                    
                    // Partner character
                    VStack(spacing: 12) {
                        BreathingView(intensity: 0.02) {
                            EmberCharacterView(
                                character: .syncee,
                                size: 100,
                                expression: viewModel.partnerExpression,
                                isAnimating: viewModel.isConnected
                            )
                            .shadow(color: EmberColors.peachyKeen.opacity(0.3), radius: 12, x: 0, y: 6)
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.partnerName)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(viewModel.partnerStatus.statusColor)
                                    .frame(width: 6, height: 6)
                                
                                Text(viewModel.partnerStatus.displayText)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                        }
                    }
                }
                
                // Last interaction
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Text(viewModel.lastTouchText)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Spacer()
                }
            }
            .padding(24)
        }
    }
    
    private var connectionBeam: some View {
        ZStack {
            // Animated connection line
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            EmberColors.roseQuartz.opacity(0.8),
                            EmberColors.peachyKeen.opacity(0.8),
                            EmberColors.roseQuartz.opacity(0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .scaleEffect(x: viewModel.connectionPulse ? 1.0 : 0.8, y: 1)
                .opacity(viewModel.connectionPulse ? 1.0 : 0.6)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
            
            // Floating heart
            Image(systemName: "heart.fill")
                .font(.system(size: 16))
                .foregroundStyle(EmberColors.roseQuartz)
                .scaleEffect(viewModel.connectionPulse ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
        }
        .frame(width: 80)
    }
    
    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Quick Touch")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Text("Tap to send")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal, 4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(QuickAction.allCases, id: \.self) { action in
                    quickActionCard(for: action)
                }
            }
        }
    }
    
    private func quickActionCard(for action: QuickAction) -> some View {
        InteractiveButton(
            hapticType: .touch,
            style: .intense,
            action: {
                EmberHapticsManager.shared.playGesture(action.hapticPattern)
                viewModel.sendQuickAction(action)
            }
        ) {
            GlassmorphicCard(style: .subtle) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(action.color.opacity(0.2))
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .stroke(action.color.opacity(0.4), lineWidth: 2)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: action.icon)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(action.color)
                    }
                    
                    VStack(spacing: 4) {
                        Text(action.label)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        Text(action.description)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(20)
            }
        }
    }
    
    // MARK: - Recent Activity Card
    private var recentActivityCard: some View {
        GlassmorphicCard(style: .subtle) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Recent Activity")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button("View All") {
                        // Navigate to activity view
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(EmberColors.roseQuartz)
                }
                
                VStack(spacing: 12) {
                    ForEach(viewModel.recentActivities, id: \.id) { activity in
                        activityRow(activity)
                    }
                }
            }
            .padding(20)
        }
    }
    
    private func activityRow(_ activity: RecentActivity) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(activity.color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: activity.icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(activity.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                
                Text(activity.timeAgo)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Beautiful Circular FAB
    private var floatingActionButton: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                ZStack {
                    // Quick action circles (when expanded)
                    if showingQuickActions {
                        let actions = [("Kiss", "heart.fill", EmberColors.roseQuartz, QuickAction.kiss),
                                     ("Hug", "figure.arms.open", EmberColors.peachyKeen, QuickAction.hug),
                                     ("Wave", "hand.wave.fill", EmberColors.coralPop, QuickAction.wave),
                                     ("Love", "heart.circle.fill", .green, QuickAction.loveTap),
                                     ("More", "ellipsis", EmberColors.textSecondary, QuickAction.missYou)]
                        
                        ForEach(Array(actions.enumerated()), id: \.offset) { index, action in
                            let angle = Double(index) * 72.0 - 90.0 // 5 positions around circle
                            let radius: CGFloat = 100
                            
                            VStack(spacing: 8) {
                                Button(action: {
                                    EmberHapticsManager.shared.playMedium()
                                    if action.0 == "More" {
                                        // Show bottom sheet for more options
                                    } else {
                                        viewModel.sendQuickAction(action.3)
                                    }
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showingQuickActions = false
                                    }
                                }) {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Image(systemName: action.1)
                                                .font(.system(size: 24, weight: .semibold))
                                                .foregroundStyle(action.2)
                                        )
                                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                }
                                .buttonStyle(.plain)
                                
                                Text(action.0)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(.black.opacity(0.7))
                                    )
                            }
                            .offset(
                                x: cos(angle * .pi / 180) * radius,
                                y: sin(angle * .pi / 180) * radius
                            )
                            .scaleEffect(showingQuickActions ? 1.0 : 0.3)
                            .opacity(showingQuickActions ? 1.0 : 0.0)
                            .animation(
                                .spring(response: 0.6, dampingFraction: 0.7)
                                .delay(Double(index) * 0.1),
                                value: showingQuickActions
                            )
                        }
                    }
                    
                    // Main FAB
                    Button(action: {
                        EmberHapticsManager.shared.playMedium()
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingQuickActions.toggle()
                        }
                    }) {
                        ZStack {
                            // Glow effect
                            Circle()
                                .fill(EmberColors.roseQuartz.opacity(0.2))
                                .frame(width: 80, height: 80)
                                .blur(radius: 8)
                                .scaleEffect(viewModel.connectionPulse ? 1.1 : 1.0)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: viewModel.connectionPulse)
                            
                            // Main button
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            EmberColors.roseQuartz,
                                            EmberColors.peachyKeen,
                                            EmberColors.coralPop
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Circle()
                                        .stroke(.white.opacity(0.3), lineWidth: 2)
                                )
                            
                            // Heart icon
                            Image(systemName: showingQuickActions ? "xmark" : "heart.fill")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.white)
                                .scaleEffect(showingQuickActions ? 0.9 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showingQuickActions)
                        }
                        .shadow(
                            color: EmberColors.roseQuartz.opacity(0.4),
                            radius: 12,
                            x: 0,
                            y: 6
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 34)
        }
        .background(
            // Overlay to close when tapping outside
            showingQuickActions ?
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingQuickActions = false
                        }
                    } : nil
        )
    }
    
    private var quickActionsSheet: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(EmberColors.textSecondary.opacity(0.3))
                        .frame(width: 40, height: 6)
                    
                    VStack(spacing: 8) {
                        Text("Send Love")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(EmberColors.textPrimary)
                        
                        Text("Choose how to express your feelings")
                            .font(.subheadline)
                            .foregroundStyle(EmberColors.textSecondary)
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
                
                // Actions list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Touch Gestures Section
                        actionSection(title: "Touch Gestures", actions: [
                            ("Kiss", "heart.fill", "Sweet & gentle kiss", EmberColors.roseQuartz, QuickAction.kiss),
                            ("Hug", "figure.arms.open", "Warm loving embrace", EmberColors.peachyKeen, QuickAction.hug),
                            ("Wave", "hand.wave.fill", "Friendly hello wave", EmberColors.coralPop, QuickAction.wave),
                            ("Love Tap", "hand.tap.fill", "Playful gentle tap", EmberColors.roseQuartz, QuickAction.loveTap)
                        ])
                        
                        // Messages Section
                        actionSection(title: "Messages", actions: [
                            ("Love Note", "heart.text.square.fill", "Write sweet words", EmberColors.peachyKeen, QuickAction.loveNote),
                            ("Miss You", "heart.circle.fill", "I miss you so much", .purple, QuickAction.missYou),
                            ("Thinking of You", "thought.bubble.fill", "You're on my mind", .blue, QuickAction.thinking)
                        ])
                        
                        // Media Section
                        actionSection(title: "Share Moments", actions: [
                            ("Voice Note", "mic.circle.fill", "Record your voice", EmberColors.coralPop, QuickAction.voiceNote),
                            ("Photo", "camera.fill", "Capture this moment", .orange, QuickAction.photo),
                            ("Memory", "photo.on.rectangle.angled", "Save this memory", .purple, QuickAction.memory)
                        ])
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
                }
            }
            .background(EmberColors.background)
            .navigationBarHidden(true)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.hidden)
    }
    
    private func actionSection(title: String, actions: [(String, String, String, Color, QuickAction)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(EmberColors.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 8) {
                ForEach(actions, id: \.0) { action in
                    Button(action: {
                        EmberHapticsManager.shared.playMedium()
                        viewModel.sendQuickAction(action.4)
                        showingQuickActions = false
                    }) {
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(action.3.opacity(0.15))
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: action.1)
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(action.3)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(action.0)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(EmberColors.textPrimary)
                                
                                Text(action.2)
                                    .font(.caption)
                                    .foregroundStyle(EmberColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(EmberColors.textSecondary)
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(EmberColors.surface)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(action.3.opacity(0.1), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Home View Model
@MainActor
class HomeViewModel: ObservableObject {
    @Published var isConnected = true
    @Published var partnerName = "His Moon"
    @Published var partnerStatus = PartnerStatus.happy
    @Published var partnerExpression: CharacterExpression = .happy
    @Published var hasCompletedFirstTouch = true
    @Published var touchesToday = 7
    @Published var dailyGoal = 10
    @Published var lastTouchText = "Last sweet hug 2 hours ago 💕"
    @Published var connectionPulse = false
@Published var recentActivities: [RecentActivity] = []
    @Published var currentUserStatus = Ember.UserStatus()
    @Published var loveNotes: [LoveNote] = []
    
    var connectionProgress: CGFloat {
        CGFloat(touchesToday) / CGFloat(dailyGoal)
    }
    
    var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    var sweetTimeGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning, Love 💕"
        case 12..<17: return "Sweet Afternoon 🌸"
        case 17..<22: return "Beautiful Evening ✨"
        default: return "Sweet Dreams 🌙"
        }
    }
    
    var affectionateMessage: String {
        let messages = [
            "Missing your touch today",
            "Thinking of you always",
            "Ready to feel close again?",
            "Your love makes everything better",
            "Can't wait to connect with you",
            "You're always in my heart",
            "Distance means nothing when love is everything"
        ]
        return messages.randomElement() ?? "Ready to connect?"
    }
    
    var loveQuoteOfTheDay: String {
        let quotes = [
            "Love is not about distance, it's about connection",
            "Every touch tells a story of love",
            "In your arms, I found my home",
            "Love bridges every distance",
            "Together in heart, no matter how far apart",
            "Your love is my favorite feeling",
            "Distance is just a test of how far love can travel"
        ]
        return quotes.randomElement() ?? "Love knows no distance"
    }
    
    var timeGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    var connectionStatusText: String {
        isConnected ? "Connected with \(partnerName)" : "Waiting for connection"
    }
    
    func loadHomeData() {
        recentActivities = [
            RecentActivity(id: "1", title: "Sent a hug", timeAgo: "2 hours ago", icon: "figure.arms.open", color: EmberColors.peachyKeen),
            RecentActivity(id: "2", title: "Received a kiss", timeAgo: "4 hours ago", icon: "heart.fill", color: EmberColors.roseQuartz),
            RecentActivity(id: "3", title: "Shared location", timeAgo: "6 hours ago", icon: "location.fill", color: EmberColors.coralPop)
        ]
        
        loveNotes = [
            LoveNote(id: "1", message: "Missing your warm hugs today 💕 Can't wait to be in your arms again", sender: "His Moon", senderInitial: "M", timeAgo: "2h ago"),
            LoveNote(id: "2", message: "You make every day brighter just by being you ✨ Love you endlessly", sender: "The Wolf", senderInitial: "W", timeAgo: "5h ago"),
            LoveNote(id: "3", message: "Thinking of our first kiss under the stars 🌟 Forever my favorite memory", sender: "His Moon", senderInitial: "M", timeAgo: "1d ago")
        ]
    }
    
    func cycleUserExpression() {
        // Cycle through user character expressions
    }
    
    func sendQuickAction(_ action: QuickAction) {
        touchesToday += 1
        updateLastTouchText(for: action)
        
        // Add to recent activities
        let newActivity = RecentActivity(
            id: UUID().uuidString,
            title: "Sent a \(action.label.lowercased())",
            timeAgo: "Just now",
            icon: action.icon,
            color: action.color
        )
        recentActivities.insert(newActivity, at: 0)
        if recentActivities.count > 3 {
            recentActivities.removeLast()
        }
    }
    
    private func updateLastTouchText(for action: QuickAction) {
        lastTouchText = "Sweet \(action.label.lowercased()) sent just now 💕"
    }
}

// MARK: - Supporting Types
struct PartnerStatus {
    let displayText: String
    let icon: String
    let statusColor: Color
    
    static let happy = PartnerStatus(
        displayText: "Feeling happy",
        icon: "heart.fill",
        statusColor: .green
    )
    
    static let busy = PartnerStatus(
        displayText: "Busy at work",
        icon: "briefcase.fill",
        statusColor: .yellow
    )
    
    static let offline = PartnerStatus(
        displayText: "Offline",
        icon: "moon.fill",
        statusColor: .gray
    )
}

enum FABCategory: CaseIterable {
    case touch, notes, voice, memory
    
    var title: String {
        switch self {
        case .touch: return "Touch"
        case .notes: return "Notes"
        case .voice: return "Voice"
        case .memory: return "Memory"
        }
    }
    
    var icon: String {
        switch self {
        case .touch: return "hand.tap.fill"
        case .notes: return "heart.text.square.fill"
        case .voice: return "mic.circle.fill"
        case .memory: return "photo.on.rectangle.angled"
        }
    }
    
    var color: Color {
        switch self {
        case .touch: return EmberColors.roseQuartz
        case .notes: return EmberColors.peachyKeen
        case .voice: return EmberColors.coralPop
        case .memory: return .purple
        }
    }
    
    var actions: [QuickAction] {
        switch self {
        case .touch: return [.kiss, .hug, .wave, .loveTap]
        case .notes: return [.loveNote, .missYou, .thinking]
        case .voice: return [.voiceNote]
        case .memory: return [.photo, .selfie, .memory]
        }
    }
}

enum QuickActionCategory: CaseIterable {
    case gestures, messages, media, location
    
    var title: String {
        switch self {
        case .gestures: return "Touch"
        case .messages: return "Messages"
        case .media: return "Media"
        case .location: return "Location"
        }
    }
    
    var actions: [QuickAction] {
        switch self {
        case .gestures: return [.kiss, .hug, .wave, .loveTap]
        case .messages: return [.loveNote, .voiceNote, .missYou, .thinking]
        case .media: return [.photo, .selfie, .memory, .song]
        case .location: return [.shareLocation, .meetHere, .onMyWay, .atHome]
        }
    }
}

enum QuickAction: CaseIterable {
    // Gestures
    case kiss, hug, wave, loveTap
    // Messages
    case loveNote, voiceNote, missYou, thinking
    // Media
    case photo, selfie, memory, song
    // Location
    case shareLocation, meetHere, onMyWay, atHome
    
    var icon: String {
        switch self {
        case .kiss: return "heart.fill"
        case .hug: return "figure.arms.open"
        case .wave: return "hand.wave.fill"
        case .loveTap: return "hand.tap.fill"
        case .loveNote: return "heart.text.square.fill"
        case .voiceNote: return "mic.circle.fill"
        case .missYou: return "heart.circle.fill"
        case .thinking: return "thought.bubble.fill"
        case .photo: return "camera.fill"
        case .selfie: return "camera.on.rectangle.fill"
        case .memory: return "photo.on.rectangle.angled"
        case .song: return "music.note"
        case .shareLocation: return "location.fill"
        case .meetHere: return "mappin.and.ellipse"
        case .onMyWay: return "car.fill"
        case .atHome: return "house.fill"
        }
    }
    
    var label: String {
        switch self {
        case .kiss: return "Kiss"
        case .hug: return "Hug"
        case .wave: return "Wave"
        case .loveTap: return "Love Tap"
        case .loveNote: return "Love Note"
        case .voiceNote: return "Voice Note"
        case .missYou: return "Miss You"
        case .thinking: return "Thinking of You"
        case .photo: return "Photo"
        case .selfie: return "Selfie"
        case .memory: return "Memory"
        case .song: return "Song"
        case .shareLocation: return "My Location"
        case .meetHere: return "Meet Here"
        case .onMyWay: return "On My Way"
        case .atHome: return "At Home"
        }
    }
    
    var color: Color {
        switch self {
        case .kiss, .hug, .wave, .loveTap: return EmberColors.roseQuartz
        case .loveNote, .voiceNote, .missYou, .thinking: return EmberColors.peachyKeen
        case .photo, .selfie, .memory, .song: return EmberColors.coralPop
        case .shareLocation, .meetHere, .onMyWay, .atHome: return .blue
        }
    }
    
    var category: QuickActionCategory {
        switch self {
        case .kiss, .hug, .wave, .loveTap: return .gestures
        case .loveNote, .voiceNote, .missYou, .thinking: return .messages
        case .photo, .selfie, .memory, .song: return .media
        case .shareLocation, .meetHere, .onMyWay, .atHome: return .location
        }
    }
    
    var description: String {
        switch self {
        case .kiss: return "Sweet & gentle"
        case .hug: return "Warm embrace"
        case .wave: return "Friendly hello"
        case .loveTap: return "Playful touch"
        case .loveNote: return "Write sweet words"
        case .voiceNote: return "Record your voice"
        case .missYou: return "I miss you so much"
        case .thinking: return "You're on my mind"
        case .photo: return "Capture this moment"
        case .selfie: return "Share your smile"
        case .memory: return "Save this memory"
        case .song: return "Share a song"
        case .shareLocation: return "Here I am"
        case .meetHere: return "Let's meet here"
        case .onMyWay: return "Coming to you"
        case .atHome: return "I'm home now"
        }
    }
    
    var hapticPattern: HapticGesture {
        switch self {
        case .kiss: return .kiss
        case .hug: return .hug
        case .wave: return .wave
        case .loveTap: return .loveTap
        case .loveNote: return .heartbeat
        case .voiceNote: return .pulse
        case .missYou: return .heartbeat
        case .thinking: return .sparkle
        case .photo: return .pulse
        case .selfie: return .sparkle
        case .memory: return .heartbeat
        case .song: return .wave
        case .shareLocation: return .pulse
        case .meetHere: return .pulse
        case .onMyWay: return .wave
        case .atHome: return .kiss
        }
    }
}

struct RecentActivity {
    let id: String
    let title: String
    let timeAgo: String
    let icon: String
    let color: Color
}

struct LoveNote {
    let id: String
    let message: String
    let sender: String
    let senderInitial: String
    let timeAgo: String
}

// MARK: - Beautiful Heart Shape for FAB
struct HeartShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let centerX = width * 0.5
        _ = height * 0.5
        
        // More beautiful, symmetrical heart shape
        path.move(to: CGPoint(x: centerX, y: height * 0.85))
        
        // Left side of heart
        path.addCurve(
            to: CGPoint(x: width * 0.15, y: height * 0.35),
            control1: CGPoint(x: centerX, y: height * 0.65),
            control2: CGPoint(x: width * 0.15, y: height * 0.55)
        )
        
        // Left top curve
        path.addCurve(
            to: CGPoint(x: centerX, y: height * 0.2),
            control1: CGPoint(x: width * 0.15, y: height * 0.15),
            control2: CGPoint(x: width * 0.35, y: height * 0.15)
        )
        
        // Right top curve
        path.addCurve(
            to: CGPoint(x: width * 0.85, y: height * 0.35),
            control1: CGPoint(x: width * 0.65, y: height * 0.15),
            control2: CGPoint(x: width * 0.85, y: height * 0.15)
        )
        
        // Right side of heart
        path.addCurve(
            to: CGPoint(x: centerX, y: height * 0.85),
            control1: CGPoint(x: width * 0.85, y: height * 0.55),
            control2: CGPoint(x: centerX, y: height * 0.65)
        )
        
        return path
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(EmberColors.textSecondary)
            
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EnhancedStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(EmberColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#Preview {
    EmberHomeView()
}
