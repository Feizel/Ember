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
    
    static let allGestures = [kiss, hug]
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
