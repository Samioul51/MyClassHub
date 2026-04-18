//
//  MailHeaderView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct MailHeaderView: View {
    let isConnected: Bool
    let connectedEmail: String
    let onDisconnect: () -> Void

    @State private var showDisconnectAlert = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("University Mail")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))

                Text(isConnected ? connectedEmail.uppercased() : "NOT CONNECTED")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(isConnected ? Color(hex: "#91f78e") : .orange)
                    .tracking(1.2)
            }

            Spacer()

            if isConnected {
                Button {
                    showDisconnectAlert = true
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 15))
                        .foregroundColor(.red.opacity(0.8))
                        .frame(width: 40, height: 40)
                        .background(Color(hex: "#1d1910"))
                        .clipShape(Circle())
                }
                .alert("Disconnect mail?", isPresented: $showDisconnectAlert) {
                    Button("Disconnect", role: .destructive) { onDisconnect() }
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
}
