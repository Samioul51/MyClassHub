//
//  UserService.swift
//  MyClassHub
//
//  Created by SIR on 14/4/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()

    // Fetch all users
    func fetchAllUsers() async throws -> [AppUser] {
        let snapshot = try await db.collection("users")
            .order(by: "name")
            .getDocuments()
        return snapshot.documents.map { doc in
            let data = doc.data()
            return AppUser(
                id: doc.documentID,
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                roll: data["roll"] as? String ?? "",
                role: UserRole(rawValue: data["role"] as? String ?? "user") ?? .user
            )
        }
    }

    // Update user in Firestore only
    
    func updateUser(_ user: AppUser) async throws {
        try await db.collection("users").document(user.id).updateData([
            "name": user.name,
            "roll": user.roll,
            "role": user.role.rawValue
        ])
    }

    // Delete user from Firestore
    
    func deleteUser(id: String) async throws {
        try await db.collection("users").document(id).delete()
    }

}
