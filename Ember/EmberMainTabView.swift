import SwiftUI

struct EmberMainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EmberHomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            EmberMemoriesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Memories")
                }
                .tag(1)
            
            EmberTouchView()
                .tabItem {
                    Image(systemName: "hand.draw.fill")
                    Text("Touch")
                }
                .tag(2)
            
            EmberProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .tint(EmberColors.roseQuartz)
    }
}