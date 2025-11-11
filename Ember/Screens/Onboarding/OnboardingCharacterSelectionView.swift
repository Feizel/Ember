import SwiftUI

struct OnboardingCharacterSelectionView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @State private var selectedCharacter: CharacterType = .touchy
    @State private var selectedTheme: ColorTheme = .ember
    @State private var selectedAccessory: Accessory = .none
    @State private var showContent = false
    @State private var breathingScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with always visible skip
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Button("Use Defaults") {
                        EmberHapticsManager.shared.playLight()
                        onSkip()
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
                }
                
                VStack(spacing: 12) {
                    Text("Meet Your Companion")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Customize your adorable blob friend")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
            
            
            Spacer().frame(height: 40)
            
            // Character preview
            VStack(spacing: 20) {
                EmberBlobCharacter(
                    size: 140,
                    mood: .happy,
                    tintStart: selectedTheme.gradientColors.first ?? EmberColors.roseQuartz,
                    tintEnd: selectedTheme.gradientColors.last ?? EmberColors.peachyKeen,
                    animate: true
                )
                .scaleEffect(breathingScale)
                
                Text(selectedCharacter.name)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer().frame(height: 32)
            
            // Customization options
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    // Character selection
                    CustomizationSection(title: "Character Type") {
                        HStack(spacing: 12) {
                            ForEach([CharacterType.touchy, CharacterType.syncee], id: \.self) { character in
                                CharacterButton(
                                    character: character,
                                    isSelected: selectedCharacter == character,
                                    onTap: {
                                        selectedCharacter = character
                                        EmberHapticsManager.shared.playLight()
                                    }
                                )
                            }
                        }
                    }
                    
                    // Color theme selection
                    CustomizationSection(title: "Color Theme") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(ColorTheme.allCases, id: \.self) { theme in
                                ColorThemeButton(
                                    theme: theme,
                                    isSelected: selectedTheme == theme,
                                    onTap: {
                                        selectedTheme = theme
                                        EmberHapticsManager.shared.playLight()
                                    }
                                )
                            }
                        }
                    }
                    
                    // Accessory selection
                    CustomizationSection(title: "Accessory") {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                            ForEach(Accessory.allCases, id: \.self) { accessory in
                                AccessoryButton(
                                    accessory: accessory,
                                    isSelected: selectedAccessory == accessory,
                                    onTap: {
                                        selectedAccessory = accessory
                                        EmberHapticsManager.shared.playMedium()
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            
            // Continue button
            VStack(spacing: 16) {
                Button(action: {
                    EmberHapticsManager.shared.playSuccess()
                    saveCustomization()
                    onNext()
                }) {
                    Text("Perfect! Let's Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .shadow(
                            color: .black.opacity(0.1),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Breathing animation
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            breathingScale = 1.06
        }
        
        EmberHapticsManager.shared.playLight()
    }
    
    private func saveCustomization() {
        // Save to UserDefaults or Core Data
        UserDefaults.standard.set(selectedCharacter.name, forKey: "selectedCharacter")
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        UserDefaults.standard.set(selectedAccessory.rawValue, forKey: "selectedAccessory")
    }
}

struct CustomizationSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
            
            content
        }
    }
}

struct CharacterButton: View {
    let character: CharacterType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                EmberBlobCharacter(
                    size: 50,
                    mood: .happy,
                    tintStart: EmberColors.roseQuartz,
                    tintEnd: EmberColors.peachyKeen,
                    animate: false
                )
                
                Text(character.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .white.opacity(0.25) : .white.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .white.opacity(0.6) : .white.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ColorThemeButton: View {
    let theme: ColorTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: theme.gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? .white : .white.opacity(0.4), lineWidth: isSelected ? 3 : 1)
                    )
                
                Text(theme.displayName)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .white.opacity(0.15) : .clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AccessoryButton: View {
    let accessory: Accessory
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    if accessory != .none {
                        Image(systemName: accessory.icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                    } else {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
                .overlay(
                    Circle()
                        .stroke(isSelected ? .white.opacity(0.6) : .white.opacity(0.3), lineWidth: isSelected ? 3 : 1)
                )
                
                Text(accessory.displayName)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.8))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .white.opacity(0.15) : .clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum ColorTheme: String, CaseIterable {
    case ember, sunset, ocean, forest, lavender, coral, orange, blue, pink
    
    var displayName: String {
        switch self {
        case .ember: return "Ember"
        case .sunset: return "Sunset"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        case .lavender: return "Lavender"
        case .coral: return "Coral"
        case .orange: return "Orange"
        case .blue: return "Blue"
        case .pink: return "Pink"
        }
    }
    
    var gradientColors: [Color] {
        switch self {
        case .ember: return [EmberColors.roseQuartz, EmberColors.peachyKeen]
        case .sunset: return [.orange, .red]
        case .ocean: return [.blue, .cyan]
        case .forest: return [.green, Color(hex: "#228B22")]
        case .lavender: return [.purple, Color(hex: "#E6E6FA")]
        case .coral: return [EmberColors.coralPop, Color(hex: "#FF7F7F")]
        case .orange: return [.orange, Color(hex: "#FFB347")]
        case .blue: return [.blue, Color(hex: "#87CEEB")]
        case .pink: return [.pink, Color(hex: "#FFB6C1")]
        }
    }
}

enum Accessory: String, CaseIterable {
    case none, crown, bow, glasses, flower, hat
    
    var displayName: String {
        switch self {
        case .none: return "None"
        case .crown: return "Crown"
        case .bow: return "Bow"
        case .glasses: return "Glasses"
        case .flower: return "Flower"
        case .hat: return "Hat"
        }
    }
    
    var icon: String {
        switch self {
        case .none: return ""
        case .crown: return "crown.fill"
        case .bow: return "bowtie.fill"
        case .glasses: return "eyeglasses"
        case .flower: return "leaf.fill"
        case .hat: return "hat.fill"
        }
    }
}

#Preview {
    OnboardingCharacterSelectionView(
        onNext: { print("Next") },
        onSkip: { print("Skip") }
    )
}