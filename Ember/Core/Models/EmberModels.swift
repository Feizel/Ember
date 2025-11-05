import SwiftUI
import Foundation

// MARK: - User Status
enum CoupleStatus: String, CaseIterable, Codable {
    // Love & Romance (4)
    case romantic, missing, inLove, dreaming
    // Mood & Energy (4) 
    case happy, excited, peaceful, playful
    // Daily Life (4)
    case available, busy, working, relaxing
    // Physical & Health (5)
    case sleeping, tired, energetic, cozy, underTheWeather
    // Emotional (6)
    case grateful, nostalgic, hopeful, content, feelingBlue, thatTimeOfTheMonth
    
    var displayName: String {
        switch self {
        case .romantic: return "Feeling Romantic"
        case .missing: return "Missing You"
        case .inLove: return "So In Love"
        case .dreaming: return "Dreaming of You"
        case .happy: return "Happy"
        case .excited: return "Excited"
        case .peaceful: return "Peaceful"
        case .playful: return "Playful"
        case .available: return "Available"
        case .busy: return "Busy"
        case .working: return "Working"
        case .relaxing: return "Relaxing"
        case .sleeping: return "Sleeping"
        case .tired: return "Tired"
        case .energetic: return "Energetic"
        case .cozy: return "Feeling Cozy"
        case .underTheWeather: return "Under the Weather"
        case .grateful: return "Grateful"
        case .nostalgic: return "Nostalgic"
        case .hopeful: return "Hopeful"
        case .content: return "Content"
        case .feelingBlue: return "Feeling Blue"
        case .thatTimeOfTheMonth: return "That Time of Month"
        }
    }
    
    var icon: String {
        switch self {
        case .romantic: return "heart.circle.fill"
        case .missing: return "heart.text.square.fill"
        case .inLove: return "heart.fill"
        case .dreaming: return "cloud.fill"
        case .happy: return "face.smiling.fill"
        case .excited: return "star.fill"
        case .peaceful: return "leaf.fill"
        case .playful: return "gamecontroller.fill"
        case .available: return "checkmark.circle.fill"
        case .busy: return "clock.fill"
        case .working: return "laptopcomputer"
        case .relaxing: return "sofa.fill"
        case .sleeping: return "moon.fill"
        case .tired: return "battery.25"
        case .energetic: return "bolt.fill"
        case .cozy: return "house.fill"
        case .underTheWeather: return "thermometer.medium"
        case .grateful: return "hands.sparkles.fill"
        case .nostalgic: return "photo.fill"
        case .hopeful: return "sunrise.fill"
        case .content: return "heart.circle"
        case .feelingBlue: return "cloud.rain.fill"
        case .thatTimeOfTheMonth: return "calendar.badge.clock"
        }
    }
    
    var color: Color {
        switch self {
        case .romantic: return EmberColors.roseQuartz
        case .missing: return .red
        case .inLove: return EmberColors.peachyKeen
        case .dreaming: return .purple
        case .happy: return .yellow
        case .excited: return .orange
        case .peaceful: return .mint
        case .playful: return .pink
        case .available: return .green
        case .busy: return .orange
        case .working: return .blue
        case .relaxing: return .teal
        case .sleeping: return .indigo
        case .tired: return .gray
        case .energetic: return .yellow
        case .cozy: return .brown
        case .underTheWeather: return .gray
        case .grateful: return EmberColors.coralPop
        case .nostalgic: return .purple
        case .hopeful: return .cyan
        case .content: return .green
        case .feelingBlue: return .blue
        case .thatTimeOfTheMonth: return .purple
        }
    }
    
    var category: StatusCategory {
        switch self {
        case .romantic, .missing, .inLove, .dreaming:
            return .loveRomance
        case .happy, .excited, .peaceful, .playful:
            return .moodEnergy
        case .available, .busy, .working, .relaxing:
            return .dailyLife
        case .sleeping, .tired, .energetic, .cozy, .underTheWeather:
            return .physicalHealth
        case .grateful, .nostalgic, .hopeful, .content, .feelingBlue, .thatTimeOfTheMonth:
            return .emotional
        }
    }
    
    static var topFour: [CoupleStatus] {
        [.romantic, .missing, .happy, .available]
    }
}

enum StatusCategory: String, CaseIterable {
    case loveRomance = "Love & Romance"
    case moodEnergy = "Mood & Energy"
    case dailyLife = "Daily Life"
    case physicalHealth = "Physical & Health"
    case emotional = "Emotional"
    
    var icon: String {
        switch self {
        case .loveRomance: return "heart.fill"
        case .moodEnergy: return "star.fill"
        case .dailyLife: return "house.fill"
        case .physicalHealth: return "figure.walk"
        case .emotional: return "brain.head.profile"
        }
    }
    
    var statuses: [CoupleStatus] {
        CoupleStatus.allCases.filter { $0.category == self }
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

// MARK: - Character System
enum CharacterExpression: String, CaseIterable, Codable {
    case happy, excited, love, sleeping, sad, waiting, romantic, warmSmile
    
    var name: String {
        switch self {
        case .happy: return "Happy"
        case .excited: return "Excited"
        case .love: return "In Love"
        case .sleeping: return "Sleepy"
        case .sad: return "Sad"
        case .waiting: return "Waiting"
        case .romantic: return "Romantic"
        case .warmSmile: return "Warm Smile"
        }
    }
}

enum CharacterColorTheme: String, CaseIterable, Codable {
    case `default`, sunset, ocean, forest, lavender, orange, coral, blue, pink
    
    var colors: [Color] {
        switch self {
        case .default: return [EmberColors.roseQuartz, EmberColors.peachyKeen]
        case .sunset: return [Color(red: 1.0, green: 0.31, blue: 0.52), Color(red: 1.0, green: 0.65, blue: 0.31)]
        case .ocean: return [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.8, blue: 0.9)]
        case .forest: return [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.6, green: 0.9, blue: 0.3)]
        case .lavender: return [Color(red: 0.7, green: 0.5, blue: 1.0), Color(red: 0.9, green: 0.7, blue: 1.0)]
        case .orange: return [Color(red: 1.0, green: 0.42, blue: 0.21), Color(red: 1.0, green: 0.65, blue: 0.31)]
        case .coral: return [Color(red: 1.0, green: 0.50, blue: 0.31), Color(red: 1.0, green: 0.75, blue: 0.80)]
        case .blue: return [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.8, blue: 0.9)]
        case .pink: return [Color(red: 1.0, green: 0.68, blue: 0.80), Color(red: 1.0, green: 0.85, blue: 0.92)]
        }
    }
    
    var displayName: String {
        switch self {
        case .default: return "Ember"
        case .sunset: return "Sunset"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        case .lavender: return "Lavender"
        case .orange: return "Orange"
        case .coral: return "Coral"
        case .blue: return "Blue"
        case .pink: return "Pink"
        }
    }
}

enum CharacterAccessory: String, CaseIterable, Codable {
    case none, crown, hat, bow, glasses, flower
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .crown: return "Crown"
        case .hat: return "Party Hat"
        case .bow: return "Bow Tie"
        case .glasses: return "Glasses"
        case .flower: return "Flower"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return "circle"
        case .crown: return "crown.fill"
        case .hat: return "party.popper.fill"
        case .bow: return "bowtie.fill"
        case .glasses: return "eyeglasses"
        case .flower: return "leaf.fill"
        }
    }
}

struct CharacterCustomization: Codable {
    var colorTheme: CharacterColorTheme
    var accessory: CharacterAccessory
    var expression: CharacterExpression
    var name: String
    
    init(colorTheme: CharacterColorTheme = .default, accessory: CharacterAccessory = .none, expression: CharacterExpression = .happy, name: String = "My Heart") {
        self.colorTheme = colorTheme
        self.accessory = accessory
        self.expression = expression
        self.name = name
    }
    
    static let `default` = CharacterCustomization()
}

enum CharacterType: CaseIterable {
    case touchy, syncee, harmony, flux
    
    var name: String {
        switch self {
        case .touchy: return "Touchy"
        case .syncee: return "Syncee"
        case .harmony: return "Harmony"
        case .flux: return "Flux"
        }
    }
    
    var personality: String {
        switch self {
        case .touchy: return "Gentle & Nurturing"
        case .syncee: return "Strong & Protective"
        case .harmony: return "Balanced & Fluid"
        case .flux: return "Dynamic & Expressive"
        }
    }
    
    var pronouns: String {
        switch self {
        case .touchy: return "they/them"
        case .syncee: return "they/them"
        case .harmony: return "they/them"
        case .flux: return "they/them"
        }
    }
}

// MARK: - Touch Models
struct TouchGesture: Codable, Identifiable {
    let id: UUID
    let type: TouchType
    let timestamp: Date
    let senderId: String
    let receiverId: String
    var isReceived: Bool
    
    init(type: TouchType, senderId: String, receiverId: String, isReceived: Bool = false) {
        self.id = UUID()
        self.type = type
        self.timestamp = Date()
        self.senderId = senderId
        self.receiverId = receiverId
        self.isReceived = isReceived
    }
}

enum TouchType: String, CaseIterable, Codable {
    case kiss, hug, wave, love, tickle, squeeze
    
    var displayName: String {
        switch self {
        case .kiss: return "Kiss"
        case .hug: return "Hug"
        case .wave: return "Wave"
        case .love: return "Love"
        case .tickle: return "Tickle"
        case .squeeze: return "Squeeze"
        }
    }
    
    var icon: String {
        switch self {
        case .kiss: return "lips.fill"
        case .hug: return "hands.sparkles.fill"
        case .wave: return "hand.wave.fill"
        case .love: return "heart.fill"
        case .tickle: return "hand.point.up.fill"
        case .squeeze: return "hand.raised.fill"
        }
    }
}

// MARK: - User Model
struct MockUser: Codable {
    let uid: String
    let email: String
    
    init(uid: String, email: String = "demo@ember.app") {
        self.uid = uid
        self.email = email
    }
}