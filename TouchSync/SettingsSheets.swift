import SwiftUI

struct HapticIntensitySheet: View {
    let settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Choose your preferred haptic intensity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    ForEach(HapticIntensity.allCases, id: \.self) { intensity in
                        Button(action: {
                            settingsManager.hapticIntensity = intensity
                            HapticsManager.shared.playButtonTap()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(intensity.displayName)
                                        .font(.headline.weight(.medium))
                                        .foregroundColor(.primary)
                                    
                                    Text(intensityDescription(intensity))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if settingsManager.hapticIntensity == intensity {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(ColorPalette.crimson)
                                        .font(.title2)
                                }
                            }
                            .padding(16)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        settingsManager.hapticIntensity == intensity ? ColorPalette.crimson : .clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .navigationTitle("Haptic Intensity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    private func intensityDescription(_ intensity: HapticIntensity) -> String {
        switch intensity {
        case .light: return "Gentle vibrations"
        case .medium: return "Balanced feedback"
        case .strong: return "Strong vibrations"
        }
    }
}

struct DailyGoalSheet: View {
    let settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedGoal: Int
    
    private let goalOptions = [3, 5, 8, 10, 15, 20]
    
    init(settingsManager: SettingsManager) {
        self.settingsManager = settingsManager
        self._selectedGoal = State(initialValue: settingsManager.dailyGoal)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text("Set your daily touch goal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(goalOptions, id: \.self) { goal in
                            Button(action: {
                                selectedGoal = goal
                                HapticsManager.shared.playButtonTap()
                            }) {
                                VStack(spacing: 8) {
                                    Text("\(goal)")
                                        .font(.title.weight(.bold))
                                        .foregroundColor(.primary)
                                    
                                    Text("touches")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selectedGoal == goal ? ColorPalette.crimson : .clear,
                                            lineWidth: 2
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
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
                    .font(.headline.weight(.medium))
                    .foregroundStyle(ColorPalette.crimson)
                }
            }
        }
    }
}

#Preview {
    HapticIntensitySheet(settingsManager: SettingsManager.shared)
}