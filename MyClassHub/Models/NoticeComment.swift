//
//  NoticeComment.swift
//  MyClassHub
//
//  Created by Pritom Banik on 9/4/26.
//


import Foundation
import FirebaseFirestoreSwift

struct NoticeComment: Identifiable, Codable {
    @DocumentID var id: String?
    
    let text: String
    let userId: String
    let userName: String
    let createdAt: Date
}
