import SwiftUI

// MARK: - Memory Journal View
struct EmberMemoryJournalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingNewEntry = false
    @State private var selectedEntry: JournalEntry?
    @State private var showingEntryDetail = false
    
    private let entries = JournalEntry.sampleEntries
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Journal Stats
                    journalStats
                    
                    // Recent Entries
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent Entries")
                                .emberHeadline()
                            Spacer()
                            Button("View All") {}
                                .emberCaption(color: EmberColors.roseQuartz)
                        }
                        
                        VStack(spacing: 12) {
                            ForEach(entries.prefix(5)) { entry in
                                journalEntryRow(entry)
                            }
                        }
                    }
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
                    Text("Memory Journal")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            EmberNewJournalEntryView()
        }
        .sheet(isPresented: $showingEntryDetail) {
            if let entry = selectedEntry {
                EmberJournalEntryDetailView(entry: entry)
            }
        }
    }
    
    private var journalStats: some View {
        HStack(spacing: 16) {
            statCard(value: "32", label: "Entries", icon: "book.fill", color: EmberColors.peachyKeen)
            statCard(value: "89", label: "Days", icon: "calendar.badge.clock", color: EmberColors.roseQuartz)
            statCard(value: "5", label: "This Week", icon: "chart.line.uptrend.xyaxis", color: EmberColors.coralPop)
        }
    }
    
    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
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
    
    private func journalEntryRow(_ entry: JournalEntry) -> some View {
        Button(action: {
            selectedEntry = entry
            showingEntryDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.title)
                            .emberLabel()
                        Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                            .emberCaption(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(EmberColors.roseQuartz)
                        Text(entry.mood.emoji)
                            .font(.system(size: 16))
                    }
                }
                
                Text(entry.preview)
                    .emberBody(color: EmberColors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Journal Entry Model
struct JournalEntry: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let date: Date
    let mood: Mood
    let isPrivate: Bool
    
    var preview: String {
        String(content.prefix(100)) + (content.count > 100 ? "..." : "")
    }
    
    enum Mood: CaseIterable {
        case happy, love, excited, peaceful, grateful, nostalgic
        
        var emoji: String {
            switch self {
            case .happy: return "😊"
            case .love: return "🥰"
            case .excited: return "🤩"
            case .peaceful: return "😌"
            case .grateful: return "🙏"
            case .nostalgic: return "💭"
            }
        }
        
        var name: String {
            switch self {
            case .happy: return "Happy"
            case .love: return "In Love"
            case .excited: return "Excited"
            case .peaceful: return "Peaceful"
            case .grateful: return "Grateful"
            case .nostalgic: return "Nostalgic"
            }
        }
    }
    
    static let sampleEntries = [
        JournalEntry(title: "Perfect Morning", content: "Woke up next to my favorite person. The way the sunlight hit their face made my heart skip a beat. These are the moments I want to remember forever.", date: Date().addingTimeInterval(-3600), mood: .love, isPrivate: true),
        JournalEntry(title: "Coffee Date", content: "We discovered this amazing little café today. The barista drew a heart in my latte foam, and Alex laughed so hard they snorted. I love their laugh.", date: Date().addingTimeInterval(-86400), mood: .happy, isPrivate: false),
        JournalEntry(title: "Rainy Day", content: "Spent the whole day inside, just talking and being together. Sometimes the best dates are the ones where you don't go anywhere at all.", date: Date().addingTimeInterval(-172800), mood: .peaceful, isPrivate: true),
        JournalEntry(title: "Anniversary", content: "Can't believe it's been three months already. Time flies when you're with the right person. Feeling so grateful for this love.", date: Date().addingTimeInterval(-259200), mood: .grateful, isPrivate: false),
        JournalEntry(title: "First Kiss", content: "I keep thinking about our first kiss. It was so perfect, so natural. I knew in that moment that this was something special.", date: Date().addingTimeInterval(-345600), mood: .nostalgic, isPrivate: true)
    ]
}

// MARK: - New Journal Entry View
struct EmberNewJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood: JournalEntry.Mood = .happy
    @State private var isPrivate = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Title
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Title")
                            .emberLabel()
                        
                        TextField("Give your entry a title", text: $title)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(EmberColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(EmberColors.border, lineWidth: 1)
                            )
                    }
                    
                    // Content
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your thoughts")
                            .emberLabel()
                        
                        TextEditor(text: $content)
                            .frame(minHeight: 200)
                            .padding(12)
                            .background(EmberColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(EmberColors.border, lineWidth: 1)
                            )
                    }
                    
                    // Mood Selector
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How are you feeling?")
                            .emberLabel()
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(JournalEntry.Mood.allCases, id: \.self) { mood in
                                    Button(action: { selectedMood = mood }) {
                                        VStack(spacing: 4) {
                                            Text(mood.emoji)
                                                .font(.system(size: 24))
                                            Text(mood.name)
                                                .emberCaption(color: selectedMood == mood ? EmberColors.roseQuartz : EmberColors.textSecondary)
                                        }
                                        .padding(12)
                                        .background(selectedMood == mood ? EmberColors.roseQuartz.opacity(0.1) : EmberColors.surface)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedMood == mood ? EmberColors.roseQuartz : EmberColors.border, lineWidth: 1)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    
                    // Privacy Toggle
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Private Entry")
                                .emberLabel()
                            Text("Only you can see this")
                                .emberCaption(color: EmberColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: $isPrivate)
                            .tint(EmberColors.roseQuartz)
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
                    Text("New Entry")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func saveEntry() {
        EmberHapticsManager.shared.playMedium()
        // Save entry logic here
        dismiss()
    }
}

// MARK: - Journal Entry Detail View
struct EmberJournalEntryDetailView: View {
    let entry: JournalEntry
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text(entry.title)
                                .emberHeadline()
                            Spacer()
                            Text(entry.mood.emoji)
                                .font(.system(size: 24))
                        }
                        
                        HStack {
                            Text(entry.date.formatted(date: .complete, time: .shortened))
                                .emberCaption(color: EmberColors.textSecondary)
                            
                            Spacer()
                            
                            if entry.isPrivate {
                                HStack(spacing: 4) {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 12))
                                    Text("Private")
                                }
                                .emberCaption(color: EmberColors.textTertiary)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Content
                    Text(entry.content)
                        .emberBody()
                        .lineSpacing(4)
                    
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
    EmberMemoryJournalView()
}