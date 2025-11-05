import SwiftUI

// MARK: - Interactive Character Customization View
struct EmberCharacterCustomizationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCharacter: CharacterType = .touchy
    @State private var selectedTheme: CharacterColorTheme = .default
    @State private var selectedAccessory: CharacterAccessory = .none
    @State private var selectedExpression: CharacterExpression = .happy
    @State private var isCharacterTouched = false
    @State private var heartParticles: [HeartParticle] = []
    @State private var showingPartnerReaction = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Interactive Character Preview
                EmberInteractiveCharacterPreview(
                    character: selectedCharacter,
                    theme: selectedTheme,
                    expression: selectedExpression,
                    accessory: selectedAccessory,
                    isCharacterTouched: $isCharacterTouched,
                    heartParticles: $heartParticles,
                    showingPartnerReaction: $showingPartnerReaction
                )
                
                // Customization Controls
                ScrollView {
                    VStack(spacing: 20) {
                        EmberCharacterSelector(selectedCharacter: $selectedCharacter)
                        EmberThemeSelector(selectedTheme: $selectedTheme)
                        EmberExpressionSelector(selectedExpression: $selectedExpression)
                        EmberAccessorySelector(selectedAccessory: $selectedAccessory)
                    }
                    .padding()
                }
                .background(EmberColors.backgroundSecondary)
            }
            .navigationTitle("Your Character")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        EmberHapticsManager.shared.playSuccess()
                        dismiss()
                    }
                    .emberBody(color: EmberColors.roseQuartz)
                }
            }
        }
    }
}

// MARK: - Interactive Character Preview
struct EmberInteractiveCharacterPreview: View {
    let character: CharacterType
    let theme: CharacterColorTheme
    let expression: CharacterExpression
    let accessory: CharacterAccessory
    @Binding var isCharacterTouched: Bool
    @Binding var heartParticles: [HeartParticle]
    @Binding var showingPartnerReaction: Bool
    @State private var dragOffset = CGSize.zero
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: theme.colors + [theme.colors.first?.opacity(0.3) ?? .clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Partner's character (smaller, in background)
                HStack {
                    Spacer()
                    EmberCharacterView(
                        character: character == .touchy ? .syncee : .touchy,
                        size: 60,
                        expression: showingPartnerReaction ? .love : .happy,
                        isAnimating: showingPartnerReaction
                    )
                    .opacity(0.7)
                    .scaleEffect(showingPartnerReaction ? 1.1 : 1.0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: showingPartnerReaction)
                }
                .padding(.trailing, 40)
                
                // Main character (interactive)
                ZStack {
                    ForEach(heartParticles) { particle in
                        Image(systemName: "heart.fill")
                            .foregroundStyle(EmberColors.roseQuartz)
                            .font(.system(size: particle.size))
                            .position(particle.position)
                            .opacity(particle.opacity)
                    }
                    
                    EmberCharacterView(
                        character: character,
                        size: 140,
                        expression: expression,
                        isAnimating: true
                    )
                    .scaleEffect(isPressed ? 1.1 : 1.0)
                    .offset(dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = CGSize(
                                    width: min(max(value.translation.width, -30), 30),
                                    height: min(max(value.translation.height, -30), 30)
                                )
                                
                                if !isPressed {
                                    isPressed = true
                                    EmberHapticsManager.shared.playLight()
                                    createHeartParticles()
                                    triggerPartnerReaction()
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                    dragOffset = .zero
                                    isPressed = false
                                }
                            }
                    )
                    .onTapGesture {
                        EmberHapticsManager.shared.playMedium()
                        createHeartParticles()
                        triggerPartnerReaction()
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                            isCharacterTouched.toggle()
                        }
                    }
                }
                
                // Character info
                VStack(spacing: 8) {
                    Text(character.name)
                        .emberHeadline(color: EmberColors.textOnGradient)
                    
                    Text("Tap and drag to play!")
                        .emberCaption(color: EmberColors.textOnGradient.opacity(0.8))
                }
                
                Spacer()
            }
            .padding(.top, 40)
        }
        .frame(height: 300)
    }
    
    private func createHeartParticles() {
        let newParticles = (0..<5).map { _ in
            HeartParticle(
                position: CGPoint(
                    x: CGFloat.random(in: 100...300),
                    y: CGFloat.random(in: 100...200)
                ),
                size: CGFloat.random(in: 12...20),
                opacity: 1.0
            )
        }
        
        heartParticles.append(contentsOf: newParticles)
        
        // Animate particles
        for (index, _) in newParticles.enumerated() {
            let particleIndex = heartParticles.count - newParticles.count + index
            
            withAnimation(.easeOut(duration: 2.0)) {
                heartParticles[particleIndex].position.y -= 100
                heartParticles[particleIndex].opacity = 0
            }
        }
        
        // Remove particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            heartParticles.removeAll { $0.opacity == 0 }
        }
    }
    
    private func triggerPartnerReaction() {
        showingPartnerReaction = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                showingPartnerReaction = false
            }
        }
    }
}

// MARK: - Character Selector
struct EmberCharacterSelector: View {
    @Binding var selectedCharacter: CharacterType
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Character")
                    .emberLabel()
                Spacer()
            }
            
            HStack(spacing: 16) {
                ForEach(CharacterType.allCases, id: \.self) { character in
                    Button(action: {
                        selectedCharacter = character
                        EmberHapticsManager.shared.playLight()
                    }) {
                        VStack(spacing: 8) {
                            EmberCharacterView(
                                character: character,
                                size: 50,
                                expression: .happy,
                                isAnimating: selectedCharacter == character
                            )
                            
                            Text(character.name)
                                .emberCaption()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(
                            selectedCharacter == character ?
                                EmberColors.roseQuartz.opacity(0.1) :
                                EmberColors.surface,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedCharacter == character ?
                                        EmberColors.roseQuartz :
                                        EmberColors.border,
                                    lineWidth: selectedCharacter == character ? 2 : 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Theme Selector
struct EmberThemeSelector: View {
    @Binding var selectedTheme: CharacterColorTheme
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Color Theme")
                    .emberLabel()
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(CharacterColorTheme.allCases, id: \.self) { theme in
                    Button(action: {
                        selectedTheme = theme
                        EmberHapticsManager.shared.playLight()
                    }) {
                        VStack(spacing: 6) {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: theme.colors,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            selectedTheme == theme ?
                                                EmberColors.roseQuartz :
                                                Color.clear,
                                            lineWidth: 2
                                        )
                                )
                                .scaleEffect(selectedTheme == theme ? 1.1 : 1.0)
                            
                            Text(theme.displayName)
                                .emberCaption()
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Expression Selector
struct EmberExpressionSelector: View {
    @Binding var selectedExpression: CharacterExpression
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Expression")
                    .emberLabel()
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(CharacterExpression.allCases, id: \.self) { expression in
                    Button(action: {
                        selectedExpression = expression
                        EmberHapticsManager.shared.playLight()
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: expression.icon)
                                .font(.system(size: 20))
                                .foregroundStyle(
                                    selectedExpression == expression ?
                                        EmberColors.roseQuartz :
                                        EmberColors.textSecondary
                                )
                                .scaleEffect(selectedExpression == expression ? 1.2 : 1.0)
                            
                            Text(expression.name)
                                .emberCaption()
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(
                            selectedExpression == expression ?
                                EmberColors.roseQuartz.opacity(0.1) :
                                EmberColors.surface,
                            in: RoundedRectangle(cornerRadius: 8)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Accessory Selector
struct EmberAccessorySelector: View {
    @Binding var selectedAccessory: CharacterAccessory
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Accessories")
                    .emberLabel()
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(CharacterAccessory.allCases, id: \.self) { accessory in
                    Button(action: {
                        selectedAccessory = accessory
                        EmberHapticsManager.shared.playLight()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: accessory.icon)
                                .font(.system(size: 24))
                                .foregroundStyle(
                                    selectedAccessory == accessory ?
                                        EmberColors.roseQuartz :
                                        EmberColors.textSecondary
                                )
                                .scaleEffect(selectedAccessory == accessory ? 1.1 : 1.0)
                            
                            Text(accessory.displayName)
                                .emberCaption()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(
                            selectedAccessory == accessory ?
                                EmberColors.roseQuartz.opacity(0.1) :
                                EmberColors.surface,
                            in: RoundedRectangle(cornerRadius: 12)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    selectedAccessory == accessory ?
                                        EmberColors.roseQuartz :
                                        EmberColors.border,
                                    lineWidth: selectedAccessory == accessory ? 2 : 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Heart Particle Model
struct HeartParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    var opacity: Double
}

// MARK: - Character Expression Icons Extension
extension CharacterExpression {
    var icon: String {
        switch self {
        case .happy: return "face.smiling"
        case .excited: return "star.fill"
        case .love: return "heart.fill"
        case .sleeping: return "moon.fill"
        case .sad: return "cloud.rain"
        case .waiting: return "clock"
        case .romantic: return "heart.circle.fill"
        case .warmSmile: return "sun.max.fill"
        }
    }
}

#Preview {
    EmberCharacterCustomizationView()
        .preferredColorScheme(.light)
}