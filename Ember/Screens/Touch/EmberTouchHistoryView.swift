import SwiftUI

// MARK: - Touch History View
struct EmberTouchHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(mockSessions, id: \.id) { session in
                        sessionCard(session)
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationTitle("Touch History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .emberBody(color: EmberColors.roseQuartz)
                }
            }
        }
    }
    
    private func sessionCard(_ session: TouchSession) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "hand.tap.fill")
                    .foregroundStyle(EmberColors.roseQuartz)
                    .frame(width: 40, height: 40)
                    .background(EmberColors.roseQuartz.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.duration)
                        .emberLabel()
                    Text("\(session.touches) touches • \(session.patterns) patterns")
                        .emberBody(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(session.date)
                        .emberCaption(color: EmberColors.textSecondary)
                    Text(session.time)
                        .emberCaption(color: EmberColors.textSecondary)
                }
            }
            
            HStack(spacing: 8) {
                ForEach(session.usedPatterns, id: \.self) { pattern in
                    HStack(spacing: 4) {
                        Image(systemName: pattern.icon)
                            .font(.system(size: 10))
                        Text(pattern.name)
                            .emberCaption()
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(pattern.color.opacity(0.1))
                    .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var mockSessions: [TouchSession] {
        [
            TouchSession(
                id: UUID(),
                duration: "5m 23s",
                touches: 47,
                patterns: 3,
                date: "Today",
                time: "2:30 PM",
                usedPatterns: [.gentle, .passionate, .playful]
            ),
            TouchSession(
                id: UUID(),
                duration: "3m 12s",
                touches: 28,
                patterns: 2,
                date: "Yesterday",
                time: "8:45 PM",
                usedPatterns: [.wave, .sparkle]
            ),
            TouchSession(
                id: UUID(),
                duration: "8m 45s",
                touches: 92,
                patterns: 4,
                date: "Dec 15",
                time: "7:20 PM",
                usedPatterns: [.gentle, .intimate, .pulse, .tease]
            )
        ]
    }
}

struct TouchSession {
    let id: UUID
    let duration: String
    let touches: Int
    let patterns: Int
    let date: String
    let time: String
    let usedPatterns: [TouchPattern]
}

#Preview {
    EmberTouchHistoryView()
}