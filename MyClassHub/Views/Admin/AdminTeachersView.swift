//
//  AdminTeachersView.swift
//  MyClassHub
//
//  Created by SIR on 14/4/26.
//

import SwiftUI

struct AdminTeacherCard: View {
    let teacher: Teacher
    var onDelete: () -> Void
    var onEdit: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: URL(string: teacher.image)) { phase in
                if case .success(let img) = phase {
                    img.resizable().scaledToFill()
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(16)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .background(Color(hex: "#1d1910"))
            .id(teacher.image)

            Text(teacher.name)
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(teacher.designation)
                .foregroundColor(.gray)
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            HStack {
                NavigationLink {
                    EditTeacherView(teacher: teacher)
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

struct AdminTeachersView: View {
    @StateObject private var vm = TeacherViewModel()
    @State private var showAdd = false
    @State private var selected: Teacher?
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
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]) {
                            ForEach(vm.teachers) { t in
                                AdminTeacherCard(
                                    teacher: t,
                                    onDelete: {
                                        selected = t
                                        showDelete = true
                                    },
                                    onEdit: {
                                        Task { await vm.fetchTeachers() }
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Teachers")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Teachers")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.teal)
                }
            }
        }
        .sheet(isPresented: $showAdd, onDismiss: {
            Task { await vm.fetchTeachers() }
        }) {
            AddTeacherView()
        }
        .alert("Delete?", isPresented: $showDelete) {
            Button("Delete", role: .destructive) {
                if let t = selected {
                    Task { await vm.deleteTeacher(id: t.id) }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .task { await vm.fetchTeachers() }
    }
}
