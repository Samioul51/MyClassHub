//
//  MailStatsRowView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct MailStatsRowView: View {
    let unread: Int
    let total: Int
    let important: Int

    var body: some View {
        HStack(spacing: 10) {
            MailStatCard(value: unread,    label: "Unread",    color: Color(hex: "#8dedec"))
            MailStatCard(value: total,     label: "Total",     color: Color(hex: "#91f78e"))
            MailStatCard(value: important, label: "Important", color: Color(hex: "#f0a843"))
        }
    }
}

private struct MailStatCard: View {
    let value: Int
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(hex: "#16130b"))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(hex: "#2a2418"), lineWidth: 1)
        )
    }
}
