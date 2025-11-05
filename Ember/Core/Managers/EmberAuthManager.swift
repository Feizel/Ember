import Foundation
import SwiftUI
import Combine

@MainActor
class EmberAuthManager: ObservableObject {
    static let shared = EmberAuthManager()
    
    @Published var isAuthenticated = false
    @Published var currentUser: MockUser?
    @Published var partnerId: String?
    @Published var pairingCode: String = ""
    @Published var accountStatus: String = "available"
    
    init() {
        checkiCloudStatus()
    }
    
    func checkiCloudStatus() {
        accountStatus = "available"
        authenticateWithMockiCloud()
    }
    
    func authenticateWithMockiCloud() {
        currentUser = MockUser(uid: "ember_user_\(UUID().uuidString.prefix(8))")
        isAuthenticated = true
        generatePairingCode()
    }
    
    func generatePairingCode() {
        pairingCode = String(format: "%06d", Int.random(in: 100000...999999))
    }
    
    func signOut() {
        currentUser = nil
        partnerId = nil
        pairingCode = ""
        isAuthenticated = false
    }
    
    func linkPartner(withCode code: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        if code.count == 6 && code.allSatisfy({ $0.isNumber }) {
            partnerId = "ember_partner_\(code)"
        } else {
            throw AuthError.invalidInviteCode
        }
    }
}

enum AuthError: LocalizedError {
    case notAuthenticated
    case invalidInviteCode
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated: return "User not authenticated"
        case .invalidInviteCode: return "Invalid invite code"
        }
    }
}