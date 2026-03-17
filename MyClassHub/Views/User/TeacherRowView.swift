//
//  TeacherRowView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct TeacherRowView: View {
    let teacher: Teacher

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: teacher.image)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 36))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .background(Color(.systemGray5).clipShape(Circle()))

            VStack(alignment: .leading, spacing: 2) {
                Text(teacher.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                Text(teacher.designation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
