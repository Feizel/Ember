import SwiftUI
import Combine

@MainActor
class CharacterCustomizationManager: ObservableObject {
    @Published var userCustomization = CharacterCustomization.default
    @Published var partnerCustomization = CharacterCustomization.default
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadCustomizations()
    }
    
    func updateUserCustomization(_ customization: CharacterCustomization) {
        userCustomization = customization
        saveCustomizations()
        syncToCloudKit()
    }
    
    func isAccessoryUnlocked(_ accessory: CharacterAccessory) -> Bool {
        let currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
        return max(1, currentLevel) >= accessory.unlockLevel
    }
    
    func isColorThemeUnlocked(_ theme: CharacterColorTheme) -> Bool {
        // All themes are unlocked for now
        return true
    }
    
    private func loadCustomizations() {
        if let data = userDefaults.data(forKey: "userCharacterCustomization"),
           let customization = try? JSONDecoder().decode(CharacterCustomization.self, from: data) {
            userCustomization = customization
        }
        
        if let data = userDefaults.data(forKey: "partnerCharacterCustomization"),
           let customization = try? JSONDecoder().decode(CharacterCustomization.self, from: data) {
            partnerCustomization = customization
        }
    }
    
    private func saveCustomizations() {
        if let data = try? JSONEncoder().encode(userCustomization) {
            userDefaults.set(data, forKey: "userCharacterCustomization")
        }
        
        if let data = try? JSONEncoder().encode(partnerCustomization) {
            userDefaults.set(data, forKey: "partnerCharacterCustomization")
        }
    }
    
    private func syncToCloudKit() {
        print("Mock CloudKit sync for character customization")
    }
    
    func loadFromCloudKit() {
        print("Mock CloudKit load for character customization")
    }
}

