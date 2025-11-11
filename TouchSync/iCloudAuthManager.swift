import CloudKit
import SwiftUI
import Combine

@MainActor
class iCloudAuthManager: ObservableObject {
    static let shared = iCloudAuthManager()
    
    @Published var isAuthenticated = false
    @Published var userRecordID: CKRecord.ID?
    @Published var partnerId: String?
    @Published var pairingCode: String = ""
    @Published var accountStatus: CKAccountStatus = .couldNotDetermine
    
    private let container = CKContainer.default()
    private var authStateHandle: NSObjectProtocol?
    
    init() {
        checkiCloudStatus()
    }
    
    func checkiCloudStatus() {
        Task {
            do {
                let status = try await container.accountStatus()
                await MainActor.run {
                    accountStatus = status
                    isAuthenticated = (status == .available)
                }
                
                if status == .available {
                    await authenticateWithiCloud()
                }
            } catch {
                print("iCloud status check failed: \(error)")
            }
        }
    }
    
    func authenticateWithiCloud() async {
        do {
            let recordID = try await container.userRecordID()
            await MainActor.run {
                userRecordID = recordID
                isAuthenticated = true
                generatePairingCode()
            }
            await loadUserProfile()
        } catch {
            print("iCloud authentication failed: \(error)")
            await MainActor.run {
                isAuthenticated = false
            }
        }
    }
    
    func generatePairingCode() {
        guard let userID = userRecordID?.recordName else { return }
        
        // Create a 6-digit code based on user ID hash
        let hash = abs(userID.hashValue)
        pairingCode = String(format: "%06d", hash % 1000000)
        
        // Store pairing code in CloudKit public database
        Task {
            await storePairingCode()
        }
    }
    
    private func storePairingCode() async {
        guard let userID = userRecordID else { return }
        
        do {
            let publicDB = container.publicCloudDatabase
            let record = CKRecord(recordType: "PairingCode", recordID: CKRecord.ID(recordName: pairingCode))
            
            record["userID"] = userID.recordName
            record["createdAt"] = Date()
            record["expiresAt"] = Date().addingTimeInterval(3600) // 1 hour expiry
            
            try await publicDB.save(record)
            print("Pairing code stored: \(pairingCode)")
        } catch {
            print("Failed to store pairing code: \(error)")
        }
    }
    
    func linkPartner(withCode code: String) async throws {
        let publicDB = container.publicCloudDatabase
        
        // Find partner by their pairing code
        let recordID = CKRecord.ID(recordName: code)
        let partnerRecord = try await publicDB.record(for: recordID)
        
        guard let partnerUserID = partnerRecord["userID"] as? String,
              let expiresAt = partnerRecord["expiresAt"] as? Date,
              expiresAt > Date() else {
            throw PairingError.invalidOrExpiredCode
        }
        
        // Store partner relationship in private database
        await MainActor.run {
            partnerId = partnerUserID
        }
        
        try await createPartnershipRecord(partnerUserID: partnerUserID)
        try await createUserProfile()
    }
    
    private func createPartnershipRecord(partnerUserID: String) async throws {
        guard let userID = userRecordID?.recordName else { return }
        
        let privateDB = container.privateCloudDatabase
        let partnershipRecord = CKRecord(recordType: "Partnership")
        
        partnershipRecord["userID"] = userID
        partnershipRecord["partnerID"] = partnerUserID
        partnershipRecord["linkedAt"] = Date()
        partnershipRecord["currentStreak"] = 0
        partnershipRecord["totalXP"] = 0
        partnershipRecord["currentLevel"] = 1
        
        try await privateDB.save(partnershipRecord)
    }
    
    private func createUserProfile() async throws {
        guard let userID = userRecordID?.recordName else { return }
        
        let privateDB = container.privateCloudDatabase
        let profileRecord = CKRecord(recordType: "UserProfile", recordID: CKRecord.ID(recordName: userID))
        
        profileRecord["createdAt"] = Date()
        if let characterData = try? JSONEncoder().encode(CharacterCustomization.default) {
            profileRecord["characterCustomization"] = characterData
        }
        profileRecord["availabilityStatus"] = "available"
        
        try await privateDB.save(profileRecord)
    }
    
    private func loadUserProfile() async {
        guard let userID = userRecordID?.recordName else { return }
        
        do {
            let privateDB = container.privateCloudDatabase
            
            // Load partnership info
            let query = CKQuery(recordType: "Partnership", predicate: NSPredicate(format: "userID == %@", userID))
            let results = try await privateDB.records(matching: query)
            
            if let result = results.matchResults.first,
               let partnershipRecord = try? result.1.get() {
                await MainActor.run {
                    partnerId = partnershipRecord["partnerID"] as? String
                }
            }
        } catch {
            print("Failed to load user profile: \(error)")
        }
    }
    
    func signOut() {
        userRecordID = nil
        partnerId = nil
        pairingCode = ""
        isAuthenticated = false
        accountStatus = .couldNotDetermine
    }
    
    // For backward compatibility with existing code
    func updateFCMToken(_ token: String) async {
        // CloudKit doesn't need FCM tokens - uses APNs directly
        print("FCM token update not needed with CloudKit")
    }
}

enum PairingError: LocalizedError {
    case invalidOrExpiredCode
    case iCloudNotAvailable
    case partnerAlreadyLinked
    
    var errorDescription: String? {
        switch self {
        case .invalidOrExpiredCode:
            return "Invalid or expired pairing code"
        case .iCloudNotAvailable:
            return "iCloud is not available. Please sign in to iCloud in Settings."
        case .partnerAlreadyLinked:
            return "Partner is already linked to another account"
        }
    }
}