import SwiftUI

struct LoveMemoriesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Premium feature placeholder
                    VStack(spacing: 16) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundStyle(ColorPalette.iconGradient)
                        
                        Text("Love Memories")
                            .font(.title2.weight(.bold))
                        
                        Text("Capture and cherish your sweetest moments together. Coming soon in TouchSync Premium!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Button("Upgrade to Premium") {
                        // Handle premium upgrade
                    }
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(ColorPalette.iconGradient, in: Capsule())
                }
            }
            .navigationTitle("Love Memories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MilestonesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Premium feature placeholder
                    VStack(spacing: 16) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(ColorPalette.iconGradient)
                        
                        Text("Relationship Milestones")
                            .font(.title2.weight(.bold))
                        
                        Text("Celebrate your journey together with beautiful milestone tracking. Coming soon in TouchSync Premium!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Button("Upgrade to Premium") {
                        // Handle premium upgrade
                    }
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(ColorPalette.iconGradient, in: Capsule())
                }
            }
            .navigationTitle("Milestones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct LoveNoteComposerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var noteText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ModernColorPalette.background
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        Text("💕")
                            .font(.system(size: 60))
                        
                        Text("Write a Love Note")
                            .font(.title2.weight(.bold))
                        
                        Text("Send your partner a sweet message")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    TextField("What's in your heart?", text: $noteText, axis: .vertical)
                        .textFieldStyle(.plain)
                        .padding(16)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .lineLimit(5, reservesSpace: true)
                    
                    Button("Send Love Note") {
                        // Handle sending note
                        dismiss()
                    }
                    .font(.headline.weight(.medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorPalette.iconGradient, in: Capsule())
                    .disabled(noteText.isEmpty)
                    .opacity(noteText.isEmpty ? 0.6 : 1.0)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("Love Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    LoveMemoriesView()
}