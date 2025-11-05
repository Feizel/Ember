import SwiftUI
import Foundation

// MARK: - Memory Model
struct Memory: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let type: MemoryType
    let date: Date
    let isFromPartner: Bool
    let isFavorite: Bool
    let location: String?
    let tags: [String]
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    enum MemoryType: CaseIterable {
        case photo, note, voice, location, milestone
        
        var title: String {
            switch self {
            case .photo: return "Photo"
            case .note: return "Note"
            case .voice: return "Voice"
            case .location: return "Location"
            case .milestone: return "Milestone"
            }
        }
        
        var icon: String {
            switch self {
            case .photo: return "camera.fill"
            case .note: return "text.quote"
            case .voice: return "mic.fill"
            case .location: return "location.fill"
            case .milestone: return "star.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .photo: return EmberColors.roseQuartz
            case .note: return EmberColors.peachyKeen
            case .voice: return EmberColors.coralPop
            case .location: return EmberColors.lavenderMist
            case .milestone: return .yellow
            }
        }
    }
    
    static let sampleMemories: [Memory] = [
        Memory(
            title: "Coffee Date",
            content: "Perfect morning with my favorite person ☕️💕",
            type: .photo,
            date: Date().addingTimeInterval(-3600),
            isFromPartner: false,
            isFavorite: true,
            location: "Blue Bottle Coffee",
            tags: ["coffee", "morning", "date"]
        ),
        Memory(
            title: "Love Note",
            content: "Missing you so much today! Can't wait to see you tonight 💕",
            type: .note,
            date: Date().addingTimeInterval(-7200),
            isFromPartner: true,
            isFavorite: false,
            location: nil,
            tags: ["love", "missing"]
        ),
        Memory(
            title: "Sunset Walk",
            content: "Beautiful evening together at the beach",
            type: .photo,
            date: Date().addingTimeInterval(-86400),
            isFromPartner: false,
            isFavorite: true,
            location: "Santa Monica Beach",
            tags: ["sunset", "beach", "walk"]
        ),
        Memory(
            title: "Good Morning",
            content: "Voice message: 'Good morning beautiful, hope you have an amazing day!'",
            type: .voice,
            date: Date().addingTimeInterval(-172800),
            isFromPartner: true,
            isFavorite: false,
            location: nil,
            tags: ["morning", "voice"]
        ),
        Memory(
            title: "First Kiss",
            content: "The moment everything changed ✨",
            type: .milestone,
            date: Date().addingTimeInterval(-2592000),
            isFromPartner: false,
            isFavorite: true,
            location: "Central Park",
            tags: ["first", "kiss", "milestone"]
        ),
        Memory(
            title: "Anniversary Dinner",
            content: "Three months together! 🎉",
            type: .milestone,
            date: Date().addingTimeInterval(-259200),
            isFromPartner: false,
            isFavorite: true,
            location: "The French Laundry",
            tags: ["anniversary", "dinner", "milestone"]
        )
    ]
}

// MARK: - Memory Statistics
struct MemoryStats {
    let totalMemories: Int
    let memoriesThisWeek: Int
    let memoriesToday: Int
    let daysTogether: Int
    let favoriteMemories: Int
    let milestones: Int
    
    static let sample = MemoryStats(
        totalMemories: 247,
        memoriesThisWeek: 32,
        memoriesToday: 8,
        daysTogether: 89,
        favoriteMemories: 45,
        milestones: 12
    )
}

// MARK: - Milestone Model
struct Milestone: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let icon: String
    let color: Color
    let isShared: Bool
    
    static let sampleMilestones: [Milestone] = [
        Milestone(
            title: "First Date",
            description: "Coffee at Blue Bottle turned into a 4-hour conversation",
            date: Date().addingTimeInterval(-7776000), // 90 days ago
            icon: "heart.fill",
            color: EmberColors.roseQuartz,
            isShared: true
        ),
        Milestone(
            title: "First Kiss",
            description: "Under the stars in Central Park",
            date: Date().addingTimeInterval(-6912000), // 80 days ago
            icon: "lips.fill",
            color: EmberColors.peachyKeen,
            isShared: true
        ),
        Milestone(
            title: "Said 'I Love You'",
            description: "Both said it at the same time during sunset",
            date: Date().addingTimeInterval(-5184000), // 60 days ago
            icon: "heart.text.square.fill",
            color: EmberColors.coralPop,
            isShared: true
        ),
        Milestone(
            title: "First Trip Together",
            description: "Weekend getaway to Napa Valley",
            date: Date().addingTimeInterval(-3456000), // 40 days ago
            icon: "airplane",
            color: EmberColors.lavenderMist,
            isShared: true
        ),
        Milestone(
            title: "Met the Parents",
            description: "Family dinner went better than expected!",
            date: Date().addingTimeInterval(-1728000), // 20 days ago
            icon: "person.3.fill",
            color: .purple,
            isShared: true
        ),
        Milestone(
            title: "Moved In Together",
            description: "Our first shared apartment",
            date: Date().addingTimeInterval(-864000), // 10 days ago
            icon: "house.fill",
            color: .green,
            isShared: true
        )
    ]
}

// MARK: - Memory Search Result
struct MemorySearchResult: Identifiable {
    let id = UUID()
    let memory: Memory
    let matchedText: String
    let matchType: MatchType
    
    enum MatchType {
        case title, content, tag, location
        
        var description: String {
            switch self {
            case .title: return "Title"
            case .content: return "Content"
            case .tag: return "Tag"
            case .location: return "Location"
            }
        }
    }
}

// MARK: - Memory Timeline Item
struct TimelineItem: Identifiable {
    let id = UUID()
    let date: Date
    let memories: [Memory]
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    static func groupMemoriesByDate(_ memories: [Memory]) -> [TimelineItem] {
        let grouped = Dictionary(grouping: memories) { memory in
            Calendar.current.startOfDay(for: memory.date)
        }
        
        return grouped.map { date, memories in
            TimelineItem(date: date, memories: memories.sorted { $0.date > $1.date })
        }.sorted { $0.date > $1.date }
    }
}