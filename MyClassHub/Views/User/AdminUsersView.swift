//
//  AdminUsersView.swift
//  MyClassHub
//
//  Created by SIR on 14/4/26.
//

import SwiftUI

struct AdminUserCard: View {
    let user: AppUser
    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        VStack(spacing: 8) {

            // Avatar with initial
            ZStack {
                Circle()
                    .fill(Color(hex: "#1d1910"))
                    .frame(width: 70, height: 70)

                Text(user.name.prefix(1).uppercased())
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }

            Text(user.name)
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(user.roll)
                .foregroundColor(.gray)
                .font(.system(size: 11))

            // Role badge
            Text(user.role == .admin ? "Admin" : "User")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(user.role == .admin ? Color(hex: "#8dedec") : .white.opacity(0.5))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    user.role == .admin
                        ? Color(hex: "#8dedec").opacity(0.15)
                        : Color.white.opacity(0.07)
                )
                .cornerRadius(6)

            HStack {
                NavigationLink {
                    EditUserView(user: user)
                        .onDisappear { onEdit() }
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.teal)
                }
                Spacer()
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                }
            }
            .padding(.top, 4)
        }
        .padding()
        .background(Color(hex: "#16130b"))
        .cornerRadius(16)
    }
}

struct AdminUsersView: View {
    @StateObject private var vm = UserViewModel()
    @State private var selected: AppUser?
    @State private var showDelete = false

    var body: some View {
        ZStack {
            Color(hex: "#110e07").ignoresSafeArea()

            Group {
                if vm.isLoading {
                    ProgressView("Loading...")
                        .tint(Color(hex: "#8dedec"))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.users.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.3.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.2))
                        Text("No users found")
                            .foregroundColor(.white.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]) {
                            ForEach(vm.users) { u in
                                AdminUserCard(
                                    user: u,
                                    onDelete: {
                                        selected = u
                                        showDelete = true
                                    },
                                    onEdit: {
                                        Task { await vm.fetchUsers() }
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Users")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .alert("Delete User?", isPresented: $showDelete) {
            Button("Delete", role: .destructive) {
                if let u = selected {
                    Task { await vm.deleteUser(id: u.id) }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The user will be deleted permanently")
        }
        .task { await vm.fetchUsers() }
    }
}
