import SwiftUI

// MARK: - Notification View
struct EmberNotificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var partnerStatus = UserStatus(status: .romantic, customMessage: "Missing you! 💕")
    
    private let notifications = [
        ("💕", "Love Note", "Your partner sent you a sweet message", "2 min ago"),
        ("🤗", "Hug Received", "Warm hug from your love", "5 min ago"),
        ("💋", "Kiss", "Sweet kiss sent your way", "1 hour ago"),
        ("💓", "Heartbeat Sync", "Partner's heartbeat is elevated - they're thinking of you", "10 min ago"),
        ("📍", "Location Share", "Partner is at your favorite coffee shop", "30 min ago"),
        ("🎵", "Voice Message", "Sweet voice note waiting for you", "1 hour ago")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Partner Activity Header
                    EmberPartnerActivitySection(partnerStatus: partnerStatus)
                    
                    // Notifications
                    VStack(spacing: 12) {
                        HStack {
                            Text("Recent Notifications")
                                .emberHeadline()
                            Spacer()
                        }
                        
                        ForEach(Array(notifications.enumerated()), id: \.offset) { index, notification in
                            EmberNotificationRow(
                                emoji: notification.0,
                                title: notification.1,
                                message: notification.2,
                                time: notification.3
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Activity & Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .emberBody(color: EmberColors.roseQuartz)
                }
            }
        }
    }
}

// MARK: - Notification Row
struct EmberNotificationRow: View {
    let emoji: String
    let title: String
    let message: String
    let time: String
    
    var body: some View {
        EmberCard {
            HStack(spacing: 12) {
                Text(emoji)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .emberBody()
                    
                    Text(message)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Text(time)
                    .emberCaption(color: EmberColors.textSecondary)
            }
        }
    }
}

#Preview {
    EmberNotificationView()
}