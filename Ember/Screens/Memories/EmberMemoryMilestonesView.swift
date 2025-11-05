import SwiftUI

// MARK: - Memory Milestones View
struct EmberMemoryMilestonesView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingNewMilestone = false
    @State private var selectedMilestone: Milestone?
    @State private var showingMilestoneDetail = false
    
    private let milestones = Milestone.sampleMilestones
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Premium Header
                    premiumHeader
                    
                    // Milestone Journey
                    milestoneJourney
                    
                    // Recent Milestones
                    recentMilestones
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.yellow)
                        Text("Milestones")
                            .emberHeadline()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewMilestone = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewMilestone) {
            EmberNewMilestoneView()
        }
        .sheet(isPresented: $showingMilestoneDetail) {
            if let milestone = selectedMilestone {
                EmberMilestoneDetailView(milestone: milestone)
            }
        }
    }
    
    private var premiumHeader: some View {
        VStack(spacing: 16) {
            // Premium Badge
            HStack {
                Image(systemName: "crown.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.yellow)
                
                Text("Premium Feature")
                    .emberLabel(color: .orange)
                
                Spacer()
            }
            .padding(12)
            .background(
                LinearGradient(
                    colors: [.yellow.opacity(0.1), .orange.opacity(0.1)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(LinearGradient(
                        colors: [.yellow.opacity(0.3), .orange.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ), lineWidth: 1)
            )
            
            // Stats
            HStack(spacing: 16) {
                milestoneStatCard(value: "\(milestones.count)", label: "Milestones", icon: "star.fill")
                milestoneStatCard(value: "89", label: "Days", icon: "calendar.badge.clock")
                milestoneStatCard(value: "6", label: "Shared", icon: "heart.2.fill")
            }
        }
    }
    
    private func milestoneStatCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(.orange)
            
            Text(value)
                .emberHeadlineSmall(color: .orange)
            
            Text(label)
                .emberCaption(color: EmberColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
    }
    
    private var milestoneJourney: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Journey")
                .emberHeadline()
            
            // Journey Timeline
            VStack(spacing: 0) {
                ForEach(Array(milestones.enumerated()), id: \.element.id) { index, milestone in
                    milestoneJourneyItem(milestone, isLast: index == milestones.count - 1)
                }
            }
        }
    }
    
    private func milestoneJourneyItem(_ milestone: Milestone, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline indicator
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(milestone.color.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: milestone.icon)
                        .font(.system(size: 14))
                        .foregroundStyle(milestone.color)
                }
                
                if !isLast {
                    Rectangle()
                        .fill(EmberColors.border)
                        .frame(width: 2, height: 40)
                }
            }
            
            // Milestone content
            Button(action: {
                selectedMilestone = milestone
                showingMilestoneDetail = true
            }) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(milestone.title)
                            .emberLabel()
                        
                        Spacer()
                        
                        Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                            .emberCaption(color: EmberColors.textTertiary)
                    }
                    
                    Text(milestone.description)
                        .emberBody(color: EmberColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    if milestone.isShared {
                        HStack(spacing: 4) {
                            Image(systemName: "heart.2.fill")
                                .font(.system(size: 10))
                            Text("Shared milestone")
                        }
                        .emberCaption(color: EmberColors.roseQuartz)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(EmberColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, isLast ? 0 : 8)
    }
    
    private var recentMilestones: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Milestones")
                    .emberHeadline()
                Spacer()
                Button("View All") {}
                    .emberCaption(color: EmberColors.roseQuartz)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(milestones.prefix(3)) { milestone in
                        recentMilestoneCard(milestone)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
    
    private func recentMilestoneCard(_ milestone: Milestone) -> some View {
        Button(action: {
            selectedMilestone = milestone
            showingMilestoneDetail = true
        }) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(milestone.color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: milestone.icon)
                        .font(.system(size: 24))
                        .foregroundStyle(milestone.color)
                }
                
                VStack(spacing: 4) {
                    Text(milestone.title)
                        .emberLabel()
                        .lineLimit(1)
                    
                    Text(milestone.date.formatted(date: .abbreviated, time: .omitted))
                        .emberCaption(color: EmberColors.textSecondary)
                }
            }
            .frame(width: 120)
            .padding(12)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - New Milestone View
struct EmberNewMilestoneView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var selectedDate = Date()
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = EmberColors.roseQuartz
    @State private var isShared = true
    
    private let availableIcons = ["star.fill", "heart.fill", "lips.fill", "airplane", "house.fill", "person.3.fill", "gift.fill", "camera.fill"]
    private let availableColors = [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop, EmberColors.lavenderMist, .purple, .green, .blue, .orange]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Title
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title")
                            .emberLabel()
                        
                        TextField("Milestone title", text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(EmberColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(EmberColors.border, lineWidth: 1)
                            )
                    }
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .emberLabel()
                        
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .padding(12)
                            .background(EmberColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(EmberColors.border, lineWidth: 1)
                            )
                    }
                    
                    // Date
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Date")
                            .emberLabel()
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding(12)
                            .background(EmberColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    // Icon Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Icon")
                            .emberLabel()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: { selectedIcon = icon }) {
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundStyle(selectedIcon == icon ? .white : selectedColor)
                                            .frame(width: 44, height: 44)
                                            .background(selectedIcon == icon ? selectedColor : selectedColor.opacity(0.1))
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Color Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .emberLabel()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(availableColors.enumerated()), id: \.offset) { index, color in
                                    Button(action: { selectedColor = color }) {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 32, height: 32)
                                            .overlay(
                                                Circle()
                                                    .stroke(.white, lineWidth: selectedColor == color ? 3 : 0)
                                            )
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Shared Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Shared Milestone")
                                .emberLabel()
                            Text("Both partners can see this")
                                .emberCaption(color: EmberColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $isShared)
                            .tint(selectedColor)
                    }
                    .padding(16)
                    .background(EmberColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("New Milestone")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveMilestone()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveMilestone() {
        EmberHapticsManager.shared.playMedium()
        // Save milestone logic here
        dismiss()
    }
}

// MARK: - Milestone Detail View
struct EmberMilestoneDetailView: View {
    let milestone: Milestone
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(milestone.color.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: milestone.icon)
                                .font(.system(size: 40))
                                .foregroundStyle(milestone.color)
                        }
                        
                        VStack(spacing: 8) {
                            Text(milestone.title)
                                .emberHeadline()
                                .multilineTextAlignment(.center)
                            
                            Text(milestone.date.formatted(date: .complete, time: .omitted))
                                .emberBody(color: EmberColors.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .emberLabel()
                        
                        Text(milestone.description)
                            .emberBody()
                            .lineSpacing(4)
                    }
                    
                    // Milestone Info
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 16))
                                .foregroundStyle(EmberColors.textSecondary)
                            
                            Text("Added \(milestone.date.formatted(date: .abbreviated, time: .omitted))")
                                .emberBody(color: EmberColors.textSecondary)
                            
                            Spacer()
                        }
                        
                        if milestone.isShared {
                            HStack {
                                Image(systemName: "heart.2.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(EmberColors.roseQuartz)
                                
                                Text("Shared with your partner")
                                    .emberBody(color: EmberColors.textSecondary)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(16)
                    .background(EmberColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EmberMemoryMilestonesView()
}