import SwiftUI

// MARK: - Character Type to Blob Mapping
extension CharacterType {
    var blobColors: (start: Color, end: Color) {
        switch self {
        case .touchy:
            return (EmberColors.roseQuartz, EmberColors.peachyKeen)
        case .syncee:
            return (EmberColors.peachyKeen, EmberColors.coralPop)
        case .harmony:
            return (EmberColors.coralPop, EmberColors.coralPopLight)
        case .flux:
            return (EmberColors.peachyKeen, EmberColors.roseQuartz)
        }
    }
}

// MARK: - Expression to Mood Mapping
extension CharacterExpression {
    var blobMood: EmberBlobCharacter.Mood {
        switch self {
        case .happy, .warmSmile:
            return .happy
        case .excited:
            return .excited
        case .love, .romantic:
            return .love
        case .sleeping:
            return .sleepy
        case .sad:
            return .sad
        case .waiting:
            return .neutral
        }
    }
}

// MARK: - Convenience View Extension
extension EmberBlobCharacter {
    init(character: CharacterType, size: CGFloat = 120, expression: CharacterExpression = .happy, isAnimating: Bool = false) {
        let colors = character.blobColors
        self.init(
            size: size,
            mood: expression.blobMood,
            tintStart: colors.start,
            tintEnd: colors.end,
            animate: isAnimating
        )
    }
}
