import SwiftUI

// MARK: - Ember Touch View
struct EmberTouchView: View {
    @State private var showingLiveTouch = false
    @State private var connectionStatus: ConnectionStatus = .connected
    @State private var showingHistory = false
    @State private var showingPatterns = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Connection Status
                    connectionStatusCard
                    
                    // Live Touch (Hero Feature)
                    liveTouchCard
                    
                    // Communication Section
                    communicationSection
                    
                    // Touch Features Section
                    touchFeaturesSection
                    
                    // Premium Features Section
                    premiumFeaturesSection
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "hand.tap.fill")
                            .font(.system(size: 16))
                        Text("Touch")
                    }
                    .emberHeadline(color: EmberColors.textOnGradient)
                }
            }
            .toolbarBackground(EmberColors.headerGradient, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .fullScreenCover(isPresented: $showingLiveTouch) {
            EmberLiveTouchView(connectionStatus: connectionStatus)
        }
        .sheet(isPresented: $showingHistory) {
            EmberTouchHistoryView()
        }
        .sheet(isPresented: $showingPatterns) {
            EmberTouchPatternsView()
        }
    }
    
    private func sendQuickAction(title: String) {
        EmberHapticsManager.shared.playMedium()
        print("Sending: \(title)")
    }
    
    private var connectionStatusCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(connectionStatus.color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(connectionStatus.message)
                    .emberLabel()
                Text("Partner: Alex")
                    .emberCaption(color: EmberColors.textSecondary)
            }
            
            Spacer()
            
            if connectionStatus == .connected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(EmberColors.success)
            }
        }
        .padding()
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var liveTouchCard: some View {
        Button(action: { 
            EmberHapticsManager.shared.playMedium()
            showingLiveTouch = true 
        }) {
            ZStack {
                LinearGradient(
                    colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 180)
                
                VStack(spacing: 12) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(.white)
                    
                    Text("Live Touch Canvas")
                        .emberHeadline(color: .white)
                    
                    Text("Feel your partner's touch in real-time")
                        .emberBody(color: .white.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.up.right.circle.fill")
                        Text("Start Session")
                    }
                    .emberLabel(color: .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Communication Section
    private var communicationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Send Messages")
                .emberHeadline()
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                communicationCard(icon: "heart.text.square.fill", title: "Love Note", subtitle: "Send sweet message", color: EmberColors.roseQuartz)
                communicationCard(icon: "mic.fill", title: "Voice Message", subtitle: "Record your voice", color: EmberColors.peachyKeen, isPremium: true)
                communicationCard(icon: "photo.fill", title: "Photo Message", subtitle: "Share a moment", color: EmberColors.coralPop)
                communicationCard(icon: "location.fill", title: "Location Share", subtitle: "Share where you are", color: EmberColors.lavenderMist, isPremium: true)
            }
        }
    }
    
    private func communicationCard(icon: String, title: String, subtitle: String, color: Color, isPremium: Bool = false) -> some View {
        Button(action: {
            sendQuickAction(title: title)
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundStyle(color)
                }
                
                VStack(spacing: 4) {
                    HStack {
                        Text(title)
                            .emberLabel()
                        if isPremium {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(.yellow)
                        }
                    }
                    
                    Text(subtitle)
                        .emberCaption(color: EmberColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Touch Features Section
    private var touchFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Touch Features")
                .emberHeadline()
            
            VStack(spacing: 12) {
                touchFeatureCard(icon: "clock.fill", title: "Touch History", subtitle: "View past sessions", action: { showingHistory = true })
                touchFeatureCard(icon: "waveform.path", title: "Touch Patterns", subtitle: "Explore different styles", action: { showingPatterns = true })
            }
        }
    }
    
    private func touchFeatureCard(icon: String, title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(EmberColors.roseQuartz)
                    .frame(width: 44, height: 44)
                    .background(EmberColors.roseQuartz.opacity(0.1))
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
                    .foregroundStyle(EmberColors.textSecondary)
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Premium Features Section
    private var premiumFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Premium Features")
                    .emberHeadline()
                Image(systemName: "crown.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(.yellow)
            }
            
            VStack(spacing: 12) {
                premiumFeatureCard(icon: "heart.fill", title: "Heartbeat Sync", subtitle: "Feel each other's heartbeat")
                premiumFeatureCard(icon: "waveform.path.ecg", title: "Advanced Patterns", subtitle: "Unlock premium touch styles")
            }
        }
    }
    
    private func premiumFeatureCard(icon: String, title: String, subtitle: String) -> some View {
        Button(action: {
            sendQuickAction(title: title)
        }) {
            HStack(spacing: 16) {
                ZStack {
                    LinearGradient(
                        colors: [.yellow.opacity(0.3), .orange.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(.orange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .emberLabel()
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.yellow)
                    }
                    Text(subtitle)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(EmberColors.textSecondary)
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(
                        colors: [.yellow.opacity(0.3), .orange.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Connection Status
enum ConnectionStatus {
    case connected, connecting, disconnected
    
    var message: String {
        switch self {
        case .connected: return "Connected"
        case .connecting: return "Connecting..."
        case .disconnected: return "Disconnected"
        }
    }
    
    var color: Color {
        switch self {
        case .connected: return EmberColors.success
        case .connecting: return .orange
        case .disconnected: return .red
        }
    }
}

#Preview {
    EmberTouchView()
}