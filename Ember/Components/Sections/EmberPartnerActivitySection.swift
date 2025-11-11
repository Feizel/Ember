import SwiftUI

// MARK: - Partner Activity Section
struct EmberPartnerActivitySection: View {
    let partnerStatus: UserStatus
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Partner Activity")
                    .emberHeadline()
                Spacer()
            }
            
            HStack(spacing: 16) {
                // Partner avatar
                Circle()
                    .fill(EmberColors.primaryGradient)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Alex")
                        .emberHeadlineSmall()
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(partnerStatus.status.color)
                            .frame(width: 8, height: 8)
                        
                        Text(partnerStatus.customMessage ?? partnerStatus.status.displayName)
                            .emberCaption(color: EmberColors.textSecondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Last seen")
                        .emberCaption(color: EmberColors.textSecondary)
                    
                    Text("2 min ago")
                        .emberCaption()
                }
            }
            .emberCardPadding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    EmberPartnerActivitySection(partnerStatus: UserStatus(status: .happy, customMessage: "Feeling great!"))
        .emberScreenPadding()
}