import SwiftUI
import RealityKit
import SceneKit

struct Ember3DCharacterView: View {
    let size: CGFloat
    let isAnimating: Bool
    
    @State private var arView = ARView(frame: .zero)
    @State private var characterEntity: ModelEntity?
    @State private var show3D = false
    @State private var rotationAngle: Double = 0
    @State private var floatOffset: CGFloat = 0
    
    init(size: CGFloat = 280, isAnimating: Bool = true) {
        self.size = size
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        ZStack {
            if show3D {
                RealityKitView(arView: arView)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.1))
                    .background(
                        RoundedRectangle(cornerRadius: size * 0.1)
                            .fill(
                                LinearGradient(
                                    colors: [EmberColors.roseQuartz.opacity(0.1), EmberColors.peachyKeen.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.1)
                            .stroke(
                                LinearGradient(
                                    colors: [EmberColors.roseQuartz.opacity(0.3), EmberColors.peachyKeen.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: EmberColors.roseQuartz.opacity(0.2), radius: 8, x: 0, y: 4)
            } else {
                // Enhanced 2D fallback with 3D-like effects
                ZStack {
                    // Background glow
                    RoundedRectangle(cornerRadius: size * 0.1)
                        .fill(
                            RadialGradient(
                                colors: [EmberColors.roseQuartz.opacity(0.2), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: size * 0.6
                            )
                        )
                        .frame(width: size * 1.2, height: size * 1.2)
                    
                    // Main character image with 3D transform
                    Image("TouchyAndSyncee")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size * 0.8, height: size * 0.8)
                        .rotation3DEffect(
                            .degrees(rotationAngle),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .offset(y: floatOffset)
                        .scaleEffect(1.0 + sin(rotationAngle * .pi / 180) * 0.05)
                }
                .frame(width: size, height: size)
                .background(
                    RoundedRectangle(cornerRadius: size * 0.1)
                        .fill(
                            LinearGradient(
                                colors: [EmberColors.roseQuartz.opacity(0.1), EmberColors.peachyKeen.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.1)
                        .stroke(
                            LinearGradient(
                                colors: [EmberColors.roseQuartz.opacity(0.3), EmberColors.peachyKeen.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
                .shadow(color: EmberColors.roseQuartz.opacity(0.2), radius: 8, x: 0, y: 4)
            }
        }
        .onAppear {
            setupScene()
            if isAnimating {
                startAnimations()
            }
        }
    }
    
    private func setupScene() {
        // Create anchor
        let anchor = AnchorEntity()
        
        // Try to load 3D model from bundle
        if let modelURL = Bundle.main.url(forResource: "touchy&syncee3d", withExtension: "usdz") {
            do {
                let modelEntity = try ModelEntity.loadModel(contentsOf: modelURL)
                characterEntity = modelEntity
                show3D = true
                
                // Scale and position for optimal viewing
                modelEntity.scale = [0.3, 0.3, 0.3]
                modelEntity.position = [0, -0.1, 0]
                
                // Add gentle rotation animation
                if isAnimating {
                    let rotationAnimation = try! AnimationResource.generate(
                        with: FromToByAnimation<Transform>(
                            name: "rotation",
                            from: .init(scale: [0.3, 0.3, 0.3], rotation: simd_quatf(angle: 0, axis: [0, 1, 0]), translation: [0, -0.1, 0]),
                            to: .init(scale: [0.3, 0.3, 0.3], rotation: simd_quatf(angle: .pi * 2, axis: [0, 1, 0]), translation: [0, -0.1, 0]),
                            duration: 12.0,
                            timing: .linear,
                            repeatMode: .repeat
                        )
                    )
                    
                    // Add floating animation
                    let floatAnimation = try! AnimationResource.generate(
                        with: FromToByAnimation<Transform>(
                            name: "float",
                            from: .init(scale: [0.3, 0.3, 0.3], rotation: simd_quatf(), translation: [0, -0.15, 0]),
                            to: .init(scale: [0.3, 0.3, 0.3], rotation: simd_quatf(), translation: [0, -0.05, 0]),
                            duration: 3.0,
                            timing: .easeInOut,
                            repeatMode: .repeat
                        )
                    )
                    
                    modelEntity.playAnimation(rotationAnimation)
                    modelEntity.playAnimation(floatAnimation)
                }
                
                anchor.addChild(modelEntity)
                
                // Setup enhanced lighting for premium look
                let directionalLight = DirectionalLight()
                directionalLight.light.intensity = 1500
                directionalLight.light.color = .white
                directionalLight.orientation = simd_quatf(angle: -.pi/3, axis: [1, 0, 0])
                anchor.addChild(directionalLight)
                
                // Add ambient light for softer shadows
                let ambientLight = DirectionalLight()
                ambientLight.light.intensity = 500
                ambientLight.light.color = UIColor(EmberColors.peachyKeen)
                ambientLight.orientation = simd_quatf(angle: .pi/4, axis: [0, 1, 0])
                anchor.addChild(ambientLight)
                
                arView.scene.addAnchor(anchor)
                
                // Setup camera for optimal viewing
                arView.cameraMode = .nonAR
                arView.environment.background = .color(.clear)
                
                print("✅ Successfully loaded 3D USDZ model")
            } catch {
                print("❌ Failed to load 3D model: \(error)")
                show3D = false
            }
        } else {
            print("❌ USDZ file not found in bundle")
            show3D = false
        }
    }
    
    private func startAnimations() {
        if !show3D {
            // Animate 2D fallback
            withAnimation(.linear(duration: 12.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                floatOffset = -size * 0.02
            }
        }
    }
}

struct RealityKitView: UIViewRepresentable {
    let arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        arView.backgroundColor = .clear
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    VStack(spacing: 30) {
        Text("3D Ember Characters")
            .font(.title.bold())
        
        Ember3DCharacterView(size: 200, isAnimating: true)
        
        HStack(spacing: 20) {
            Ember3DCharacterView(size: 120, isAnimating: true)
            Ember3DCharacterView(size: 120, isAnimating: false)
        }
    }
    .padding()
}