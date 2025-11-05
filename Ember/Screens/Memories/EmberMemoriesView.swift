import SwiftUI

// MARK: - Ember Memories View
struct EmberMemoriesView: View {
    @State private var showingMemoryCapture = false
    @State private var showingMemoryGallery = false
    @State private var showingMemoryJournal = false
    @State private var showingMemoryMilestones = false
    @State private var showingMemoryTimeline = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Memory Card
                    heroMemoryCard
                    
                    // Quick Capture Section
                    quickCaptureSection
                    
                    // Memory Collections
                    memoryCollectionsSection
                    
                    // Recent Memories
                    recentMemoriesSection
                    
                    // Memory Insights
                    memoryInsightsSection
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 16))
                        Text("Memories")
                    }
                    .emberHeadline(color: EmberColors.textOnGradient)
                }
            }
            .toolbarBackground(EmberColors.headerGradient, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .sheet(isPresented: $showingMemoryCapture) {
            EmberMemoryCaptureView()
        }
        .sheet(isPresented: $showingMemoryGallery) {
            EmberMemoryGalleryView()
        }
        .sheet(isPresented: $showingMemoryJournal) {
            EmberMemoryJournalView()
        }
        .sheet(isPresented: $showingMemoryMilestones) {
            EmberMemoryMilestonesView()
        }
        .sheet(isPresented: $showingMemoryTimeline) {
            EmberMemoryTimelineView()
        }
    }
    
    private func performAction(title: String) {
        EmberHapticsManager.shared.playMedium()
        print("Memory action: \(title)")
    }
    
    // MARK: - Hero Memory Card
    private var heroMemoryCard: some View {
        VStack(spacing: 0) {
            // Featured Memory Image Placeholder
            Rectangle()
                .fill(EmberColors.roseQuartz.opacity(0.1))
                .frame(height: 200)
                .overlay(
                    VStack(spacing: 12) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundStyle(EmberColors.roseQuartz.opacity(0.6))
                        
                        Text("Your latest memory")
                            .emberBody(color: EmberColors.textSecondary)
                    }
                )
            
            // Memory Details
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Coffee Date")
                            .emberHeadline()
                        Text("Yesterday • Shared by Alex")
                            .emberCaption(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        performAction(title: "View Memory")
                    }) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(EmberColors.roseQuartz)
                    }
                }
                
                Text("\"Perfect morning with my favorite person ☕️💕\"")
                    .emberBody(color: EmberColors.textSecondary)
                    .italic()
            }
            .padding(20)
            .background(EmberColors.surface)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Quick Capture Section
    private var quickCaptureSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Capture This Moment")
                .emberHeadline()
            
            HStack(spacing: 12) {
                quickCaptureButton(
                    icon: "camera.fill",
                    title: "Photo",
                    color: EmberColors.roseQuartz,
                    action: { showingMemoryCapture = true }
                )
                
                quickCaptureButton(
                    icon: "text.quote",
                    title: "Note",
                    color: EmberColors.peachyKeen,
                    action: { showingMemoryCapture = true }
                )
                
                quickCaptureButton(
                    icon: "mic.fill",
                    title: "Voice",
                    color: EmberColors.coralPop,
                    action: { showingMemoryCapture = true },
                    isPremium: true
                )
                
                quickCaptureButton(
                    icon: "location.fill",
                    title: "Place",
                    color: EmberColors.lavenderMist,
                    action: { showingMemoryCapture = true }
                )
            }
        }
    }
    
    private func quickCaptureButton(icon: String, title: String, color: Color, action: @escaping () -> Void, isPremium: Bool = false) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundStyle(color)
                    
                    if isPremium {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.yellow)
                            }
                            Spacer()
                        }
                        .padding(4)
                    }
                }
                
                Text(title)
                    .emberCaption()
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Memory Collections Section
    private var memoryCollectionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Collections")
                .emberHeadline()
            
            VStack(spacing: 12) {
                memoryCollectionRow(
                    icon: "photo.stack.fill",
                    title: "Photo Gallery",
                    subtitle: "247 photos • Last added 2h ago",
                    color: EmberColors.roseQuartz,
                    action: { showingMemoryGallery = true }
                )
                
                memoryCollectionRow(
                    icon: "book.closed.fill",
                    title: "Memory Journal",
                    subtitle: "32 entries • Private thoughts",
                    color: EmberColors.peachyKeen,
                    action: { showingMemoryJournal = true }
                )
                
                memoryCollectionRow(
                    icon: "star.fill",
                    title: "Milestones",
                    subtitle: "12 special moments • Premium",
                    color: EmberColors.coralPop,
                    action: { showingMemoryMilestones = true },
                    isPremium: true
                )
                
                memoryCollectionRow(
                    icon: "timeline.selection",
                    title: "Timeline View",
                    subtitle: "89 days together • Chronological",
                    color: EmberColors.lavenderMist,
                    action: { showingMemoryTimeline = true }
                )
            }
        }
    }
    
    private func memoryCollectionRow(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void, isPremium: Bool = false) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundStyle(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .emberLabel()
                        if isPremium {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(.yellow)
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
    
    // MARK: - Recent Memories Section
    private var recentMemoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Memories")
                    .emberHeadline()
                Spacer()
                Button("See All") {
                    showingMemoryTimeline = true
                }
                .emberCaption(color: EmberColors.roseQuartz)
            }
            
            VStack(spacing: 8) {
                ForEach(0..<3) { index in
                    recentMemoryRow(index: index)
                }
            }
        }
    }
    
    private func recentMemoryRow(index: Int) -> some View {
        let memories = [
            ("Sunset Walk", "Beautiful evening together", "2h ago", "figure.walk"),
            ("Love Note", "Missing you today 💕", "Yesterday", "heart.text.square"),
            ("Dinner Date", "Amazing pasta night", "2 days ago", "fork.knife")
        ]
        
        let memory = memories[index]
        
        return Button(action: {
            performAction(title: memory.0)
        }) {
            HStack(spacing: 12) {
                Circle()
                    .fill(EmberColors.roseQuartz.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: memory.3)
                            .font(.system(size: 16))
                            .foregroundStyle(EmberColors.roseQuartz)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(memory.0)
                        .emberBody()
                    Text(memory.1)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Text(memory.2)
                    .emberCaption(color: EmberColors.textTertiary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Memory Insights Section
    private var memoryInsightsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                insightCard(
                    value: "89",
                    label: "Days Together",
                    icon: "calendar.badge.clock",
                    color: EmberColors.roseQuartz
                )
                
                insightCard(
                    value: "247",
                    label: "Memories",
                    icon: "heart.fill",
                    color: EmberColors.peachyKeen
                )
            }
            
            HStack(spacing: 16) {
                insightCard(
                    value: "32",
                    label: "This Month",
                    icon: "chart.line.uptrend.xyaxis",
                    color: EmberColors.coralPop
                )
                
                insightCard(
                    value: "12",
                    label: "Milestones",
                    icon: "star.fill",
                    color: EmberColors.lavenderMist
                )
            }
        }
    }
    
    private func insightCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(color)
            
            Text(value)
                .emberHeadlineSmall(color: color)
            
            Text(label)
                .emberCaption(color: EmberColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
}



#Preview {
    EmberMemoriesView()
}