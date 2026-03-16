//
//  BatchmateDetailView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct BatchmateDetailView: View {
    let batchmates: [Batchmate]
    @State var selectedIndex: Int

    var batchmate: Batchmate { batchmates[selectedIndex] }

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(batchmates.enumerated()), id: \.element.id) { index, b in
                BatchmateDetailCard(batchmate: b)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .navigationTitle(batchmate.name)
        .navigationBarTitleDisplayMode(.inline)
        .animation(.easeInOut, value: selectedIndex)
    }
}

// Detail card

struct BatchmateDetailCard: View {
    let batchmate: Batchmate

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Profile header
                
                VStack(spacing: 12) {
                    AsyncImage(url: URL(string: batchmate.image ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure, .empty:
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .background(Color(.systemGray5).clipShape(Circle()))

                    Text(batchmate.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)

                    // Roll badge
                    
                    Text("Roll: \(batchmate.roll)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color(.systemBackground))

                // Info cards
                
                VStack(spacing: 0) {

                    InfoRow(icon: "building.columns.fill",
                            color: .purple,
                            title: "College",
                            value: batchmate.college)

                    Divider().padding(.leading, 56)

                    InfoRow(icon: "mappin.circle.fill",
                            color: .red,
                            title: "Home District",
                            value: batchmate.homeDistrict)

                    Divider().padding(.leading, 56)

                    InfoRow(icon: "drop.fill",
                            color: .red,
                            title: "Blood Group",
                            value: batchmate.bloodGroup)

                    Divider().padding(.leading, 56)

                    // Contact number
                    
                    if let contact = batchmate.contactNumber, !contact.isEmpty {
                        Button {
                            if let url = URL(string: "tel:\(contact)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            InfoRow(icon: "phone.fill",
                                    color: .green,
                                    title: "Contact",
                                    value: contact)
                        }
                    } else {
                        InfoRow(icon: "phone.fill",
                                color: .gray,
                                title: "Contact",
                                value: "Not available")
                        .opacity(0.5)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(16)

                // Swipe hint
                HStack(spacing: 6) {
                    Image(systemName: "hand.draw.fill")
                        .font(.caption)
                    Text("Swipe left or right to see other batchmates")
                        .font(.caption)
                }
                .foregroundColor(.secondary)
                .padding(.bottom, 24)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

// Info row
struct InfoRow: View {
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
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
