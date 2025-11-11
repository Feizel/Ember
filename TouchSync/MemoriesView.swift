import SwiftUI

struct MemoriesView: View {
    @State private var showingPhotoGallery = false
    @State private var showingMilestones = false
    @State private var selectedTimeFilter = "All"
    
    private let timeFilters = ["All", "This Week", "This Month", "This Year"]
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 24) {
                        // BOND SECTION
                        BondHeaderView()
                        BondLevelSection()
                        DailyGoalsSection()
                        RelationshipStatsSection()
                        
                        // MEMORIES SECTION
                        SectionDivider(title: "Our Memories")
                        MilestonesSection(showingMilestones: $showingMilestones)
                        TouchTimelineSection(selectedFilter: $selectedTimeFilter, filters: timeFilters)
                        PhotoGallerySection(showingPhotoGallery: $showingPhotoGallery)
                        AnniversaryCountdownView()
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Bond & Memories")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingPhotoGallery) {
            PhotoGalleryView()
        }
        .sheet(isPresented: $showingMilestones) {
            Text("Milestones")
        }
    }
}

struct BondHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: -10) {
                CuteCharacter(
                    character: .touchy,
                    size: 60,
                    customization: CharacterCustomization(
                        colorTheme: .blue,
                        accessory: .none,
                        expression: .love,
                        name: "My Heart"
                    ),
                    isAnimating: true
                )
                
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundStyle(ColorPalette.crimson)
                
                CuteCharacter(
                    character: .syncee,
                    size: 60,
                    customization: CharacterCustomization(
                        colorTheme: .pink,
                        accessory: .flower,
                        expression: .love,
                        name: "Partner's Heart"
                    ),
                    isAnimating: true
                )
            }
            
            VStack(spacing: 4) {
                Text("Together for 23 days")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Since October 15, 2024")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(hex: "FF6F91"), Color(hex: "FFD97D")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct BondLevelSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundStyle(ColorPalette.crimson)
                Text("Bond Level")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text("Level 3")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(ColorPalette.crimson)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("Loving Hearts")
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Text("750 / 1000 XP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                ProgressView(value: 0.75)
                    .tint(ColorPalette.crimson)
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct DailyGoalsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "target")
                    .foregroundStyle(ColorPalette.goldenYellow)
                Text("Today's Goals")
                    .font(.headline.weight(.semibold))
                Spacer()
                Text("2/3 Complete")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 8) {
                GoalRow(title: "Send 5 touches", progress: 1.0, isComplete: true)
                GoalRow(title: "Exchange messages", progress: 1.0, isComplete: true)
                GoalRow(title: "Share a photo", progress: 0.0, isComplete: false)
            }
        }
    }
}

struct GoalRow: View {
    let title: String
    let progress: Double
    let isComplete: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? .green : .secondary)
            Text(title)
                .font(.subheadline)
                .strikethrough(isComplete)
            Spacer()
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
}

struct RelationshipStatsSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(ColorPalette.sunsetOrange)
                Text("Relationship Stats")
                    .font(.headline.weight(.semibold))
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(title: "Total Touches", value: "247", subtitle: "hand.tap.fill", color: Color(hex: "FF6B35"))
                StatCard(title: "Current Streak", value: "7 days", subtitle: "flame.fill", color: Color(hex: "FF8C61"))
                StatCard(title: "Messages Sent", value: "89", subtitle: "message.fill", color: Color(hex: "FFD97D"))
                StatCard(title: "Photos Shared", value: "12", subtitle: "photo.fill", color: Color(hex: "FFAD84"))
            }
        }
    }
}



struct SectionDivider: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Divider()
                .background(.secondary.opacity(0.3))
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

struct MilestonesSection: View {
    @Binding var showingMilestones: Bool
    
    private let milestones = [
        Milestone(icon: "hand.tap.fill", title: "First Touch", date: "Oct 15, 2024", isUnlocked: true, color: Color(hex: "FF6B35")),
        Milestone(icon: "flame.fill", title: "7 Day Streak", date: "Oct 22, 2024", isUnlocked: true, color: Color(hex: "FF8C61")),
        Milestone(icon: "heart.circle.fill", title: "1 Month Together", date: "Nov 15, 2024", isUnlocked: false, color: Color(hex: "FFD97D")),
        Milestone(icon: "sparkles", title: "100 Touches", date: "47/100", isUnlocked: false, color: Color(hex: "FFAD84"))
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(ColorPalette.goldenYellow)
                Text("Milestones")
                    .font(.headline.weight(.semibold))
                Spacer()
                Button("See All") {
                    showingMilestones = true
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(ColorPalette.crimson)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(milestones) { milestone in
                    MilestoneCard(milestone: milestone)
                }
            }
        }
    }
}

struct MilestoneCard: View {
    let milestone: Milestone
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(milestone.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: milestone.icon)
                    .font(.title3)
                    .foregroundStyle(milestone.isUnlocked ? milestone.color : .gray)
            }
            Text(milestone.title)
                .font(.caption.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            Text(milestone.date)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .opacity(milestone.isUnlocked ? 1.0 : 0.6)
    }
}

struct TouchTimelineSection: View {
    @Binding var selectedFilter: String
    let filters: [String]
    
    private let touchEntries = [
        TouchEntry(sender: "You", gesture: "Hug", time: "2 hours ago", message: "Missing you 💕", color: Color(hex: "FF6B35")),
        TouchEntry(sender: "Partner", gesture: "Kiss", time: "4 hours ago", message: "Good morning love!", color: Color(hex: "FFAD84")),
        TouchEntry(sender: "You", gesture: "Wave", time: "Yesterday", message: nil, color: Color(hex: "FFB3C1"))
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(ColorPalette.sunsetOrange)
                Text("Touch History")
                    .font(.headline.weight(.semibold))
                Spacer()
                Menu(selectedFilter) {
                    ForEach(filters, id: \String.self) { filter in
                        Button(filter) {
                            selectedFilter = filter
                        }
                    }
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(ColorPalette.crimson)
            }
            
            VStack(spacing: 8) {
                ForEach(touchEntries) { entry in
                    TouchEntryCard(entry: entry)
                }
            }
        }
    }
}

struct TouchEntryCard: View {
    let entry: TouchEntry
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(entry.color.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: gestureIcon(entry.gesture))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(entry.color)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("\(entry.sender) sent a \(entry.gesture)")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(entry.time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let message = entry.message {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
    
    private func gestureIcon(_ gesture: String) -> String {
        switch gesture.lowercased() {
        case "hug": return "hands.sparkles.fill"
        case "kiss": return "heart.fill"
        case "wave": return "hand.wave.fill"
        default: return "heart.fill"
        }
    }
}

struct PhotoGallerySection: View {
    @Binding var showingPhotoGallery: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "photo.stack.fill")
                    .foregroundStyle(ColorPalette.roseGold)
                Text("Our Photos")
                    .font(.headline.weight(.semibold))
                Spacer()
                Button("Add Photo") {
                    showingPhotoGallery = true
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(ColorPalette.crimson)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(0..<6) { index in
                    if index == 5 {
                        Button(action: { showingPhotoGallery = true }) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.ultraThinMaterial)
                                .frame(height: 80)
                                .overlay(
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(Color(hex: "FF6B35"))
                                )
                        }
                        .buttonStyle(.plain)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(
                                colors: [Color(hex: "FFD97D").opacity(0.3), Color(hex: "FF6B35").opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 80)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundStyle(.secondary)
                            )
                    }
                }
            }
        }
    }
}

struct AnniversaryCountdownView: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundStyle(ColorPalette.goldenYellow)
                Text("Next Anniversary")
                    .font(.headline.weight(.semibold))
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text("1 Year Anniversary")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.primary)
                Text("346 days remaining")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("October 15, 2025")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color(hex: "FFD97D").opacity(0.3), Color(hex: "FF6B35").opacity(0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: RoundedRectangle(cornerRadius: 12)
            )
        }
    }
}

struct PhotoGalleryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Photo Gallery")
                    .font(.title)
                Text("Coming Soon")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Our Photos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}



struct Milestone: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let date: String
    let isUnlocked: Bool
    let color: Color
}

struct TouchEntry: Identifiable {
    let id = UUID()
    let sender: String
    let gesture: String
    let time: String
    let message: String?
    let color: Color
}

#Preview {
    MemoriesView()
}