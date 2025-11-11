import SwiftUI

struct OnboardingRomanticPartnerSetupView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @State private var connectionCode = generateConnectionCode()
    @State private var enteredCode = ""
    @State private var selectedMethod: ConnectionMethod = .shareCode
    @State private var isConnecting = false
    @State private var connectionSuccess = false
    @State private var floatingHearts: [FloatingHeart] = []
    @State private var codeGlow: Double = 0.5
    
    var body: some View {
        ZStack {
            // Romantic gradient
            LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen, EmberColors.coralPop],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating hearts
            ForEach(floatingHearts) { heart in
                Image(systemName: "heart.fill")
                    .font(.system(size: heart.size))
                    .foregroundStyle(.white.opacity(heart.opacity))
                    .position(heart.position)
                    .scaleEffect(heart.scale)
            }
            
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Button("Skip") {
                            onSkip()
                        }
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 12) {
                        // Two hearts joining
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 16))
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.white)
                        }
                        
                        Text("Two Hearts, One Connection")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Create your sacred bond and begin sharing love across any distance")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 20)
                
                Spacer()
                
                // Connection methods with romantic styling
                VStack(spacing: 24) {
                    // Method selector
                    HStack(spacing: 12) {
                        ForEach(ConnectionMethod.allCases, id: \.self) { method in
                            RomanticConnectionButton(
                                method: method,
                                isSelected: selectedMethod == method,
                                onTap: { selectedMethod = method }
                            )
                        }
                    }
                    
                    // Content based on selected method
                    connectionContent
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Action button
                VStack(spacing: 16) {
                    Button(action: handleConnection) {
                        HStack {
                            if isConnecting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            
                            Text(buttonTitle)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: connectionSuccess ?
                                    [.green, .green.opacity(0.8)] :
                                    [.white.opacity(0.3), .white.opacity(0.2)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.4), lineWidth: 1)
                        )
                    }
                    .buttonStyle(EmberPressableButtonStyle())
                    .disabled(isConnecting)
                    
                    if connectionSuccess {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.circle.fill")
                                .foregroundStyle(.green)
                            
                            Text("Hearts united! Your love story begins now")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    
                    Button("Set Up Pairing Later") {
                        onNext()
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startHeartAnimation()
            startCodeGlow()
        }
    }
    
    @ViewBuilder
    private var connectionContent: some View {
        switch selectedMethod {
        case .shareCode:
            romanticShareCodeView
        case .scanQR:
            romanticScanQRView
        case .enterCode:
            romanticEnterCodeView
        }
    }
    
    private var romanticShareCodeView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("Your Love Code")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                // Glowing code display
                HStack(spacing: 8) {
                    ForEach(Array(connectionCode.enumerated()), id: \.offset) { index, digit in
                        Text(String(digit))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 45, height: 55)
                            .background(.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white.opacity(codeGlow), lineWidth: 2)
                            )
                    }
                }
                
                Button(action: copyCode) {
                    HStack(spacing: 8) {
                        Image(systemName: "heart.text.square.fill")
                        Text("Share Love Code")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
            
            Text("Send this sacred code to your beloved to unite your hearts forever")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var romanticScanQRView: some View {
        VStack(spacing: 24) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                VStack(spacing: 16) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 60, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                    
                    Text("Heart Scanner")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            
            Text("Scan your partner's love code to instantly connect your souls")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var romanticEnterCodeView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("Enter Your Beloved's Code")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                
                TextField("Love Code", text: $enteredCode)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(.white.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                    )
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
            }
            
            Text("Ask your partner to share their love code with you")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }
    
    private var buttonTitle: String {
        if isConnecting {
            return "Uniting Hearts..."
        } else if connectionSuccess {
            return "Begin Love Story"
        } else {
            switch selectedMethod {
            case .shareCode: return "Share Sacred Code"
            case .scanQR: return "Open Heart Scanner"
            case .enterCode: return "Unite Our Hearts"
            }
        }
    }
    
    private func handleConnection() {
        if connectionSuccess {
            onNext()
            return
        }
        
        isConnecting = true
        EmberHapticsManager.shared.playMedium()
        
        // Simulate connection with romantic feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isConnecting = false
            connectionSuccess = true
            EmberHapticsManager.shared.playSuccess()
            createCelebrationHearts()
        }
    }
    
    private func copyCode() {
        UIPasteboard.general.string = connectionCode
        EmberHapticsManager.shared.playLight()
    }
    

    
    private func startHeartAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { _ in
            createFloatingHeart()
        }
    }
    
    private func startCodeGlow() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            codeGlow = 1.0
        }
    }
    
    private func createFloatingHeart() {
        let heart = FloatingHeart(
            position: CGPoint(x: CGFloat.random(in: 50...350), y: 800),
            size: CGFloat.random(in: 8...16),
            opacity: Double.random(in: 0.3...0.6),
            scale: 1.0
        )
        
        floatingHearts.append(heart)
        
        withAnimation(.easeOut(duration: 5.0)) {
            if let index = floatingHearts.firstIndex(where: { $0.id == heart.id }) {
                floatingHearts[index].position.y = -50
                floatingHearts[index].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            floatingHearts.removeAll { $0.id == heart.id }
        }
    }
    
    private func createCelebrationHearts() {
        for _ in 0..<15 {
            let heart = FloatingHeart(
                position: CGPoint(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 300...500)),
                size: CGFloat.random(in: 12...24),
                opacity: 0.8,
                scale: 1.0
            )
            
            floatingHearts.append(heart)
            
            withAnimation(.easeOut(duration: 2.0)) {
                if let index = floatingHearts.firstIndex(where: { $0.id == heart.id }) {
                    floatingHearts[index].position.y -= CGFloat.random(in: 100...200)
                    floatingHearts[index].opacity = 0
                    floatingHearts[index].scale = 0.3
                }
            }
        }
    }
    
    private static func generateConnectionCode() -> String {
        return String(format: "%06d", Int.random(in: 100000...999999))
    }
}

struct RomanticConnectionButton: View {
    let method: ConnectionMethod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: method.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.6))
                
                Text(method.romanticTitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(isSelected ? .white.opacity(0.25) : .white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .white.opacity(0.6) : .white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RomanticNumberButton: View {
    let number: String
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            Text(number)
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(.white.opacity(0.15))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct FloatingHeart: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var opacity: Double
    var scale: CGFloat
}

extension ConnectionMethod {
    var romanticTitle: String {
        switch self {
        case .shareCode: return "Share Love"
        case .scanQR: return "Scan Hearts"
        case .enterCode: return "Enter Code"
        }
    }
}

#Preview {
    OnboardingRomanticPartnerSetupView(
        onNext: { print("Next") },
        onSkip: { print("Skip") }
    )
}