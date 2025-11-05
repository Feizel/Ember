import SwiftUI

// MARK: - Ember Character Component
struct EmberCharacterView: View {
    let character: CharacterType
    let size: CGFloat
    let expression: CharacterExpression
    let isAnimating: Bool
    
    @State private var bounceOffset: CGFloat = 0
    @State private var sparkleRotation: Double = 0
    @State private var eyeBlink: Bool = false
    @State private var heartPulse: Bool = false
    @State private var breathingScale: CGFloat = 1.0
    @State private var glowIntensity: Double = 0.0
    
    init(character: CharacterType, size: CGFloat = 120, expression: CharacterExpression = .happy, isAnimating: Bool = false) {
        self.character = character
        self.size = size
        self.expression = expression
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        ZStack {
            characterBody
                .offset(y: bounceOffset)
                .scaleEffect(breathingScale)
                .emberGlowShadow()
            
            faceView
                .offset(y: bounceOffset)
            
            signatureElement
                .offset(y: -size * 0.35 + bounceOffset)
            
            if isAnimating {
                sparklesView
            }
        }
        .onAppear {
            if isAnimating {
                startAnimations()
            }
        }
    }
    
    private var characterBody: some View {
        ZStack {
            // Simple drop shadow
            BlobShape(character: character)
                .fill(.black.opacity(0.1))
                .frame(width: size * 0.72, height: size * 1.02)
                .offset(x: size * 0.01, y: size * 0.02)
                .blur(radius: 2)
            
            // Main cute blob body
            BlobShape(character: character)
                .fill(bodyGradient)
                .frame(width: size * 0.7, height: size * 1.0)
                .overlay(
                    // Simple highlight for HD look
                    BlobShape(character: character)
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.3), .clear],
                                startPoint: .topLeading,
                                endPoint: .center
                            )
                        )
                        .frame(width: size * 0.6, height: size * 0.4)
                        .offset(y: -size * 0.2)
                )
        }
    }
    
    private var bodyGradient: LinearGradient {
        switch character {
        case .touchy:
            return LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.roseQuartzLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .syncee:
            return LinearGradient(
                colors: [EmberColors.peachyKeen, EmberColors.peachyKeenLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .harmony:
            return LinearGradient(
                colors: [EmberColors.coralPop, EmberColors.coralPopLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .flux:
            return LinearGradient(
                colors: [EmberColors.peachyKeen, EmberColors.coralPop],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var bodyDepthGradient: LinearGradient {
        switch character {
        case .touchy:
            return LinearGradient(
                colors: [EmberColors.roseQuartz.opacity(0.7), EmberColors.roseQuartzLight.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .syncee:
            return LinearGradient(
                colors: [EmberColors.peachyKeen.opacity(0.7), EmberColors.peachyKeenLight.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .harmony:
            return LinearGradient(
                colors: [EmberColors.coralPop.opacity(0.7), EmberColors.coralPopLight.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .flux:
            return LinearGradient(
                colors: [EmberColors.peachyKeen.opacity(0.7), EmberColors.coralPop.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var faceView: some View {
        ZStack {
            VStack(spacing: size * 0.06) {
                eyesView.offset(y: -size * 0.1)
                mouthView.offset(y: -size * 0.05)
            }
            
            // Rosy cheeks like reference - always visible
            HStack(spacing: size * 0.28) {
                ForEach(0..<2, id: \.self) { _ in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [EmberColors.roseQuartz.opacity(0.4), EmberColors.roseQuartz.opacity(0.0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: size * 0.04
                            )
                        )
                        .frame(width: size * 0.08, height: size * 0.08)
                }
            }
            .offset(y: size * 0.02)
        }
    }
    
    @ViewBuilder
    private var eyesView: some View {
        HStack(spacing: eyeSpacing) {
            ForEach(0..<2, id: \.self) { eyeIndex in
                switch expression {
                case .happy, .warmSmile, .excited, .waiting:
                    // Recessed 3D googly eyes like reference
                    ZStack {
                        // Eye socket (darker recessed area)
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.black.opacity(0.2), Color.black.opacity(0.05)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: eyeWidth * 1.1
                                )
                            )
                            .frame(width: eyeWidth * 2.2, height: eyeBlink ? size * 0.02 : eyeHeight * 2.2)
                        
                        if !eyeBlink {
                            // White eyeball with subtle gradient
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [.white, Color.gray.opacity(0.15)],
                                        center: UnitPoint(x: 0.4, y: 0.4),
                                        startRadius: 0,
                                        endRadius: eyeWidth * 0.9
                                    )
                                )
                                .frame(width: eyeWidth * 1.8, height: eyeHeight * 1.8)
                            
                            // Large black pupil
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.black.opacity(0.95), .black],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: eyeWidth * 0.5
                                    )
                                )
                                .frame(width: eyeWidth * 1.0, height: eyeHeight * 1.0)
                            
                            // Large bright highlight
                            Circle()
                                .fill(.white)
                                .frame(width: eyeWidth * 0.5, height: eyeHeight * 0.5)
                                .offset(x: -eyeWidth * 0.18, y: -eyeHeight * 0.18)
                            
                            // Smaller secondary highlight
                            Circle()
                                .fill(.white.opacity(0.7))
                                .frame(width: eyeWidth * 0.2, height: eyeHeight * 0.2)
                                .offset(x: eyeWidth * 0.2, y: eyeHeight * 0.15)
                        }
                    }
                    .animation(.easeInOut(duration: 0.1), value: eyeBlink)
                case .love, .romantic:
                    Image(systemName: "heart.fill")
                        .font(.system(size: size * 0.12))
                        .foregroundStyle(EmberColors.roseQuartz)
                        .scaleEffect(heartPulse ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.6), value: heartPulse)
                case .sleeping:
                    Capsule()
                        .fill(.black)
                        .frame(width: size * 0.12, height: size * 0.025)
                case .sad:
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.black.opacity(0.2), Color.black.opacity(0.05)],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: sadEyeSize * 0.9
                                )
                            )
                            .frame(width: sadEyeSize * 1.8, height: sadEyeSize * 1.8)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: sadEyeSize * 1.5, height: sadEyeSize * 1.5)
                        
                        Circle()
                            .fill(.black)
                            .frame(width: sadEyeSize * 0.9, height: sadEyeSize * 0.9)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: sadEyeSize * 0.35, height: sadEyeSize * 0.35)
                            .offset(x: -sadEyeSize * 0.15, y: -sadEyeSize * 0.15)
                        
                        Circle()
                            .fill(.blue.opacity(0.7))
                            .frame(width: size * 0.025, height: size * 0.025)
                            .offset(x: eyeIndex == 0 ? -size * 0.06 : size * 0.06, y: size * 0.08)
                    }
                }
            }
        }
    }
    
    private var eyeSpacing: CGFloat {
        switch character {
        case .touchy: return size * 0.08
        case .syncee: return size * 0.12
        case .harmony: return size * 0.10
        case .flux: return size * 0.09
        }
    }
    

    
    private var eyeWidth: CGFloat {
        switch character {
        case .touchy: return size * 0.09
        case .syncee: return size * 0.08
        case .harmony: return size * 0.085
        case .flux: return size * 0.09
        }
    }
    
    private var eyeHeight: CGFloat {
        switch character {
        case .touchy: return size * 0.09
        case .syncee: return size * 0.07
        case .harmony: return size * 0.085
        case .flux: return size * 0.08
        }
    }
    
    private var sadEyeSize: CGFloat {
        switch character {
        case .touchy: return size * 0.07
        case .syncee: return size * 0.06
        case .harmony: return size * 0.065
        case .flux: return size * 0.07
        }
    }
    
    @ViewBuilder
    private var mouthView: some View {
        switch expression {
        case .happy, .warmSmile:
            // Curved smile like reference with inner pink
            ZStack {
                // Smile shape
                Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                    .fill(.black)
                    .frame(width: size * 0.16, height: size * 0.1)
                    .mask(
                        Rectangle()
                            .frame(width: size * 0.16, height: size * 0.05)
                            .offset(y: size * 0.025)
                    )
                
                // Inner pink mouth
                Arc(startAngle: .degrees(10), endAngle: .degrees(170), clockwise: false)
                    .fill(EmberColors.roseQuartz.opacity(0.6))
                    .frame(width: size * 0.12, height: size * 0.07)
                    .mask(
                        Rectangle()
                            .frame(width: size * 0.12, height: size * 0.035)
                            .offset(y: size * 0.0175)
                    )
            }
        case .excited:
            ZStack {
                Ellipse()
                    .fill(.black)
                    .frame(width: size * 0.15, height: size * 0.12)
                
                Ellipse()
                    .fill(EmberColors.roseQuartz.opacity(0.5))
                    .frame(width: size * 0.1, height: size * 0.08)
            }
        case .love, .romantic:
            ZStack {
                Arc(startAngle: .degrees(0), endAngle: .degrees(180), clockwise: false)
                    .fill(.black)
                    .frame(width: size * 0.13, height: size * 0.08)
                    .mask(
                        Rectangle()
                            .frame(width: size * 0.13, height: size * 0.04)
                            .offset(y: size * 0.02)
                    )
                
                Arc(startAngle: .degrees(15), endAngle: .degrees(165), clockwise: false)
                    .fill(EmberColors.roseQuartz.opacity(0.5))
                    .frame(width: size * 0.1, height: size * 0.06)
                    .mask(
                        Rectangle()
                            .frame(width: size * 0.1, height: size * 0.03)
                            .offset(y: size * 0.015)
                    )
            }
        case .sleeping:
            Ellipse()
                .fill(.black)
                .frame(width: size * 0.06, height: size * 0.03)
        case .sad:
            Arc(startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
                .fill(.black)
                .frame(width: size * 0.14, height: size * 0.08)
                .mask(
                    Rectangle()
                        .frame(width: size * 0.14, height: size * 0.04)
                        .offset(y: -size * 0.02)
                )
        case .waiting:
            Ellipse()
                .fill(.black)
                .frame(width: size * 0.05, height: size * 0.025)
        }
    }
    
    @ViewBuilder
    private var signatureElement: some View {
        switch character {
        case .touchy:
            // Gentle sparkles with soft elements
            VStack(spacing: size * 0.02) {
                // Soft accent lines
                HStack(spacing: size * 0.03) {
                    ForEach(0..<3, id: \.self) { _ in
                        Capsule()
                            .fill(.black.opacity(0.4))
                            .frame(width: size * 0.012, height: size * 0.03)
                            .rotationEffect(.degrees(Double.random(in: -10...10)))
                    }
                }
                .offset(y: -size * 0.35)
                
                // Sparkles
                ForEach(0..<4, id: \.self) { index in
                    let angle = Double(index) * .pi / 2 + sparkleRotation
                    let radius = size * 0.15
                    let xOffset = cos(angle) * radius
                    let yOffset = sin(angle) * radius
                    
                    Image(systemName: "sparkle")
                        .font(.system(size: size * 0.04))
                        .foregroundStyle(EmberColors.coralPop)
                        .offset(x: xOffset, y: yOffset)
                }
                .offset(x: size * 0.3, y: -size * 0.2)
            }
        case .syncee:
            // Strong angular elements
            VStack(spacing: size * 0.02) {
                // Angular accent lines
                HStack(spacing: size * 0.06) {
                    ForEach(0..<2, id: \.self) { _ in
                        Rectangle()
                            .fill(.black.opacity(0.6))
                            .frame(width: size * 0.05, height: size * 0.015)
                            .rotationEffect(.degrees(-15))
                    }
                }
                .offset(y: -size * 0.38)
                
                // Hearts
                ForEach(0..<3, id: \.self) { index in
                    let angle = Double(index) * .pi * 2/3 + sparkleRotation * 0.5
                    let radius = size * 0.12
                    let xOffset = cos(angle) * radius
                    let yOffset = sin(angle) * radius
                    
                    Image(systemName: "heart.fill")
                        .font(.system(size: size * 0.03))
                        .foregroundStyle(EmberColors.roseQuartz)
                        .offset(x: xOffset, y: yOffset)
                }
                .offset(x: size * 0.25, y: -size * 0.15)
            }
        case .harmony:
            // Balanced elements - geometric patterns
            VStack(spacing: size * 0.02) {
                // Balanced accent
                HStack(spacing: size * 0.04) {
                    ForEach(0..<4, id: \.self) { index in
                        Circle()
                            .fill(.black.opacity(0.3))
                            .frame(width: size * 0.008, height: size * 0.008)
                    }
                }
                .offset(y: -size * 0.35)
                
                // Geometric elements
                ForEach(0..<6, id: \.self) { index in
                    let angle = Double(index) * .pi / 3 + sparkleRotation * 0.7
                    let radius = size * 0.13
                    let xOffset = cos(angle) * radius
                    let yOffset = sin(angle) * radius
                    
                    Image(systemName: "diamond.fill")
                        .font(.system(size: size * 0.025))
                        .foregroundStyle(EmberColors.peachyKeen)
                        .offset(x: xOffset, y: yOffset)
                }
                .offset(x: size * 0.28, y: -size * 0.18)
            }
        case .flux:
            // Dynamic elements - flowing patterns
            VStack(spacing: size * 0.02) {
                // Flowing accent
                HStack(spacing: size * 0.02) {
                    ForEach(0..<5, id: \.self) { index in
                        Capsule()
                            .fill(.black.opacity(0.4))
                            .frame(width: size * 0.006, height: size * 0.02 + CGFloat(index) * size * 0.005)
                            .rotationEffect(.degrees(Double(index) * 8))
                    }
                }
                .offset(y: -size * 0.35)
                
                // Wave elements
                ForEach(0..<5, id: \.self) { index in
                    let angle = Double(index) * .pi * 2/5 + sparkleRotation * 1.2
                    let radius = size * 0.11 + CGFloat(index % 2) * size * 0.03
                    let xOffset = cos(angle) * radius
                    let yOffset = sin(angle) * radius
                    
                    Image(systemName: "wave.3.right")
                        .font(.system(size: size * 0.02))
                        .foregroundStyle(EmberColors.coralPop.opacity(0.8))
                        .offset(x: xOffset, y: yOffset)
                        .rotationEffect(.degrees(angle * 180 / .pi))
                }
                .offset(x: size * 0.26, y: -size * 0.16)
            }
        }
    }
    
    @ViewBuilder
    private var sparklesView: some View {
        ForEach(0..<3, id: \.self) { index in
            let angle = Double(index) * .pi * 2/3 + sparkleRotation
            let radius = size * 0.45
            let xOffset = cos(angle) * radius
            let yOffset = sin(angle) * radius + bounceOffset
            
            Image(systemName: "sparkle")
                .font(.system(size: size * 0.04))
                .foregroundStyle(EmberColors.peachyKeen.opacity(0.6))
                .offset(x: xOffset, y: yOffset)
        }
    }
    
    @ViewBuilder
    private var cheeksView: some View {
        HStack(spacing: size * 0.2) {
            ForEach(0..<2, id: \.self) { _ in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [EmberColors.roseQuartz.opacity(0.6), EmberColors.roseQuartz.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: size * 0.03
                        )
                    )
                    .frame(width: size * 0.05, height: size * 0.05)
            }
        }
    }
    
    private func startAnimations() {
        // Gentle floating animation
        withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
            bounceOffset = -size * 0.04
        }
        
        // Breathing effect for life-like appearance
        withAnimation(.easeInOut(duration: 3.5).repeatForever(autoreverses: true)) {
            breathingScale = 1.08
        }
        
        // Sparkle rotation
        withAnimation(.linear(duration: 10.0).repeatForever(autoreverses: false)) {
            sparkleRotation = 360
        }
        
        // Glow pulsing
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            glowIntensity = 0.3
        }
        
        // Heart pulsing for love expressions
        if expression == .love || expression == .romantic {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    heartPulse.toggle()
                }
            }
        }
        
        // Natural blinking with variation
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 2.5...5.0), repeats: true) { _ in
            withAnimation(.spring(response: 0.2, dampingFraction: 0.8)) {
                eyeBlink = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    eyeBlink = false
                }
            }
        }
    }
}

// MARK: - Arc Shape
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

// MARK: - Blob Shape
struct BlobShape: Shape {
    let character: CharacterType
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let centerX = rect.midX
        let centerY = rect.midY
        
        switch character {
        case .touchy:
            // Gentle blob - soft, nurturing curves
            path.move(to: CGPoint(x: centerX, y: rect.minY + height * 0.1))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.05, y: centerY - height * 0.1),
                control: CGPoint(x: rect.maxX - width * 0.1, y: rect.minY + height * 0.2)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.1, y: centerY + height * 0.2),
                control: CGPoint(x: rect.maxX, y: centerY)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX + width * 0.1, y: rect.maxY - height * 0.05),
                control: CGPoint(x: rect.maxX - width * 0.05, y: rect.maxY - height * 0.1)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX - width * 0.1, y: rect.maxY - height * 0.05),
                control: CGPoint(x: centerX, y: rect.maxY + height * 0.02)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.1, y: centerY + height * 0.2),
                control: CGPoint(x: rect.minX + width * 0.05, y: rect.maxY - height * 0.1)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.05, y: centerY - height * 0.1),
                control: CGPoint(x: rect.minX, y: centerY)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX, y: rect.minY + height * 0.1),
                control: CGPoint(x: rect.minX + width * 0.1, y: rect.minY + height * 0.2)
            )
            
        case .syncee:
            // Strong blob - structured, protective angles
            path.move(to: CGPoint(x: centerX, y: rect.minY + height * 0.08))
            path.addLine(to: CGPoint(x: rect.maxX - width * 0.12, y: rect.minY + height * 0.15))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.08, y: centerY),
                control: CGPoint(x: rect.maxX - width * 0.05, y: centerY - height * 0.15)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.15, y: centerY + height * 0.25),
                control: CGPoint(x: rect.maxX, y: centerY + height * 0.1)
            )
            path.addLine(to: CGPoint(x: centerX + width * 0.08, y: rect.maxY - height * 0.08))
            path.addQuadCurve(
                to: CGPoint(x: centerX - width * 0.08, y: rect.maxY - height * 0.08),
                control: CGPoint(x: centerX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: rect.minX + width * 0.15, y: centerY + height * 0.25))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.08, y: centerY),
                control: CGPoint(x: rect.minX, y: centerY + height * 0.1)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.12, y: rect.minY + height * 0.15),
                control: CGPoint(x: rect.minX + width * 0.05, y: centerY - height * 0.15)
            )
            path.addLine(to: CGPoint(x: centerX, y: rect.minY + height * 0.08))
            
        case .harmony:
            // Balanced blob - perfect symmetry, fluid form
            let points = 8
            for i in 0..<points {
                let angle = Double(i) * 2 * .pi / Double(points)
                let radiusVariation = 0.85 + 0.15 * sin(Double(i) * 0.5)
                let radius = min(width, height) * 0.35 * radiusVariation
                let x = centerX + cos(angle) * radius
                let y = centerY + sin(angle) * radius
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    let prevAngle = Double(i - 1) * 2 * .pi / Double(points)
                    let prevRadius = min(width, height) * 0.35 * (0.85 + 0.15 * sin(Double(i - 1) * 0.5))
                    let controlRadius = (radius + prevRadius) * 0.5
                    let controlAngle = (angle + prevAngle) * 0.5
                    let controlX = centerX + cos(controlAngle) * controlRadius * 1.2
                    let controlY = centerY + sin(controlAngle) * controlRadius * 1.2
                    
                    path.addQuadCurve(
                        to: CGPoint(x: x, y: y),
                        control: CGPoint(x: controlX, y: controlY)
                    )
                }
            }
            
        case .flux:
            // Dynamic blob - asymmetric, expressive waves
            path.move(to: CGPoint(x: centerX - width * 0.2, y: rect.minY + height * 0.15))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.1, y: rect.minY + height * 0.3),
                control: CGPoint(x: centerX + width * 0.1, y: rect.minY + height * 0.05)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.2, y: centerY + height * 0.1),
                control: CGPoint(x: rect.maxX + width * 0.05, y: centerY - height * 0.2)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX + width * 0.15, y: rect.maxY - height * 0.1),
                control: CGPoint(x: rect.maxX - width * 0.1, y: centerY + height * 0.3)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.15, y: rect.maxY - height * 0.2),
                control: CGPoint(x: centerX - width * 0.1, y: rect.maxY + height * 0.05)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.05, y: centerY + height * 0.05),
                control: CGPoint(x: rect.minX - width * 0.05, y: centerY + height * 0.2)
            )
            path.addQuadCurve(
                to: CGPoint(x: centerX - width * 0.2, y: rect.minY + height * 0.15),
                control: CGPoint(x: rect.minX + width * 0.1, y: centerY - height * 0.15)
            )
            
        case .syncee:
            // Strong blob - structured, protective angles
            path.move(to: CGPoint(x: centerX, y: rect.minY + height * 0.08))
            path.addLine(to: CGPoint(x: rect.maxX - width * 0.12, y: rect.minY + height * 0.15))
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.08, y: centerY),
                control: CGPoint(x: rect.maxX - width * 0.05, y: centerY - height * 0.15)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX - width * 0.15, y: centerY + height * 0.25),
                control: CGPoint(x: rect.maxX, y: centerY + height * 0.1)
            )
            path.addLine(to: CGPoint(x: centerX + width * 0.08, y: rect.maxY - height * 0.08))
            path.addQuadCurve(
                to: CGPoint(x: centerX - width * 0.08, y: rect.maxY - height * 0.08),
                control: CGPoint(x: centerX, y: rect.maxY)
            )
            path.addLine(to: CGPoint(x: rect.minX + width * 0.15, y: centerY + height * 0.25))
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.08, y: centerY),
                control: CGPoint(x: rect.minX, y: centerY + height * 0.1)
            )
            path.addQuadCurve(
                to: CGPoint(x: rect.minX + width * 0.12, y: rect.minY + height * 0.15),
                control: CGPoint(x: rect.minX + width * 0.05, y: centerY - height * 0.15)
            )
            path.addLine(to: CGPoint(x: centerX, y: rect.minY + height * 0.08))
        }
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    HStack(spacing: 30) {
        EmberCharacterView(
            character: .touchy,
            expression: .happy,
            isAnimating: true
        )
        
        EmberCharacterView(
            character: .syncee,
            expression: .love,
            isAnimating: true
        )
    }
    .padding()
}