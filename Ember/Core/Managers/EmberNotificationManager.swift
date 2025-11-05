import Foundation
import UserNotifications
import Combine

@MainActor
class EmberNotificationManager: ObservableObject {
    static let shared = EmberNotificationManager()
    
    @Published var hasPermission = false
    @Published var notifications: [EmberNotification] = []
    
    init() {
        checkPermission()
    }
    
    func requestPermission() async {
        do {
            hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            hasPermission = false
        }
    }
    
    private func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.hasPermission = settings.authorizationStatus == .authorized
            }
        }
    }
    
    func scheduleTouch(_ type: TouchType, from senderId: String) {
        guard hasPermission else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "💕 Touch Received"
        content.body = "Your partner sent you a \(type.displayName.lowercased())"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct EmberNotification: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timestamp: Date
    let type: NotificationType
    
    enum NotificationType {
        case touch, milestone, reminder
    }
}
