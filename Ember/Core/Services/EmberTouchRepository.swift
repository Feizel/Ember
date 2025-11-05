import Foundation
import Combine

@MainActor
class EmberTouchRepository: ObservableObject {
    static let shared = EmberTouchRepository()
    
    @Published var touchHistory: [TouchGesture] = []
    @Published var todayTouches: Int = 0
    @Published var dailyGoal: Int = 10
    
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    init() {
        loadTouchHistory()
        calculateTodayTouches()
    }
    
    func sendTouch(_ type: TouchType, to receiverId: String) {
        guard let senderId = EmberAuthManager.shared.currentUser?.uid else { return }
        
        let touch = TouchGesture(
            type: type,
            senderId: senderId,
            receiverId: receiverId,
            isReceived: false
        )
        
        touchHistory.insert(touch, at: 0)
        saveTouchHistory()
        calculateTodayTouches()
        
        // Trigger haptic feedback
        EmberHapticsManager.shared.playButtonTap()
        
        // Check for perfect day
        checkPerfectDay()
    }
    
    func receiveTouch(_ type: TouchType, from senderId: String) {
        guard let receiverId = EmberAuthManager.shared.currentUser?.uid else { return }
        
        let touch = TouchGesture(
            type: type,
            senderId: senderId,
            receiverId: receiverId,
            isReceived: true
        )
        
        touchHistory.insert(touch, at: 0)
        saveTouchHistory()
        
        // Play appropriate haptic
        if let gesture = HapticGesture.allGestures.first(where: { $0.name.lowercased() == type.displayName.lowercased() }) {
            EmberHapticsManager.shared.playGesture(gesture)
        }
    }
    
    private func calculateTodayTouches() {
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        todayTouches = touchHistory.filter { touch in
            touch.timestamp >= today && touch.timestamp < tomorrow && !touch.isReceived
        }.count
    }
    
    private func checkPerfectDay() {
        if todayTouches >= dailyGoal {
            EmberStreakManager.shared.checkDailyStreak(isPerfectDay: true)
        }
    }
    
    func getTouchHistory(for date: Date) -> [TouchGesture] {
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return touchHistory.filter { touch in
            touch.timestamp >= startOfDay && touch.timestamp < endOfDay
        }
    }
    
    func getWeeklyStats() -> [Int] {
        let today = Date()
        var weeklyTouches: [Int] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let dayTouches = getTouchHistory(for: date).filter { !$0.isReceived }.count
            weeklyTouches.append(dayTouches)
        }
        
        return weeklyTouches.reversed()
    }
    
    private func loadTouchHistory() {
        if let data = userDefaults.data(forKey: "touchHistory"),
           let history = try? JSONDecoder().decode([TouchGesture].self, from: data) {
            touchHistory = history
        }
    }
    
    private func saveTouchHistory() {
        if let data = try? JSONEncoder().encode(touchHistory) {
            userDefaults.set(data, forKey: "touchHistory")
        }
    }
}