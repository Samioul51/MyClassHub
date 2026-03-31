//
//  NoticeService.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import Foundation
import FirebaseFirestore

class NoticeService {
    private let db = Firestore.firestore()
    
    func fetchNotices(completion: @escaping ([Notice]) -> Void) {
        db.collection("notices")
            .order(by: "date", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else { return }
                let notices = documents.compactMap { try? $0.data(as: Notice.self) }
                completion(notices)
            }
    }
    
    func uploadNotice(_ notice: Notice) async throws {
        try db.collection("notices").addDocument(from: notice)
    }
}
