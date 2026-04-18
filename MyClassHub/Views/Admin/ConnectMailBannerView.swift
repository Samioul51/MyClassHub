//
//  ConnectMailBannerView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct ConnectMailBannerView: View {
    let onConnect: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "envelope.badge.shield.half.filled.fill")
                .font(.system(size: 52))
                .foregroundColor(Color(hex: "#8dedec"))

            VStack(spacing: 6) {
                Text("Connect University Mail")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Text("Sign in with your KUET Google account\nto read emails directly from the dashboard.")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
            }

            Button(action: onConnect) {
                HStack(spacing: 8) {
                    Image(systemName: "envelope.fill")
                    Text("Connect with University Gmail")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(Color(hex: "#91f78e"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(hex: "#16130b"))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#91f78e").opacity(0.4), lineWidth: 1)
                )
                .cornerRadius(16)
            }
            .padding(.horizontal, 32)

            Spacer()
        }
    }
}
