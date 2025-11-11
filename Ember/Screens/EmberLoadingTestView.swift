import SwiftUI

struct EmberLoadingTestView: View {
    @State private var showLoading = false
    @State private var loadingComplete = false
    
    var body: some View {
        ZStack {
            if showLoading && !loadingComplete {
                EmberLoadingView {
                    loadingComplete = true
                }
            } else if loadingComplete {
                VStack {
                    Text("🎉 Loading Complete!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome to Ember")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    Button("Test Again") {
                        loadingComplete = false
                        showLoading = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showLoading = true
                        }
                    }
                    .padding()
                    .background(EmberColors.roseQuartz)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
            } else {
                VStack {
                    Text("Ember Loading Demo")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Button("Start Loading") {
                        showLoading = true
                    }
                    .padding()
                    .background(EmberColors.roseQuartz)
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showLoading)
        .animation(.easeInOut(duration: 0.5), value: loadingComplete)
    }
}

#Preview {
    EmberLoadingTestView()
}