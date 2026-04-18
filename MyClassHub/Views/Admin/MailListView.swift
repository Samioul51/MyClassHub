//
//  MailListView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct MailListView: View {
    let messages: [MailMessage]
    let isLoading: Bool
    let onRefresh: () -> Void

    var body: some View {
        Group {
            if isLoading {
                Spacer()
                ProgressView()
                    .tint(Color(hex: "#8dedec"))
                Spacer()
            } else if messages.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.system(size: 32))
                        .foregroundColor(.white.opacity(0.2))
                    Text("No messages")
                        .foregroundColor(.white.opacity(0.4))
                        .font(.system(size: 14))
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(messages) { mail in
                            NavigationLink(destination: MailDetailView(mail: mail)) {
                                MailRowView(mail: mail)
                            }
                            .buttonStyle(.plain)
                        }
                        Spacer().frame(height: 30)
                    }
                    .padding(.horizontal)
                }
                .refreshable { onRefresh() }
            }
        }
    }
}
