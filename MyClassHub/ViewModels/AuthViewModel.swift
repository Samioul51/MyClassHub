//
//  AuthViewModel.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    
    @Published var currentUser: AppUser? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published private(set) var isShowingStudentView: Bool = false
    
    var isLoggedIn: Bool { currentUser != nil }
    var isAdmin: Bool { currentUser?.role == .admin }
    var canAccessAdminPanel: Bool { currentUser?.role == .admin }
    var shouldShowAdminDashboard: Bool { canAccessAdminPanel && !isShowingStudentView }
    
    init() {
        Task { await checkSession() }
    }
    
    // Checking session during opening app
    
    func checkSession() async {
        isLoading = true
        currentUser = await AuthService.shared.getCurrentUser()
        isLoading = false
    }
    
    // Login
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        do {
            currentUser = try await AuthService.shared.login(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Register
    
    func register(name: String, roll: String, email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        do {
            currentUser = try await AuthService.shared.register(
                name: name, roll: roll, email: email, password: password
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    // Logout
    
    func logout() {
        try? AuthService.shared.logout()
        currentUser = nil
        isShowingStudentView = false
    }
    
    func switchToStudentMode() {
        guard canAccessAdminPanel else { return }
        isShowingStudentView = true
    }
    
    func returnToAdminMode() {
        guard canAccessAdminPanel else { return }
        isShowingStudentView = false
    }
}
