import SwiftUI

struct PremiumProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 4)
                .fill(.quaternary)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(ColorPalette.sensualGradient)
                .scaleEffect(x: configuration.fractionCompleted ?? 0, y: 1, anchor: .leading)
        }
    }
}