import SwiftUI
import Combine

struct NotificationBellView: View {
    @EnvironmentObject var notificationManager: CoupleNotificationManager
    @Binding var showingNotifications: Bool
    
    var body: some View {
        Button(action: { showingNotifications = true }) {
            ZStack {
                Image(systemName: "bell.fill")
                    .font(.title2)
                    .foregroundStyle(.primary)
                
                if notificationManager.unreadCount > 0 {
                    Text("\(min(notificationManager.unreadCount, 99))")
                        .font(.caption2.weight(.bold))
                        .foregroundColor(.white)
                        .frame(minWidth: 16, minHeight: 16)
                        .background(ColorPalette.crimson, in: Circle())
                        .offset(x: 10, y: -10)
                        .scaleEffect(notificationManager.unreadCount > 0 ? 1.0 : 0.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: notificationManager.unreadCount)
                }
            }
        }
    }
}

#Preview {
    NotificationBellView(showingNotifications: Binding.constant(false))
        .environmentObject(CoupleNotificationManager())
}
