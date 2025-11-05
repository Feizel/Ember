import SwiftUI

// MARK: - Memory Timeline View
struct EmberMemoryTimelineView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMemory: Memory?
    @State private var showingMemoryDetail = false
    
    private let timelineItems = TimelineItem.groupMemoriesByDate(Memory.sampleMemories)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(timelineItems) { item in
                        timelineSection(item)
                    }
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Timeline")
                        .emberHeadline()
                }
            }
        }
        .sheet(isPresented: $showingMemoryDetail) {
            if let memory = selectedMemory {
                EmberMemoryDetailView(memory: memory)
            }
        }
    }
    
    private func timelineSection(_ item: TimelineItem) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Date Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.dayOfWeek)
                        .emberCaption(color: EmberColors.textSecondary)
                    Text(item.date.formatted(date: .abbreviated, time: .omitted))
                        .emberLabel()
                }
                
                Spacer()
                
                Text("\(item.memories.count) memories")
                    .emberCaption(color: EmberColors.textTertiary)
            }
            .padding(.horizontal, 4)
            
            // Timeline Line and Memories
            HStack(alignment: .top, spacing: 16) {
                // Timeline Line
                VStack(spacing: 0) {
                    Circle()
                        .fill(EmberColors.roseQuartz)
                        .frame(width: 12, height: 12)
                    
                    Rectangle()
                        .fill(EmberColors.border)
                        .frame(width: 2)
                        .frame(minHeight: CGFloat(item.memories.count * 100))
                }
                
                // Memories
                VStack(spacing: 12) {
                    ForEach(item.memories) { memory in
                        timelineMemoryCard(memory)
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    private func timelineMemoryCard(_ memory: Memory) -> some View {
        Button(action: {
            selectedMemory = memory
            showingMemoryDetail = true
        }) {
            HStack(spacing: 12) {
                // Memory Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(memory.type.color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: memory.type.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(memory.type.color)
                }
                
                // Memory Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(memory.title)
                            .emberLabel()
                        
                        Spacer()
                        
                        if memory.isFavorite {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(EmberColors.roseQuartz)
                        }
                        
                        Text(memory.date.formatted(date: .omitted, time: .shortened))
                            .emberCaption(color: EmberColors.textTertiary)
                    }
                    
                    Text(memory.content)
                        .emberBody(color: EmberColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        if let location = memory.location {
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 10))
                                Text(location)
                            }
                            .emberCaption(color: EmberColors.textTertiary)
                        }
                        
                        Spacer()
                        
                        Text(memory.isFromPartner ? "From Alex" : "From You")
                            .emberCaption(color: memory.isFromPartner ? EmberColors.peachyKeen : EmberColors.roseQuartz)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Memory Detail View
struct EmberMemoryDetailView: View {
    let memory: Memory
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorite: Bool
    
    init(memory: Memory) {
        self.memory = memory
        self._isFavorite = State(initialValue: memory.isFavorite)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 16) {
                        // Memory Type Icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(memory.type.color.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: memory.type.icon)
                                .font(.system(size: 32))
                                .foregroundStyle(memory.type.color)
                        }
                        
                        // Title and Date
                        VStack(alignment: .leading, spacing: 8) {
                            Text(memory.title)
                                .emberHeadline()
                            
                            HStack {
                                Text(memory.date.formatted(date: .complete, time: .shortened))
                                    .emberBody(color: EmberColors.textSecondary)
                                
                                Spacer()
                                
                                Text(memory.isFromPartner ? "From Alex" : "From You")
                                    .emberCaption(color: memory.isFromPartner ? EmberColors.peachyKeen : EmberColors.roseQuartz)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Content
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Memory")
                            .emberLabel()
                        
                        Text(memory.content)
                            .emberBody()
                            .lineSpacing(4)
                    }
                    
                    // Location
                    if let location = memory.location {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Location")
                                .emberLabel()
                            
                            HStack(spacing: 12) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 16))
                                    .foregroundStyle(EmberColors.lavenderMist)
                                
                                Text(location)
                                    .emberBody()
                                
                                Spacer()
                            }
                            .padding(12)
                            .background(EmberColors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    
                    // Tags
                    if !memory.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .emberLabel()
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(memory.tags, id: \.self) { tag in
                                        Text("#\(tag)")
                                            .emberCaption(color: EmberColors.roseQuartz)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(EmberColors.roseQuartz.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { toggleFavorite() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? EmberColors.roseQuartz : EmberColors.textSecondary)
                    }
                }
            }
        }
    }
    
    private func toggleFavorite() {
        EmberHapticsManager.shared.playLight()
        withAnimation(.easeInOut(duration: 0.2)) {
            isFavorite.toggle()
        }
    }
}

#Preview {
    EmberMemoryTimelineView()
}