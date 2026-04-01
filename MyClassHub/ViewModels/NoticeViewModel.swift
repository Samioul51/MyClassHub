//
//  NoticeViewModel.swift
//  MyClassHub
//
//  Created by Mridul on 31/3/26.
//

import Foundation

@MainActor
final class NoticeViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var isLoading = false
    
    private let service = NoticeService()
    
    init() {
        fetchNotices()
    }
    
    func fetchNotices() {
        isLoading = true
        
        service.fetchNotices { [weak self] fetchedNotices in
            guard let self = self else { return }
            self.notices = fetchedNotices
            self.isLoading = false
        }
    }
    
    func filteredNotices(for category: NoticeCategory) -> [Notice] {
        notices.filter { $0.category == category }
    }
    
    func deleteNotice(_ notice: Notice) async {
        do {
            try await service.deleteNotice(notice)
        } catch {
            print("DEBUG: Failed to delete notice: \(error.localizedDescription)")
        }
    }
}
