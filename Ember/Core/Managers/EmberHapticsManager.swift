import CoreHaptics
import Foundation
import UIKit
import Combine

@MainActor
class EmberHapticsManager: ObservableObject {
    static let shared = EmberHapticsManager()
    
    private var engine: CHHapticEngine?
    private var isPlaying = false
    
    var supportsHaptics: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    var isHapticsAvailable: Bool {
        supportsHaptics
    }
    
    init() {
        setupEngine()
    }
    
    func prepareEngine() {
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
    
    func playGesture(_ gesture: HapticGesture) {
        guard let engine = engine, !isPlaying else { return }
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        
        do {
            let pattern = try createPattern(for: gesture)
            let player = try engine.makePlayer(with: pattern)
            
            isPlaying = true
            
            NotificationCenter.default.post(name: .hapticGestureStarted, object: gesture)
            
            try player.start(atTime: 0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + gesture.duration) {
                self.isPlaying = false
            }
            
        } catch {
            print("Failed to play haptic: \(error)")
            isPlaying = false
        }
    }
    
    func playButtonTap() {
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func playLight() {
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    func playMedium() {
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    func playHeavy() {
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    func playSelection() {
        guard UserDefaults.standard.object(forKey: "hapticFeedbackEnabled") as? Bool ?? true else { return }
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
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
    
    private func createPattern(for gesture: HapticGesture) throws -> CHHapticPattern {
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

struct HapticGesture {
    let name: String
    let events: [HapticEvent]
    let duration: TimeInterval
    let icon: String
    
    static let kiss = HapticGesture(
        name: "Kiss",
        events: [
            HapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.4, sharpness: 0.2, duration: 1.0)
        ],
        duration: 1.0,
        icon: "heart.fill"
    )
    
    static let hug = HapticGesture(
        name: "Hug",
        events: [
            HapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.3, sharpness: 0.3, duration: 3.0),
            HapticEvent(time: 1.5, type: .hapticContinuous, intensity: 0.8, sharpness: 0.3, duration: 0.5)
        ],
        duration: 3.0,
        icon: "hands.sparkles.fill"
    )
    
    static let heartbeat = HapticGesture(
        name: "Heartbeat",
        events: [
            HapticEvent(time: 0.0, type: .hapticTransient, intensity: 0.6, sharpness: 0.3, duration: 0.1),
            HapticEvent(time: 0.15, type: .hapticTransient, intensity: 0.8, sharpness: 0.4, duration: 0.1),
            HapticEvent(time: 0.8, type: .hapticTransient, intensity: 0.6, sharpness: 0.3, duration: 0.1),
            HapticEvent(time: 0.95, type: .hapticTransient, intensity: 0.8, sharpness: 0.4, duration: 0.1)
        ],
        duration: 1.5,
        icon: "heart.fill"
    )
    
    static let wave = HapticGesture(
        name: "Wave",
        events: [
            HapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.3, sharpness: 0.2, duration: 0.3),
            HapticEvent(time: 0.2, type: .hapticContinuous, intensity: 0.6, sharpness: 0.4, duration: 0.3),
            HapticEvent(time: 0.4, type: .hapticContinuous, intensity: 0.9, sharpness: 0.6, duration: 0.3),
            HapticEvent(time: 0.6, type: .hapticContinuous, intensity: 0.6, sharpness: 0.4, duration: 0.3),
            HapticEvent(time: 0.8, type: .hapticContinuous, intensity: 0.3, sharpness: 0.2, duration: 0.3)
        ],
        duration: 1.2,
        icon: "waveform"
    )
    
    static let sparkle = HapticGesture(
        name: "Sparkle",
        events: [
            HapticEvent(time: 0.0, type: .hapticTransient, intensity: 0.4, sharpness: 0.8, duration: 0.05),
            HapticEvent(time: 0.1, type: .hapticTransient, intensity: 0.6, sharpness: 0.9, duration: 0.05),
            HapticEvent(time: 0.25, type: .hapticTransient, intensity: 0.5, sharpness: 0.85, duration: 0.05),
            HapticEvent(time: 0.4, type: .hapticTransient, intensity: 0.7, sharpness: 0.95, duration: 0.05),
            HapticEvent(time: 0.6, type: .hapticTransient, intensity: 0.8, sharpness: 1.0, duration: 0.05)
        ],
        duration: 0.8,
        icon: "sparkles"
    )
    
    static let pulse = HapticGesture(
        name: "Pulse",
        events: [
            HapticEvent(time: 0.0, type: .hapticContinuous, intensity: 0.8, sharpness: 0.5, duration: 0.2),
            HapticEvent(time: 0.3, type: .hapticContinuous, intensity: 0.9, sharpness: 0.6, duration: 0.2),
            HapticEvent(time: 0.6, type: .hapticContinuous, intensity: 1.0, sharpness: 0.7, duration: 0.2)
        ],
        duration: 1.0,
        icon: "bolt.fill"
    )
    
    static let loveTap = HapticGesture(
        name: "Love Tap",
        events: [
            HapticEvent(time: 0.0, type: .hapticTransient, intensity: 0.7, sharpness: 0.6, duration: 0.1),
            HapticEvent(time: 0.1, type: .hapticTransient, intensity: 0.5, sharpness: 0.4, duration: 0.1)
        ],
        duration: 0.2,
        icon: "hand.tap.fill"
    )
    
    static let allGestures = [kiss, hug, heartbeat, wave, sparkle, pulse, loveTap]
}

struct HapticEvent {
    let time: TimeInterval
    let type: CHHapticEvent.EventType
    let intensity: Float
    let sharpness: Float
    let duration: TimeInterval
}

extension Notification.Name {
    static let hapticGestureStarted = Notification.Name("hapticGestureStarted")
}
