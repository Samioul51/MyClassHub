//
//  AddBatchmateView.swift
//  MyClassHub
//
//  Created by SIR on 13/4/26.
//

import SwiftUI
import PhotosUI

struct AddBatchmateView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var batchmate = Batchmate(
        id: UUID().uuidString,
        roll: "",
        name: "",
        college: "",
        homeDistrict: "",
        bloodGroup: "",
        contactNumber: "",
        image: nil
    )

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    @State private var isSaving = false
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {

        NavigationStack {
            ZStack {
                Color(hex: "#110e07").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // MARK: IMAGE
                        Group {
                            if let img = selectedImage {
                                Image(uiImage: img)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(25)
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .frame(width: 120, height: 120)
                        .background(Color(hex: "#1d1910"))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )

                        // MARK: IMAGE PICKER
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            HStack(spacing: 6) {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 13))
                                Text("Select Photo")
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

                        // MARK: FIELDS
                        VStack(spacing: 14) {
                            field("Name", systemImage: "person.fill", $batchmate.name)
                            field("Roll", systemImage: "number", $batchmate.roll)
                            field("College", systemImage: "building.columns.fill", $batchmate.college)
                            field("Home District", systemImage: "mappin.circle.fill", $batchmate.homeDistrict)
                            field("Blood Group", systemImage: "drop.fill", $batchmate.bloodGroup)
                            field("Contact", systemImage: "phone.fill", Binding(
                                get: { batchmate.contactNumber ?? "" },
                                set: { batchmate.contactNumber = $0 }
                            ))
                        }

                        // MARK: SAVE BUTTON
                        Button(action: {
                            Task { await save() }
                        }) {
                            HStack(spacing: 8) {
                                if isSaving {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(0.85)
                                }
                                Text(isSaving ? "Saving..." : "Save")
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
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Title
                ToolbarItem(placement: .principal) {
                    Text("Add Batchmate")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                // MARK: Cancel / Back button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Cancel")
                                .font(.system(size: 15))
                        }
                        .foregroundColor(Color(hex: "#8dedec"))
                    }
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
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }

    // MARK: SAVE FUNCTION
    private func save() async {
        isSaving = true
        do {
            if let img = selectedImage {
                let url = try await ImgBBUploadService.shared.uploadImage(img)
                batchmate.image = url
            }

            try await BatchmateService.shared.addBatchmate(batchmate)

            await MainActor.run {
                dismiss()
            }

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        isSaving = false
    }

    // MARK: INPUT FIELD — now with icon + visible placeholder
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

// MARK: Placeholder helper extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: .leading) {
            if shouldShow { placeholder() }
            self
        }
    }
}
