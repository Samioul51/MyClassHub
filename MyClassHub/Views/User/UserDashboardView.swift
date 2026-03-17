//
//  UserDashboardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct UserDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    let menuItems: [(title: String, subtitle: String, icon: String, color: Color)] = [
        ("My Batchmates", "See your classmates",  "person.2.fill",     .blue),
        ("Routine",       "View class schedule",  "calendar",           .green),
        ("Notices",       "Latest announcements", "bell.fill",          .orange),
        ("Our Teachers",  "Faculty directory",    "graduationcap.fill", .purple)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {

                        // Header card
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back,")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                            Text(authViewModel.currentUser?.name ?? "Student")
                                .font(.title.bold())
                                .foregroundColor(.white)
                            Text("Roll: \(authViewModel.currentUser?.roll ?? "-")")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(24)
                        .background(
                            LinearGradient(
                                colors: [.blue, Color.blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                        // Menu grid
                        
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())],
                            spacing: 16
                        ) {
                            ForEach(menuItems, id: \.title) { item in
                                NavigationLink(destination: destinationView(for: item.title)) {
                                        MenuCard(
                                            title: item.title,
                                            subtitle: item.subtitle,
                                            icon: item.icon,
                                            color: item.color
                                        )
                                    }.buttonStyle(.plain)
                            }
                        }
                        .padding(16)

                        // Settings row
                        
                        NavigationLink(destination: SettingsView()) {
                            HStack(spacing: 14) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(.gray)
                                    .frame(width: 36, height: 36)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(10)

                                Text("Settings")
                                    .font(.body)
                                    .foregroundColor(.primary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(Color(.systemBackground))
                            .cornerRadius(14)
                            .padding(.horizontal, 16)
                        }

                        Spacer(minLength: 32)
                    }
                }
            }
            .navigationTitle("MyClass Hub")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

@ViewBuilder
    func destinationView(for title: String) -> some View {
        switch title {
        case "Our Teachers":
            OurTeachersView()
        case "My Batchmates":
            MyBatchmatesView()
        case "Routine":
            Text("Routine")
        case "Notices":
            Text("Notices")
        default:
            Text("default")
        }
    }

// Menu card component

struct MenuCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.12))
                .cornerRadius(12)

            Spacer()

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .frame(height: 130)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
