import SwiftUI

// MARK: - Onboarding Preview for Testing
struct OnboardingPreview: View {
    @State private var currentStep = 0
    
    var body: some View {
        VStack {
            Text("Onboarding Preview")
                .font(.title)
                .padding()
            
            Text("Current Step: \(currentStep + 1) of 3")
                .font(.caption)
                .padding(.bottom)
            
            TabView(selection: $currentStep) {
                // Step 1: Touch Demo
                VStack {
                    Text("Touch Patterns Experience")
                        .font(.headline)
                    Text("Experience Ember's haptic touch patterns")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Next") {
                        withAnimation {
                            currentStep = 1
                        }
                    }
                    .padding()
                }
                .tag(0)
                
                // Step 2: Partner Setup (Code Sharing)
                VStack {
                    Text("Connect with Partner")
                        .font(.headline)
                    Text("Share, scan, or enter pairing code")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Next") {
                        withAnimation {
                            currentStep = 2
                        }
                    }
                    .padding()
                }
                .tag(1)
                
                // Step 3: Permissions
                VStack {
                    Text("Enable Permissions")
                        .font(.headline)
                    Text("Allow notifications, haptics, and microphone")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Complete") {
                        print("Onboarding completed!")
                    }
                    .padding()
                }
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}

#Preview {
    OnboardingPreview()
}