import SwiftUI

struct CuteCharacter: View {
    let character: CharacterType
    let size: CGFloat
    let customization: CharacterCustomization
    let isAnimating: Bool
    
    private var mood: CharacterMood {
        switch customization.expression {
        case .happy: return .happy
        case .excited: return .excited
        case .love: return .love
        case .sleeping: return .sleeping
        case .sad: return .sad
        case .waiting: return .waiting
        case .romantic: return .romantic
        case .warmSmile: return .warmSmile
        }
    }
    
    @State private var bounceOffset: CGFloat = 0
    @State private var sparkleRotation: Double = 0
    @State private var eyeBlink: Bool = false
    @State private var blinkTimer: Timer?
    @State private var armWave: Bool = false
    @State private var heartPulse: Bool = false
    @State private var cheekBlush: Bool = false
    @State private var breathingScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.0
    
    init(
        character: CharacterType,
        size: CGFloat = 120,
        customization: CharacterCustomization = .default,
        isAnimating: Bool = false
    ) {
        self.character = character
        self.size = size
        self.customization = customization
        self.isAnimating = isAnimating
    }
    
    init(
        character: CharacterType,
        size: CGFloat = 120,
        mood: CharacterMood = .happy,
        isAnimating: Bool = false
    ) {
        self.character = character
        self.size = size
        self.customization = CharacterCustomization(
            colorTheme: .default,
            accessory: .none,
            expression: CharacterExpression(rawValue: mood.rawValue) ?? .happy,
            name: "My Heart"
        )
        self.isAnimating = isAnimating
    }
    
    // Convenience initializer for old API
    init(
        size: CGFloat = 120,
        isAnimating: Bool = false,
        customization: CharacterCustomization = .default
    ) {
        self.character = .touchy
        self.size = size
        self.customization = customization
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        ZStack {
            blobBody
                .offset(y: bounceOffset)
                .scaleEffect(breathingScale)
                .shadow(color: customization.colorTheme.primaryColor.opacity(glowIntensity), radius: 8)
            
            faceView.offset(y: bounceOffset)
            accessoryView.offset(y: bounceOffset)
            signatureElement.offset(y: -size * 0.35 + bounceOffset)
            
            if isAnimating {
                sparklesView
                moodParticles
            }
        }
        .onAppear {
            if isAnimating {
                startAnimations()
            }
        }
        .onDisappear {
            stopAnimations()
        }
    }
    
    private var blobBody: some View {
        ZStack {
            // Shadow
            Ellipse()
                .fill(.black.opacity(0.15))
                .frame(width: size * 0.7, height: size * 0.15)
                .offset(y: size * 0.45)
                .blur(radius: 3)
            
            // Main body
            mainBodyView
            
            // Arms
            armsView
        }
    }
    
    private var mainBodyView: some View {
        let bodyColors = customization.colorTheme.colors
        let firstColor = bodyColors.first ?? .orange
        let gradientColors = bodyColors + [firstColor.opacity(0.8)]
        
        return Capsule()
            .fill(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size * 0.65, height: size * 1.0)
            .overlay(innerHighlight)
            .overlay(outerStroke)
    }
    
    private var innerHighlight: some View {
        Capsule()
            .stroke(
                LinearGradient(
                    colors: [.white.opacity(0.3), .clear],
                    startPoint: .topLeading,
                    endPoint: .center
                ),
                lineWidth: size * 0.01
            )
            .frame(width: size * 0.6, height: size * 0.95)
    }
    
    private var outerStroke: some View {
        Capsule()
            .stroke(.black.opacity(0.8), lineWidth: size * 0.02)
    }
    
    private var faceView: some View {
        VStack(spacing: size * 0.06) {
            eyesView.offset(y: -size * 0.1)
            mouthView.offset(y: -size * 0.05)
            
            // Cheeks for certain expressions
            if mood == .love || mood == .romantic || mood == .excited {
                cheeksView.offset(y: -size * 0.08)
            }
        }
    }
    
    @ViewBuilder
    private var eyesView: some View {
        VStack(spacing: size * 0.04) {
            // Eyebrows (for certain expressions)
            if mood == .sad || mood == .romantic {
                HStack(spacing: size * 0.12) {
                    ForEach(0..<2, id: \.self) { _ in
                        Capsule()
                            .fill(.black)
                            .frame(width: size * 0.08, height: size * 0.015)
                            .rotationEffect(.degrees(mood == .sad ? -15 : 15))
                    }
                }
            }
            
            // Eyes
            HStack(spacing: size * 0.1) {
                ForEach(0..<2, id: \.self) { _ in
                    switch mood {
                    case .happy, .warmSmile, .excited, .waiting:
                        Circle()
                            .fill(.black)
                            .frame(
                                width: size * 0.08,
                                height: eyeBlink ? size * 0.015 : size * 0.08
                            )
                            .animation(.easeInOut(duration: 0.1), value: eyeBlink)
                    case .love, .romantic:
                        ZStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: size * 0.09))
                                .foregroundStyle(.pink)
                                .scaleEffect(heartPulse ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.6), value: heartPulse)
                            
                            // Sparkle overlay for extra romance
                            Image(systemName: "sparkles")
                                .font(.system(size: size * 0.04))
                                .foregroundStyle(.white.opacity(0.8))
                                .scaleEffect(heartPulse ? 0.8 : 1.2)
                                .animation(.easeInOut(duration: 0.6), value: heartPulse)
                        }
                    case .sleeping:
                        Capsule()
                            .fill(.black)
                            .frame(width: size * 0.1, height: size * 0.02)
                    case .sad:
                        Circle()
                            .fill(.black)
                            .frame(width: size * 0.06, height: size * 0.06)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var mouthView: some View {
        switch mood {
        case .happy, .warmSmile:
            happyMouth
        case .excited:
            excitedMouth
        case .love, .romantic:
            lovingMouth
        case .sleeping:
            sleepingMouth
        case .sad:
            sadMouth
        case .waiting:
            waitingMouth
        }
    }
    
    private var happyMouth: some View {
        ZStack {
            Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                .stroke(.black, lineWidth: size * 0.02)
                .frame(width: size * 0.12, height: size * 0.06)
            
            Arc(startAngle: .degrees(20), endAngle: .degrees(60), clockwise: false)
                .stroke(.white.opacity(0.3), lineWidth: size * 0.01)
                .frame(width: size * 0.1, height: size * 0.05)
                .offset(y: -size * 0.01)
        }
    }
    
    private var excitedMouth: some View {
        ZStack {
            Ellipse()
                .fill(.black)
                .frame(width: size * 0.1, height: size * 0.08)
            
            Ellipse()
                .fill(.white.opacity(0.4))
                .frame(width: size * 0.03, height: size * 0.02)
                .offset(x: -size * 0.02, y: -size * 0.01)
        }
    }
    
    private var lovingMouth: some View {
        Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
            .stroke(.black, lineWidth: size * 0.02)
            .frame(width: size * 0.1, height: size * 0.05)
    }
    
    private var sleepingMouth: some View {
        Ellipse()
            .fill(.black)
            .frame(width: size * 0.05, height: size * 0.025)
    }
    
    private var sadMouth: some View {
        Arc(startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
            .stroke(.black, lineWidth: size * 0.02)
            .frame(width: size * 0.1, height: size * 0.05)
    }
    
    private var waitingMouth: some View {
        Ellipse()
            .fill(.black)
            .frame(width: size * 0.04, height: size * 0.02)
    }
    
    @ViewBuilder
    private var signatureElement: some View {
        switch character {
        case .touchy:
            touchySignature
        case .syncee:
            synceeSignature
        }
    }
    
    private var touchySignature: some View {
        let sparkleGradient = LinearGradient(
            colors: [.orange, .yellow],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        return ZStack {
            ForEach(0..<4, id: \.self) { index in
                let angle = Double(index) * .pi / 2 + sparkleRotation
                let radius = size * 0.15
                let xOffset = cos(angle) * radius
                let yOffset = sin(angle) * radius
                let scaleValue = 0.8 + sin(sparkleRotation + Double(index)) * 0.3
                let opacityValue = 0.7 + sin(sparkleRotation + Double(index)) * 0.3
                
                Image(systemName: "sparkle")
                    .font(.system(size: size * 0.04))
                    .foregroundStyle(sparkleGradient)
                    .offset(x: xOffset, y: yOffset)
                    .scaleEffect(scaleValue)
                    .opacity(opacityValue)
            }
        }
        .offset(x: size * 0.3, y: -size * 0.2)
    }
    
    private var synceeSignature: some View {
        let heartGradient = LinearGradient(
            colors: [.pink, .red.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        return ZStack {
            ForEach(0..<3, id: \.self) { index in
                let angle = Double(index) * .pi * 2/3 + sparkleRotation * 0.5
                let radius = size * 0.12
                let xOffset = cos(angle) * radius
                let yOffset = sin(angle) * radius
                let scaleValue = 1.0 + sin(sparkleRotation + Double(index)) * 0.2
                let opacityValue = 0.6 + sin(sparkleRotation + Double(index)) * 0.4
                
                Image(systemName: "heart.fill")
                    .font(.system(size: size * 0.03))
                    .foregroundStyle(heartGradient)
                    .offset(x: xOffset, y: yOffset)
                    .scaleEffect(scaleValue)
                    .opacity(opacityValue)
            }
        }
        .offset(x: size * 0.25, y: -size * 0.15)
    }
    
    @ViewBuilder
    private var sparklesView: some View {
        ForEach(0..<3, id: \.self) { index in
            let angle = Double(index) * .pi * 2/3 + sparkleRotation
            let radius = size * 0.45
            let xOffset = cos(angle) * radius
            let yOffset = sin(angle) * radius + bounceOffset
            let scaleValue = 0.8 + sin(sparkleRotation + Double(index)) * 0.3
            let foregroundColor = customization.colorTheme.colors.last?.opacity(0.6) ?? .orange.opacity(0.6)
            
            Image(systemName: "sparkle")
                .font(.system(size: size * 0.04))
                .foregroundStyle(foregroundColor)
                .offset(x: xOffset, y: yOffset)
                .scaleEffect(scaleValue)
        }
    }
    
    @ViewBuilder
    private var moodParticles: some View {
        if mood == .love || mood == .romantic {
            ForEach(0..<5, id: \.self) { index in
                let angle = Double(index) * .pi * 2/5 + sparkleRotation * 0.5
                let radius = size * 0.6
                let xOffset = cos(angle) * radius
                let yOffset = sin(angle) * radius
                let scaleValue = 0.5 + sin(sparkleRotation * 2 + Double(index)) * 0.5
                
                Image(systemName: "heart.fill")
                    .font(.system(size: size * 0.02))
                    .foregroundStyle(.pink.opacity(0.4))
                    .offset(x: xOffset, y: yOffset)
                    .scaleEffect(scaleValue)
            }
        } else if mood == .excited {
            ForEach(0..<4, id: \.self) { index in
                let angle = Double(index) * .pi * 2/4 + sparkleRotation * 1.5
                let radius = size * 0.5
                let xOffset = cos(angle) * radius
                let yOffset = sin(angle) * radius
                
                Image(systemName: "star.fill")
                    .font(.system(size: size * 0.025))
                    .foregroundStyle(.yellow.opacity(0.5))
                    .offset(x: xOffset, y: yOffset)
            }
        }
    }
    
    @ViewBuilder
    private var accessoryView: some View {
        switch customization.accessory {
        case .none:
            EmptyView()
        case .hat:
            ZStack {
                Ellipse()
                    .fill(.red)
                    .frame(width: size * 0.25, height: size * 0.08)
                    .offset(y: -size * 0.45)
                Circle()
                    .fill(.red)
                    .frame(width: size * 0.15, height: size * 0.15)
                    .offset(y: -size * 0.52)
            }
        case .crown:
            HStack(spacing: size * 0.02) {
                ForEach(0..<3, id: \.self) { index in
                    Triangle()
                        .fill(.yellow)
                        .frame(width: size * 0.06, height: size * 0.08)
                        .scaleEffect(index == 1 ? 1.2 : 1.0)
                }
            }
            .offset(y: -size * 0.48)
        case .bow:
            BowTie()
                .fill(.red)
                .frame(width: size * 0.12, height: size * 0.08)
                .offset(y: -size * 0.25)
        case .glasses:
            HStack(spacing: size * 0.08) {
                ForEach(0..<2, id: \.self) { _ in
                    Circle()
                        .stroke(.black, lineWidth: 2)
                        .frame(width: size * 0.12, height: size * 0.12)
                }
            }
            .overlay(
                Rectangle()
                    .fill(.black)
                    .frame(width: size * 0.06, height: 2)
            )
            .offset(y: -size * 0.08)
        case .flower:
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Ellipse()
                        .fill(.pink)
                        .frame(width: size * 0.04, height: size * 0.08)
                        .rotationEffect(.degrees(Double(index) * 72))
                }
                Circle()
                    .fill(.yellow)
                    .frame(width: size * 0.03, height: size * 0.03)
            }
            .offset(y: -size * 0.45)
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            bounceOffset = -size * 0.03
        }
        
        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
            breathingScale = 1.05
        }
        
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            glowIntensity = mood == .love || mood == .romantic ? 0.3 : 0.1
        }
        
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            sparkleRotation = 360
        }
        
        startBlinking()
        startMicroInteractions()
    }
    
    private func startMicroInteractions() {
        // Arm waving for excited/happy moods
        if mood == .excited || mood == .happy || mood == .warmSmile {
            Timer.scheduledTimer(withTimeInterval: Double.random(in: 2.0...4.0), repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    armWave.toggle()
                }
            }
        }
        
        // Heart pulsing for love/romantic moods
        if mood == .love || mood == .romantic {
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.6)) {
                    heartPulse.toggle()
                }
            }
        }
        
        // Cheek blushing for love/romantic/excited moods
        if mood == .love || mood == .romantic || mood == .excited {
            Timer.scheduledTimer(withTimeInterval: Double.random(in: 3.0...5.0), repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.8)) {
                    cheekBlush.toggle()
                }
            }
        }
    }
    
    private func startBlinking() {
        blinkTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 3.0...6.0), repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                eyeBlink = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    eyeBlink = false
                }
            }
        }
    }
    
    private func stopAnimations() {
        blinkTimer?.invalidate()
        blinkTimer = nil
    }
    
    @ViewBuilder
    private var armsView: some View {
        HStack(spacing: size * 0.8) {
            // Left arm
            RoundedRectangle(cornerRadius: size * 0.02)
                .fill(customization.colorTheme.colors.first ?? .pink)
                .frame(width: size * 0.04, height: size * 0.15)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.02)
                        .stroke(.black, lineWidth: size * 0.01)
                )
                .rotationEffect(.degrees(armWaveAnimation(-10, -30)))
                .offset(x: -size * 0.28, y: size * 0.1)
            
            // Right arm
            RoundedRectangle(cornerRadius: size * 0.02)
                .fill(customization.colorTheme.colors.first ?? .pink)
                .frame(width: size * 0.04, height: size * 0.15)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.02)
                        .stroke(.black, lineWidth: size * 0.01)
                )
                .rotationEffect(.degrees(armWaveAnimation(10, 30)))
                .offset(x: size * 0.28, y: size * 0.1)
        }
    }
    
    private func armWaveAnimation(_ normal: Double, _ wave: Double) -> Double {
        switch mood {
        case .excited:
            return armWave ? wave : normal
        case .happy, .warmSmile:
            return isAnimating ? (armWave ? wave * 0.7 : normal) : normal
        default:
            return normal
        }
    }
    

    
    @ViewBuilder
    private var cheeksView: some View {
        HStack(spacing: size * 0.2) {
            ForEach(0..<2, id: \.self) { _ in
                cheekView
            }
        }
    }
    
    private var cheekView: some View {
        let blushGradient = RadialGradient(
            colors: [.pink.opacity(cheekBlush ? 0.6 : 0.4), .pink.opacity(cheekBlush ? 0.2 : 0.1)],
            center: .center,
            startRadius: 0,
            endRadius: size * 0.03
        )
        
        return ZStack {
            Circle()
                .fill(blushGradient)
                .frame(width: size * 0.05, height: size * 0.05)
                .scaleEffect(cheekBlush ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.8), value: cheekBlush)
            
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: size * 0.02, height: size * 0.02)
                .offset(x: -size * 0.008, y: -size * 0.008)
        }
    }
}

// MARK: - Custom Shapes

struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0.2 * width, y: 0.1 * height))
        path.addCurve(
            to: CGPoint(x: 0.8 * width, y: 0.1 * height),
            control1: CGPoint(x: 0.4 * width, y: -0.05 * height),
            control2: CGPoint(x: 0.6 * width, y: -0.05 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.9 * width, y: 0.4 * height),
            control1: CGPoint(x: 0.95 * width, y: 0.2 * height),
            control2: CGPoint(x: 0.95 * width, y: 0.3 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.8 * width, y: 0.8 * height),
            control1: CGPoint(x: 0.95 * width, y: 0.6 * height),
            control2: CGPoint(x: 0.9 * width, y: 0.7 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.2 * width, y: 0.8 * height),
            control1: CGPoint(x: 0.6 * width, y: 0.95 * height),
            control2: CGPoint(x: 0.4 * width, y: 0.95 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.1 * width, y: 0.4 * height),
            control1: CGPoint(x: 0.1 * width, y: 0.7 * height),
            control2: CGPoint(x: 0.05 * width, y: 0.6 * height)
        )
        path.addCurve(
            to: CGPoint(x: 0.2 * width, y: 0.1 * height),
            control1: CGPoint(x: 0.05 * width, y: 0.3 * height),
            control2: CGPoint(x: 0.05 * width, y: 0.2 * height)
        )
        
        return path
    }
}

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        return path
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

struct BowTie: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width * 0.4, y: height * 0.5))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width * 0.3, y: height))
        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.5))
        path.addLine(to: CGPoint(x: width * 0.7, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width * 0.6, y: height * 0.5))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width * 0.7, y: 0))
        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.5))
        path.addLine(to: CGPoint(x: width * 0.3, y: 0))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 30) {
            CuteCharacter(
                character: .touchy,
                customization: CharacterCustomization(
                    colorTheme: .default,
                    accessory: .none,
                    expression: .happy,
                                        name: "My Heart"
                ),
                isAnimating: true
            )
            
            CuteCharacter(
                character: .syncee,
                customization: CharacterCustomization(
                    colorTheme: .default,
                    accessory: .bow,
                    expression: .love,
                                        name: "My Heart"
                ),
                isAnimating: true
            )
        }
    }
    .padding()
}
