import SwiftUI
import Combine

enum AvailabilityStatus: String, CaseIterable {
    case available = "available"
    case busy = "busy"
    case sleeping = "sleeping"
    
    var displayName: String {
        switch self {
        case .available: return "Available"
        case .busy: return "Busy"
        case .sleeping: return "Sleeping"
        }
    }
    
    var icon: String {
        switch self {
        case .available: return "heart.fill"
        case .busy: return "minus.circle.fill"
        case .sleeping: return "moon.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .available: return ColorPalette.amber
        case .busy: return ColorPalette.roseGold
        case .sleeping: return ColorPalette.deepPurple
        }
    }
    
    var characterExpression: CharacterExpression {
        switch self {
        case .available: return .happy
        case .busy: return .waiting
        case .sleeping: return .sleeping
        }
    }
}

@MainActor
class AvailabilityManager: ObservableObject {
    static let shared = AvailabilityManager()
    
    @Published var currentStatus: AvailabilityStatus = .available
    @Published var partnerStatus: AvailabilityStatus = .available
    @Published var lastStatusUpdate: Date = Date()
    

    
    init() {
        print("AvailabilityManager running in mock mode")
        updateStatus(.available)
    }
    
    func updateStatus(_ status: AvailabilityStatus) {
        currentStatus = status
        lastStatusUpdate = Date()
        
        guard let userId = AuthManager.shared.currentUser?.uid else {
            print("Mock status update to \(status.displayName)")
            return
        }
        
        print("Status updated to \(status.displayName) for user \(userId)")
        
        // Auto-schedule sleep mode for nighttime
        if status == .sleeping {
            scheduleAutoWakeUp()
        }
    }
    
    private func setupStatusListener() {
        // Mock partner status updates
        print("Mock status listener setup")
    }
    
    private func scheduleAutoWakeUp() {
        // Schedule to automatically set to available at 7 AM
        let calendar = Calendar.current
        let now = Date()
        
        guard let tomorrow7AM = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 7, minute: 0),
            matchingPolicy: .nextTime
        ) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Good Morning!"
        content.body = "Ready to connect with your partner?"
        content.categoryIdentifier = "WAKE_UP"
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: calendar.dateComponents([.hour, .minute], from: tomorrow7AM),
            repeats: false
        )
        
        let request = UNNotificationRequest(identifier: "auto_wake_up", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func canReceiveTouch() -> Bool {
        return currentStatus != .sleeping
    }
    
    func shouldShowBusyWarning() -> Bool {
        return partnerStatus == .busy
    }
    

}

// MARK: - Availability Status View
struct AvailabilityStatusView: View {
    @StateObject private var availabilityManager = AvailabilityManager.shared
    @State private var showingStatusPicker = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Current user status
            Button(action: { showingStatusPicker = true }) {
                HStack(spacing: 6) {
                    Image(systemName: availabilityManager.currentStatus.icon)
                        .foregroundColor(availabilityManager.currentStatus.color)
                        .font(.caption)
                    
                    Text(availabilityManager.currentStatus.displayName)
                        .font(.caption.weight(.medium))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial, in: Capsule())
            }
            
            Spacer()
            
            // Partner status (read-only)
            HStack(spacing: 6) {
                Image(systemName: availabilityManager.partnerStatus.icon)
                    .foregroundColor(availabilityManager.partnerStatus.color)
                    .font(.caption)
                
                Text("Partner: \(availabilityManager.partnerStatus.displayName)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .confirmationDialog("Set Your Status", isPresented: $showingStatusPicker) {
            ForEach(AvailabilityStatus.allCases, id: \.self) { status in
                Button(status.displayName) {
                    availabilityManager.updateStatus(status)
                }
            }
        }
    }
}