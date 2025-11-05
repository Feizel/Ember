import SwiftUI

// MARK: - Relationship Analytics View
struct EmberRelationshipAnalyticsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Picker
                Picker("Analytics", selection: $selectedTab) {
                    Text("Insights").tag(0)
                    Text("Heatmap").tag(1)
                    Text("Milestones").tag(2)
                    Text("Moods").tag(3)
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                TabView(selection: $selectedTab) {
                    EmberLoveLanguageInsightsView()
                        .tag(0)
                    
                    EmberConnectionHeatmapView()
                        .tag(1)
                    
                    EmberMilestoneTrackingView()
                        .tag(2)
                    
                    EmberMoodCorrelationView()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Relationship Analytics")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .emberBody(color: EmberColors.roseQuartz)
                }
            }
        }
    }
}

// MARK: - Love Language Insights
struct EmberLoveLanguageInsightsView: View {
    private let loveLanguages = [
        ("Physical Touch", 45, EmberColors.roseQuartz),
        ("Words of Affirmation", 25, EmberColors.peachyKeen),
        ("Quality Time", 15, EmberColors.coralPop),
        ("Acts of Service", 10, Color.blue),
        ("Receiving Gifts", 5, Color.purple)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Love Language Analysis")
                        .emberHeadline()
                    
                    Text("Based on your communication patterns")
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                VStack(spacing: 16) {
                    ForEach(Array(loveLanguages.enumerated()), id: \.offset) { index, language in
                        HStack {
                            Text(language.0)
                                .emberBody()
                            
                            Spacer()
                            
                            Text("\(language.1)%")
                                .emberBody(color: language.2)
                                .fontWeight(.semibold)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(EmberColors.border)
                                    .frame(height: 8)
                                
                                Capsule()
                                    .fill(language.2)
                                    .frame(width: geometry.size.width * CGFloat(language.1) / 100, height: 8)
                            }
                        }
                        .frame(height: 8)
                    }
                }
                .emberCardPadding()
                .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
                
                VStack(spacing: 12) {
                    Text("Key Insights")
                        .emberHeadline()
                    
                    VStack(spacing: 8) {
                        EmberInsightCard(
                            icon: "hand.draw.fill",
                            title: "Physical Touch Dominant",
                            description: "You both express love primarily through touches",
                            color: EmberColors.roseQuartz
                        )
                        
                        EmberInsightCard(
                            icon: "message.fill",
                            title: "Growing Communication",
                            description: "Words of affirmation increased 30% this month",
                            color: EmberColors.peachyKeen
                        )
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Connection Heatmap
struct EmberConnectionHeatmapView: View {
    private let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    private let heatmapData = [
        [3, 5, 2, 8, 4, 12, 15],
        [2, 4, 6, 3, 7, 10, 8],
        [5, 3, 4, 6, 9, 14, 12],
        [1, 2, 3, 5, 6, 8, 10]
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Connection Heatmap")
                        .emberHeadline()
                    
                    Text("Touch frequency over the past month")
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        ForEach(weekDays, id: \.self) { day in
                            Text(day)
                                .emberCaption()
                                .frame(width: 30)
                        }
                    }
                    
                    ForEach(Array(heatmapData.enumerated()), id: \.offset) { weekIndex, week in
                        HStack(spacing: 4) {
                            Text("W\(weekIndex + 1)")
                                .emberCaption()
                                .frame(width: 30)
                            
                            ForEach(Array(week.enumerated()), id: \.offset) { dayIndex, count in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(heatmapColor(for: count))
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Text("\(count)")
                                            .emberCaption(color: count > 5 ? .white : EmberColors.textSecondary)
                                    )
                            }
                        }
                    }
                }
                .emberCardPadding()
                .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
    }
    
    private func heatmapColor(for count: Int) -> Color {
        switch count {
        case 0: return EmberColors.border
        case 1...3: return EmberColors.roseQuartz.opacity(0.3)
        case 4...6: return EmberColors.roseQuartz.opacity(0.6)
        case 7...10: return EmberColors.roseQuartz.opacity(0.8)
        default: return EmberColors.roseQuartz
        }
    }
}

// MARK: - Milestone Tracking
struct EmberMilestoneTrackingView: View {
    private let milestones = [
        ("First Date", "March 15, 2023", "🌹", true),
        ("First Kiss", "March 22, 2023", "💋", true),
        ("First 'I Love You'", "April 10, 2023", "💕", true),
        ("6 Month Anniversary", "September 15, 2023", "🎉", false)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Relationship Milestones")
                        .emberHeadline()
                    
                    Text("Your journey together")
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                VStack(spacing: 16) {
                    ForEach(Array(milestones.enumerated()), id: \.offset) { index, milestone in
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(milestone.3 ? EmberColors.roseQuartz.opacity(0.2) : EmberColors.border)
                                    .frame(width: 50, height: 50)
                                
                                Text(milestone.2)
                                    .font(.title2)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(milestone.0)
                                    .emberBody()
                                
                                Text(milestone.1)
                                    .emberCaption(color: EmberColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            if milestone.3 {
                                Image(systemName: "checkmark.circle.fill")
                                    .emberIconMedium()
                                    .foregroundStyle(EmberColors.roseQuartz)
                            }
                        }
                        .emberCardPadding()
                        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Mood Correlation
struct EmberMoodCorrelationView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Mood Correlation")
                        .emberHeadline()
                    
                    Text("How your moods affect each other")
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                VStack(spacing: 16) {
                    EmberMoodCorrelationCard(
                        title: "Positive Influence",
                        description: "When you're happy, your partner is 85% more likely to be happy too",
                        percentage: 85,
                        color: EmberColors.roseQuartz
                    )
                    
                    EmberMoodCorrelationCard(
                        title: "Emotional Support",
                        description: "Your partner's romantic mood boosts your happiness by 70%",
                        percentage: 70,
                        color: EmberColors.peachyKeen
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Supporting Components
struct EmberInsightCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .emberIconMedium()
                        .foregroundStyle(color)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .emberBody()
                
                Text(description)
                    .emberCaption(color: EmberColors.textSecondary)
            }
            
            Spacer()
        }
        .emberCardPadding()
        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
    }
}

struct EmberMoodCorrelationCard: View {
    let title: String
    let description: String
    let percentage: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .emberTitle()
                
                Spacer()
                
                Text("\(percentage)%")
                    .emberHeadlineSmall(color: color)
            }
            
            Text(description)
                .emberCaption(color: EmberColors.textSecondary)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(EmberColors.border)
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage) / 100, height: 8)
                }
            }
            .frame(height: 8)
        }
        .emberCardPadding()
        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    EmberRelationshipAnalyticsView()
}