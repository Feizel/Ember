import SwiftUI

// MARK: - Ember Blob Character (adorable edition)

struct EmberBlobCharacter: View {
    enum Mood: CaseIterable {
        case happy, excited, love, sleepy, sad, shy, wink, neutral
    }

    // Inputs
    let size: CGFloat
    let mood: Mood
    let tintStart: Color   // e.g. EmberColors.roseQuartz
    let tintEnd: Color     // e.g. EmberColors.peachyKeen
    let animate: Bool

    // Animation state
    @State private var blink = false
    @State private var bounce: CGFloat = 0
    @State private var breathe: CGFloat = 1
    @State private var heartPulse = false
    @State private var winkLeft = false

    // Design tokens (tweak for brand feel)
    private var eyeRadius: CGFloat { size * 0.19 }            // big googly eyes
    private var eyeSpacing: CGFloat { size * 0.08 }           // small gap = cuter
    private var mouthWidth: CGFloat { size * 0.44 }
    private var cheekRadius: CGFloat { size * 0.11 }
    private var glossRadius: CGFloat { size * 0.55 }

    var body: some View {
        ZStack {
            // Soft drop shadow to ground the blob
            Circle()
                .fill(Color.black.opacity(0.10))
                .frame(width: size * 0.86, height: size * 0.24)
                .offset(y: size * 0.48)
                .blur(radius: size * 0.06)

            // Body with dual gradient + subtle subsurface scatter
            Circle()
                .fill(LinearGradient(colors: [tintStart, tintEnd],
                                      startPoint: .topLeading,
                                      endPoint: .bottomTrailing))
                .scaleEffect(x: 1.02, y: 0.92)                 // slight squish silhouette
                .overlay(
                    Circle()
                        .fill(
                            RadialGradient(colors: [.white.opacity(0.45), .clear],
                                           center: .topLeading,
                                           startRadius: 0,
                                           endRadius: glossRadius)
                        )
                        .blendMode(.screen)
                        .opacity(0.8)
                )
                .overlay(
                    Circle()
                        .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
                        .blur(radius: 0.3)
                )
                .frame(width: size, height: size)
                .scaleEffect(breathe + bounceSquish)
                .offset(y: bounce)

            // Face
            face
                .offset(y: bounce)

            // Love sparkles
            if mood == .love || mood == .excited {
                sparkles
                    .offset(y: -size * 0.12 + bounce)
            }
        }
        .frame(width: size, height: size * 1.18)               // reserve shadow space
        .onAppear { if animate { startAnimations() } }
        .accessibilityLabel(Text(accessibleDescription))
    }

    // MARK: - Face

    private var face: some View {
        VStack(spacing: size * 0.06) {
            eyes
                .offset(y: -size * 0.10)
            mouth
                .offset(y: -size * 0.02)
            cheeks
                .offset(y: -size * 0.02)
        }
    }

    private var eyes: some View {
        HStack(spacing: eyeSpacing) {
            singleEye(left: true)
            singleEye(left: false)
        }
    }

    private func singleEye(left: Bool) -> some View {
        ZStack {
            // Recessed socket for premium depth
            Circle()
                .fill(RadialGradient(colors: [
                    Color.black.opacity(0.18), Color.black.opacity(0.04)
                ], center: .center, startRadius: 0, endRadius: eyeRadius * 1.2))
                .frame(width: eyeRadius * 2.2, height: blinkForEye(left) ? size * 0.02 : eyeRadius * 2.2)

            if !blinkForEye(left) {
                // Eyeball
                Circle()
                    .fill(RadialGradient(colors: [.white, Color.gray.opacity(0.18)],
                                         center: UnitPoint(x: 0.35, y: 0.35),
                                         startRadius: 0,
                                         endRadius: eyeRadius * 0.95))
                    .frame(width: eyeRadius * 1.85, height: eyeRadius * 1.85)

                // Pupil (slightly off-center for cuteness)
                Circle()
                    .fill(RadialGradient(colors: [.black.opacity(0.95), .black],
                                         center: .center,
                                         startRadius: 0,
                                         endRadius: eyeRadius * 0.55))
                    .frame(width: eyeRadius * 1.05, height: eyeRadius * 1.05)
                    .offset(x: left ? -eyeRadius * 0.15 : eyeRadius * 0.15,
                            y: -eyeRadius * 0.05)

                // Specular highlights (big + small)
                Circle()
                    .fill(.white)
                    .frame(width: eyeRadius * 0.55, height: eyeRadius * 0.55)
                    .offset(x: -eyeRadius * 0.22, y: -eyeRadius * 0.22)

                Circle()
                    .fill(.white.opacity(0.8))
                    .frame(width: eyeRadius * 0.22, height: eyeRadius * 0.22)
                    .offset(x: eyeRadius * 0.20, y: eyeRadius * 0.17)
            }
        }
        .frame(width: eyeRadius * 2.2, height: eyeRadius * 2.2)
        .rotationEffect(.degrees(mood == .shy ? (left ? -6 : 6) : 0))
        .opacity(mood == .sleepy ? 0.9 : 1)
    }

    private func blinkForEye(_ left: Bool) -> Bool {
        switch mood {
        case .wink: return left ? true : blink
        case .sleepy: return true
        default: return blink
        }
    }

    private var mouth: some View {
        Group {
            switch mood {
            case .happy, .neutral, .shy:
                Smile(width: mouthWidth, thickness: size * 0.06)
                    .foregroundColor(.black.opacity(0.9))
                    .overlay(
                        Smile(width: mouthWidth * 0.78, thickness: size * 0.04)
                            .foregroundColor(tintStart.opacity(0.45))
                            .offset(y: size * 0.01)
                    )

            case .excited:
                ZStack {
                    Capsule()
                        .fill(.black)
                        .frame(width: mouthWidth * 0.65, height: size * 0.18)
                    Capsule()
                        .fill(tintStart.opacity(0.5))
                        .frame(width: mouthWidth * 0.44, height: size * 0.12)
                        .offset(y: size * 0.01)
                    Circle()
                        .fill(.white.opacity(0.85))
                        .frame(width: size * 0.06)
                        .offset(x: size * 0.1, y: -size * 0.02)
                }

            case .love:
                Smile(width: mouthWidth * 0.9, thickness: size * 0.07)
                    .foregroundColor(.black)
                    .scaleEffect(heartPulse ? 1.06 : 1.0)

            case .sad:
                Smile(width: mouthWidth * 0.8, thickness: size * 0.06, inverted: true)
                    .foregroundColor(.black.opacity(0.9))

            case .sleepy:
                Capsule()
                    .fill(.black)
                    .frame(width: size * 0.10, height: size * 0.04)

            case .wink:
                Smile(width: mouthWidth * 0.95, thickness: size * 0.06)
                    .foregroundColor(.black.opacity(0.9))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: mood)
    }

    private var cheeks: some View {
        HStack(spacing: size * 0.28) {
            ForEach(0..<2, id: \.self) { _ in
                Circle()
                    .fill(RadialGradient(colors: [tintStart.opacity(0.55), .clear],
                                         center: .center,
                                         startRadius: 0,
                                         endRadius: cheekRadius))
                    .frame(width: cheekRadius, height: cheekRadius)
            }
        }
        .opacity(mood == .sad ? 0.35 : 1.0)
    }

    private var sparkles: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                let angle = Angle.degrees(Double(i) / 6.0 * 360.0)
                let r = size * 0.42
                Group {
                    if mood == .love {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(tintStart)
                    } else {
                        Image(systemName: "sparkle")
                            .foregroundStyle(tintEnd)
                    }
                }
                .font(.system(size: size * 0.06))
                .opacity(0.9)
                .offset(x: CGFloat(cos(angle.radians)) * r,
                        y: CGFloat(sin(angle.radians)) * r)
                .scaleEffect(heartPulse ? 1.08 : 1.0)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: heartPulse)
    }

    // MARK: - Helpers

    private var accessibleDescription: String {
        switch mood {
        case .happy: return "Happy, smiling blob character"
        case .excited: return "Excited blob character"
        case .love: return "Loving blob character with hearts"
        case .sleepy: return "Sleepy blob character"
        case .sad: return "Sad blob character"
        case .shy: return "Shy blob character"
        case .wink: return "Winking blob character"
        case .neutral: return "Neutral blob character"
        }
    }

    private var bounceSquish: CGFloat { animate ? 0.02 : 0 }

    private func startAnimations() {
        // Bounce
        withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
            bounce = -size * 0.035
        }
        // Breathe (life‑like)
        withAnimation(.easeInOut(duration: 3.6).repeatForever(autoreverses: true)) {
            breathe = 1.06
        }
        // Blink (random cadence)
        Task.detached {
            while true {
                try? await Task.sleep(nanoseconds: UInt64(Double.random(in: 1.9...3.8) * 1_000_000_000))
                await MainActor.run {
                    withAnimation(.easeInOut(duration: 0.10)) { blink = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                        withAnimation(.easeInOut(duration: 0.10)) { blink = false }
                    }
                }
            }
        }
        // Heart pulse for love/excited
        if mood == .love || mood == .excited {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                heartPulse = true
            }
        }
    }
}

// MARK: - Smile Shape

struct Smile: Shape {
    var width: CGFloat
    var thickness: CGFloat
    var inverted: Bool = false

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let mid = CGPoint(x: rect.midX, y: rect.midY)
        let w = width
        let t = thickness
        let arcRect = CGRect(x: mid.x - w/2, y: mid.y - (inverted ? -t : t),
                             width: w, height: w * 0.55)

        p.addArc(center: CGPoint(x: arcRect.midX, y: arcRect.midY),
                 radius: min(arcRect.width, arcRect.height)/2,
                 startAngle: .degrees(inverted ? 210 : 330),
                 endAngle: .degrees(inverted ? -30 : 150),
                 clockwise: inverted)
        return p.strokedPath(.init(lineWidth: t, lineCap: .round, lineJoin: .round))
    }
}
