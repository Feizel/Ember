import SwiftUI
import Combine 

@main
struct EmberApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            AppContentView()
                .environmentObject(appState)
                .onAppear {
                    setupApp()
                }
        }
    }
    
    private func setupApp() {
        // Initialize haptics engine
        EmberHapticsManager.shared.prepareEngine()
        
        // Setup audio session
        setupAudioSession()
        
        // Configure appearance
        configureAppearance()
    }
    
    private func setupAudioSession() {
        // Configure audio session for multimodal feedback
        // This would use AVAudioSession configuration from the spec
    }
    
    private func configureAppearance() {
        // Configure navigation bar and tab bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

// MARK: - App Content View
struct AppContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isFirstLaunch {
                EmberSplashScreen {
                    appState.completeFirstLaunch()
                }
            } else if !appState.hasCompletedOnboarding {
                OnboardingFlowView {
                    appState.completeOnboarding()
                }
            } else if !appState.hasCompletedIntro {
                EmberGamefiedIntroView {
                    appState.completeIntro()
                }
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.currentFlow)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EmberHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            EmberMemoriesView()
                .tabItem {
                    Image(systemName: "heart.circle.fill")
                    Text("Memories")
                }
                .tag(1)
            
            EmberTouchView()
                .tabItem {
                    Image(systemName: "hand.draw.fill")
                    Text("Touch")
                }
                .tag(2)
            
            EmberProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(EmberColors.roseQuartz)
    }
}

// MARK: - App State
@MainActor
class AppState: ObservableObject {
    @Published var isFirstLaunch = true
    @Published var hasCompletedOnboarding = false
    @Published var hasCompletedIntro = false
    @Published var currentFlow: AppFlow = .splash
    
    enum AppFlow {
        case splash, onboarding, intro, main
    }
    
    init() {
        loadAppState()
    }
    
    private func loadAppState() {
        // Load from UserDefaults or other persistence
        isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        hasCompletedIntro = UserDefaults.standard.bool(forKey: "hasCompletedIntro")
        
        if isFirstLaunch {
            currentFlow = .splash
        } else if !hasCompletedOnboarding {
            currentFlow = .onboarding
        } else if !hasCompletedIntro {
            currentFlow = .intro
        } else {
            currentFlow = .main
        }
    }
    
    func completeFirstLaunch() {
        UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        isFirstLaunch = false
        currentFlow = .onboarding
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        hasCompletedOnboarding = true
        currentFlow = .intro
    }
    
    func completeIntro() {
        UserDefaults.standard.set(true, forKey: "hasCompletedIntro")
        hasCompletedIntro = true
        currentFlow = .main
    }
}

// MARK: - Placeholder Views
struct PlaceholderMemoriesView: View {
    var body: some View {
        NavigationView {
            ZStack {
                EmberColors.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Text("Memories")
                        .emberTitleLarge()
                    
                    Text("Your shared moments will appear here")
                        .emberBody(color: EmberColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .emberScreenPadding()
            }
            .navigationTitle("Memories")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct PlaceholderProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                EmberColors.backgroundPrimary.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Profile avatar
                    Circle()
                        .fill(EmberColors.primaryGradient)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        )
                    
                    VStack(spacing: 8) {
                        Text("Your Profile")
                            .emberTitleLarge()
                        
                        Text("Customize your Ember experience")
                            .emberBody(color: EmberColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Profile options
                    VStack(spacing: 16) {
                        profileOption("Character Customization", icon: "paintbrush.fill")
                        profileOption("Relationship Settings", icon: "heart.fill")
                        profileOption("Notifications", icon: "bell.fill")
                        profileOption("Privacy & Security", icon: "lock.fill")
                        profileOption("Support", icon: "questionmark.circle.fill")
                    }
                    
                    Spacer()
                }
                .emberScreenPadding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func profileOption(_ title: String, icon: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .emberIconMedium()
                .foregroundStyle(EmberColors.roseQuartz)
                .frame(width: 24)
            
            Text(title)
                .emberHeadline()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .emberIconSmall()
                .foregroundStyle(EmberColors.textSecondary)
        }
        .emberCardPadding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    AppContentView()
        .environmentObject(AppState())
}
