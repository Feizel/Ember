import SwiftUI

struct NotificationCenterView: View {
    @EnvironmentObject var notificationManager: CoupleNotificationManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                if notificationManager.notifications.isEmpty {
                    EmptyNotificationsView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(notificationManager.notifications) { notification in
                                NotificationRowView(notification: notification)
                                    .onTapGesture {
                                        notificationManager.markAsRead(notification)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(ColorPalette.crimson)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if notificationManager.unreadCount > 0 {
                        Button("Mark All Read") {
                            notificationManager.markAllAsRead()
                        }
                        .font(.subheadline)
                        .foregroundStyle(ColorPalette.crimson)
                    }
                }
            }
        }
    }
}

struct NotificationRowView: View {
    let notification: CoupleNotification
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(colorForType(notification.type).opacity(0.2))
                    .frame(width: 44, height: 44)
                
                Image(systemName: notification.type.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(colorForType(notification.type))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if !notification.isRead {
                        Circle()
                            .fill(ColorPalette.crimson)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(timeAgoString(from: notification.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(notification.isRead ? .clear : ColorPalette.crimson.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    private func colorForType(_ type: CoupleNotification.NotificationType) -> Color {
        switch type {
        case .touchReceived: return ColorPalette.crimson
        case .partnerOnline: return .green
        case .milestone: return ColorPalette.goldenYellow
        case .loveNote: return ColorPalette.roseGold
        case .statusChange: return ColorPalette.sunsetOrange
        }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}

struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Notifications")
                .font(.title2.weight(.semibold))
                .foregroundColor(.primary)
            
            Text("You'll see partner activity and\nmilestones here when they happen")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NotificationCenterView()
        .environmentObject(CoupleNotificationManager())
}