import SwiftUI

struct StatusPickerSheet: View {
    @Binding var currentStatus: UserStatus
    @Environment(\.dismiss) private var dismiss
    @State private var customMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 20) {
                        // Header
                        VStack(spacing: 12) {
                            Text("How are you feeling?")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            Text("Let your partner know your current mood")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Status options
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(CoupleStatus.allCases, id: \.self) { status in
                                StatusOptionCard(
                                    status: status,
                                    isSelected: currentStatus.status == status,
                                    action: {
                                        currentStatus.status = status
                                        currentStatus.lastUpdated = Date()
                                    }
                                )
                            }
                        }
                        
                        // Custom message section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Add a personal message (optional)")
                                .font(.headline.weight(.medium))
                                .foregroundColor(.primary)
                            
                            TextField("What's on your mind?", text: $customMessage, axis: .vertical)
                                .textFieldStyle(.plain)
                                .padding(16)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                )
                                .lineLimit(3, reservesSpace: true)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Your Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        currentStatus.customMessage = customMessage.isEmpty ? nil : customMessage
                        currentStatus.lastUpdated = Date()
                        dismiss()
                    }
                    .font(.headline.weight(.medium))
                    .foregroundStyle(ColorPalette.crimson)
                }
            }
        }
        .onAppear {
            customMessage = currentStatus.customMessage ?? ""
        }
    }
}

struct StatusOptionCard: View {
    let status: CoupleStatus
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(status.color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: status.icon)
                        .font(.title2)
                        .foregroundStyle(status.color)
                }
                
                VStack(spacing: 4) {
                    Text(status.displayName)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text(status.description)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? status.color : .clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(color: isSelected ? status.color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    StatusPickerSheet(currentStatus: .constant(UserStatus()))
}