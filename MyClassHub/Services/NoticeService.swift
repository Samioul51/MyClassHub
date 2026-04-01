//
//  NoticeService.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class NoticeService {
    private let db = Firestore.firestore()
    
    func fetchNotices(completion: @escaping ([Notice]) -> Void) {
        db.collection("notices")
            .order(by: "date", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("DEBUG: Failed to fetch notices: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }
                
                let notices = documents.compactMap { document in
                    try? document.data(as: Notice.self)
                }
                
                completion(notices)
            }
    }
    
    func uploadNotice(_ notice: Notice) async throws {
        try db.collection("notices").addDocument(from: notice)
    }
    
    func updateNotice(_ notice: Notice) async throws {
        guard let id = notice.id else {
            throw NSError(
                domain: "NoticeService",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Missing notice ID for update."]
            )
        }
        
        try db.collection("notices").document(id).setData(from: notice)
    }
    
    func deleteNotice(_ notice: Notice) async throws {
        guard let id = notice.id else {
            throw NSError(
                domain: "NoticeService",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Missing notice ID for delete."]
            )
        }
        
        try await db.collection("notices").document(id).delete()
    }
}
