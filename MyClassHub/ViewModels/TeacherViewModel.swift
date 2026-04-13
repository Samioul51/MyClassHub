//
//  TeacherViewModel.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import Foundation

@MainActor
class TeacherViewModel: ObservableObject {
    @Published var teachers: [Teacher] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    func fetchTeachers() async {
        isLoading = true
        do {
            teachers = try await TeacherService.shared.fetchTeachers()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: Admin delete
    func deleteTeacher(id: String) async {
        do {
            try await TeacherService.shared.deleteTeacher(id: id)
            await fetchTeachers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
