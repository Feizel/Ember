import SwiftUI
import Combine

@MainActor
class MockAuthManager: ObservableObject {
    static let shared = MockAuthManager()
    
    @Published var isAuthenticated = false
    @Published var userRecordID: String?
    @Published var partnerId: String?
    @Published var pairingCode: String = ""
    @Published var accountStatus: String = "available"
    
    init() {
        // Simulate iCloud being available
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.authenticateWithMockiCloud()
        }
    }
    
    func checkiCloudStatus() {
        // Mock iCloud as available
        accountStatus = "available"
        isAuthenticated = true
        authenticateWithMockiCloud()
    }
    
    func authenticateWithMockiCloud() {
        // Generate mock user ID
        userRecordID = "mock_user_\(UUID().uuidString.prefix(8))"
        isAuthenticated = true
        generatePairingCode()
    }
    
    func generatePairingCode() {
        // Generate random 6-digit code
        pairingCode = String(format: "%06d", Int.random(in: 100000...999999))
        print("Mock pairing code generated: \(pairingCode)")
    }
    
    func linkPartner(withCode code: String) async throws {
        // Simulate partner linking
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        if code.count == 6 && code.allSatisfy({ $0.isNumber }) {
            partnerId = "mock_partner_\(code)"
            print("Mock partner linked with code: \(code)")
        } else {
            throw MockPairingError.invalidCode
        }
    }
    
    func signOut() {
        userRecordID = nil
        partnerId = nil
        pairingCode = ""
        isAuthenticated = false
    }
    
    func updateFCMToken(_ token: String) async {
        print("Mock FCM token update: \(token)")
    }
}

enum MockPairingError: LocalizedError {
    case invalidCode
    
    var errorDescription: String? {
        switch self {
        case .invalidCode:
            return "Invalid pairing code. Please enter a 6-digit code."
        }
    }
}