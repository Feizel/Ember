import SwiftUI

// MARK: - Status Picker Sheet
struct EmberStatusPickerSheet: View {
    @Binding var currentStatus: Ember.UserStatus
    @Environment(\.dismiss) private var dismiss
    @State private var customMessage = ""
    @State private var showingAllStatuses = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    // Romantic Header
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(EmberColors.primaryGradient)
                                .frame(width: 100, height: 100)
                                .shadow(color: currentStatus.status.color.opacity(0.3), radius: 20, x: 0, y: 8)
                            
                            Image(systemName: currentStatus.status.icon)
                                .font(.system(size: 40, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("How are you feeling?")
                                .emberCaption(color: EmberColors.textSecondary)
                            
                            Text(currentStatus.status.displayName)
                                .emberHeadline()
                        }
                    }
                
                    // Quick Status Selection
                    VStack(spacing: 12) {
                        Text("Share your heart")
                            .emberLabel(color: EmberColors.textSecondary)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(CoupleStatus.topFour, id: \.self) { status in
                                EmberStatusCard(status: status, currentStatus: currentStatus, onSelect: selectStatus)
                            }
                        }
                        
                        // View More Button
                        Button(action: { showingAllStatuses = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "ellipsis.circle.fill")
                                    .emberIconMedium()
                                    .foregroundStyle(EmberColors.roseQuartz)
                                
                                Text("View More Moods")
                                    .emberBody(color: EmberColors.roseQuartz)
                            }
                            .frame(maxWidth: .infinity)
                            .emberComponentPadding()
                            .background(EmberColors.roseQuartz.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(EmberColors.roseQuartz.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                
                    // Love Message
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "heart.text.square.fill")
                                .emberIconSmall()
                                .foregroundStyle(EmberColors.roseQuartz)
                            
                            Text("Share what's in your heart")
                                .emberLabel()
                        }
                        
                        TextEditor(text: $customMessage)
                            .emberBody()
                            .frame(minHeight: 80)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(EmberColors.surface)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(EmberColors.roseQuartz.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .overlay(
                                VStack {
                                    HStack {
                                        Spacer()
                                        if customMessage.isEmpty {
                                            Text("Let your love know how you're feeling...")
                                                .emberCaption(color: EmberColors.textSecondary.opacity(0.7))
                                                .padding(.top, 20)
                                                .padding(.trailing, 8)
                                        }
                                    }
                                    Spacer()
                                },
                                alignment: .topTrailing
                            )
                    }
                
                // Premium Features
                VStack(spacing: 16) {
                    // Mood Intensity
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mood Intensity")
                            .emberLabel()
                        
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { level in
                                Button(action: {}) {
                                    Circle()
                                        .fill(level <= 3 ? currentStatus.status.color : EmberColors.border)
                                        .frame(width: 20, height: 20)
                                }
                                .buttonStyle(.plain)
                            }
                            
                            Spacer()
                            
                            Text("Moderate")
                                .emberCaption(color: EmberColors.textSecondary)
                        }
                    }
                    
                    // Auto Status
                    EmberToggle(title: "Auto-update based on activity", isOn: .constant(true))
                    
                    // Visibility Settings
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Visibility")
                            .emberLabel()
                        
                        HStack(spacing: 12) {
                            Button(action: {}) {
                                HStack(spacing: 6) {
                                    Image(systemName: "eye.fill")
                                        .emberIconSmall()
                                    Text("Visible")
                                        .emberCaption()
                                }
                                .emberComponentPadding()
                                .background(EmberColors.roseQuartz.opacity(0.2), in: Capsule())
                                .overlay(Capsule().stroke(EmberColors.roseQuartz, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: {}) {
                                HStack(spacing: 6) {
                                    Image(systemName: "eye.slash.fill")
                                        .emberIconSmall()
                                    Text("Private")
                                        .emberCaption()
                                }
                                .emberComponentPadding()
                                .background(EmberColors.surface, in: Capsule())
                                .overlay(Capsule().stroke(EmberColors.border, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                    }
                }
                
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("My Heart Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        currentStatus.customMessage = customMessage.isEmpty ? nil : customMessage
                        dismiss()
                    }
                    .emberBody(color: EmberColors.roseQuartz)
                }
            }
        }
        .onAppear {
            customMessage = currentStatus.customMessage ?? ""
        }
        .sheet(isPresented: $showingAllStatuses) {
            EmberAllStatusesView(currentStatus: $currentStatus)
        }
    }
    
    private func selectStatus(_ status: CoupleStatus) {
        currentStatus.status = status
    }
}

// MARK: - Status Card Component
struct EmberStatusCard: View {
    let status: CoupleStatus
    let currentStatus: Ember.UserStatus
    let onSelect: (CoupleStatus) -> Void
    
    var body: some View {
        Button(action: { 
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                onSelect(status)
            }
        }) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(status.color.opacity(0.15))
                        .frame(width: 60, height: 60)
                    
                    if currentStatus.status == status {
                        Circle()
                            .stroke(status.color, lineWidth: 2)
                            .frame(width: 60, height: 60)
                    }
                    
                    Image(systemName: status.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(status.color)
                }
                
                Text(status.displayName)
                    .emberCaption()
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                currentStatus.status == status ? 
                    LinearGradient(
                        colors: [status.color.opacity(0.1), status.color.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [EmberColors.surface, EmberColors.surface],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        currentStatus.status == status ? 
                            status.color.opacity(0.5) : 
                            EmberColors.border.opacity(0.3),
                        lineWidth: currentStatus.status == status ? 2 : 1
                    )
            )
            .scaleEffect(currentStatus.status == status ? 1.02 : 1.0)
            .shadow(
                color: currentStatus.status == status ? status.color.opacity(0.2) : .clear,
                radius: currentStatus.status == status ? 8 : 0,
                x: 0,
                y: currentStatus.status == status ? 4 : 0
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - All Statuses View
struct EmberAllStatusesView: View {
    @Binding var currentStatus: Ember.UserStatus
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    ForEach(StatusCategory.allCases, id: \.self) { category in
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: category.icon)
                                    .emberIconMedium()
                                    .foregroundStyle(EmberColors.roseQuartz)
                                
                                Text(category.rawValue)
                                    .emberHeadline()
                                
                                Spacer()
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(category.statuses, id: \.self) { status in
                                    EmberStatusCard(status: status, currentStatus: currentStatus) { selectedStatus in
                                        currentStatus.status = selectedStatus
                                        dismiss()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
            .navigationTitle("All Moods")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    EmberStatusPickerSheet(currentStatus: .constant(Ember.UserStatus()))
}