import SwiftUI
import RealityKit

struct Ember3DTouchySyncee: View {
    let character: CharacterType
    let size: CGFloat
    let isAnimating: Bool
    
    @State private var arView = ARView(frame: .zero)
    @State private var modelEntity: ModelEntity?
    
    var body: some View {
        ZStack {
            RealityKitView(arView: arView)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.1))
                .background(
                    RoundedRectangle(cornerRadius: size * 0.1)
                        .fill(characterGradient)
                        .opacity(0.1)
                )
        }
        .onAppear {
            setup3DModel()
        }
    }
    
    private var characterGradient: LinearGradient {
        switch character {
        case .touchy:
            return LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.roseQuartzLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .syncee:
            return LinearGradient(
                colors: [EmberColors.peachyKeen, EmberColors.peachyKeenLight],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [EmberColors.roseQuartz, EmberColors.peachyKeen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private func setup3DModel() {
        guard let modelURL = Bundle.main.url(forResource: "touchy&syncee3d", withExtension: "usdz") else {
            print("❌ USDZ file not found")
            return
        }
        
        do {
            let model = try ModelEntity.loadModel(contentsOf: modelURL)
            modelEntity = model
            
            // Scale and position
            model.scale = [0.4, 0.4, 0.4]
            model.position = [0, -0.1, 0]
            
            // Character-specific positioning
            if character == .syncee {
                model.position.x = 0.05  // Slight offset for Syncee
            }
            
            // Add to scene
            let anchor = AnchorEntity()
            anchor.addChild(model)
            
            // Lighting
            let light = DirectionalLight()
            light.light.intensity = 2000
            light.light.color = UIColor(character == .touchy ? EmberColors.roseQuartz : EmberColors.peachyKeen)
            light.orientation = simd_quatf(angle: -.pi/4, axis: [1, 0, 0])
            anchor.addChild(light)
            
            arView.scene.addAnchor(anchor)
            arView.cameraMode = .nonAR
            arView.environment.background = .color(.clear)
            
            if isAnimating {
                startAnimations(model)
            }
            
        } catch {
            print("❌ Failed to load 3D model: \(error)")
        }
    }
    
    private func startAnimations(_ model: ModelEntity) {
        // Gentle rotation
        let rotationAnimation = try! AnimationResource.generate(
            with: FromToByAnimation<Transform>(
                name: "rotation",
                from: .init(scale: [0.4, 0.4, 0.4], rotation: simd_quatf(angle: 0, axis: [0, 1, 0]), translation: model.position),
                to: .init(scale: [0.4, 0.4, 0.4], rotation: simd_quatf(angle: .pi * 2, axis: [0, 1, 0]), translation: model.position),
                duration: 15.0,
                timing: .linear,
                repeatMode: .repeat
            )
        )
        
        // Floating animation
        let floatAnimation = try! AnimationResource.generate(
            with: FromToByAnimation<Transform>(
                name: "float",
                from: .init(scale: [0.4, 0.4, 0.4], rotation: simd_quatf(), translation: [model.position.x, model.position.y - 0.02, model.position.z]),
                to: .init(scale: [0.4, 0.4, 0.4], rotation: simd_quatf(), translation: [model.position.x, model.position.y + 0.02, model.position.z]),
                duration: 3.0,
                timing: .easeInOut,
                repeatMode: .repeat
            )
        )
        
        model.playAnimation(rotationAnimation)
        model.playAnimation(floatAnimation)
    }
}



#Preview {
    HStack(spacing: 30) {
        VStack {
            Text("Touchy")
                .font(.headline)
            Ember3DTouchySyncee(character: .touchy, size: 150, isAnimating: true)
        }
        
        VStack {
            Text("Syncee")
                .font(.headline)
            Ember3DTouchySyncee(character: .syncee, size: 150, isAnimating: true)
        }
    }
    .padding()
}