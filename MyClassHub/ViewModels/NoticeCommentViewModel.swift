//
//  NoticeCommentViewModel.swift
//  MyClassHub
//
//  Created by Pritom Banik on 9/4/26.
//

import Foundation
@MainActor
final class NoticeCommentViewModel: ObservableObject {
    @Published var comments: [NoticeComment] = []
    @Published var newComment: String = ""
    
    private let service = NoticeCommentService()
    
    func fetchComments(for noticeId: String) async {
        do {
            let fetched = try await service.fetchComments(for: noticeId)
            self.comments = fetched
        } catch {
            print("DEBUG: Failed to fetch comments: \(error.localizedDescription)")
        }
    }
    
    func addComment(noticeId: String, userId: String, userName: String) async {
        guard !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        do {
            try await service.addComment(
                to: noticeId,
                text: newComment,
                userId: userId,
                userName: userName
            )
            newComment = ""
            
            // Refresh comments
            await fetchComments(for: noticeId)
        } catch {
            print("DEBUG: Failed to add comment: \(error.localizedDescription)")
        }
    }
}
