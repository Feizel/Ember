import SwiftUI
import RealityKit

struct Ember3DCharacters: View {
    let character: CharacterType
    let size: CGFloat
    let isAnimating: Bool
    
    @State private var arView = ARView(frame: .zero)
    @State private var characterEntity: ModelEntity?
    
    init(character: CharacterType, size: CGFloat = 120, isAnimating: Bool = true) {
        self.character = character
        self.size = size
        self.isAnimating = isAnimating
    }
    
    var body: some View {
        RealityKitView(arView: arView)
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.1))
            .onAppear {
                setup3DCharacter()
            }
    }
    
    private func setup3DCharacter() {
        let anchor = AnchorEntity()
        
        switch character {
        case .touchy:
            characterEntity = createTouchy()
        case .syncee:
            characterEntity = createSyncee()
        default:
            characterEntity = createTouchy()
        }
        
        guard let entity = characterEntity else { return }
        
        entity.scale = [0.8, 0.8, 0.8]
        entity.position = [0, -0.1, 0]
        
        if isAnimating {
            addAnimations(to: entity)
        }
        
        anchor.addChild(entity)
        setupLighting(anchor: anchor)
        
        arView.scene.addAnchor(anchor)
        arView.cameraMode = .nonAR
        arView.environment.background = .color(.clear)
    }
    
    private func createTouchy() -> ModelEntity {
        let entity = ModelEntity()
        
        // Main body - gentle blob shape
        let bodyMesh = MeshResource.generateSphere(radius: 0.15)
        let bodyMaterial = SimpleMaterial(color: UIColor(EmberColors.roseQuartz), isMetallic: false)
        let body = ModelEntity(mesh: bodyMesh, materials: [bodyMaterial])
        body.scale = [1.0, 1.2, 0.9] // Slightly taller, softer
        entity.addChild(body)
        
        // Eyes - larger, friendlier
        let eyeMesh = MeshResource.generateSphere(radius: 0.02)
        let eyeMaterial = SimpleMaterial(color: .black, isMetallic: false)
        
        let leftEye = ModelEntity(mesh: eyeMesh, materials: [eyeMaterial])
        leftEye.position = [-0.04, 0.05, 0.12]
        entity.addChild(leftEye)
        
        let rightEye = ModelEntity(mesh: eyeMesh, materials: [eyeMaterial])
        rightEye.position = [0.04, 0.05, 0.12]
        entity.addChild(rightEye)
        
        // Eye highlights
        let highlightMesh = MeshResource.generateSphere(radius: 0.008)
        let highlightMaterial = SimpleMaterial(color: .white, isMetallic: false)
        
        let leftHighlight = ModelEntity(mesh: highlightMesh, materials: [highlightMaterial])
        leftHighlight.position = [-0.035, 0.055, 0.125]
        entity.addChild(leftHighlight)
        
        let rightHighlight = ModelEntity(mesh: highlightMesh, materials: [highlightMaterial])
        rightHighlight.position = [0.045, 0.055, 0.125]
        entity.addChild(rightHighlight)
        
        // Mouth - gentle smile
        let mouthMesh = MeshResource.generateBox(width: 0.04, height: 0.008, depth: 0.01)
        let mouthMaterial = SimpleMaterial(color: .black, isMetallic: false)
        let mouth = ModelEntity(mesh: mouthMesh, materials: [mouthMaterial])
        mouth.position = [0, 0.02, 0.12]
        mouth.orientation = simd_quatf(angle: 0.3, axis: [1, 0, 0])
        entity.addChild(mouth)
        
        // Cheeks - rosy glow
        let cheekMesh = MeshResource.generateSphere(radius: 0.015)
        let cheekMaterial = SimpleMaterial(color: UIColor(EmberColors.roseQuartz.opacity(0.6)), isMetallic: false)
        
        let leftCheek = ModelEntity(mesh: cheekMesh, materials: [cheekMaterial])
        leftCheek.position = [-0.08, 0.02, 0.1]
        entity.addChild(leftCheek)
        
        let rightCheek = ModelEntity(mesh: cheekMesh, materials: [cheekMaterial])
        rightCheek.position = [0.08, 0.02, 0.1]
        entity.addChild(rightCheek)
        
        return entity
    }
    
    private func createSyncee() -> ModelEntity {
        let entity = ModelEntity()
        
        // Main body - more structured shape
        let bodyMesh = MeshResource.generateSphere(radius: 0.15)
        let bodyMaterial = SimpleMaterial(color: UIColor(EmberColors.peachyKeen), isMetallic: false)
        let body = ModelEntity(mesh: bodyMesh, materials: [bodyMaterial])
        body.scale = [0.95, 1.15, 0.95] // Slightly more angular
        entity.addChild(body)
        
        // Eyes - more focused
        let eyeMesh = MeshResource.generateSphere(radius: 0.018)
        let eyeMaterial = SimpleMaterial(color: .black, isMetallic: false)
        
        let leftEye = ModelEntity(mesh: eyeMesh, materials: [eyeMaterial])
        leftEye.position = [-0.035, 0.05, 0.12]
        entity.addChild(leftEye)
        
        let rightEye = ModelEntity(mesh: eyeMesh, materials: [eyeMaterial])
        rightEye.position = [0.035, 0.05, 0.12]
        entity.addChild(rightEye)
        
        // Eye highlights
        let highlightMesh = MeshResource.generateSphere(radius: 0.007)
        let highlightMaterial = SimpleMaterial(color: .white, isMetallic: false)
        
        let leftHighlight = ModelEntity(mesh: highlightMesh, materials: [highlightMaterial])
        leftHighlight.position = [-0.03, 0.055, 0.125]
        entity.addChild(leftHighlight)
        
        let rightHighlight = ModelEntity(mesh: highlightMesh, materials: [highlightMaterial])
        rightHighlight.position = [0.04, 0.055, 0.125]
        entity.addChild(rightHighlight)
        
        // Mouth - confident smile
        let mouthMesh = MeshResource.generateBox(width: 0.05, height: 0.01, depth: 0.01)
        let mouthMaterial = SimpleMaterial(color: .black, isMetallic: false)
        let mouth = ModelEntity(mesh: mouthMesh, materials: [mouthMaterial])
        mouth.position = [0, 0.015, 0.12]
        mouth.orientation = simd_quatf(angle: 0.2, axis: [1, 0, 0])
        entity.addChild(mouth)
        
        // Accent marks - small decorative elements
        let accentMesh = MeshResource.generateBox(width: 0.008, height: 0.025, depth: 0.005)
        let accentMaterial = SimpleMaterial(color: UIColor(EmberColors.coralPop), isMetallic: false)
        
        let leftAccent = ModelEntity(mesh: accentMesh, materials: [accentMaterial])
        leftAccent.position = [-0.12, 0.08, 0.05]
        leftAccent.orientation = simd_quatf(angle: -0.3, axis: [0, 0, 1])
        entity.addChild(leftAccent)
        
        let rightAccent = ModelEntity(mesh: accentMesh, materials: [accentMaterial])
        rightAccent.position = [0.12, 0.08, 0.05]
        rightAccent.orientation = simd_quatf(angle: 0.3, axis: [0, 0, 1])
        entity.addChild(rightAccent)
        
        return entity
    }
    
    private func addAnimations(to entity: ModelEntity) {
        // Gentle floating animation
        let floatAnimation = try! AnimationResource.generate(
            with: FromToByAnimation<Transform>(
                name: "float",
                from: .init(scale: [0.8, 0.8, 0.8], rotation: simd_quatf(), translation: [0, -0.12, 0]),
                to: .init(scale: [0.8, 0.8, 0.8], rotation: simd_quatf(), translation: [0, -0.08, 0]),
                duration: 2.5,
                timing: .easeInOut,
                repeatMode: .repeat
            )
        )
        
        // Gentle rotation
        let rotationAnimation = try! AnimationResource.generate(
            with: FromToByAnimation<Transform>(
                name: "rotation",
                from: .init(scale: [0.8, 0.8, 0.8], rotation: simd_quatf(angle: 0, axis: [0, 1, 0]), translation: [0, -0.1, 0]),
                to: .init(scale: [0.8, 0.8, 0.8], rotation: simd_quatf(angle: .pi * 2, axis: [0, 1, 0]), translation: [0, -0.1, 0]),
                duration: 15.0,
                timing: .linear,
                repeatMode: .repeat
            )
        )
        
        entity.playAnimation(floatAnimation)
        entity.playAnimation(rotationAnimation)
    }
    
    private func setupLighting(anchor: AnchorEntity) {
        // Main directional light
        let directionalLight = DirectionalLight()
        directionalLight.light.intensity = 2000
        directionalLight.light.color = .white
        directionalLight.orientation = simd_quatf(angle: -.pi/4, axis: [1, 0, 0])
        anchor.addChild(directionalLight)
        
        // Ambient light for softer shadows
        let ambientLight = DirectionalLight()
        ambientLight.light.intensity = 800
        ambientLight.light.color = UIColor(EmberColors.peachyKeen.opacity(0.8))
        ambientLight.orientation = simd_quatf(angle: .pi/3, axis: [0, 1, 0])
        anchor.addChild(ambientLight)
    }
}

#Preview {
    HStack(spacing: 30) {
        VStack(spacing: 10) {
            Ember3DCharacters(character: .touchy, size: 150)
            Text("Touchy")
                .font(.caption.weight(.semibold))
        }
        
        VStack(spacing: 10) {
            Ember3DCharacters(character: .syncee, size: 150)
            Text("Syncee")
                .font(.caption.weight(.semibold))
        }
    }
    .padding()
}