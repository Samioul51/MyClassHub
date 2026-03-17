//
//  BatchmateViewModel.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import Foundation

@MainActor
class BatchmateViewModel: ObservableObject {
    @Published var batchmates: [Batchmate] = []
    @Published var isLoading = false
    @Published var errorMessage = ""

    func fetchBatchmates() async {
        isLoading = true
        do {
            batchmates = try await BatchmateService.shared.fetchBatchmates()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func deleteBatchmate(id: String) async {
        do {
            try await BatchmateService.shared.deleteBatchmate(id: id)
            batchmates.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
