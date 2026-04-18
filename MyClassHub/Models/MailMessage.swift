//
//  MailMessage.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import Foundation

struct MailMessage: Identifiable {
    let id: String
    let sender: String
    let senderInitials: String
    let subject: String
    let preview: String
    let time: String
    let isUnread: Bool
    let isImportant: Bool
    let avatarColor: String
}

enum MailTab: String, CaseIterable {
    case inbox = "Inbox"
    case sent = "Sent"
    case important = "Important"
}
