//
//  TeacherDetailView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct TeacherDetailView: View {
    let teacher: Teacher

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Profile header
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: teacher.image)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure, .empty:
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                                .font(.system(size: 80))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .background(Color(.systemGray5).clipShape(Circle()))

                    Text(teacher.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    Text(teacher.designation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color(.systemBackground))

                // Contact info
                
                VStack(spacing: 0) {

                    // Email
                    Button {
                        if let url = URL(string: "mailto:\(teacher.email)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        ContactRow(
                            icon: "envelope.fill",
                            color: .blue,
                            title: "Email",
                            value: teacher.email
                        )
                    }

                    Divider().padding(.leading, 56)

                    // Phone
                    
                    if let phone = teacher.phone {
                        Button {
                            if let url = URL(string: "tel:\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            ContactRow(
                                icon: "phone.fill",
                                color: .green,
                                title: "Phone",
                                value: phone
                            )
                        }
                    } else {
                        ContactRow(
                            icon: "phone.fill",
                            color: .gray,
                            title: "Phone",
                            value: "Not available"
                        )
                        .opacity(0.5)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(16)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(teacher.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Contact row
struct ContactRow: View {
    let icon: String
    let color: Color
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(color)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
