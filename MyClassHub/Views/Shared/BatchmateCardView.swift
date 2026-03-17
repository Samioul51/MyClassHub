//
//  BatchmateCardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct BatchmateCardView: View {
    let batchmate: Batchmate

    var body: some View {
        VStack(spacing: 10) {

            // Photo
            
            AsyncImage(url: URL(string: batchmate.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Image(systemName: "person.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())
            .background(Color(.systemGray5).clipShape(Circle()))

            // Name
            
            Text(batchmate.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            // Roll Badge
            
            Text("Roll: \(batchmate.roll)")
                .font(.caption2)
                .foregroundColor(.blue)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
