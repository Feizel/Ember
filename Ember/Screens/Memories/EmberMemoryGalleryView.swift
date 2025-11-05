import SwiftUI

// MARK: - Memory Gallery View
struct EmberMemoryGalleryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter: GalleryFilter = .all
    @State private var showingMemoryDetail = false
    @State private var selectedMemory: Memory?
    
    private let memories = Memory.sampleMemories
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Filter Bar
                filterBar
                
                // Gallery Grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        ForEach(filteredMemories) { memory in
                            memoryCard(memory)
                        }
                    }
                    .padding()
                }
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Photo Gallery")
                        .emberHeadline()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingMemoryDetail) {
            if let memory = selectedMemory {
                EmberMemoryDetailView(memory: memory)
            }
        }
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(GalleryFilter.allCases, id: \.self) { filter in
                    Button(action: { selectedFilter = filter }) {
                        Text(filter.title)
                            .emberCaption(color: selectedFilter == filter ? .white : EmberColors.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedFilter == filter ? EmberColors.roseQuartz : EmberColors.surface)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(EmberColors.backgroundSecondary)
    }
    
    private func memoryCard(_ memory: Memory) -> some View {
        Button(action: {
            selectedMemory = memory
            showingMemoryDetail = true
        }) {
            VStack(spacing: 0) {
                // Image placeholder
                Rectangle()
                    .fill(memory.type.color.opacity(0.2))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: memory.type.icon)
                            .font(.system(size: 30))
                            .foregroundStyle(memory.type.color)
                    )
                
                // Memory info
                VStack(alignment: .leading, spacing: 4) {
                    Text(memory.title)
                        .emberCaption()
                        .lineLimit(1)
                    
                    Text(memory.timeAgo)
                        .emberCaption(color: EmberColors.textTertiary)
                        .font(.system(size: 10))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)
                .background(EmberColors.surface)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
    
    private var filteredMemories: [Memory] {
        switch selectedFilter {
        case .all: return memories
        case .photos: return memories.filter { $0.type == .photo }
        case .thisWeek: return memories.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
        case .thisMonth: return memories.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
        case .favorites: return memories.filter { $0.isFavorite }
        }
    }
}

enum GalleryFilter: CaseIterable {
    case all, photos, thisWeek, thisMonth, favorites
    
    var title: String {
        switch self {
        case .all: return "All"
        case .photos: return "Photos"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        case .favorites: return "Favorites"
        }
    }
}

#Preview {
    EmberMemoryGalleryView()
}