import SwiftUI

struct SimplePairingView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var partnerCode = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // App icon inspired gradient background
            LinearGradient(
                colors: [
                    ColorPalette.sunnyYellow.opacity(0.9),
                    ColorPalette.vibrantOrange.opacity(0.8),
                    ColorPalette.deepOrange.opacity(0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    Spacer(minLength: 60)
                    
                    // Header with hearts
                    VStack(spacing: 20) {
                        HStack(spacing: 40) {
                            CuteCharacter(
                                character: .touchy,
                                size: 80,
                                customization: CharacterCustomization(
                                    colorTheme: .orange,
                                    accessory: .none,
                                    expression: .happy,
                                        name: "My Heart"
                                ),
                                isAnimating: true
                            )
                            .scaleEffect(showContent ? 1.0 : 0.5)
                            .opacity(showContent ? 1.0 : 0)
                            
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundStyle(.white.opacity(0.6))
                                .scaleEffect(showContent ? 1.0 : 0.5)
                                .opacity(showContent ? 1.0 : 0)
                            
                            CuteCharacter(
                                character: .syncee,
                                size: 80,
                                customization: CharacterCustomization(
                                    colorTheme: .sunset,
                                    accessory: .none,
                                    expression: .happy,
                                        name: "My Heart"
                                ),
                                isAnimating: true
                            )
                            .scaleEffect(showContent ? 1.0 : 0.5)
                            .opacity(showContent ? 1.0 : 0)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Connect with Your Partner")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1.0 : 0)
                                .offset(y: showContent ? 0 : 20)
                            
                            Text("No signup required - just share codes")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white.opacity(0.8))
                                .opacity(showContent ? 1.0 : 0)
                                .offset(y: showContent ? 0 : 20)
                        }
                    }
                    
                    // Your pairing code
                        VStack(spacing: 24) {
                            VStack(spacing: 16) {
                                Text("Your Pairing Code")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)
                                
                                Text(authManager.pairingCode)
                                    .font(.system(size: 36, weight: .bold, design: .monospaced))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 20)
                                    .background(.ultraThinMaterial.opacity(0.4), in: RoundedRectangle(cornerRadius: 20))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.white.opacity(0.3), lineWidth: 2)
                                    )
                                
                                VStack(spacing: 8) {
                                    Text("Share this code with your partner")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundStyle(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                    
                                    HStack(spacing: 4) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .font(.caption2)
                                        Text("Local Testing Mode")
                                    }
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(.yellow)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(.yellow.opacity(0.2), in: Capsule())
                                }
                            }
                            
                            // Divider
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                                .padding(.horizontal, 40)
                            
                            // Enter partner's code
                            VStack(spacing: 20) {
                                VStack(spacing: 8) {
                                    Text("Enter Partner's Code")
                                        .font(.headline.weight(.semibold))
                                        .foregroundStyle(.white)
                                    
                                    Text("Any 6-digit code works for testing")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                                
                                VStack(spacing: 16) {
                                    TextField("000000", text: $partnerCode)
                                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .keyboardType(.numberPad)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 16)
                                        .background(.ultraThinMaterial.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .onChange(of: partnerCode) { _, newValue in
                                            // Limit to 6 digits
                                            if newValue.count > 6 {
                                                partnerCode = String(newValue.prefix(6))
                                            }
                                        }
                                    
                                    if !errorMessage.isEmpty {
                                        Text(errorMessage)
                                            .foregroundStyle(.red)
                                            .font(.caption.weight(.medium))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                                    }
                                    
                                    Button(action: linkPartner) {
                                        HStack(spacing: 12) {
                                            if isLoading {
                                                ProgressView()
                                                    .scaleEffect(0.8)
                                                    .tint(.white)
                                            }
                                            Text("Connect")
                                                .font(.headline.weight(.semibold))
                                        }
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 18)
                                        .background(
                                            ColorPalette.iconGradient,
                                            in: RoundedRectangle(cornerRadius: 16)
                                        )
                                        .shadow(color: ColorPalette.vibrantOrange.opacity(0.4), radius: 15, x: 0, y: 8)
                                    }
                                    .disabled(partnerCode.count != 6 || isLoading)
                                    .opacity((partnerCode.count != 6 || isLoading) ? 0.6 : 1.0)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                showContent = true
            }
        }
    }
    

    
    private func linkPartner() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = true
            errorMessage = ""
        }
        
        Task {
            do {
                try await authManager.linkPartner(withCode: partnerCode)
                // Success - the app will automatically navigate to HomeView
            } catch {
                await MainActor.run {
                    withAnimation(.spring(response: 0.3)) {
                        errorMessage = error.localizedDescription
                    }
                }
            }
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    SimplePairingView()
        .environmentObject(AuthManager())
}