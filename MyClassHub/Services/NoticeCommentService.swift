//
//  NoticeCommentService.swift
//  MyClassHub
//
//  Created by Pritom Banik on 9/4/26.
//

import FirebaseFirestore

final class NoticeCommentService {
    private let db = Firestore.firestore()
    
    func addComment(
        to noticeId: String,
        text: String,
        userId: String,
        userName: String
    ) async throws {
        let comment = NoticeComment(
            text: text,
            userId: userId,
            userName: userName,
            createdAt: Date()
        )
        
        try db.collection("notices")
            .document(noticeId)
            .collection("comments")
            .addDocument(from: comment)
    }
    
    func fetchComments(for noticeId: String) async throws -> [NoticeComment] {
        let snapshot = try await db.collection("notices")
            .document(noticeId)
            .collection("comments")
            .order(by: "createdAt", descending: false)
            .getDocuments()
        
        return snapshot.documents.compactMap {
            try? $0.data(as: NoticeComment.self)
        }
    }
}
