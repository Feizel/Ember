import SwiftUI
import PhotosUI

// MARK: - Memory Capture View
struct EmberMemoryCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCaptureType: CaptureType = .photo
    @State private var memoryTitle = ""
    @State private var memoryNote = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isRecording = false
    @State private var recordingDuration = 0.0
    @State private var showingLocationPicker = false
    @State private var selectedLocation = "Current Location"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Capture Type Selector
                    captureTypeSelector
                    
                    // Main Capture Area
                    mainCaptureArea
                    
                    // Memory Details
                    memoryDetailsSection
                    
                    // Save Button
                    saveButton
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
                    Text("New Memory")
                        .emberHeadline()
                }
            }
        }
    }
    
    private var captureTypeSelector: some View {
        HStack(spacing: 12) {
            ForEach(CaptureType.allCases, id: \.self) { type in
                Button(action: { selectedCaptureType = type }) {
                    VStack(spacing: 8) {
                        Image(systemName: type.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(selectedCaptureType == type ? .white : type.color)
                        
                        Text(type.title)
                            .emberCaption(color: selectedCaptureType == type ? .white : EmberColors.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(selectedCaptureType == type ? type.color : EmberColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var mainCaptureArea: some View {
        VStack(spacing: 16) {
            switch selectedCaptureType {
            case .photo:
                photoCapture
            case .note:
                noteCapture
            case .voice:
                voiceCapture
            case .location:
                locationCapture
            }
        }
    }
    
    private var photoCapture: some View {
        VStack(spacing: 16) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(EmberColors.roseQuartz.opacity(0.1))
                    .frame(height: 200)
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(EmberColors.roseQuartz)
                            
                            Text("Tap to select photo")
                                .emberBody(color: EmberColors.textSecondary)
                        }
                    )
            }
            
            if selectedPhoto != nil {
                Text("Photo selected ✓")
                    .emberCaption(color: EmberColors.success)
            }
        }
    }
    
    private var noteCapture: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Write your memory")
                .emberLabel()
            
            TextEditor(text: $memoryNote)
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
    
    private var voiceCapture: some View {
        VStack(spacing: 20) {
            Circle()
                .fill(isRecording ? EmberColors.error : EmberColors.coralPop.opacity(0.1))
                .frame(width: 120, height: 120)
                .overlay(
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(isRecording ? .white : EmberColors.coralPop)
                )
                .onTapGesture {
                    toggleRecording()
                }
            
            if isRecording {
                Text(String(format: "%.1fs", recordingDuration))
                    .emberHeadline(color: EmberColors.error)
            } else {
                Text("Tap to record")
                    .emberBody(color: EmberColors.textSecondary)
            }
        }
    }
    
    private var locationCapture: some View {
        VStack(spacing: 16) {
            Button(action: { showingLocationPicker = true }) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(EmberColors.lavenderMist.opacity(0.1))
                    .frame(height: 120)
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(EmberColors.lavenderMist)
                            
                            Text(selectedLocation)
                                .emberBody(color: EmberColors.textSecondary)
                        }
                    )
            }
            .buttonStyle(.plain)
        }
    }
    
    private var memoryDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Memory Details")
                .emberHeadline()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Title")
                    .emberLabel()
                
                TextField("Give this memory a title", text: $memoryTitle)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(EmberColors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(EmberColors.border, lineWidth: 1)
                    )
            }
            
            if selectedCaptureType != .note {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Note (Optional)")
                        .emberLabel()
                    
                    TextField("Add a note to this memory", text: $memoryNote, axis: .vertical)
                        .textFieldStyle(.plain)
                        .lineLimit(3...6)
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
    }
    
    private var saveButton: some View {
        Button(action: saveMemory) {
            HStack {
                Image(systemName: "heart.fill")
                Text("Save Memory")
            }
            .emberLabel(color: .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(EmberColors.roseQuartz)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(memoryTitle.isEmpty)
        .opacity(memoryTitle.isEmpty ? 0.5 : 1.0)
    }
    
    private func toggleRecording() {
        EmberHapticsManager.shared.playMedium()
        isRecording.toggle()
        
        if isRecording {
            // Start recording simulation
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if isRecording {
                    recordingDuration += 0.1
                } else {
                    timer.invalidate()
                }
            }
        }
    }
    
    private func saveMemory() {
        EmberHapticsManager.shared.playMedium()
        // Save memory logic here
        print("Saving memory: \(memoryTitle)")
        dismiss()
    }
}

enum CaptureType: CaseIterable {
    case photo, note, voice, location
    
    var title: String {
        switch self {
        case .photo: return "Photo"
        case .note: return "Note"
        case .voice: return "Voice"
        case .location: return "Place"
        }
    }
    
    var icon: String {
        switch self {
        case .photo: return "camera.fill"
        case .note: return "text.quote"
        case .voice: return "mic.fill"
        case .location: return "location.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .photo: return EmberColors.roseQuartz
        case .note: return EmberColors.peachyKeen
        case .voice: return EmberColors.coralPop
        case .location: return EmberColors.lavenderMist
        }
    }
}

#Preview {
    EmberMemoryCaptureView()
}