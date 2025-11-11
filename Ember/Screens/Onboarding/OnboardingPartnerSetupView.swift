import SwiftUI

struct OnboardingPartnerSetupView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    
    @State private var connectionCode = generateConnectionCode()
    @State private var enteredCode = ""
    @State private var selectedMethod: ConnectionMethod = .shareCode
    @State private var isConnecting = false
    @State private var connectionSuccess = false
    
    var body: some View {
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
                
                VStack(spacing: 8) {
                    Text("Unite Your Hearts")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Create your intimate connection with your beloved")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            Spacer()
            
            // Connection methods
            VStack(spacing: 20) {
                // Method selector
                HStack(spacing: 12) {
                    ForEach(ConnectionMethod.allCases, id: \.self) { method in
                        ConnectionMethodButton(
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
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: connectionSuccess ?
                                [.green, .green.opacity(0.8)] :
                                [EmberColors.roseQuartz, EmberColors.coralPop],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                }
                .buttonStyle(EmberPressableButtonStyle())
                .disabled(isConnecting || (selectedMethod == .enterCode && enteredCode.count != 6))
                
                if connectionSuccess {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                        
                        Text("Hearts connected! Love is in the air")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    private var connectionContent: some View {
        switch selectedMethod {
        case .shareCode:
            shareCodeView
        case .scanQR:
            scanQRView
        case .enterCode:
            enterCodeView
        }
    }
    
    private var shareCodeView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("Your Connection Code")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    ForEach(Array(connectionCode.enumerated()), id: \.offset) { index, digit in
                        Text(String(digit))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 50)
                            .background(.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Button(action: copyCode) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.on.doc.fill")
                        Text("Copy Code")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                }
            }
            
            Text("Share this special code with your love to begin your journey together")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var scanQRView: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                VStack(spacing: 12) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                    
                    Text("QR Scanner")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            
            Text("Scan your partner's code to instantly connect your hearts")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
    
    private var enterCodeView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("Enter Your Love's Code")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                HStack(spacing: 8) {
                    ForEach(0..<6, id: \.self) { index in
                        Text(index < enteredCode.count ? String(enteredCode[enteredCode.index(enteredCode.startIndex, offsetBy: index)]) : "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 50)
                            .background(.white.opacity(index < enteredCode.count ? 0.3 : 0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
            }
            
            // Number pad
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(1...9, id: \.self) { number in
                    NumberPadButton(number: "\(number)") {
                        addDigit("\(number)")
                    }
                }
                
                Button(action: {}) {
                    // Empty space
                }
                .disabled(true)
                
                NumberPadButton(number: "0") {
                    addDigit("0")
                }
                
                Button(action: removeDigit) {
                    Image(systemName: "delete.left.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(width: 60, height: 60)
                .background(.white.opacity(0.1))
                .clipShape(Circle())
            }
        }
    }
    
    private var buttonTitle: String {
        if isConnecting {
            return "Connecting..."
        } else if connectionSuccess {
            return "Continue"
        } else {
            switch selectedMethod {
            case .shareCode: return "Share Love Code"
            case .scanQR: return "Scan Heart Code"
            case .enterCode: return "Unite Hearts"
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
        
        // Simulate connection
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isConnecting = false
            connectionSuccess = true
            EmberHapticsManager.shared.playSuccess()
        }
    }
    
    private func copyCode() {
        UIPasteboard.general.string = connectionCode
        EmberHapticsManager.shared.playLight()
    }
    
    private func addDigit(_ digit: String) {
        if enteredCode.count < 6 {
            enteredCode += digit
            EmberHapticsManager.shared.playLight()
        }
    }
    
    private func removeDigit() {
        if !enteredCode.isEmpty {
            enteredCode.removeLast()
            EmberHapticsManager.shared.playLight()
        }
    }
    
    private static func generateConnectionCode() -> String {
        return String(format: "%06d", Int.random(in: 100000...999999))
    }
}

enum ConnectionMethod: CaseIterable {
    case shareCode, scanQR, enterCode
    
    var title: String {
        switch self {
        case .shareCode: return "Share"
        case .scanQR: return "Scan"
        case .enterCode: return "Enter"
        }
    }
    
    var icon: String {
        switch self {
        case .shareCode: return "square.and.arrow.up.fill"
        case .scanQR: return "qrcode.viewfinder"
        case .enterCode: return "keyboard.fill"
        }
    }
}

struct ConnectionMethodButton: View {
    let method: ConnectionMethod
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: method.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isSelected ? EmberColors.roseQuartz : .white.opacity(0.6))
                
                Text(method.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(isSelected ? .white : .white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? .white.opacity(0.2) : .white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? EmberColors.roseQuartz : .white.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NumberPadButton: View {
    let number: String
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            Text(number)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(.white.opacity(0.1))
                .clipShape(Circle())
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

#Preview {
    OnboardingPartnerSetupView(
        onNext: { print("Next") },
        onSkip: { print("Skip") }
    )
}