import SwiftUI

// MARK: - Ember Activity Row Component
struct EmberActivityRow: View {
    let type: String
    let time: String
    let isReceived: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(isReceived ? EmberColors.peachyKeen.opacity(0.2) : EmberColors.roseQuartz.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .emberIconSmall()
                        .foregroundStyle(isReceived ? EmberColors.peachyKeen : EmberColors.roseQuartz)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(type)
                    .emberBody()
                
                Text(isReceived ? "Received from partner" : "Sent to partner")
                    .emberCaption(color: EmberColors.textSecondary)
            }
            
            Spacer()
            
            Text(time)
                .emberCaption(color: EmberColors.textSecondary)
        }
        .emberComponentPadding()
    }
}

// MARK: - Ember Love Note Card Component
struct EmberLoveNoteCard: View {
    let note: String
    let isFromPartner: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(note)
                .emberBody()
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Text(isFromPartner ? "From your love" : "From you")
                .emberCaption(color: EmberColors.textSecondary)
        }
        .frame(width: 160)
        .emberCardPadding()
        .background(
            LinearGradient(
                colors: isFromPartner ? 
                    [EmberColors.roseQuartzUltraLight, EmberColors.peachyKeenUltraLight] :
                    [EmberColors.coralPopUltraLight, EmberColors.roseQuartzUltraLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Ember Notification Bell View
struct EmberNotificationBellView: View {
    @Binding var showingNotifications: Bool
    @State private var hasNotifications = true
    
    var body: some View {
        Button(action: { showingNotifications = true }) {
            ZStack {
                Image(systemName: "bell")
                    .emberIconMedium()
                    .foregroundColor(EmberColors.textOnGradient)
                
                if hasNotifications {
                    Circle()
                        .fill(EmberColors.error)
                        .frame(width: 8, height: 8)
                        .offset(x: 8, y: -8)
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            EmberStatsCard(
                title: "Sent",
                value: "8",
                subtitle: "touches",
                color: EmberColors.roseQuartz
            )
            
            EmberStatsCard(
                title: "Streak",
                value: "12",
                subtitle: "days",
                color: EmberColors.peachyKeen
            )
            
            EmberStatsCard(
                title: "Goal",
                value: "10",
                subtitle: "daily",
                color: EmberColors.coralPop
            )
        }
        
        EmberActivityRow(
            type: "Hug",
            time: "2 min ago",
            isReceived: true,
            icon: "hands.sparkles.fill"
        )
        
        HStack {
            EmberLoveNoteCard(note: "Missing your smile today 😊", isFromPartner: true)
            EmberLoveNoteCard(note: "Can't wait to see you! 💕", isFromPartner: false)
        }
    }
    .padding()
}