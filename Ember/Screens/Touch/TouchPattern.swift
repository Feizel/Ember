import SwiftUI

// MARK: - Touch Heart Particle
struct TouchHeartParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat = 1.0
    var rotation: Double = 0.0
}

// MARK: - Touch Patterns
enum TouchPattern: CaseIterable {
    case gentle, passionate, playful, wave, sparkle, pulse, intimate, tease
    
    var name: String {
        switch self {
        case .gentle: return "Gentle"
        case .passionate: return "Passionate"
        case .playful: return "Playful"
        case .wave: return "Wave"
        case .sparkle: return "Sparkle"
        case .pulse: return "Pulse"
        case .intimate: return "Intimate"
        case .tease: return "Tease"
        }
    }
    
    var icon: String {
        switch self {
        case .gentle: return "hand.tap.fill"
        case .passionate: return "heart.fill"
        case .playful: return "star.fill"
        case .wave: return "waveform"
        case .sparkle: return "sparkles"
        case .pulse: return "bolt.fill"
        case .intimate: return "moon.fill"
        case .tease: return "eye.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .gentle: return EmberColors.roseQuartz
        case .passionate: return .red
        case .playful: return EmberColors.coralPop
        case .wave: return .blue
        case .sparkle: return .yellow
        case .pulse: return .purple
        case .intimate: return .pink
        case .tease: return .orange
        }
    }
    
    var size: CGFloat {
        switch self {
        case .gentle: return 80
        case .passionate: return 100
        case .playful: return 70
        case .wave: return 90
        case .sparkle: return 60
        case .pulse: return 85
        case .intimate: return 95
        case .tease: return 75
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .gentle: return 1.2
        case .passionate: return 1.5
        case .playful: return 1.1
        case .wave: return 1.3
        case .sparkle: return 1.0
        case .pulse: return 1.4
        case .intimate: return 1.3
        case .tease: return 1.2
        }
    }
    
    var description: String {
        switch self {
        case .gentle: return "Soft, tender touches"
        case .passionate: return "Intense, loving connection"
        case .playful: return "Fun, lighthearted touches"
        case .wave: return "Flowing, rhythmic patterns"
        case .sparkle: return "Quick, sparkling sensations"
        case .pulse: return "Strong, rhythmic pulses"
        case .intimate: return "Deep, meaningful connection"
        case .tease: return "Playful, teasing touches"
        }
    }
    
    var isPremium: Bool {
        switch self {
        case .gentle, .passionate, .playful: return false
        case .wave, .sparkle, .pulse, .intimate, .tease: return true
        }
    }
    
    func performHaptic() {
        switch self {
        case .gentle:
            EmberHapticsManager.shared.playLight()
        case .passionate, .intimate:
            EmberHapticsManager.shared.playMedium()
        case .playful, .tease:
            EmberHapticsManager.shared.playLight()
        case .wave:
            EmberHapticsManager.shared.playMedium()
        case .sparkle:
            EmberHapticsManager.shared.playLight()
        case .pulse:
            EmberHapticsManager.shared.playMedium()
        }
    }
    
    func createEffect(at location: CGPoint) -> [TouchHeartParticle] {
        let particleCount: Int
        let particleSize: ClosedRange<CGFloat>
        
        switch self {
        case .gentle:
            particleCount = 2
            particleSize = 16...20
        case .passionate:
            particleCount = 5
            particleSize = 20...28
        case .playful:
            particleCount = 3
            particleSize = 14...18
        case .wave:
            particleCount = 4
            particleSize = 18...24
        case .sparkle:
            particleCount = 8
            particleSize = 12...16
        case .pulse:
            particleCount = 3
            particleSize = 22...30
        case .intimate:
            particleCount = 4
            particleSize = 20...26
        case .tease:
            particleCount = 2
            particleSize = 16...22
        }
        
        var newParticles: [TouchHeartParticle] = []
        
        for _ in 0..<particleCount {
            let particle = TouchHeartParticle(
                position: CGPoint(
                    x: location.x + CGFloat.random(in: -30...30),
                    y: location.y + CGFloat.random(in: -20...20)
                ),
                size: CGFloat.random(in: particleSize),
                opacity: 1.0
            )
            newParticles.append(particle)
        }
        
        return newParticles
    }
}