import SwiftUI

struct EmberSimple3DCharacters: View {
    let character: CharacterType
    let size: CGFloat
    let isAnimating: Bool
    
    var body: some View {
        Ember3DTouchySyncee(
            character: character,
            size: size,
            isAnimating: isAnimating
        )
    }
}

#Preview {
    HStack(spacing: 30) {
        EmberSimple3DCharacters(character: .touchy, size: 120, isAnimating: true)
        EmberSimple3DCharacters(character: .syncee, size: 120, isAnimating: true)
    }
    .padding()
}