import SwiftUI

// MARK: - Memory Search View
struct EmberMemorySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedFilter: SearchFilter = .all
    @State private var searchResults: [MemorySearchResult] = []
    @State private var isSearching = false
    @State private var selectedMemory: Memory?
    @State private var showingMemoryDetail = false
    
    private let allMemories = Memory.sampleMemories
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Filter Bar
                if !searchText.isEmpty {
                    filterBar
                }
                
                // Search Results
                if searchText.isEmpty {
                    emptySearchState
                } else if searchResults.isEmpty && !isSearching {
                    noResultsState
                } else {
                    searchResultsList
                }
            }
            .background(EmberColors.backgroundPrimary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
                ToolbarItem(placement: .principal) {
                    Text("Search Memories")
                        .emberHeadline()
                }
            }
        }
        .onChange(of: searchText) { _, newValue in
            performSearch(newValue)
        }
        .sheet(isPresented: $showingMemoryDetail) {
            if let memory = selectedMemory {
                EmberMemoryDetailView(memory: memory)
            }
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(EmberColors.textSecondary)
                
                TextField("Search memories, notes, locations...", text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(EmberColors.textTertiary)
                    }
                }
            }
            .padding(12)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(EmberColors.border, lineWidth: 1)
            )
        }
        .padding()
    }
    
    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SearchFilter.allCases, id: \.self) { filter in
                    Button(action: { 
                        selectedFilter = filter
                        performSearch(searchText)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: filter.icon)
                                .font(.system(size: 12))
                            Text(filter.title)
                        }
                        .emberCaption(color: selectedFilter == filter ? .white : EmberColors.textSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedFilter == filter ? EmberColors.roseQuartz : EmberColors.surface)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 12)
    }
    
    private var emptySearchState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundStyle(EmberColors.textTertiary)
            
            VStack(spacing: 8) {
                Text("Search Your Memories")
                    .emberHeadline()
                
                Text("Find photos, notes, locations, and more")
                    .emberBody(color: EmberColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Quick Search Suggestions
            VStack(alignment: .leading, spacing: 12) {
                Text("Try searching for:")
                    .emberLabel()
                
                VStack(spacing: 8) {
                    quickSearchButton("Coffee dates", icon: "cup.and.saucer.fill")
                    quickSearchButton("Love notes", icon: "heart.text.square.fill")
                    quickSearchButton("Photos", icon: "camera.fill")
                    quickSearchButton("This week", icon: "calendar")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(EmberColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func quickSearchButton(_ text: String, icon: String) -> some View {
        Button(action: { searchText = text }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(EmberColors.roseQuartz)
                
                Text(text)
                    .emberBody()
                
                Spacer()
                
                Image(systemName: "arrow.up.left")
                    .font(.system(size: 12))
                    .foregroundStyle(EmberColors.textTertiary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
    
    private var noResultsState: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "questionmark.folder")
                .font(.system(size: 50))
                .foregroundStyle(EmberColors.textTertiary)
            
            VStack(spacing: 8) {
                Text("No Results Found")
                    .emberHeadline()
                
                Text("Try different keywords or check your spelling")
                    .emberBody(color: EmberColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
    
    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(searchResults) { result in
                    searchResultRow(result)
                }
            }
            .padding()
        }
    }
    
    private func searchResultRow(_ result: MemorySearchResult) -> some View {
        Button(action: {
            selectedMemory = result.memory
            showingMemoryDetail = true
        }) {
            HStack(spacing: 12) {
                // Memory Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(result.memory.type.color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: result.memory.type.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(result.memory.type.color)
                }
                
                // Memory Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(result.memory.title)
                            .emberLabel()
                        
                        Spacer()
                        
                        Text(result.memory.timeAgo)
                            .emberCaption(color: EmberColors.textTertiary)
                    }
                    
                    // Highlighted match
                    HStack {
                        Text("Match in \(result.matchType.description):")
                            .emberCaption(color: EmberColors.textSecondary)
                        
                        Text(result.matchedText)
                            .emberCaption(color: EmberColors.roseQuartz)
                            .italic()
                        
                        Spacer()
                    }
                    
                    Text(result.memory.content)
                        .emberBody(color: EmberColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    // Additional info
                    HStack {
                        if let location = result.memory.location {
                            HStack(spacing: 4) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 10))
                                Text(location)
                            }
                            .emberCaption(color: EmberColors.textTertiary)
                        }
                        
                        Spacer()
                        
                        Text(result.memory.isFromPartner ? "From Alex" : "From You")
                            .emberCaption(color: result.memory.isFromPartner ? EmberColors.peachyKeen : EmberColors.roseQuartz)
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
    
    private func performSearch(_ query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        
        // Simulate search delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let results = searchMemories(query: query, filter: selectedFilter)
            searchResults = results
            isSearching = false
        }
    }
    
    private func searchMemories(query: String, filter: SearchFilter) -> [MemorySearchResult] {
        let lowercaseQuery = query.lowercased()
        var results: [MemorySearchResult] = []
        
        for memory in allMemories {
            // Apply filter
            switch filter {
            case .all:
                break
            case .photos:
                if memory.type != .photo { continue }
            case .notes:
                if memory.type != .note { continue }
            case .locations:
                if memory.location == nil { continue }
            case .thisWeek:
                if !Calendar.current.isDate(memory.date, equalTo: Date(), toGranularity: .weekOfYear) { continue }
            case .favorites:
                if !memory.isFavorite { continue }
            }
            
            // Search in title
            if memory.title.lowercased().contains(lowercaseQuery) {
                results.append(MemorySearchResult(
                    memory: memory,
                    matchedText: memory.title,
                    matchType: .title
                ))
                continue
            }
            
            // Search in content
            if memory.content.lowercased().contains(lowercaseQuery) {
                results.append(MemorySearchResult(
                    memory: memory,
                    matchedText: String(memory.content.prefix(50)) + "...",
                    matchType: .content
                ))
                continue
            }
            
            // Search in location
            if let location = memory.location, location.lowercased().contains(lowercaseQuery) {
                results.append(MemorySearchResult(
                    memory: memory,
                    matchedText: location,
                    matchType: .location
                ))
                continue
            }
            
            // Search in tags
            for tag in memory.tags {
                if tag.lowercased().contains(lowercaseQuery) {
                    results.append(MemorySearchResult(
                        memory: memory,
                        matchedText: "#\(tag)",
                        matchType: .tag
                    ))
                    break
                }
            }
        }
        
        return results.sorted { $0.memory.date > $1.memory.date }
    }
}

enum SearchFilter: CaseIterable {
    case all, photos, notes, locations, thisWeek, favorites
    
    var title: String {
        switch self {
        case .all: return "All"
        case .photos: return "Photos"
        case .notes: return "Notes"
        case .locations: return "Locations"
        case .thisWeek: return "This Week"
        case .favorites: return "Favorites"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .photos: return "camera.fill"
        case .notes: return "text.quote"
        case .locations: return "location.fill"
        case .thisWeek: return "calendar"
        case .favorites: return "heart.fill"
        }
    }
}

#Preview {
    EmberMemorySearchView()
}