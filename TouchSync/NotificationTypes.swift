import Foundation
import Combine

struct CoupleNotification: Identifiable {
    let id = UUID()
    let type: NotificationType
    let title: String
    let message: String
    let timestamp: Date
    let isRead: Bool
    
    enum NotificationType {
        case touchReceived
        case partnerOnline
        case milestone
        case loveNote
        case statusChange
        
        var icon: String {
            switch self {
            case .touchReceived: return "hand.draw.fill"
            case .partnerOnline: return "person.fill.checkmark"
            case .milestone: return "star.fill"
            case .loveNote: return "heart.text.square.fill"
            case .statusChange: return "person.crop.circle.badge.checkmark"
            }
        }
        
        var color: String {
            switch self {
            case .touchReceived: return "crimson"
            case .partnerOnline: return "green"
            case .milestone: return "goldenYellow"
            case .loveNote: return "roseGold"
            case .statusChange: return "sunsetOrange"
            }
        }
    }
}

class CoupleNotificationManager: ObservableObject {
    @Published var notifications: [CoupleNotification] = []
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    init() {
        loadMockNotifications()
    }
    
    private func loadMockNotifications() {
        notifications = [
            CoupleNotification(
                type: .touchReceived,
                title: "Touch Received",
                message: "Your partner sent you a hug 🤗",
                timestamp: Date().addingTimeInterval(-300),
                isRead: false
            ),
            CoupleNotification(
                type: .partnerOnline,
                title: "Partner Online",
                message: "Your partner is now available",
                timestamp: Date().addingTimeInterval(-1800),
                isRead: false
            ),
            CoupleNotification(
                type: .milestone,
                title: "Milestone Achieved!",
                message: "You've reached a 30-day streak! 🎉",
                timestamp: Date().addingTimeInterval(-3600),
                isRead: true
            ),
            CoupleNotification(
                type: .loveNote,
                title: "New Love Note",
                message: "Your partner sent you a sweet message",
                timestamp: Date().addingTimeInterval(-7200),
                isRead: false
            )
        ]
    }
    
    func markAsRead(_ notification: CoupleNotification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index] = CoupleNotification(
                type: notification.type,
                title: notification.title,
                message: notification.message,
                timestamp: notification.timestamp,
                isRead: true
            )
        }
    }
    
    func markAllAsRead() {
        notifications = notifications.map { notification in
            CoupleNotification(
                type: notification.type,
                title: notification.title,
                message: notification.message,
                timestamp: notification.timestamp,
                isRead: true
            )
        }
    }
}
