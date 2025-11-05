import SwiftUI

// MARK: - Love Note Composer
struct EmberLoveNoteComposerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var noteText = ""
    @State private var selectedTemplate: LoveNoteTemplate?
    
    private let templates = LoveNoteTemplate.allTemplates
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Text Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Message")
                        .emberLabel()
                    
                    TextEditor(text: $noteText)
                        .emberBody()
                        .frame(minHeight: 120)
                        .padding(12)
                        .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(EmberColors.border, lineWidth: 1)
                        )
                }
                
                // Templates
                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Templates")
                        .emberLabel()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(templates) { template in
                                Button(action: { useTemplate(template) }) {
                                    VStack(spacing: 8) {
                                        Text(template.emoji)
                                            .font(.title2)
                                        
                                        Text(template.title)
                                            .emberCaption()
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 80, height: 80)
                                    .background(EmberColors.surface, in: RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(EmberColors.border, lineWidth: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Write Love Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") {
                        sendLoveNote()
                        dismiss()
                    }
                    .emberBody(color: EmberColors.roseQuartz)
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func useTemplate(_ template: LoveNoteTemplate) {
        noteText = template.message
        selectedTemplate = template
    }
    
    private func sendLoveNote() {
        // Send love note logic
        print("Sending love note: \(noteText)")
    }
}

// MARK: - Love Note Template
struct LoveNoteTemplate: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let message: String
    
    static let allTemplates = [
        LoveNoteTemplate(title: "Missing You", emoji: "💕", message: "Missing you so much today! Can't wait to see you."),
        LoveNoteTemplate(title: "Good Morning", emoji: "☀️", message: "Good morning, beautiful! Hope you have an amazing day."),
        LoveNoteTemplate(title: "Thinking of You", emoji: "💭", message: "Just wanted you to know I'm thinking of you right now."),
        LoveNoteTemplate(title: "Love You", emoji: "❤️", message: "I love you more than words can express."),
        LoveNoteTemplate(title: "Sweet Dreams", emoji: "🌙", message: "Sweet dreams, my love. Can't wait to hold you again."),
        LoveNoteTemplate(title: "Grateful", emoji: "🙏", message: "So grateful to have you in my life. You make everything better.")
    ]
}

#Preview {
    EmberLoveNoteComposerView()
}