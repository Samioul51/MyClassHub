//
//  MailRowView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct MailRowView: View {
    let mail: MailMessage

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Text(mail.senderInitials)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(hex: mail.avatarColor))
                .frame(width: 38, height: 38)
                .background(Color(hex: mail.avatarColor).opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(mail.sender)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    Text(mail.time)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.35))
                }

                Text(mail.subject)
                    .font(.system(size: 12, weight: mail.isUnread ? .semibold : .regular))
                    .foregroundColor(mail.isUnread ? .white.opacity(0.9) : .white.opacity(0.6))
                    .lineLimit(1)

                Text(mail.preview)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
                    .lineLimit(1)
            }

            if mail.isUnread {
                Circle()
                    .fill(Color(hex: "#8dedec"))
                    .frame(width: 7, height: 7)
                    .padding(.top, 5)
            }
        }
        .padding(14)
        .background(Color(hex: "#16130b"))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    mail.isUnread
                    ? Color(hex: "#8dedec").opacity(0.4)
                    : Color(hex: "#2a2418"),
                    lineWidth: mail.isUnread ? 1 : 0.5
                )
        )
    }
}
