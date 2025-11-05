import SwiftUI

// MARK: - FAQ View
struct EmberFAQView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var expandedItems: Set<Int> = []
    
    private let faqItems = [
        FAQItem(question: "How do I connect with my partner?", answer: "Go to Profile > Partner Connection and share your connection code with your partner. They can enter this code in their app to connect."),
        FAQItem(question: "Why can't I feel my partner's touch?", answer: "Make sure both devices are connected to the internet and that haptic feedback is enabled in your device settings."),
        FAQItem(question: "How do I customize my character?", answer: "Tap on 'Characters' in your profile or go to the Personal tab to customize your character's appearance and personality."),
        FAQItem(question: "What are Premium features?", answer: "Premium includes voice messages, location sharing, milestone tracking, cloud backup, and advanced touch patterns."),
        FAQItem(question: "How do I backup my memories?", answer: "Premium users get automatic cloud backup. Free users can manually export their data from Privacy & Security settings."),
        FAQItem(question: "Can I use Ember on multiple devices?", answer: "Yes, sign in with the same account on multiple devices. Your data will sync automatically."),
        FAQItem(question: "How do I delete my account?", answer: "Go to Profile > Privacy & Security > Delete Account. This action cannot be undone."),
        FAQItem(question: "Is my data secure?", answer: "Yes, all data is encrypted and we follow strict privacy guidelines. Read our Privacy Policy for details.")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(faqItems.enumerated()), id: \.offset) { index, item in
                        faqItemView(item, index: index)
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("FAQ")
                        .emberHeadline()
                }
            }
        }
    }
    
    private func faqItemView(_ item: FAQItem, index: Int) -> some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if expandedItems.contains(index) {
                        expandedItems.remove(index)
                    } else {
                        expandedItems.insert(index)
                    }
                }
            }) {
                HStack {
                    Text(item.question)
                        .emberLabel()
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: expandedItems.contains(index) ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14))
                        .foregroundStyle(EmberColors.textSecondary)
                }
                .padding(16)
            }
            .buttonStyle(.plain)
            
            if expandedItems.contains(index) {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                        .background(EmberColors.border)
                    
                    Text(item.answer)
                        .emberBody(color: EmberColors.textSecondary)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .background(EmberColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct FAQItem {
    let question: String
    let answer: String
}

// MARK: - Contact View
struct EmberContactView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contactType: ContactType = .feedback
    @State private var subject = ""
    @State private var message = ""
    @State private var email = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Contact Type
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What can we help you with?")
                            .emberHeadline()
                        
                        VStack(spacing: 12) {
                            ForEach(ContactType.allCases, id: \.self) { type in
                                contactTypeButton(type)
                            }
                        }
                    }
                    
                    // Contact Form
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Contact Information")
                            .emberHeadline()
                        
                        VStack(spacing: 16) {
                            inputField("Email", text: $email, placeholder: "your@email.com")
                            inputField("Subject", text: $subject, placeholder: "Brief description")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Message")
                                    .emberLabel()
                                
                                TextEditor(text: $message)
                                    .frame(minHeight: 120)
                                    .padding(12)
                                    .background(EmberColors.surface)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(EmberColors.border, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    
                    // Send Button
                    Button(action: sendMessage) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send Message")
                        }
                        .emberLabel(color: .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(EmberColors.roseQuartz)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(email.isEmpty || subject.isEmpty || message.isEmpty)
                    .opacity(email.isEmpty || subject.isEmpty || message.isEmpty ? 0.5 : 1.0)
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Contact Support")
                        .emberHeadline()
                }
            }
        }
    }
    
    private func contactTypeButton(_ type: ContactType) -> some View {
        Button(action: { contactType = type }) {
            HStack(spacing: 12) {
                Image(systemName: type.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(type.color)
                    .frame(width: 44, height: 44)
                    .background(type.color.opacity(0.1))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.title)
                        .emberLabel()
                    Text(type.description)
                        .emberCaption(color: EmberColors.textSecondary)
                }
                
                Spacer()
                
                Circle()
                    .fill(contactType == type ? EmberColors.roseQuartz : EmberColors.border)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(contactType == type ? 1 : 0)
                    )
            }
            .padding(16)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(contactType == type ? EmberColors.roseQuartz : EmberColors.border, lineWidth: contactType == type ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func inputField(_ title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .emberLabel()
            
            TextField(placeholder, text: text)
                .textFieldStyle(.plain)
                .padding(12)
                .background(EmberColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(EmberColors.border, lineWidth: 1)
                )
        }
    }
    
    private func sendMessage() {
        EmberHapticsManager.shared.playMedium()
        // Send message logic
        dismiss()
    }
}

enum ContactType: CaseIterable {
    case feedback, bug, feature, other
    
    var title: String {
        switch self {
        case .feedback: return "General Feedback"
        case .bug: return "Report a Bug"
        case .feature: return "Feature Request"
        case .other: return "Other"
        }
    }
    
    var description: String {
        switch self {
        case .feedback: return "Share your thoughts about the app"
        case .bug: return "Something isn't working correctly"
        case .feature: return "Suggest a new feature"
        case .other: return "Something else"
        }
    }
    
    var icon: String {
        switch self {
        case .feedback: return "heart.fill"
        case .bug: return "ladybug.fill"
        case .feature: return "lightbulb.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .feedback: return EmberColors.roseQuartz
        case .bug: return EmberColors.error
        case .feature: return .yellow
        case .other: return EmberColors.peachyKeen
        }
    }
}

// MARK: - Tutorial View
struct EmberTutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    private let tutorialSteps = [
        TutorialStep(
            title: "Welcome to Ember",
            description: "Connect with your partner through touch, messages, and shared memories.",
            icon: "heart.fill",
            color: EmberColors.roseQuartz
        ),
        TutorialStep(
            title: "Connect with Your Partner",
            description: "Share your connection code to link your devices and start your journey together.",
            icon: "link",
            color: EmberColors.peachyKeen
        ),
        TutorialStep(
            title: "Send Touch Messages",
            description: "Tap the Touch tab to send real-time touches and feel your partner's presence.",
            icon: "hand.tap.fill",
            color: EmberColors.coralPop
        ),
        TutorialStep(
            title: "Create Memories",
            description: "Capture special moments with photos, notes, and voice messages in the Memories tab.",
            icon: "camera.fill",
            color: EmberColors.lavenderMist
        ),
        TutorialStep(
            title: "Customize Your Experience",
            description: "Personalize your character and app settings in the Personal tab.",
            icon: "person.circle.fill",
            color: EmberColors.roseQuartz
        )
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                // Progress Indicator
                HStack(spacing: 8) {
                    ForEach(0..<tutorialSteps.count, id: \.self) { index in
                        Circle()
                            .fill(index <= currentStep ? EmberColors.roseQuartz : EmberColors.border)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Spacer()
                
                // Tutorial Content
                VStack(spacing: 32) {
                    ZStack {
                        Circle()
                            .fill(tutorialSteps[currentStep].color.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: tutorialSteps[currentStep].icon)
                            .font(.system(size: 50))
                            .foregroundStyle(tutorialSteps[currentStep].color)
                    }
                    
                    VStack(spacing: 16) {
                        Text(tutorialSteps[currentStep].title)
                            .emberHeadline()
                            .multilineTextAlignment(.center)
                        
                        Text(tutorialSteps[currentStep].description)
                            .emberBody(color: EmberColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                // Navigation Buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button("Previous") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }
                        .emberLabel(color: EmberColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(currentStep == tutorialSteps.count - 1 ? "Get Started" : "Next") {
                        if currentStep == tutorialSteps.count - 1 {
                            dismiss()
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        }
                    }
                    .emberLabel(color: EmberColors.roseQuartz)
                }
            }
            .padding(32)
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") { dismiss() }
                        .emberCaption(color: EmberColors.textSecondary)
                }
            }
        }
    }
}

struct TutorialStep {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

#Preview {
    EmberFAQView()
}