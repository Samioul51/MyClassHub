//
//  MailTabBarView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct MailTabBarView: View {
    @Binding var selected: MailTab

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(MailTab.allCases, id: \.self) { tab in
                    Button { selected = tab } label: {
                        Text(tab.rawValue)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(selected == tab
                                ? Color(hex: "#8dedec")
                                : .white.opacity(0.4))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selected == tab ? Color(hex: "#1d1910") : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        selected == tab
                                        ? Color(hex: "#8dedec").opacity(0.6)
                                        : Color(hex: "#2a2418"),
                                        lineWidth: 1
                                    )
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 12)
    }
}
