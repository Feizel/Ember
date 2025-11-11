import Foundation
import SwiftUI
import Combine

@MainActor
class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: MockUser?
    @Published var partnerId: String?
    @Published var pairingCode: String = ""
    @Published var accountStatus: String = "available"
    

    
    init() {
        checkiCloudStatus()
    }
    

    
    func checkiCloudStatus() {
        // Mock iCloud as available for Simulator
        accountStatus = "available"
        authenticateWithMockiCloud()
    }
    
    func authenticateWithMockiCloud() {
        // Generate mock user
        currentUser = MockUser(uid: "mock_user_\(UUID().uuidString.prefix(8))")
        isAuthenticated = true
        generatePairingCode()
    }
    
    func generatePairingCode() {
        // Generate random 6-digit code
        pairingCode = String(format: "%06d", Int.random(in: 100000...999999))
        print("Pairing code generated: \(pairingCode)")
    }
    
    func signOut() {
        currentUser = nil
        partnerId = nil
        pairingCode = ""
        isAuthenticated = false
    }
    

    
    func linkPartner(withCode code: String) async throws {
        // Local-only pairing for testing - will be replaced with CloudKit
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay
        
        // For testing: accept any 6-digit code
        if code.count == 6 && code.allSatisfy({ $0.isNumber }) {
            partnerId = "local_partner_\(code)"
            print("LOCAL TESTING: Partner linked with code: \(code)")
            print("NOTE: Real pairing requires CloudKit (Apple Developer Account)")
        } else {
            throw AuthError.invalidInviteCode
        }
    }
    

    
    func updateFCMToken(_ token: String) async {
        print("Mock FCM token update: \(token)")
    }
    
}

struct MockUser {
    let uid: String
    let email: String = "demo@touchsync.app"
}

enum AuthError: LocalizedError {
    case notAuthenticated
    case invalidInviteCode
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "User not authenticated"
        case .invalidInviteCode:
            return "Invalid invite code"
        }
    }
}