import Foundation
import Combine
import SwiftUI

@MainActor
class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @Published var hapticFeedbackEnabled: Bool {
        didSet { UserDefaults.standard.set(hapticFeedbackEnabled, forKey: "hapticFeedbackEnabled") }
    }
    
    @Published var hapticIntensity: HapticIntensity {
        didSet { UserDefaults.standard.set(hapticIntensity.rawValue, forKey: "hapticIntensity") }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet { UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled") }
    }
    
    @Published var remindersEnabled: Bool {
        didSet { UserDefaults.standard.set(remindersEnabled, forKey: "remindersEnabled") }
    }
    
    @Published var dailyGoal: Int {
        didSet { UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal") }
    }
    
    @Published var characterCustomization: CharacterCustomization {
        didSet { saveCharacterCustomization() }
    }
    
    private init() {
        self.hapticFeedbackEnabled = UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true
        self.hapticIntensity = HapticIntensity(rawValue: UserDefaults.standard.string(forKey: "hapticIntensity") ?? "medium") ?? .medium
        self.notificationsEnabled = UserDefaults.standard.object(forKey: "notificationsEnabled") as? Bool ?? true
        self.remindersEnabled = UserDefaults.standard.object(forKey: "remindersEnabled") as? Bool ?? true
        self.dailyGoal = UserDefaults.standard.object(forKey: "dailyGoal") as? Int ?? 5
        
        if let data = UserDefaults.standard.data(forKey: "characterCustomization"),
           let customization = try? JSONDecoder().decode(CharacterCustomization.self, from: data) {
            self.characterCustomization = customization
        } else {
            self.characterCustomization = .default
        }
    }
    
    private func saveCharacterCustomization() {
        if let data = try? JSONEncoder().encode(characterCustomization) {
            UserDefaults.standard.set(data, forKey: "characterCustomization")
        }
    }
    

}

enum HapticIntensity: String, CaseIterable {
    case light = "light"
    case medium = "medium"
    case strong = "strong"
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .medium: return "Medium"
        case .strong: return "Strong"
        }
    }
    
    var multiplier: Float {
        switch self {
        case .light: return 0.5
        case .medium: return 1.0
        case .strong: return 1.5
        }
    }
}