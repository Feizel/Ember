import SwiftUI

struct OnboardingView: View {
    @StateObject private var appStateManager = AppStateManager.shared
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Feel Every Touch",
            subtitle: "Experience your partner's touch through advanced haptic technology",
            icon: "hand.tap.fill",
            color: ColorPalette.crimson
        ),
        OnboardingPage(
            title: "Stay Connected",
            subtitle: "Send hugs, kisses, and custom touches no matter the distance",
            icon: "heart.fill",
            color: ColorPalette.roseGold
        ),
        OnboardingPage(
            title: "Grow Together",
            subtitle: "Track your connection and watch your bond strengthen every day",
            icon: "chart.line.uptrend.xyaxis",
            color: ColorPalette.goldenYellow
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemGroupedBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Pages
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxHeight: .infinity)
                
                // Bottom section
                VStack(spacing: 24) {
                    // Page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? ColorPalette.crimson : Color(.systemGray4))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    // Action button
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            appStateManager.completeOnboarding()
                        }
                    }) {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorPalette.crimson, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    
                    // Skip button
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            appStateManager.completeOnboarding()
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(page.color)
            }
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}

#Preview {
    OnboardingView()
}