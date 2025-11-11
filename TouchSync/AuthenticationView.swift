import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var showingPartnerLink = false
    @State private var inviteCode = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
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
                    
                    // Premium Logo/Header
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [ColorPalette.crimson.opacity(0.3), .clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .scaleEffect(showContent ? 1.0 : 0.5)
                                .opacity(showContent ? 1.0 : 0)
                            
                            CuteCharacter(
                                size: 80,
                                isAnimating: true,
                                customization: CharacterCustomization(
                                    colorTheme: .orange,
                                    expression: .warmSmile,
                                        name: "My Heart"
                                )
                            )
                            .scaleEffect(showContent ? 1.0 : 0.3)
                            .opacity(showContent ? 1.0 : 0)
                        }
                        
                        VStack(spacing: 8) {
                            Text("TouchSync")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .opacity(showContent ? 1.0 : 0)
                                .offset(y: showContent ? 0 : 20)
                            
                            Text("Feel them from anywhere")
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white.opacity(0.8))
                                .opacity(showContent ? 1.0 : 0)
                                .offset(y: showContent ? 0 : 20)
                        }
                    }
                    
                    // Premium Auth Form
                    VStack(spacing: 24) {
                        // Demo mode notice
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.orange)
                            Text("Demo Mode - Use any email/password")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial.opacity(0.3), in: Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                        
                        VStack(spacing: 16) {
                            PremiumTextField(
                                placeholder: "Email",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            
                            PremiumSecureField(
                                placeholder: "Password",
                                text: $password
                            )
                            
                            // Quick demo button
                            Button("Use Demo Credentials") {
                                withAnimation(.spring(response: 0.3)) {
                                    email = "demo@touchsync.app"
                                    password = "demo123"
                                }
                            }
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.white.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial.opacity(0.2), in: Capsule())
                            
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundStyle(.red)
                                    .font(.caption.weight(.medium))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.red.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                            }
                            
                            // Main CTA Button
                            Button(action: authenticate) {
                                HStack(spacing: 12) {
                                    if isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .tint(.white)
                                    }
                                    Text(isSignUp ? "Create Account" : "Sign In")
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
                            .disabled(isLoading || email.isEmpty || password.isEmpty)
                            .opacity((isLoading || email.isEmpty || password.isEmpty) ? 0.6 : 1.0)
                            
                            // Toggle Sign Up/In
                            Button(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up") {
                                withAnimation(.spring(response: 0.3)) {
                                    isSignUp.toggle()
                                    errorMessage = ""
                                }
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Partner Link Button (only show after authentication)
                    if authManager.isAuthenticated && authManager.partnerId == nil {
                        Button("Link with Partner") {
                            showingPartnerLink = true
                        }
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            ColorPalette.secondaryGradient,
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                        .padding(.horizontal, 24)
                        .shadow(color: ColorPalette.peachOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                showContent = true
            }
        }
        .sheet(isPresented: $showingPartnerLink) {
            PremiumPartnerLinkView()
        }
    }
    
    private func authenticate() {
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = true
            errorMessage = ""
        }
        
        Task {
            // Mock authentication - any email/password works
            authManager.authenticateWithMockiCloud()
            print("Mock authentication with email: \(email)")
            
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Premium Components

struct PremiumTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    
    init(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.body.weight(.medium))
            .foregroundStyle(.white)
            .keyboardType(keyboardType)
            .autocapitalization(.none)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct PremiumSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .font(.body.weight(.medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.ultraThinMaterial.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
    }
}

struct PremiumPartnerLinkView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @State private var inviteCode = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    @State private var myInviteCode = ""
    @State private var showContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Premium background
                LinearGradient(
                    colors: [
                        ColorPalette.deepPurple.opacity(0.9),
                        ColorPalette.crimson.opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header with hearts
                        VStack(spacing: 20) {
                            HStack(spacing: 40) {
                                CuteCharacter(
                                    size: 60,
                                    isAnimating: true,
                                    customization: CharacterCustomization(
                                        colorTheme: .orange,
                                        expression: .warmSmile,
                                        name: "My Heart"
                                    )
                                )
                                .scaleEffect(showContent ? 1.0 : 0.5)
                                .opacity(showContent ? 1.0 : 0)
                                
                                Image(systemName: "heart.fill")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.6))
                                    .scaleEffect(showContent ? 1.0 : 0.5)
                                    .opacity(showContent ? 1.0 : 0)
                                
                                CuteCharacter(
                                    size: 60,
                                    isAnimating: true,
                                    customization: CharacterCustomization(
                                        colorTheme: .coral,
                                        expression: .love,
                                        name: "My Heart"
                                    )
                                )
                                .scaleEffect(showContent ? 1.0 : 0.5)
                                .opacity(showContent ? 1.0 : 0)
                            }
                            
                            Text("Connect with Your Partner")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .opacity(showContent ? 1.0 : 0)
                                .offset(y: showContent ? 0 : 20)
                        }
                        
                        // Your invite code section
                        VStack(spacing: 20) {
                            Text("Your Invite Code")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.white)
                            
                            VStack(spacing: 12) {
                                Text(myInviteCode)
                                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial.opacity(0.4), in: RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.white.opacity(0.3), lineWidth: 1)
                                    )
                                
                                Text("Share this code with your partner")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Divider
                        Rectangle()
                            .fill(.white.opacity(0.2))
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                        
                        // Enter partner's code section
                        VStack(spacing: 20) {
                            Text("Enter Partner's Code")
                                .font(.headline.weight(.semibold))
                                .foregroundStyle(.white)
                            
                            VStack(spacing: 16) {
                                TextField("Partner's invite code", text: $inviteCode)
                                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                                    .foregroundStyle(.white)
                                    .textCase(.uppercase)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                                    .background(.ultraThinMaterial.opacity(0.3), in: RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                                
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
                                        Text("Link Partner")
                                            .font(.headline.weight(.semibold))
                                    }
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(
                                        LinearGradient(
                                            colors: [ColorPalette.crimson, ColorPalette.deepPurple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        in: RoundedRectangle(cornerRadius: 16)
                                    )
                                    .shadow(color: ColorPalette.crimson.opacity(0.4), radius: 15, x: 0, y: 8)
                                }
                                .disabled(inviteCode.isEmpty || isLoading)
                                .opacity((inviteCode.isEmpty || isLoading) ? 0.6 : 1.0)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .onAppear {
            myInviteCode = authManager.pairingCode
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
                try await authManager.linkPartner(withCode: inviteCode.uppercased())
                await MainActor.run {
                    dismiss()
                }
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

struct PartnerLinkView: View {
    var body: some View {
        PremiumPartnerLinkView()
    }
}
    


#Preview {
    AuthenticationView()
        .environmentObject(AuthManager())
}