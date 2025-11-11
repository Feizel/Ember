import SwiftUI

enum CharacterExpression: String, CaseIterable, Codable {
    case happy = "happy"
    case excited = "excited"
    case love = "love"
    case sleeping = "sleeping"
    case sad = "sad"
    case waiting = "waiting"
    case romantic = "romantic"
    case warmSmile = "warmSmile"
    
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
    
    var description: String {
        switch self {
        case .happy: return "Cheerful and bright"
        case .excited: return "Full of energy"
        case .love: return "Heart eyes for you"
        case .sleeping: return "Peaceful and calm"
        case .sad: return "Feeling down"
        case .waiting: return "Patiently waiting"
        case .romantic: return "Feeling romantic"
        case .warmSmile: return "Gentle and caring"
        }
    }
}

struct CharacterCustomization: Codable {
    var colorTheme: CharacterColorTheme
    var accessory: CharacterAccessory
    var expression: CharacterExpression
    var name: String
    
    init(colorTheme: CharacterColorTheme, accessory: CharacterAccessory, expression: CharacterExpression, name: String = "My Heart") {
        self.colorTheme = colorTheme
        self.accessory = accessory
        self.expression = expression
        self.name = name
    }
    
    // Convenience initializer for AuthenticationView compatibility
    init(colorTheme: CharacterColorTheme, expression: CharacterExpression, name: String = "My Heart") {
        self.colorTheme = colorTheme
        self.accessory = .none
        self.expression = expression
        self.name = name
    }
    
    var primaryColor: Color {
        return colorTheme.colors.first ?? .orange
    }
    
    var secondaryColor: Color {
        return colorTheme.colors.last ?? .yellow
    }
    
    static let `default` = CharacterCustomization(
        colorTheme: .default,
        accessory: .none,
        expression: .happy,
        name: "My Heart"
    )
}

enum CharacterColorTheme: String, CaseIterable, Codable {
    case `default` = "default"
    case sunset = "sunset"
    case ocean = "ocean"
    case forest = "forest"
    case lavender = "lavender"
    case orange = "orange"
    case coral = "coral"
    case blue = "blue"
    case pink = "pink"
    
    var colors: [Color] {
        switch self {
        case .default:
            return [Color(red: 1.0, green: 0.42, blue: 0.21), Color(red: 1.0, green: 0.85, blue: 0.49)]
        case .sunset:
            return [Color(red: 1.0, green: 0.31, blue: 0.52), Color(red: 1.0, green: 0.65, blue: 0.31)]
        case .ocean:
            return [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.8, blue: 0.9)]
        case .forest:
            return [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.6, green: 0.9, blue: 0.3)]
        case .lavender:
            return [Color(red: 0.7, green: 0.5, blue: 1.0), Color(red: 0.9, green: 0.7, blue: 1.0)]
        case .orange:
            return [Color(red: 1.0, green: 0.42, blue: 0.21), Color(red: 1.0, green: 0.65, blue: 0.31)]
        case .coral:
            return [Color(red: 1.0, green: 0.50, blue: 0.31), Color(red: 1.0, green: 0.75, blue: 0.80)]
        case .blue:
            return [Color(red: 0.2, green: 0.6, blue: 1.0), Color(red: 0.4, green: 0.8, blue: 0.9)]
        case .pink:
            return [Color(red: 1.0, green: 0.68, blue: 0.80), Color(red: 1.0, green: 0.85, blue: 0.92)]
        }
    }
    
    var displayName: String {
        switch self {
        case .default: return "Warm Orange"
        case .sunset: return "Sunset"
        case .ocean: return "Ocean Blue"
        case .forest: return "Forest Green"
        case .lavender: return "Lavender"
        case .orange: return "Orange"
        case .coral: return "Coral"
        case .blue: return "Blue"
        case .pink: return "Pink"
        }
    }
    
    var description: String {
        switch self {
        case .default: return "Classic warm tones"
        case .sunset: return "Romantic sunset hues"
        case .ocean: return "Cool ocean vibes"
        case .forest: return "Natural green tones"
        case .lavender: return "Soft purple shades"
        case .orange: return "Vibrant orange"
        case .coral: return "Soft coral pink"
        case .blue: return "Cool blue tones"
        case .pink: return "Sweet pink shades"
        }
    }
    
    var primaryColor: Color {
        return colors.first ?? .orange
    }
    
    var secondaryColor: Color {
        return colors.last ?? .yellow
    }
}

enum CharacterAccessory: String, CaseIterable, Codable {
    case none = "none"
    case crown = "crown"
    case hat = "hat"
    case bow = "bow"
    case glasses = "glasses"
    case flower = "flower"
    
    var unlockLevel: Int {
        switch self {
        case .none: return 1
        case .bow: return 5
        case .hat: return 10
        case .crown: return 12
        case .glasses: return 15
        case .flower: return 20
        }
    }
    
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
    
    var colors: [Color] {
        switch self {
        case .none: return [.gray]
        case .crown: return [.yellow, .orange]
        case .hat: return [.blue, .purple]
        case .bow: return [.red, .pink]
        case .glasses: return [.black, .gray]
        case .flower: return [.green, .yellow]
        }
    }
}

enum CharacterType {
    case touchy
    case syncee
    case harmony
    case flux
    
    var name: String {
        switch self {
        case .touchy: return "Touchy"
        case .syncee: return "Syncee"
        case .harmony: return "Harmony"
        case .flux: return "Flux"
        }
    }
}

enum CharacterMood: String, CaseIterable {
    case happy = "happy"
    case excited = "excited"
    case love = "love"
    case sleeping = "sleeping"
    case sad = "sad"
    case waiting = "waiting"
    case romantic = "romantic"
    case warmSmile = "warmSmile"
}