import SwiftUI

// MARK: - Touch Patterns View
struct EmberTouchPatternsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPattern: TouchPattern = .gentle
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Pattern Preview
                    patternPreview
                    
                    // Pattern Grid
                    patternGrid
                    
                    // Pattern Details
                    patternDetails
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationTitle("Touch Patterns")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .emberBody(color: EmberColors.roseQuartz)
                }
            }
        }
    }
    
    private var patternPreview: some View {
        VStack(spacing: 16) {
            ZStack {
                LinearGradient(
                    colors: [selectedPattern.color.opacity(0.3), selectedPattern.color.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                
                VStack(spacing: 12) {
                    Image(systemName: selectedPattern.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(selectedPattern.color)
                    
                    Text(selectedPattern.name)
                        .emberHeadline()
                    
                    Text(selectedPattern.description)
                        .emberBody(color: EmberColors.textSecondary)
                        .multilineTextAlignment(.center)
                    
                    if selectedPattern.isPremium {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .foregroundStyle(.yellow)
                            Text("Premium")
                                .emberCaption(color: .yellow)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.yellow.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    private var patternGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            ForEach(TouchPattern.allCases, id: \.self) { pattern in
                Button(action: {
                    selectedPattern = pattern
                    pattern.performHaptic()
                }) {
                    VStack(spacing: 12) {
                        Image(systemName: pattern.icon)
                            .font(.system(size: 32))
                            .foregroundStyle(selectedPattern == pattern ? .white : pattern.color)
                            .frame(width: 80, height: 80)
                            .background(
                                selectedPattern == pattern ?
                                    pattern.color :
                                    pattern.color.opacity(0.1)
                            )
                            .clipShape(Circle())
                        
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Text(pattern.name)
                                    .emberLabel()
                                
                                if pattern.isPremium {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(.yellow)
                                }
                            }
                            
                            Text(pattern.description)
                                .emberCaption(color: EmberColors.textSecondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                    }
                    .padding()
                    .background(
                        selectedPattern == pattern ?
                            pattern.color.opacity(0.1) :
                            EmberColors.surface
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                selectedPattern == pattern ?
                                    pattern.color :
                                    Color.clear,
                                lineWidth: 2
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var patternDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pattern Details")
                .emberLabel()
            
            VStack(spacing: 12) {
                detailRow(icon: "waveform", title: "Intensity", value: intensityText)
                detailRow(icon: "timer", title: "Duration", value: "Variable")
                detailRow(icon: "hand.tap.fill", title: "Touch Size", value: sizeText)
                detailRow(icon: "sparkles", title: "Effects", value: effectsText)
            }
        }
        .padding()
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(selectedPattern.color)
                .frame(width: 24)
            
            Text(title)
                .emberBody()
            
            Spacer()
            
            Text(value)
                .emberBody(color: EmberColors.textSecondary)
        }
    }
    
    private var intensityText: String {
        switch selectedPattern {
        case .gentle: return "Light"
        case .passionate, .intimate: return "Strong"
        case .playful, .tease: return "Light"
        case .wave: return "Medium"
        case .sparkle: return "Quick"
        case .pulse: return "Strong"
        }
    }
    
    private var sizeText: String {
        let size = selectedPattern.size
        if size < 70 { return "Small" }
        else if size < 90 { return "Medium" }
        else { return "Large" }
    }
    
    private var effectsText: String {
        switch selectedPattern {
        case .gentle: return "2 hearts"
        case .passionate: return "5 hearts"
        case .playful: return "3 hearts"
        case .wave: return "4 hearts"
        case .sparkle: return "8 sparkles"
        case .pulse: return "3 pulses"
        case .intimate: return "4 hearts"
        case .tease: return "2 hearts"
        }
    }
}

#Preview {
    EmberTouchPatternsView()
}