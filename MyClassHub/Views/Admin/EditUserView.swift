//
//  EditUserView.swift
//  MyClassHub
//
//  Created by SIR on 14/4/26.
//

import SwiftUI

struct EditUserView: View {

    @Environment(\.dismiss) private var dismiss
    @State var user: AppUser

    @State private var isSaving = false
    @State private var showConfirm = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {

        ZStack {
            Color(hex: "#110e07").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // Avatar
                    ZStack {
                        Circle()
                            .fill(Color(hex: "#1d1910"))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )

                        Text(user.name.prefix(1).uppercased())
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#8dedec"))
                    }

                    // MEmail (read only — cannot change email from client)
                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#8dedec").opacity(0.4))
                            .frame(width: 20)

                        Text(user.email)
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 15))

                        Spacer()

                        Text("read only")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.2))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#16130b"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.04), lineWidth: 1)
                    )

                    // Fields
                    VStack(spacing: 14) {
                        field("Name", systemImage: "person.fill", Binding(
                            get: { user.name },
                            set: { user.name = $0 }
                        ))
                        field("Roll", systemImage: "number", Binding(
                            get: { user.roll },
                            set: { user.roll = $0 }
                        ))

                        // MARK: Role Picker
                        HStack(spacing: 12) {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#8dedec").opacity(0.7))
                                .frame(width: 20)

                            Picker("Role", selection: Binding(
                                get: { user.role },
                                set: { user.role = $0 }
                            )) {
                                Text("User").tag(UserRole.user)
                                Text("Admin").tag(UserRole.admin)
                            }
                            .pickerStyle(.menu)
                            .accentColor(.white)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#16130b"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.07), lineWidth: 1)
                        )
                    }

                    // Save Button
                    Button {
                        showConfirm = true
                    } label: {
                        HStack(spacing: 8) {
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(0.85)
                            }
                            Text(isSaving ? "Saving..." : "Save Changes")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#8dedec"))
                        .cornerRadius(16)
                    }
                    .disabled(isSaving)
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Edit User")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .alert("Save changes?", isPresented: $showConfirm) {
            Button("Save") { Task { await save() } }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // Save
    private func save() async {
        isSaving = true
        do {
            try await UserService.shared.updateUser(user)
            await MainActor.run { dismiss() }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isSaving = false
    }

    private func field(_ title: String, systemImage: String, _ text: Binding<String>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#8dedec").opacity(0.7))
                .frame(width: 20)

            TextField("", text: text)
                .placeholder(when: text.wrappedValue.isEmpty) {
                    Text(title)
                        .foregroundColor(.white.opacity(0.35))
                }
                .foregroundColor(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color(hex: "#16130b"))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
    }
}
