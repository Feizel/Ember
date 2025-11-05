import SwiftUI

// MARK: - Touch Tab View
struct EmberTouchTabView: View {
    @State private var showingTouchCanvas = false
    @State private var selectedGesture: TouchType?
    
    var body: some View {
        NavigationView {
            ZStack {
                EmberColors.backgroundPrimary
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Header
                        EmberTouchHeaderView()
                        
                        // Quick Touch Actions
                        EmberQuickTouchGrid(onGestureTap: sendQuickTouch)
                        
                        // Touch Canvas CTA
                        EmberTouchCanvasCTA(showingTouchCanvas: $showingTouchCanvas)
                        
                        // Recent Touches
                        EmberRecentTouchesSection()
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Touch")
                        .emberHeadline(color: EmberColors.textOnGradient)
                }
            }
            .toolbarBackground(EmberColors.headerGradient, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .fullScreenCover(isPresented: $showingTouchCanvas) {
            EmberTouchCanvasView()
        }
    }
    
    private func sendQuickTouch(_ touchType: TouchType) {
        selectedGesture = touchType
        // Send touch logic
        EmberHapticsManager.shared.playSuccess()
    }
}

// MARK: - Touch Header
struct EmberTouchHeaderView: View {
    var body: some View {
        EmberGradientCard(gradient: EmberColors.headerGradient) {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Send Touch")
                            .emberHeadline(color: EmberColors.textOnGradient)
                        
                        Text("Express your love through touch")
                            .emberBody(color: EmberColors.textOnGradient.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "hand.draw.fill")
                            .emberIconLarge()
                            .foregroundStyle(EmberColors.textOnGradient)
                    }
                }
            }
        }
    }
}

// MARK: - Quick Touch Grid
struct EmberQuickTouchGrid: View {
    let onGestureTap: (TouchType) -> Void
    
    private let touchTypes: [(TouchType, String, String, Color)] = [
        (.kiss, "Kiss", "lips.fill", EmberColors.roseQuartz),
        (.hug, "Hug", "hands.sparkles.fill", EmberColors.peachyKeen),
        (.love, "Love", "heart.fill", EmberColors.coralPop),
        (.wave, "Wave", "hand.wave.fill", EmberColors.roseQuartz),
        (.tickle, "Tickle", "hand.point.up.fill", EmberColors.peachyKeen),
        (.squeeze, "Squeeze", "hand.raised.fill", EmberColors.coralPop)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Touches")
                    .emberHeadline()
                
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(touchTypes, id: \.0) { touchType in
                    Button(action: { onGestureTap(touchType.0) }) {
                        VStack(spacing: 12) {
                            Circle()
                                .fill(touchType.3.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: touchType.2)
                                        .emberIconLarge()
                                        .foregroundStyle(touchType.3)
                                )
                            
                            Text(touchType.1)
                                .emberBody()
                        }
                        .frame(maxWidth: .infinity)
                        .emberCardPadding()
                        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(touchType.3.opacity(0.3), lineWidth: 1)
                        )
                        .emberCardShadow()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Touch Canvas CTA
struct EmberTouchCanvasCTA: View {
    @Binding var showingTouchCanvas: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Custom Touch")
                    .emberHeadline()
                
                Spacer()
            }
            
            Button(action: { showingTouchCanvas = true }) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(EmberColors.roseQuartz.opacity(0.2))
                        .frame(width: 60, height: 60)
                        .overlay(
                            Image(systemName: "scribble.variable")
                                .emberIconLarge()
                                .foregroundStyle(EmberColors.roseQuartz)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Touch Canvas")
                            .emberTitle()
                        
                        Text("Draw your touch with your finger")
                            .emberBody(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .emberIconMedium()
                        .foregroundStyle(EmberColors.roseQuartz)
                }
                .emberCardPadding()
                .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(EmberColors.roseQuartz.opacity(0.3), lineWidth: 1)
                )
                .emberCardShadow()
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Recent Touches Section
struct EmberRecentTouchesSection: View {
    private let recentTouches = [
        ("Kiss", "2 min ago", false, "lips.fill"),
        ("Hug", "5 min ago", true, "hands.sparkles.fill"),
        ("Love", "12 min ago", false, "heart.fill")
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recent Touches")
                    .emberHeadline()
                
                Spacer()
            }
            
            EmberCard(style: .elevated) {
                VStack(spacing: 12) {
                    ForEach(Array(recentTouches.enumerated()), id: \.offset) { index, touch in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(touch.2 ? EmberColors.peachyKeen.opacity(0.2) : EmberColors.roseQuartz.opacity(0.2))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: touch.3)
                                        .emberIconSmall()
                                        .foregroundStyle(touch.2 ? EmberColors.peachyKeen : EmberColors.roseQuartz)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(touch.0)
                                    .emberBody()
                                
                                Text(touch.2 ? "Received from partner" : "Sent to partner")
                                    .emberCaption(color: EmberColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Text(touch.1)
                                .emberCaption(color: EmberColors.textSecondary)
                        }
                        
                        if index < recentTouches.count - 1 {
                            Divider()
                                .background(EmberColors.divider)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EmberTouchTabView()
}