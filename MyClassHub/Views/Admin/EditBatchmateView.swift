//
//  EditBatchmateView.swift
//  MyClassHub
//
//  Created by SIR on 13/4/26.
//

import SwiftUI
import PhotosUI

struct EditBatchmateView: View {

    @Environment(\.dismiss) private var dismiss
    @State var batchmate: Batchmate

    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    @State private var isSaving = false
    @State private var showConfirm = false
    @State private var showError = false
    @State private var errorMessage = ""

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
                            AsyncImage(url: URL(string: batchmate.image ?? "")) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                default:
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(25)
                                        .foregroundColor(.white.opacity(0.4))
                                }
                            }
                            .id(batchmate.image)
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
            // MARK: Title
            ToolbarItem(placement: .principal) {
                Text("Edit Batchmate")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            // MARK: Back button
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 15))
                    }
                    .foregroundColor(Color(hex: "#8dedec"))
                }
            }
        }

        // MARK: Load selected image
        .onChange(of: selectedItem) { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    selectedImage = img
                }
            }
        }

        // MARK: Save confirmation
        .alert("Save changes?", isPresented: $showConfirm) {
            Button("Save") {
                Task { await save() }
            }
            Button("Cancel", role: .cancel) {}
        }

        // MARK: Error Alert
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: Save Logic
    private func save() async {
        isSaving = true

        do {
            if let img = selectedImage {
                let url = try await ImgBBUploadService.shared.uploadImage(img)
                batchmate.image = url
            }

            try await BatchmateService.shared.updateBatchmate(batchmate)

            await MainActor.run {
                dismiss()
            }

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

        isSaving = false
    }

    // MARK: Input Field — with icon + visible placeholder
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
