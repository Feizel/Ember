import SwiftUI

struct HapticSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "iphone.radiowaves.left.and.right")
                        .font(.system(size: 48))
                        .foregroundStyle(ColorPalette.crimson)
                    
                    Text("Haptic Intensity")
                        .font(.title2.weight(.bold))
                    
                    Text("Choose how strong you want to feel touches from your partner")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                VStack(spacing: 12) {
                    ForEach(HapticIntensity.allCases, id: \.self) { intensity in
                        HapticIntensityRow(
                            intensity: intensity,
                            isSelected: settingsManager.hapticIntensity == intensity,
                            action: {
                                settingsManager.hapticIntensity = intensity
                                HapticsManager.shared.playGestureSelect()
                            }
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Haptic Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.headline.weight(.semibold))
                }
            }
        }
    }
}

struct HapticIntensityRow: View {
    let intensity: HapticIntensity
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(intensityColor.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: intensityIcon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(intensityColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(intensity.displayName)
                        .font(.headline.weight(.medium))
                        .foregroundColor(.primary)
                    
                    Text(intensityDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(ColorPalette.crimson)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorPalette.crimson : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var intensityColor: Color {
        switch intensity {
        case .light: return .green
        case .medium: return .orange
        case .strong: return .red
        }
    }
    
    private var intensityIcon: String {
        switch intensity {
        case .light: return "leaf.fill"
        case .medium: return "circle.fill"
        case .strong: return "bolt.fill"
        }
    }
    
    private var intensityDescription: String {
        switch intensity {
        case .light: return "Gentle, subtle vibrations"
        case .medium: return "Balanced, noticeable feedback"
        case .strong: return "Strong, pronounced vibrations"
        }
    }
}

struct GoalSettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGoal: Int
    
    private let goalOptions = [3, 5, 8, 10, 15, 20, 25, 30]
    
    init() {
        self._selectedGoal = State(initialValue: SettingsManager.shared.dailyGoal)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "target")
                        .font(.system(size: 48))
                        .foregroundStyle(ColorPalette.crimson)
                    
                    Text("Daily Touch Goal")
                        .font(.title2.weight(.bold))
                    
                    Text("Set how many touches you want to exchange with your partner each day")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(goalOptions, id: \.self) { goal in
                        GoalOptionCard(
                            goal: goal,
                            isSelected: selectedGoal == goal,
                            action: {
                                selectedGoal = goal
                                HapticsManager.shared.playButtonTap()
                            }
                        )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Daily Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        settingsManager.dailyGoal = selectedGoal
                        HapticsManager.shared.playSuccess()
                        dismiss()
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(ColorPalette.crimson)
                }
            }
        }
    }
}

struct GoalOptionCard: View {
    let goal: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("\(goal)")
                    .font(.title.weight(.bold))
                    .foregroundColor(.primary)
                
                Text(goal == 1 ? "touch" : "touches")
                    .font(.caption.weight(.medium))
                    .foregroundColor(.secondary)
                
                Text(goalDescription)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? ColorPalette.crimson : .clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var goalDescription: String {
        switch goal {
        case 1...5: return "Casual"
        case 6...10: return "Regular"
        case 11...20: return "Active"
        default: return "Devoted"
        }
    }
}

#Preview {
    HapticSettingsView()
        .environmentObject(SettingsManager.shared)
}