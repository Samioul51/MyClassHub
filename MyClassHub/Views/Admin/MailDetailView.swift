//
//  MailDetailView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct MailDetailView: View {
    let mail: MailMessage

    var body: some View {
        ZStack {
            Color(hex: "#110e07").ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Subject
                    Text(mail.subject)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    // Sender row
                    HStack(spacing: 12) {
                        Text(mail.senderInitials)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: mail.avatarColor))
                            .frame(width: 42, height: 42)
                            .background(Color(hex: mail.avatarColor).opacity(0.15))
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(mail.sender)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Text(mail.time)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.4))
                        }

                        Spacer()

                        if mail.isImportant {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(hex: "#f0a843"))
                                .font(.system(size: 14))
                        }
                    }

                    Divider()
                        .background(Color.white.opacity(0.1))

                    // Body preview
                    Text(mail.preview)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.75))
                        .lineSpacing(6)

                    Text("Open full email in browser →")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#8dedec"))
                        .padding(.top, 8)
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(false)
    }
}
