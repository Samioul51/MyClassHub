//
//  AuthService.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    static let shared = AuthService()
    private let db = Firestore.firestore()
    
    // Register function
    
    func register(name: String, roll: String, email: String, password: String) async throws -> AppUser {
        // Creating User
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = result.user.uid
        
        // New user
        
        let newUser = AppUser(id: uid, name: name, email: email, roll: roll, role: .user)
        let data: [String: Any] = [
            "name": name,
            "email": email,
            "roll": roll,
            "role": UserRole.user.rawValue
        ]
        try await db.collection("users").document(uid).setData(data)
        return newUser
    }
    
    // Login function
    
    func login(email: String, password: String) async throws -> AppUser {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        let uid = result.user.uid
        return try await fetchUser(uid: uid)
    }
    
    // Fetch User from Firestore
    
    func fetchUser(uid: String) async throws -> AppUser {
        let doc = try await db.collection("users").document(uid).getDocument()
        guard let data = doc.data() else {
            throw NSError(domain: "UserNotFound", code: 404)
        }
        return AppUser(
            id: uid,
            name: data["name"] as? String ?? "",
            email: data["email"] as? String ?? "",
            roll: data["roll"] as? String ?? "",
            role: UserRole(rawValue: data["role"] as? String ?? "user") ?? .user
        )
    }
    
    // Logout function
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    // Checking current user
    
    func getCurrentUser() async -> AppUser? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return try? await fetchUser(uid: firebaseUser.uid)
    }
}
