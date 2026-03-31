//
//  AdminRoutineViewModel.swift
//  MyClassHub
//
//  Created by Mridul on 31/3/26.
//

import Foundation

@MainActor
class AdminRoutineViewModel: ObservableObject {
    @Published var routines: [ClassRoutine] = []
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage = ""
    @Published var successMessage = ""

    func fetchRoutines() async {
        isLoading = true
        do {
            routines = try await AdminRoutineService.shared.fetchAllRoutines()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func saveRoutine(_ routine: ClassRoutine) async {
        isSaving = true
        do {
            try await AdminRoutineService.shared.saveRoutine(routine)
            successMessage = "Routine saved successfully."
            await fetchRoutines()
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }

    func deleteRoutine(_ routine: ClassRoutine) async {
        do {
            try await AdminRoutineService.shared.deleteRoutine(id: routine.id)
            await fetchRoutines()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Pre-fills the routine from the PDF data so admin just taps Save
    func loadPDFRoutine() -> ClassRoutine {
        return PDFRoutineData.routine
    }
}
