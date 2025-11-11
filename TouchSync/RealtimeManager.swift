import Foundation

import CryptoKit
import Combine

@MainActor
class RealtimeManager: ObservableObject {
    private var currentSessionId: String?
    
    @Published var isConnected = false
    @Published var partnerOnline = false
    
    func startSession(userId: String, partnerId: String) {
        let sessionId = "\(min(userId, partnerId))_\(max(userId, partnerId))"
        currentSessionId = sessionId
        
        print("Mock session started: \(sessionId)")
        isConnected = true
    }
    
    func sendTouch(point: CGPoint, intensity: Float, userId: String) {
        print("Mock touch sent: \(point) intensity: \(intensity)")
        
        // Save drawing touch to local storage
        Task { @MainActor in
            let touchRepo = TouchRepository()
            touchRepo.saveTouch(
                gestureType: "Drawing",
                senderId: userId,
                receiverId: "partner",
                intensity: intensity,
                drawingPath: "\(point.x),\(point.y)"
            )
        }
    }
    
    func sendGesture(_ gesture: HapticGesture, userId: String) {
        print("Mock gesture sent: \(gesture.name)")
        
        // Save to local storage
        Task { @MainActor in
            let touchRepo = TouchRepository()
            touchRepo.saveTouch(
                gestureType: gesture.name,
                senderId: userId,
                receiverId: "partner",
                intensity: nil,
                drawingPath: nil
            )
        }
    }
    

    

    
    private func encryptTouchData(_ data: [String: Any]) -> [String: Any]? {
        // Simple encryption for demo - in production use proper E2E encryption
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data),
              let key = getEncryptionKey() else { return nil }
        
        let sealedBox = try? AES.GCM.seal(jsonData, using: key)
        
        return [
            "encrypted": sealedBox?.combined?.base64EncodedString() ?? "",
            "timestamp": data["timestamp"] ?? Date().timeIntervalSince1970
        ]
    }
    
    private func decryptTouchData(_ data: [String: Any]) -> [String: Any]? {
        guard let encryptedString = data["encrypted"] as? String,
              let encryptedData = Data(base64Encoded: encryptedString),
              let key = getEncryptionKey() else { return nil }
        
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return try JSONSerialization.jsonObject(with: decryptedData) as? [String: Any]
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
    
    private func getEncryptionKey() -> SymmetricKey? {
        // In production, derive this from partner linking process
        let keyString = "TouchSyncDemoKey32CharactersLong"
        guard let keyData = keyString.data(using: .utf8) else { return nil }
        return SymmetricKey(data: keyData)
    }
    
    func endSession() {
        currentSessionId = nil
        isConnected = false
        print("Mock session ended")
    }
}

extension Notification.Name {
    static let partnerTouchReceived = Notification.Name("partnerTouchReceived")
}
