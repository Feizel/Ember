import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingTouch = false
    @StateObject private var settingsManager = SettingsManager.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            Group {
                switch selectedTab {
                case 0:
                    HomeView()
                case 1:
                    MemoriesView()
                case 2:
                    TouchView()
                case 3:
                    PremiumSettingsView()
                        .environmentObject(settingsManager)
                default:
                    HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 100)
            }
            
            // Floating tab bar
            FloatingTabView(selectedTab: $selectedTab)
            
            // Floating Action Button
            FloatingActionButton(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: selectedTab) { _, newValue in
            // Touch tab is now a regular tab, no modal needed
        }

    }
}

struct BondView: View {
    @State private var showingMemories = false
    @State private var showingMilestones = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AdaptiveTheme.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // Relationship Level Header
                        RelationshipLevelView()
                        
                        // Bond Strength Meter
                        BondStrengthView()
                        
                        // Premium Features
                        VStack(spacing: 16) {
                            PremiumFeatureCard(
                                title: "Love Memories",
                                subtitle: "Your sweetest moments together",
                                icon: "photo.on.rectangle.angled",
                                color: .pink,
                                isPremium: true,
                                action: { showingMemories = true }
                            )
                            
                            PremiumFeatureCard(
                                title: "Relationship Milestones",
                                subtitle: "Celebrate your journey",
                                icon: "trophy.fill",
                                color: .orange,
                                isPremium: true,
                                action: { showingMilestones = true }
                            )
                            
                            PremiumFeatureCard(
                                title: "Couple Challenges",
                                subtitle: "Fun activities to do together",
                                icon: "gamecontroller.fill",
                                color: .purple,
                                isPremium: false,
                                action: {}
                            )
                        }
                        
                        // Bond Stats
                        BondStatsGrid()
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Your Bond")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingMemories) {
            LoveMemoriesView()
        }
        .sheet(isPresented: $showingMilestones) {
            MilestonesView()
        }
    }
}

struct RelationshipLevelView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                CuteCharacter(
                    character: .touchy,
                    size: 70,
                    customization: CharacterCustomization(
                        colorTheme: .blue,
                        accessory: .crown,
                        expression: .love,
                        name: "My Heart"
                    ),
                    isAnimating: true
                )
                
                VStack(spacing: 8) {
                    Text("Soulmates")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(ColorPalette.iconGradient)
                    
                    Text("Level 8 • 2,847 XP")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                    
                    // XP Progress bar
                    ProgressView(value: 0.73)
                        .progressViewStyle(PremiumProgressStyle())
                        .frame(height: 6)
                        .frame(width: 120)
                }
                
                CuteCharacter(
                    character: .syncee,
                    size: 70,
                    customization: CharacterCustomization(
                        colorTheme: .pink,
                        accessory: .flower,
                        expression: .romantic,
                        name: "Partner's Heart"
                    ),
                    isAnimating: true
                )
            }
            
            Text("153 XP until next level")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .adaptiveGlassmorphism(cornerRadius: 20)
    }
}

struct BondStrengthView: View {
    @State private var animateStrength = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Bond Strength")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Text("92%")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(ColorPalette.crimson)
            }
            
            // Animated bond strength meter
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: animateStrength ? 0.92 : 0)
                    .stroke(ColorPalette.iconGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 2), value: animateStrength)
                
                VStack(spacing: 4) {
                    Text("💕")
                        .font(.title)
                    Text("Unbreakable")
                        .font(.caption.weight(.medium))
                        .foregroundColor(.secondary)
                }
            }
            
            Text("Your connection is stronger than ever!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .adaptiveGlassmorphism(cornerRadius: 16)
        .onAppear {
            animateStrength = true
        }
    }
}

struct PremiumFeatureCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isPremium: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.headline.weight(.medium))
                            .foregroundColor(.primary)
                        
                        if isPremium {
                            Text("PRO")
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(ColorPalette.goldenYellow, in: Capsule())
                        }
                    }
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .adaptiveGlassmorphism(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}

struct BondStatsGrid: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("This Month")
                    .font(.headline.weight(.semibold))
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                BondStatCard(title: "Touches", value: "247", icon: "hand.point.up.left.fill", color: .pink)
                BondStatCard(title: "Messages", value: "89", icon: "message.fill", color: .blue)
                BondStatCard(title: "Perfect Days", value: "12", icon: "star.fill", color: .orange)
                BondStatCard(title: "Streak Record", value: "18", icon: "flame.fill", color: .red)
            }
        }
    }
}

struct BondStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .adaptiveCard(cornerRadius: 12)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MockAuthManager())
}