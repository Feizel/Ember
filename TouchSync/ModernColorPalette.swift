import SwiftUI

struct ModernColorPalette {
    // Primary Colors - Soft and Modern
    static let primary = Color(red: 0.4, green: 0.6, blue: 1.0)        // Soft Blue
    static let secondary = Color(red: 1.0, green: 0.4, blue: 0.8)      // Soft Pink
    static let accent = Color(red: 0.6, green: 0.8, blue: 0.4)         // Soft Green
    
    // Neutral Colors
    static let background = Color(red: 0.98, green: 0.98, blue: 1.0)   // Very Light Blue
    static let surface = Color.white
    static let surfaceSecondary = Color(red: 0.96, green: 0.97, blue: 0.99)
    
    // Text Colors
    static let textPrimary = Color(red: 0.15, green: 0.15, blue: 0.2)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.5)
    static let textTertiary = Color(red: 0.6, green: 0.6, blue: 0.65)
    
    // Character Colors
    static let characterPrimary = Color(red: 0.5, green: 0.7, blue: 1.0)
    static let characterSecondary = Color(red: 1.0, green: 0.5, blue: 0.8)
    static let characterAccent = Color(red: 0.7, green: 0.9, blue: 0.5)
    
    // Gradient Combinations
    static let primaryGradient = LinearGradient(
        colors: [primary, Color(red: 0.3, green: 0.5, blue: 0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [secondary, Color(red: 0.9, green: 0.3, blue: 0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}