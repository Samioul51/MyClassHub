//
//  UserViewModel.swift
//  MyClassHub
//
//  Created by SIR on 14/4/26.
//

import Foundation

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [AppUser] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    func fetchUsers() async {
        isLoading = true
        do {
            users = try await UserService.shared.fetchAllUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func deleteUser(id: String) async {
        do {
            try await UserService.shared.deleteUser(id: id)
            await fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
