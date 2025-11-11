import SwiftUI

enum CoupleStatus: String, CaseIterable, Codable {
    case available = "available"
    case busy = "busy"
    case sleeping = "sleeping"
    case romantic = "romantic"
    case missing = "missing"
    case excited = "excited"
    case working = "working"
    case relaxing = "relaxing"
    case feelingBlue = "feelingBlue"
    case thatTimeOfMonth = "thatTimeOfMonth"
    case underTheWeather = "underTheWeather"
    
    var displayName: String {
        switch self {
        case .available: return "Available"
        case .busy: return "Busy"
        case .sleeping: return "Sleeping"
        case .romantic: return "Feeling Romantic"
        case .missing: return "Missing You"
        case .excited: return "Excited"
        case .working: return "Working"
        case .relaxing: return "Relaxing"
        case .feelingBlue: return "Feeling Blue"
        case .thatTimeOfMonth: return "That Time of Month"
        case .underTheWeather: return "Under the Weather"
        }
    }
    
    var icon: String {
        switch self {
        case .available: return "heart.fill"
        case .busy: return "clock.fill"
        case .sleeping: return "moon.fill"
        case .romantic: return "heart.circle.fill"
        case .missing: return "heart.text.square.fill"
        case .excited: return "star.fill"
        case .working: return "laptopcomputer"
        case .relaxing: return "leaf.fill"
        case .feelingBlue: return "cloud.rain.fill"
        case .thatTimeOfMonth: return "calendar.badge.clock"
        case .underTheWeather: return "thermometer.medium"
        }
    }
    
    var color: Color {
        switch self {
        case .available: return .green
        case .busy: return .orange
        case .sleeping: return .indigo
        case .romantic: return .pink
        case .missing: return .red
        case .excited: return .yellow
        case .working: return .blue
        case .relaxing: return .mint
        case .feelingBlue: return .blue
        case .thatTimeOfMonth: return .purple
        case .underTheWeather: return .gray
        }
    }
    
    var description: String {
        switch self {
        case .available: return "Ready for touches"
        case .busy: return "Might not respond quickly"
        case .sleeping: return "Dreaming of you"
        case .romantic: return "In the mood for love"
        case .missing: return "Thinking of you"
        case .excited: return "Full of energy"
        case .working: return "Focus mode on"
        case .relaxing: return "Taking it easy"
        case .feelingBlue: return "Need some comfort"
        case .thatTimeOfMonth: return "Extra care needed"
        case .underTheWeather: return "Not feeling well"
        }
    }
}

struct UserStatus: Codable {
    var status: CoupleStatus
    var customMessage: String?
    var lastUpdated: Date
    
    init(status: CoupleStatus = .available, customMessage: String? = nil) {
        self.status = status
        self.customMessage = customMessage
        self.lastUpdated = Date()
    }
}