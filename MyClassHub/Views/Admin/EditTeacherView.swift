//
//  EditTeacherView.swift
//  MyClassHub
//
//  Created by SIR on 14/4/26.
//

import SwiftUI
import PhotosUI

struct EditTeacherView: View {

    @Environment(\.dismiss) private var dismiss
    @State var teacher: Teacher

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    @State private var isSaving = false
    @State private var showConfirm = false
    @State private var showError = false
    @State private var errorMessage = ""

    private let designations = [
        "Professor",
        "Associate Professor",
        "Assistant Professor",
        "Lecturer"
    ]

    var body: some View {

        ZStack {
            Color(hex: "#110e07").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    // MARK: Profile Image
                    Group {
                        if let img = selectedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                        } else {
                            AsyncImage(url: URL(string: teacher.image)) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable().scaledToFill()
                                default:
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(25)
                                        .foregroundColor(.white.opacity(0.4))
                                }
                            }
                            .id(teacher.image)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .background(Color(hex: "#1d1910"))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )

                    // MARK: Image Picker
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack(spacing: 6) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 13))
                            Text("Change Photo")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.white.opacity(0.85))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(Color(hex: "#1d1910"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    }

                    // MARK: Fields
                    VStack(spacing: 14) {
                        field("Name", systemImage: "person.fill", Binding(
                            get: { teacher.name },
                            set: { teacher.name = $0 }
                        ))
                        field("Email", systemImage: "envelope.fill", Binding(
                            get: { teacher.email },
                            set: { teacher.email = $0 }
                        ))
                        field("Phone", systemImage: "phone.fill", Binding(
                            get: { teacher.phone ?? "" },
                            set: { teacher.phone = $0 }
                        ))

                        // MARK: Designation Picker
                        HStack(spacing: 12) {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#8dedec").opacity(0.7))
                                .frame(width: 20)

                            Picker("Designation", selection: Binding(
                                get: { teacher.designation },
                                set: { teacher.designation = $0 }
                            )) {
                                ForEach(designations, id: \.self) { d in
                                    Text(d).tag(d)
                                }
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

                    // MARK: Save Button
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
                Text("Edit Teacher")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .onChange(of: selectedItem) { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    selectedImage = img
                }
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

    // MARK: Save
    private func save() async {
        isSaving = true
        do {
            if let img = selectedImage {
                let url = try await ImgBBUploadService.shared.uploadImage(img)
                teacher.image = url
            }
            try await TeacherService.shared.updateTeacher(teacher)
            await MainActor.run { dismiss() }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isSaving = false
    }

    // MARK: Input Field
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
