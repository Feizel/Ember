import CoreHaptics
import Foundation
import UIKit
import Combine

@MainActor
class EmberEnhancedHapticsManager: ObservableObject {
    static let shared = EmberEnhancedHapticsManager()
    
    private var engine: CHHapticEngine?
    private var isPlaying = false
    
    var supportsHaptics: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    init() {
        setupEngine()
    }
    
    private func setupEngine() {
        guard supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            
            engine?.stoppedHandler = { [weak self] reason in
                switch reason {
                case .audioSessionInterrupt, .applicationSuspended, .idleTimeout:
                    try? self?.engine?.start()
                default:
                    break
                }
            }
        } catch {
            print("Haptic engine setup failed: \(error)")
        }
    }
    
    func playGesture(_ gesture: EmberHapticGesture) {
        guard let engine = engine, !isPlaying else { return }
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        
        do {
            let pattern = try createPattern(for: gesture)
            let player = try engine.makePlayer(with: pattern)
            
            isPlaying = true
            
            try player.start(atTime: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + gesture.duration) {
                self.isPlaying = false
            }
            
        } catch {
            print("Failed to play haptic: \(error)")
            isPlaying = false
        }
    }
    
    func playRealtimeTouch(intensity: Float, sharpness: Float = 0.5) {
        guard let engine = engine else { return }
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        
        do {
            let event = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                ],
                relativeTime: 0,
                duration: 0.1
            )
            
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            
        } catch {
            print("Failed to play realtime haptic: \(error)")
        }
    }
    
    func playLight() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func playMedium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func playHeavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    func playSuccess() {
        guard let engine = engine else { return }
        
        do {
            let events = [
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                    ],
                    relativeTime: 0,
                    duration: 0
                ),
                CHHapticEvent(
                    eventType: .hapticTransient,
                    parameters: [
                        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
                    ],
                    relativeTime: 0.1,
                    duration: 0
                )
            ]
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
            
        } catch {
            print("Failed to play success haptic: \(error)")
        }
    }
    
    private func createPattern(for gesture: EmberHapticGesture) throws -> CHHapticPattern {
        let events = gesture.events.map { event in
            CHHapticEvent(
                eventType: event.type,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: event.intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: event.sharpness)
                ],
                relativeTime: event.time,
                duration: event.duration
            )
        }
        
        return try CHHapticPattern(events: events, parameters: [])
    }
}

struct EmberHapticGesture {
    let name: String
    let events: [EmberHapticEvent]
    let duration: TimeInterval
    let icon: String
    
    static let kiss = EmberHapticGesture(
        name: "Kiss",
        events: [
            EmberHapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.4, sharpness: 0.2, duration: 1.0)
        ],
        duration: 1.0,
        icon: "heart.fill"
    )
    
    static let hug = EmberHapticGesture(
        name: "Hug",
        events: [
            EmberHapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.3, sharpness: 0.3, duration: 3.0),
            EmberHapticEvent(time: 1.5, type: .hapticContinuous, intensity: 0.8, sharpness: 0.3, duration: 0.5),
            EmberHapticEvent(time: 2.5, type: .hapticContinuous, intensity: 0.3, sharpness: 0.3, duration: 0.5)
        ],
        duration: 3.0,
        icon: "figure.arms.open"
    )
    
    static let wave = EmberHapticGesture(
        name: "Wave",
        events: [
            EmberHapticEvent(time: 0.0, type: .hapticTransient, intensity: 1.0, sharpness: 0.8, duration: 0),
            EmberHapticEvent(time: 0.15, type: .hapticTransient, intensity: 1.0, sharpness: 0.8, duration: 0)
        ],
        duration: 0.3,
        icon: "hand.wave.fill"
    )
    
    static let loveTap = EmberHapticGesture(
        name: "Love Tap",
        events: [
            EmberHapticEvent(time: 0.0, type: .hapticTransient, intensity: 0.7, sharpness: 0.6, duration: 0),
            EmberHapticEvent(time: 0.1, type: .hapticTransient, intensity: 0.5, sharpness: 0.4, duration: 0),
            EmberHapticEvent(time: 0.2, type: .hapticTransient, intensity: 0.7, sharpness: 0.6, duration: 0)
        ],
        duration: 0.4,
        icon: "hand.tap.fill"
    )
    
    static let squeeze = EmberHapticGesture(
        name: "Squeeze",
        events: [
            EmberHapticEvent(time: 0.0, type: .hapticTransient, intensity: 0.8, sharpness: 0.5, duration: 0),
            EmberHapticEvent(time: 0.2, type: .hapticTransient, intensity: 0.8, sharpness: 0.5, duration: 0),
            EmberHapticEvent(time: 0.4, type: .hapticTransient, intensity: 0.8, sharpness: 0.5, duration: 0)
        ],
        duration: 0.6,
        icon: "hand.raised.fill"
    )
    
    static let tickle = EmberHapticGesture(
        name: "Tickle",
        events: [
            EmberHapticEvent(time: 0.0, type: .hapticTransient, intensity: 0.3, sharpness: 0.8, duration: 0),
            EmberHapticEvent(time: 0.1, type: .hapticTransient, intensity: 0.4, sharpness: 0.9, duration: 0),
            EmberHapticEvent(time: 0.2, type: .hapticTransient, intensity: 0.3, sharpness: 0.8, duration: 0),
            EmberHapticEvent(time: 0.3, type: .hapticTransient, intensity: 0.5, sharpness: 1.0, duration: 0),
            EmberHapticEvent(time: 0.4, type: .hapticTransient, intensity: 0.3, sharpness: 0.8, duration: 0)
        ],
        duration: 0.5,
        icon: "hand.point.up.left.fill"
    )
    
    static let allGestures = [kiss, hug, wave, loveTap, squeeze, tickle]
}

struct EmberHapticEvent {
    let time: TimeInterval
    let type: CHHapticEvent.EventType
    let intensity: Float
    let sharpness: Float
    let duration: TimeInterval
}
