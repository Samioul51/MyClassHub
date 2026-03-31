//
//  AdminRoutineView.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import SwiftUI

struct AdminRoutineView: View {
    @StateObject private var viewModel = AdminRoutineViewModel()
    @State private var showConfirmUpload = false
    @State private var showConfirmDelete: ClassRoutine? = nil

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    // Upload from PDF section
                    Section("Upload from PDF Data") {
                        Button {
                            showConfirmUpload = true
                        } label: {
                            HStack {
                                Image(systemName: "arrow.up.doc.fill")
                                    .foregroundColor(.blue)
                                Text("Upload 3rd Year 2nd Term Routine")
                                    .foregroundColor(.primary)
                            }
                        }
                    }

                    // Existing routines
                    Section("Existing Routines") {
                        if viewModel.routines.isEmpty {
                            Text("No routines in Firestore yet.")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                        } else {
                            ForEach(viewModel.routines) { routine in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(routine.year) \(routine.term)")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Session: \(routine.session) · Starts: \(routine.startDate)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(routine.sections.count) sections")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .swipeActions {
                                    Button(role: .destructive) {
                                        showConfirmDelete = routine
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }

                    // Status messages
                    if !viewModel.errorMessage.isEmpty {
                        Section {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    if !viewModel.successMessage.isEmpty {
                        Section {
                            Text(viewModel.successMessage)
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Manage Routine")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isSaving {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Saving to Firestore...")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(24)
                    .background(Color(.systemGray2).opacity(0.9))
                    .cornerRadius(14)
                }
            }
        }
        .confirmationDialog(
            "Upload routine to Firestore?",
            isPresented: $showConfirmUpload,
            titleVisibility: .visible
        ) {
            Button("Upload") {
                Task {
                    let routine = viewModel.loadPDFRoutine()
                    await viewModel.saveRoutine(routine)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will overwrite any existing routine with the same ID.")
        }
        .confirmationDialog(
            "Delete this routine?",
            isPresented: Binding(
                get: { showConfirmDelete != nil },
                set: { if !$0 { showConfirmDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let routine = showConfirmDelete {
                    Task { await viewModel.deleteRoutine(routine) }
                }
                showConfirmDelete = nil
            }
            Button("Cancel", role: .cancel) { showConfirmDelete = nil }
        }
        .task {
            await viewModel.fetchRoutines()
        }
    }
}
