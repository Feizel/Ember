import SwiftUI

// Test view to verify the new character implementation
struct CharacterTestView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Ember 3D Characters Test")
                .font(.title.bold())
                .foregroundStyle(EmberColors.textPrimary)
            
            HStack(spacing: 40) {
                VStack(spacing: 16) {
                    Text("Touchy")
                        .font(.headline)
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    EmberSimple3DCharacters(
                        character: .touchy,
                        size: 120,
                        isAnimating: true
                    )
                }
                
                VStack(spacing: 16) {
                    Text("Syncee")
                        .font(.headline)
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    EmberSimple3DCharacters(
                        character: .syncee,
                        size: 120,
                        isAnimating: true
                    )
                }
            }
            
            HStack(spacing: 40) {
                VStack(spacing: 16) {
                    Text("Harmony")
                        .font(.headline)
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    EmberSimple3DCharacters(
                        character: .harmony,
                        size: 120,
                        isAnimating: true
                    )
                }
                
                VStack(spacing: 16) {
                    Text("Flux")
                        .font(.headline)
                        .foregroundStyle(EmberColors.textPrimary)
                    
                    EmberSimple3DCharacters(
                        character: .flux,
                        size: 120,
                        isAnimating: true
                    )
                }
            }
            
            Text("These should be adorable blob characters with:")
                .font(.subheadline)
                .foregroundStyle(EmberColors.textSecondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("• 3D-like gradients and highlights")
                Text("• Expressive googly eyes with highlights")
                Text("• Different moods (happy, love, excited, wink)")
                Text("• Breathing and floating animations")
                Text("• Rosy cheeks and cute smiles")
                Text("• Sparkles and character-specific accents")
            }
            .font(.caption)
            .foregroundStyle(EmberColors.textSecondary)
            
            Spacer()
        }
        .padding()
        .background(EmberColors.background)
    }
}

#Preview {
    CharacterTestView()
}