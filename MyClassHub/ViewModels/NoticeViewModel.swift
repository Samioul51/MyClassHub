//
//  NoticeViewModel.swift
//  MyClassHub
//
//  Created by Mridul on 31/3/26.
//

import Foundation

@MainActor
class NoticeViewModel: ObservableObject {
    @Published var notices: [Notice] = []
    @Published var isLoading = false
    private let service = NoticeService()
    
    init() {
        fetchNotices()
    }
    
    func fetchNotices() {
        isLoading = true
        service.fetchNotices { [weak self] fetchedNotices in
            self?.notices = fetchedNotices
            self?.isLoading = false
        }
    }
    
    // Dynamically filter notices based on the UI selection
    func filteredNotices(for category: NoticeCategory) -> [Notice] {
        return notices.filter { $0.category == category }
    }
}
